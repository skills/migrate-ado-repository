
output "repository_url" {
  description = "The URL of the created repository"
  value       = azuredevops_git_repository.repo.web_url
}

output "project_name" {
  description = "The name of the created project"
  value       = azuredevops_project.this.name
}

output "repository_id" {
  description = "The ID of the created repository"
  value       = azuredevops_git_repository.repo.id
}

output "repository_name" {
  description = "The name of the created repository"
  value       = azuredevops_git_repository.repo.name
}

output "updated_branch" {
  description = "The name of the source branch for pull request"
  value       = azuredevops_git_repository_branch.update_readme.name
}

output "organization_url" {
  description = "The Azure DevOps organization URL"
  value       = local.ado_url
}

output "update_readme_work_item_id" {
  description = "The ID of the update README work item"
  value       = azuredevops_workitem.update_readme.id
}

