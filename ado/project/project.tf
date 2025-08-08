resource "azuredevops_project" "this" {
  name                  = var.project_name
  description           = "Project created for migration from Azure DevOps to GitHub"
  # description           = "ADO/GH demo repository for ${var.actor}"
  visibility            = "private"
  work_item_template    = "Basic"
}


resource "azuredevops_git_repository" "repo" {
  project_id = azuredevops_project.this.id
  name       = var.project_name
  initialization {
    init_type = "Clean"
  }
  default_branch = "refs/heads/main"
}

# Local values to define the files to create
locals {
  # Dynamically discover all files in the files directory
  files_directory = "${path.module}/files"
  
  # Get all files from the files directory
  discovered_files = fileset(local.files_directory, "*")
  
  # Define files with their respective commit messages
  repository_files = {
    for filename in local.discovered_files : filename => {
      content = file("${local.files_directory}/${filename}")
      commit_message = "Add ${filename}"
    }
  }
  
}

# Create repository files using for_each loop
# Each file will be created in a separate commit
resource "azuredevops_git_repository_file" "repo_files" {
  for_each = local.repository_files
  
  repository_id       = azuredevops_git_repository.repo.id
  branch              = "refs/heads/main"

  file                = each.key
  content             = each.value.content
  commit_message      = each.value.commit_message

  overwrite_on_create = true
}

# Output the repository information
output "repository_id" {
  description = "The ID of the created repository"
  value       = azuredevops_git_repository.repo.id
}

output "repository_url" {
  description = "The URL of the created repository"
  value       = azuredevops_git_repository.repo.remote_url
}
