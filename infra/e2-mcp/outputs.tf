output "instance_id" {
  description = "OCID of the MCP host."
  value       = oci_core_instance.mcp.id
}

output "instance_state" {
  description = "Current lifecycle state of the MCP host."
  value       = oci_core_instance.mcp.state
}

output "public_ip" {
  description = "Reserved public IPv4 address of the MCP host."
  value       = oci_core_public_ip.mcp.ip_address
}

output "public_ip_id" {
  description = "OCID of the reserved public IPv4 address."
  value       = oci_core_public_ip.mcp.id
}
