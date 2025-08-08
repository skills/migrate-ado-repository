# Work items for testing migration scenarios
resource "azuredevops_workitem" "sample_migration_issue" {
  project_id = azuredevops_project.this.id
  title      = "Sample work item for migration testing"
  type       = "Issue"
  state      = "To Do"
  
  tags = ["migration", "testing"]
}

resource "azuredevops_workitem" "update_readme" {
  project_id = azuredevops_project.this.id
  title      = "Update README documentation"
  type       = "Issue"
  state      = "To Do"
  
  tags = ["documentation", "readme"]
}
