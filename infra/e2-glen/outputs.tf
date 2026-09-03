output "instance_id" {
  description = "OCID of the Glen authentication host."
  value       = oci_core_instance.glen.id
}

output "instance_state" {
  description = "Current lifecycle state of the Glen authentication host."
  value       = oci_core_instance.glen.state
}

output "private_ip" {
  description = "Private IPv4 address of the Glen authentication host."
  value       = one([for ip in data.oci_core_private_ips.glen.private_ips : ip.ip_address if ip.is_primary])
}

output "public_ip" {
  description = "Reserved public IPv4 address of the Glen authentication host."
  value       = oci_core_public_ip.glen.ip_address
}

output "public_ip_id" {
  description = "OCID of the reserved public IPv4 address."
  value       = oci_core_public_ip.glen.id
}
