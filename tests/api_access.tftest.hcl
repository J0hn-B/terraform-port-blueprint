
provider "port" {
  client_id = var.client_id
  secret    = var.client_secret

}


variables {

  // Set the path to the directory containing the blueprint json files
  blueprint_dir = "./tests/json"

  blueprint_repo = ""

}

// Verify the token to access the Port API
run "verify_port_api_token" {

  command = plan

  // Check the url of the api access post_request
  assert {
    condition     = data.http.port_api_token.url == "https://api.getport.io/v1/auth/access_token"
    error_message = "url is not https://api.getport.io/v1/auth/access_token for ${data.http.port_api_token.url}"
  }

  // Check the status code of the api access post_request
  assert {
    condition     = data.http.port_api_token.status_code == 200
    error_message = "status code is not 200 for ${data.http.port_api_token.url}"
  }

}

// Verify the blueprints from the port api
run "verify_api_get_blueprint" {

  command = plan

  // Check the url of the blueprint get_request
  assert {
    condition     = data.http.api_get_blueprint.url == "https://api.getport.io/v1/blueprints"
    error_message = "url is not https://api.getport.io/v1/blueprints for ${data.http.api_get_blueprint.url}"
  }

  // Check the status code of the blueprint get_request
  assert {
    condition     = data.http.api_get_blueprint.status_code == 200
    error_message = "status code is not 200 for ${data.http.api_get_blueprint.url}"
  }

}
