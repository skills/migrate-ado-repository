provider "azuredevops" {
  personal_access_token = var.ado_token
  org_service_url       = local.config.ado_url
}