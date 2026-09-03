data "oci_core_subnet" "glen" {
  subnet_id = var.subnet_ocid
}

# The existing VCN is in the root compartment. CI receives only VCN_ATTACH
# there; Glen resources remain in the dedicated workload compartment.
resource "oci_core_network_security_group" "glen" {
  compartment_id = var.compartment_ocid
  vcn_id         = data.oci_core_subnet.glen.vcn_id
  display_name   = "glen-auth"

  freeform_tags = {
    "managed-by" = "terraform-github-actions"
    "purpose"    = "glen-auth"
  }
}

resource "oci_core_network_security_group_security_rule" "egress" {
  network_security_group_id = oci_core_network_security_group.glen.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  description               = "Allow package installation and outbound identity integrations"
}

resource "oci_core_network_security_group_security_rule" "ssh" {
  network_security_group_id = oci_core_network_security_group.glen.id
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
  network_security_group_id = oci_core_network_security_group.glen.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = var.https_ingress_cidr
  source_type               = "CIDR_BLOCK"
  description               = "HTTPS authentication endpoint"

  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

resource "oci_core_instance" "glen" {
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
    assign_public_ip = false
    display_name     = "glen-auth"
    hostname_label   = "glen-auth"
    nsg_ids          = [oci_core_network_security_group.glen.id]
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
    "purpose"    = "glen-auth"
  }

  lifecycle {
    prevent_destroy = true
  }
}

data "oci_core_vnic_attachments" "glen" {
  compartment_id = var.compartment_ocid
  instance_id    = oci_core_instance.glen.id
}

data "oci_core_private_ips" "glen" {
  vnic_id = data.oci_core_vnic_attachments.glen.vnic_attachments[0].vnic_id
}

resource "oci_core_public_ip" "glen" {
  compartment_id = var.compartment_ocid
  display_name   = "glen-auth-reserved"
  lifetime       = "RESERVED"
  private_ip_id  = one([for ip in data.oci_core_private_ips.glen.private_ips : ip.id if ip.is_primary])

  freeform_tags = {
    "managed-by" = "terraform-github-actions"
    "purpose"    = "glen-auth"
  }

  lifecycle {
    prevent_destroy = true
  }
}
