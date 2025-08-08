resource "azuredevops_branch_policy_min_reviewers" "reviewer-policy" {

  project_id = azuredevops_project.this.id

  enabled  = true
  blocking = true

  settings {
    reviewer_count                         = 1
    submitter_can_vote                     = false
    last_pusher_cannot_approve             = true
    allow_completion_with_rejects_or_waits = false
    on_push_reset_approved_votes           = true 

    scope {
      repository_id  = azuredevops_git_repository.repo.id
      repository_ref = azuredevops_git_repository.repo.default_branch
      match_type     = "Exact"
    }
  }

  depends_on = [ 
    azuredevops_git_repository_file.repo_files
  ]
}

resource "azuredevops_branch_policy_build_validation" "build-validation" {
  project_id = azuredevops_project.this.id

  enabled  = true
  blocking = false

  settings {
    display_name                = "Example build validation policy"
    build_definition_id         = azuredevops_build_definition.pipeline.id

    scope {
      repository_id  = azuredevops_git_repository.repo.id
      repository_ref = azuredevops_git_repository.repo.default_branch
      match_type     = "Exact"
    }
  }

  depends_on = [ 
    azuredevops_git_repository_file.repo_files
  ]
}
