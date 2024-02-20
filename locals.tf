locals {

  // Iterate over json files in the directory and return their names
  dir_files = fileset(var.blueprint_dir, "/*.json")

  // Get directory json files content
  dir_blueprints = [
    for file in local.dir_files :
    jsondecode(file("${var.blueprint_dir}/${file}"))

    if length(file("${var.blueprint_dir}/${file}")) > 3 # Verify file is not empty
  ]

  // Set identifier as the name of the file. Verify both identifier and title values (required) are not empty
  dir_identifier = { for blueprint in flatten(local.dir_blueprints) : blueprint.identifier => blueprint if length(blueprint.identifier) > 0
  && length(blueprint.title) > 0 }

  // Get blueprint files from the repository
  repo_files = var.blueprint_repo != "" ? [jsondecode(var.blueprint_repo)] : []

  // Set identifier as the name of the file. Verify both identifier and title values (required) are not empty
  repo_identifier = { for blueprint in flatten(local.repo_files) : blueprint.identifier => blueprint if length(blueprint.identifier) > 0
  && length(blueprint.title) > 0 }

  // Merge the local and repository blueprints
  merge_blueprint = merge(local.repo_identifier, local.dir_identifier)

}
