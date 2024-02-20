
# Create blueprints for the Port API
resource "port_blueprint" "definition" {

  for_each = local.merge_blueprint

  identifier = each.value.identifier
  title      = each.value.title
  // Optional
  icon                  = contains(keys(each.value), "icon") ? each.value.icon : null
  description           = contains(keys(each.value), "description") ? each.value.description : null
  force_delete_entities = var.force_delete_entities


  properties = contains(keys(each.value.schema), "properties") ? {

    string_props = { for k, v in each.value.schema.properties : k => {

      default             = contains(keys(v), "default") ? v.default : null
      description         = contains(keys(v), "description") ? v.description : null
      enum                = contains(keys(v), "enum") ? v.enum : null
      enum_colors         = contains(keys(v), "enumColors") ? v.enumColors : null
      format              = contains(keys(v), "format") ? v.format : null
      icon                = contains(keys(v), "icon") ? v.icon : null
      max_length          = contains(keys(v), "maxLength") ? v.maxLength : null
      min_length          = contains(keys(v), "minLength") ? v.minLength : null
      pattern             = contains(keys(v), "pattern") ? v.pattern : null
      required            = contains(keys(each.value.schema), "required") ? contains(each.value.schema.required, k) : false
      spec                = contains(keys(v), "spec") ? v.spec : null
      spec_authentication = contains(keys(v), "specAuthentication") ? v.spec_authentication : null
      title               = contains(keys(v), "title") ? v.title : null

    } if v.type == "string" }

    number_props = { for k, v in each.value.schema.properties : k => {

      default     = contains(keys(v), "default") ? v.default : null
      description = contains(keys(v), "description") ? v.description : null
      enum        = contains(keys(v), "enum") ? v.enum : null
      enum_colors = contains(keys(v), "enumColors") ? v.enumColors : null
      icon        = contains(keys(v), "icon") ? v.icon : null
      maximum     = contains(keys(v), "maximum") ? v.maximum : null
      minimum     = contains(keys(v), "minimum") ? v.minimum : null
      required    = contains(keys(each.value.schema), "required") ? contains(each.value.schema.required, k) : false
      title       = contains(keys(v), "title") ? v.title : null

    } if v.type == "number" }

    boolean_props = { for k, v in each.value.schema.properties : k => {

      default     = contains(keys(v), "default") ? v.default : null
      description = contains(keys(v), "description") ? v.description : null
      icon        = contains(keys(v), "icon") ? v.icon : null
      required    = contains(keys(each.value.schema), "required") ? contains(each.value.schema.required, k) : false
      title       = contains(keys(v), "title") ? v.title : null
    } if v.type == "boolean" }


    object_props = { for k, v in each.value.schema.properties : k => {

      default     = contains(keys(v), "default") ? v.default : null
      description = contains(keys(v), "description") ? v.description : null
      icon        = contains(keys(v), "icon") ? v.icon : null
      required    = contains(keys(each.value.schema), "required") ? contains(each.value.schema.required, k) : false
      title       = contains(keys(v), "title") ? v.title : null
      spec        = contains(keys(v), "spec") ? v.spec : null

    } if v.type == "object" }

    array_props = { for k, v in each.value.schema.properties : k => {
      description = contains(keys(v), "description") ? v.description : null
      icon        = contains(keys(v), "icon") ? v.icon : null
      title       = contains(keys(v), "title") ? v.title : null
      max_items   = contains(keys(v), "maxItems") ? v.maxItems : null
      min_items   = contains(keys(v), "minItems") ? v.minItems : null
      required    = contains(keys(each.value.schema), "required") ? contains(each.value.schema.required, k) : false


      string_items = contains(keys(v), "items") ? contains(keys(v.items), "type") == "string" ? {
        default = contains(keys(v.items), "default") ? [v.items.default] : null
        format  = contains(keys(v.items), "format") ? v.items.format : null
      } : null : null

      number_items = contains(keys(v), "items") ? contains(keys(v.items), "type") == "number" ? {
        default = contains(keys(v.items), "default") ? [v.items.default] : null
      } : null : null

      object_items = contains(keys(v), "items") ? contains(keys(v.items), "type") == "object" ? {
        default = contains(keys(v.items), "default") ? [v.items.default] : null
      } : null : null

      boolean_items = contains(keys(v), "items") ? contains(keys(v.items), "type") == "boolean" ? {
        default = contains(keys(v.items), "default") ? [v.items.default] : null
      } : null : null

    } if v.type == "array" }

  } : null

  // Relations define conections between blueprints already defined in the Port API
  relations = contains(keys(each.value), "relations") ? { for k, v in each.value.relations : k => {
    target   = contains(keys(v), "target") ? v.target : null
    title    = contains(keys(v), "title") ? v.title : null
    required = contains(keys(v), "required") ? v.required : null
    many     = contains(keys(v), "many") ? v.many : null

    } if contains(local.port_blueprint_identifier, each.value.identifier)

  } : null

  calculation_properties = contains(keys(each.value), "calculationProperties") ? { for k, v in each.value.calculationProperties : k => {
    calculation = contains(keys(v), "calculation") ? v.calculation : null
    type        = contains(keys(v), "type") ? v.type : null
    colorized   = contains(keys(v), "colorized ") ? v.colorized : null
    colors      = contains(keys(v), "colors") ? v.colors : null
    description = contains(keys(v), "description") ? v.description : null
    format      = contains(keys(v), "format") ? v.format : null
    icon        = contains(keys(v), "icon") ? v.icon : null
    title       = contains(keys(v), "title") ? v.title : null

    } if contains(local.port_blueprint_identifier, each.value.identifier)

  } : null

  // Mirror properties can be used for blueprints that have relations defined.
  mirror_properties = contains(keys(each.value), "mirrorProperties") ? { for k, v in each.value.mirrorProperties : k => {
    path  = contains(keys(v), "path") ? v.path : null
    title = contains(keys(v), "title") ? v.title : null

    } if contains([for value in local.port_blueprint : value.identifier if value.relations != {}], each.value.identifier)

  } : null

}

