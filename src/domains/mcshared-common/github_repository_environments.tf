# ------------------------------------------------------------------------------
# Create GitHub environment for each repository.
# ------------------------------------------------------------------------------
data "github_team" "admin" {
  slug = "swc-mil-team-admin"
}

resource "github_repository_environment" "gh_env" {
  for_each            = { for x in local.repositories : x.repository => x }
  repository          = each.value.repository
  environment         = local.project
  can_admins_bypass   = true
  prevent_self_review = true

  reviewers {
    teams = [data.github_team.admin.id]
  }
}