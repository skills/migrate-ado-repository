resource "azuredevops_project" "this" {
  name                  = local.ado_project_name
  description           = "Project created for migration from Azure DevOps to GitHub"
  visibility            = "private"
  work_item_template    = "Basic"
  version_control       = "Git"
}


resource "azuredevops_git_repository" "repo" {
  project_id = azuredevops_project.this.id
  name       = local.ado_repository_name
  initialization {
    init_type = "Clean"
  }
  default_branch = "refs/heads/main"
}
