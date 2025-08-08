output "repository_id" {
  description = "The ID of the created repository"
  value       = azuredevops_git_repository.repo.id
}

output "repository_url" {
  description = "The URL of the created repository"
  value       = azuredevops_git_repository.repo.remote_url
}
