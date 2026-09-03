output "instance_id" {
  description = "OCID of the MCP host."
  value       = oci_core_instance.mcp.id
}

output "instance_state" {
  description = "Current lifecycle state of the MCP host."
  value       = oci_core_instance.mcp.state
}

output "public_ip" {
  description = "Public IPv4 address of the MCP host."
  value       = oci_core_instance.mcp.public_ip
}
