# ------------------------------------------------------------------------------
# Create GitHub environment for each repository.
# ------------------------------------------------------------------------------
resource "github_team" "admin" {
  name = "pagopa/swc-mil-team-admin"
}

resource "github_repository_environment" "gh_env" {
  for_each            = { for x in local.repositories : x.repository => x }
  repository          = each.value.repository
  environment         = local.project
  can_admins_bypass   = true
  prevent_self_review = true
  reviewers {
    teams = [github_team.admin.id]
  }
  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = false
  }
}