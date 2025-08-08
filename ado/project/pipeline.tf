resource "azuredevops_build_definition" "pipeline" {
  project_id = azuredevops_project.this.id
  name       = "Build Validation"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.repo.id
    branch_name = azuredevops_git_repository.repo.default_branch
    yml_path    = azuredevops_git_repository_file.repo_files["azure-pipelines.yml"].file
  }
}



