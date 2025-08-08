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
  commit_message      = "Add ${each.key}"

  overwrite_on_create = true
}
