//  main.tf

# Provider
terraform {
  required_providers {
    port-labs = {
      source  = "port-labs/port-labs"
      version = "~> 1.10.1"
    }
  }
}

provider "port-labs" {
  client_id = var.client_id
  secret    = var.client_secret
}

# Variables
variable "client_id" { type = string }
variable "client_secret" { type = string }

# Module
module "port" {

  // Set the module source
  source  = "github.com/J0hn-B/terraform-port-blueprint"
  version = "~> 0.1"

  // Port API credentials used by hashicorp/http provider (required)
  client_id     = var.client_id
  client_secret = var.client_secret

  // Set the path to the directory containing the blueprint json files (required)
  blueprint_dir = "${path.module}/blueprint_json_files"

  // Force delete entities (optional)
  force_delete_entities = true

}

# Outputs
output "blueprint" {
  value = module.port.blueprint

  // Access output values (examples)
  // module.port.blueprint["githubWorkflowRun"]["relations"]["workflow"]["target"]
}

