variable "region" {
  description = "OCI region identifier, for example ap-tokyo-1."
  type        = string
}

variable "compartment_ocid" {
  description = "OCID of the compartment in which to create the instance."
  type        = string
}

variable "availability_domain" {
  description = "Full availability domain name, for example xxxx:AP-TOKYO-1-AD-1."
  type        = string
}

variable "subnet_ocid" {
  description = "OCID of the subnet for the primary VNIC."
  type        = string
}

variable "image_ocid" {
  description = "OCID of the Ubuntu 26.04 ARM64 image in the selected region."
  type        = string
}

variable "ssh_public_key" {
  description = "OpenSSH-format public key installed for the default Ubuntu user."
  type        = string
  sensitive   = true
}

variable "instance_name" {
  description = "Display name used for the instance."
  type        = string
  default     = "a1-capacity-watcher"
}

variable "ocpus" {
  description = "Number of A1 OCPUs."
  type        = number
  default     = 1

  validation {
    condition     = var.ocpus >= 1 && var.ocpus <= 2
    error_message = "ocpus must be between 1 and 2 for the current Always Free allocation."
  }
}

variable "memory_in_gbs" {
  description = "Memory assigned to the A1 instance in GiB."
  type        = number
  default     = 6

  validation {
    condition     = var.memory_in_gbs >= 1 && var.memory_in_gbs <= 12
    error_message = "memory_in_gbs must be between 1 and 12 for the current Always Free allocation."
  }
}

variable "assign_public_ip" {
  description = "Whether OCI should assign a public IPv4 address to the primary VNIC."
  type        = bool
  default     = true
}
