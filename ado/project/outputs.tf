
output "repository_url" {
  description = "The URL of the created repository"
  value       = azuredevops_git_repository.repo.remote_url
}

output "project_name" {
  description = "The name of the created project"
  value       = azuredevops_project.this.name
}

