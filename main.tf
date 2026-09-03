resource "oci_core_instance" "a1" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = var.instance_name
  shape               = "VM.Standard.A1.Flex"

  capacity_reservation_id = null

  shape_config {
    ocpus         = var.ocpus
    memory_in_gbs = var.memory_in_gbs
  }

  source_details {
    source_id               = var.image_ocid
    source_type             = "image"
    boot_volume_size_in_gbs = 50
  }

  create_vnic_details {
    assign_public_ip = var.assign_public_ip
    subnet_id        = var.subnet_ocid
  }

  metadata = {
    ssh_authorized_keys = trimspace(var.ssh_public_key)
  }

  freeform_tags = {
    "managed-by" = "terraform-github-actions"
    "purpose"    = "a1-capacity-watcher"
  }

  lifecycle {
    prevent_destroy = true
  }
}
