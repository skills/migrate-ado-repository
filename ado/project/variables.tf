variable "ado_token" {
  type = string
  sensitive = true
  description = "Token used to access Azure DevOps"
}

variable "ado_url" {
  type = string
  description = "Azure DevOps url"
}


variable "project_name" {
  type        = string
  description = "Name of the Azure DevOps project"
  default     = "MigrateFromADO"
}