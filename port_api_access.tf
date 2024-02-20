// No data resources are available for this provider yet.
// Resources verification is done using the data source http and making requests to the port api.

# Generate a token to access the Port API
data "http" "port_api_token" {
  url    = "https://api.getport.io/v1/auth/access_token"
  method = "POST"

  request_headers = {
    Content-Type = "application/json"
  }
  # Optional request body
  request_body = tostring(jsonencode({ "clientId" : var.client_id, "clientSecret" : var.client_secret }))

}

# Get the blueprints from the port api
data "http" "api_get_blueprint" {
  url    = "https://api.getport.io/v1/blueprints"
  method = "GET"

  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(data.http.port_api_token.response_body)["accessToken"]}"
  }

}


locals {
  # Get a list with all blueprint identifiers from the port api
  port_blueprint_identifier = jsondecode(data.http.api_get_blueprint.response_body)["blueprints"][*]["identifier"]
  port_blueprint            = jsondecode(data.http.api_get_blueprint.response_body)["blueprints"][*]

}


