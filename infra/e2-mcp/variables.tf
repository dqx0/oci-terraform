variable "region" {
  description = "OCI home region identifier."
  type        = string
}

variable "compartment_ocid" {
  description = "OCID of the dedicated application compartment."
  type        = string
}

variable "availability_domain" {
  description = "Availability domain that offers the Always Free E2 Micro shape."
  type        = string
}

variable "subnet_ocid" {
  description = "OCID of the public subnet for the MCP host."
  type        = string
}

variable "image_ocid" {
  description = "Pinned Ubuntu Minimal AMD64 image OCID compatible with VM.Standard.E2.1.Micro."
  type        = string
}

variable "ssh_public_key" {
  description = "OpenSSH public key installed for the ubuntu user."
  type        = string
  sensitive   = true
}

variable "instance_name" {
  description = "Display name of the MCP host."
  type        = string
  default     = "personal-mcp-e2-micro"
}

variable "ssh_ingress_cidr" {
  description = "CIDR allowed to connect over SSH."
  type        = string
  default     = "121.2.38.242/32"
}

variable "mcp_ingress_cidr" {
  description = "CIDR allowed to connect to the future HTTPS MCP endpoint."
  type        = string
  default     = "0.0.0.0/0"
}
