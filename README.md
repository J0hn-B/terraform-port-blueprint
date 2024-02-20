# Port Blueprint Module

This Terraform module creates [blueprints](https://registry.terraform.io/providers/port-labs/port-labs/latest/docs/resources/port_blueprint) in [Port](https://app.getport.io/) using the blueprint json schema.

1. Create the [blueprint](https://docs.getport.io/build-your-software-catalog/define-your-data-model/setup-blueprint/) in Port and copy the json definition

2. Save the json definition in a local directory or in a git repository

3. Use the module to create the blueprint in Port

## How it works

The module will create the blueprints defined in the blueprint json schema following the order below:

- First run of `terraform apply` will create the blueprints defined in the blueprint json files
  - Second run of `terraform apply` will `add || update` the blueprints relations (if any)
    - Third run of `terraform apply` will `add || update` the blueprints mirrorProperties (if any)

## Examples

[Basic Example Dir](/examples/basic_example/)

```bash
# Export your Port Credentials
export TF_VAR_client_id="your_client_id"
export TF_VAR_client_secret="your_client_secret"
```

---

```bash
# Create a local directory in your root folder
mkdir blueprint_json_files && cd blueprint_json_files

# Download a blueprint JSON file and save it
curl -0 https://raw.githubusercontent.com/port-labs/template-assets/main/kubernetes/blueprints/argo-blueprints.json > argo-blueprints.json

# Create a main.tf
cd ..
touch main.tf
```

```dir
# $ tree
.
|-- blueprint_json_files
|   `-- argo-blueprints.json
`-- main.tf

```

---

```hcl
//  main.tf  (basic example)

# Provider
terraform {
  required_providers {
    port = {
      source  = "port-labs/port-labs"
      version = "~> 1.10.1"
    }
  }
}

provider "port" {
  client_id = var.client_id
  secret    = var.client_secret
}

# Variables
variable "client_id" { type = string }
variable "client_secret" { type = string }

module "port" {

  # Module source
  source = "github.com/J0hn-B/terraform-port-blueprint"
  version = "~> 0.1"

  # Port API credentials
  client_id     = var.client_id
  client_secret = var.client_secret

  # Path to the directory containing the blueprint json files (required)
  blueprint_dir = "${path.module}/blueprint_json_files"

}

# Output
// Return the blueprint definition
output "blueprint" {
  value = module.port.blueprint
}

```

<!-- markdownlint-disable -->
<details>

<summary>Advanced</summary>
<!-- markdownlint-enable -->

[Advanced Example Dir](/examples/advanced_example/)

- Complete the basic example
  - Replace the `main.tf` file with the following code:

```hcl
//  main.tf

# Provider
terraform {
  required_providers {
    port = {
      source  = "port-labs/port-labs"
      version = "~> 1.10.1"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.45.0"
    }
  }
}


provider "port" {
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
  source = "github.com/J0hn-B/terraform-port-blueprint"
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

```

## </details>

---

### Outputs

The module has a single output named `blueprint` which returns the blueprint definition.

Access the output values using the syntax as shown in the example below:

```hcl
output "blueprint" {
  value = module.port.blueprint

  // Access output values (examples)
  // module.port.blueprint["workload"]["properties"]["array_props"]["containers"]["description"]
}
```
