
provider "port" {
  client_id = var.client_id
  secret    = var.client_secret

}


variables {

  // Set the path to the directory containing the blueprint json files
  blueprint_dir = "./tests/json"

  blueprint_repo = ""
}

// Test blueprints directory and their contents

run "blueprint_directory_is_not_empty" {

  command = plan

  // Verify that the directory containing the blueprint json files is not empty
  assert {
    condition     = length(local.dir_files) != 0
    error_message = "no files found in ${var.blueprint_dir}"
  }

}

run "blueprint_required_keys_are_not_empty" {

  command = plan

  // Verify each blueprint "identifier" is not empty:
  ## "identifier": "basic_empty_blueprint" ==> "": "basic_empty_blueprint"

  assert {
    condition     = anytrue([for value in local.merge_blueprint : contains([""], value.identifier)]) == false
    error_message = "'identifier' key is empty or missing in dir: ${var.blueprint_dir}"
  }

  // Verify each blueprint "title" is not empty:
  ## "title": "basic-empty-blueprint" ==> "": "basic-empty-blueprint"

  assert {
    condition     = anytrue([for value in local.merge_blueprint : contains([""], value.title)]) == false
    error_message = "'title' key is empty or missing in dir: ${var.blueprint_dir}"
  }

}
