output "instance_id" {
  description = "OCID of the created instance."
  value       = oci_core_instance.a1.id
}

output "instance_state" {
  description = "Current lifecycle state reported by OCI."
  value       = oci_core_instance.a1.state
}

output "public_ip" {
  description = "Public IPv4 address, if one was assigned."
  value       = oci_core_instance.a1.public_ip
}

