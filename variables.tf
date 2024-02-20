variable "client_id" {
  type        = string
  description = "value of Port API client id"
}

variable "client_secret" {
  type        = string
  description = "value of Port API client secret"
}

variable "blueprint_dir" {
  type        = string
  default     = ""
  description = "Local path to the directory containing the blueprint json files"
}

variable "blueprint_repo" {
  type        = string
  default     = ""
  description = "Access the content of blueprint json files"
}

variable "force_delete_entities" {
  type        = bool
  description = "force delete entities"
  default     = false
}

