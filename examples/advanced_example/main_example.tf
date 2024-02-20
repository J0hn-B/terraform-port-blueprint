
// Example advanced configuration

//  main.tf

# Provider
terraform {
  required_providers {
    port-labs = {
      source  = "port-labs/port-labs"
      version = "~> 1.10.1"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.45.0"
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


# Get the json configuration from the gitops repository
data "github_repository" "port_labs" {
  full_name = "port-labs/template-assets"
}

data "github_repository_file" "lean_kubernetes_usecase_bps" {
  repository = data.github_repository.port_labs.full_name
  branch     = "main"
  file       = "kubernetes/blueprints/lean_kubernetes_usecase_bps.json"
}

# Module
module "port" {

  // Set the module source
  source  = "J0hn-B/blueprint/port" #checkov:skip=CKV_TF_1:Ensure Terraform module sources use a commit hash
  version = "~> 0.1"

  // Port API credentials used by hashicorp/http provider
  client_id     = var.client_id
  client_secret = var.client_secret

  // Set the path to the directory containing the blueprint json files
  blueprint_dir = "${path.module}/blueprint_json_files"

  // Get the blueprints json data
  blueprint_repo = data.github_repository_file.lean_kubernetes_usecase_bps.content

  // Force delete entities (optional)
  force_delete_entities = true

}

# Outputs
output "blueprint" {
  value = module.port.blueprint

  // Access output values (examples)
  // module.port.blueprint["workload"]["properties"]["array_props"]["containers"]["description"]
}

