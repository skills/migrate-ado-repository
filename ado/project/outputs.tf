
output "repository_url" {
  description = "The URL of the created repository"
  value       = azuredevops_git_repository.repo.remote_url
}

output "project_name" {
  description = "The name of the created project"
  value       = azuredevops_project.this.name
}

output "repository_id" {
  description = "The ID of the created repository"
  value       = azuredevops_git_repository.repo.id
}

output "update_readme_work_item_id" {
  description = "The ID of the update README work item"
  value       = azuredevops_workitem.update_readme.id
}

