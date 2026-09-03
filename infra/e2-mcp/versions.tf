terraform {
  required_version = ">= 1.12.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "8.23.0"
    }
  }

  backend "oci" {}
}

provider "oci" {
  region = var.region
}
