resource "azuredevops_project" "this" {
  name                  = var.project_name
  description           = "Project created for migration from Azure DevOps to GitHub"
  # description           = "ADO/GH demo repository for ${var.actor}"
  visibility            = "private"
  work_item_template    = "Basic"
  version_control       = "Git"
}


resource "azuredevops_git_repository" "repo" {
  project_id = azuredevops_project.this.id
  name       = "${var.project_name}Repo"
  initialization {
    init_type = "Clean"
  }
  default_branch = "refs/heads/main"
}
