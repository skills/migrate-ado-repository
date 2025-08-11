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
  overwrite_on_create = true
  
  # Prevent parallel execution to ensure distinct commits
  lifecycle {
    create_before_destroy = false
  }
}

# Additional branch for the repository
resource "azuredevops_git_repository_branch" "update_readme" {
  depends_on = [azuredevops_git_repository_file.repo_files]
  
  repository_id = azuredevops_git_repository.repo.id
  name          = "update-readme"
  ref_branch    = azuredevops_git_repository.repo.default_branch
}

# Create updated README.md file on the update-readme branch
resource "azuredevops_git_repository_file" "updated_readme" {
  depends_on = [azuredevops_git_repository_branch.update_readme]
  
  repository_id       = azuredevops_git_repository.repo.id
  branch              = "refs/heads/update-readme"
  
  file                = "README.md"
  content             = <<-EOT
    # Migration Demo Repository (Updated)

    This repository demonstrates Azure DevOps to GitHub migration using infrastructure as code.

    ## Contents

    - `app.py` - Python application
    - `README.md` - Documentation (updated)
    - `azure-pipelines.yml` - CI/CD pipeline

    ## Migration Features

    - Multi-file repository setup
    - Branch policies and build validation  
    - Work item management
    - Multi-branch workflow demonstration

    Ready for GitHub migration!
  EOT
  commit_message      = "Update README with comprehensive documentation"
  
  overwrite_on_create = true
}

