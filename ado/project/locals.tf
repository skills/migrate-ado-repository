locals {
  # Load configuration from YAML file
  config = yamldecode(file("${path.module}/../config.yml"))
  
  # Extract individual values for easier reference
  ado_project_name    = local.config.ado_project_name
  ado_repository_name = local.config.ado_repository_name

  # Normalize the ADO URL: convert old *.visualstudio.com URLs to dev.azure.com format
  # e.g. https://myorg.visualstudio.com -> https://dev.azure.com/myorg
  ado_url = try("https://dev.azure.com/${regex("https?://(.+)\\.visualstudio\\.com", local.config.ado_url)[0]}", local.config.ado_url)
}
