# Work items for testing migration scenarios

resource "azuredevops_workitem" "update_readme" {
  project_id = azuredevops_project.this.id
  title      = "Update README documentation"
  type       = "Issue"
  state      = "To Do"
  
  tags = ["documentation"]
}
