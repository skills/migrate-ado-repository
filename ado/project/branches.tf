# Additional branches for the repository
resource "azuredevops_git_repository_branch" "development" {
  depends_on = [azuredevops_git_repository_file.repo_files]
  
  repository_id = azuredevops_git_repository.repo.id
  name          = "development"
  ref_branch    = azuredevops_git_repository.repo.default_branch
}


resource "azuredevops_git_repository_branch" "hotfix" {
  depends_on = [azuredevops_git_repository_file.repo_files]
  
  repository_id = azuredevops_git_repository.repo.id
  name          = "hotfix"
  ref_branch    = azuredevops_git_repository.repo.default_branch
}
