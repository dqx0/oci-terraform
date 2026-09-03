data "oci_core_subnet" "mcp" {
  subnet_id = var.subnet_ocid
}

# The existing VCN is in the root compartment. CI receives only VCN_ATTACH
# there; the NSG itself remains managed in the dedicated workload compartment.
resource "oci_core_network_security_group" "mcp" {
  compartment_id = var.compartment_ocid
  vcn_id         = data.oci_core_subnet.mcp.vcn_id
  display_name   = "itinero-mcp"

  freeform_tags = {
    "managed-by" = "terraform-github-actions"
    "purpose"    = "itinero-mcp"
  }
}

resource "oci_core_network_security_group_security_rule" "egress" {
  network_security_group_id = oci_core_network_security_group.mcp.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  description               = "Allow package installation and outbound API calls"
}

resource "oci_core_network_security_group_security_rule" "ssh" {
  network_security_group_id = oci_core_network_security_group.mcp.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = var.ssh_ingress_cidr
  source_type               = "CIDR_BLOCK"
  description               = "SSH administration from the approved address"

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "https" {
  network_security_group_id = oci_core_network_security_group.mcp.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = var.mcp_ingress_cidr
  source_type               = "CIDR_BLOCK"
  description               = "HTTPS Streamable HTTP MCP endpoint"

  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

resource "oci_core_instance" "mcp" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = var.instance_name
  shape               = "VM.Standard.E2.1.Micro"

  source_details {
    source_id               = var.image_ocid
    source_type             = "image"
    boot_volume_size_in_gbs = 50
  }

  create_vnic_details {
    assign_public_ip = true
    display_name     = "itinero-mcp"
    hostname_label   = "itinero-mcp"
    nsg_ids          = [oci_core_network_security_group.mcp.id]
    subnet_id        = var.subnet_ocid
  }

  metadata = {
    ssh_authorized_keys = trimspace(var.ssh_public_key)
    user_data = base64encode(templatefile("${path.module}/cloud-init.yaml", {
      ssh_ingress_cidr = var.ssh_ingress_cidr
    }))
  }

  freeform_tags = {
    "managed-by" = "terraform-github-actions"
    "purpose"    = "itinero-mcp"
  }

  lifecycle {
    prevent_destroy = true
    # OCI rejects changes to user_data and ssh_authorized_keys after launch.
    # Updated metadata is applied the next time the instance is created.
    ignore_changes = [metadata]
  }
}
