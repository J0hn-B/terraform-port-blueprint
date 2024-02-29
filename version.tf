
terraform {
  required_providers {
    port = {
      source  = "port-labs/port-labs"
      version = ">= 1.10.1"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.4.1"
    }
  }
}
