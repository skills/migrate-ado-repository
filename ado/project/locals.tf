locals {
  # Load configuration from YAML file
  config = yamldecode(file("${path.module}/../config.yml"))
  
  # Extract individual values for easier reference
  ado_project_name    = local.config.ado_project_name
  ado_repository_name = local.config.ado_repository_name
  ado_url = local.config.ado_url
}
