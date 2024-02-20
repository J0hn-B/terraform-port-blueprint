// This resource uses for_each ==> its values output is a map.

// Return a map example: { for name, value in port_blueprint.environment : name => value.created_at }
// Return only the values: [for value in port_blueprint.environment : value.created_at]

// Return blueprint definition
output "blueprint" {
  value       = { for blueprint, value in port_blueprint.definition : blueprint => value }
  description = "The blueprint definition properties and values"
}
