# Github environment
resource "github_repository_environment" "gh_env" {
  for_each            = { for x in local.repositories : x.repository => x }
  environment         = local.project
  repository          = each.value.repository
  prevent_self_review = true
  deployment_branch_policy {
    protected_branches     = var.env_short == "d" ? false : true
    custom_branch_policies = false
  }
}

# ------------------------------------------------------------------------------
# Create GitHub secret with Tenant ID in each repository.
# ------------------------------------------------------------------------------
resource "github_actions_environment_secret" "azure_cd_tenant_id" {
  for_each        = { for x in local.repositories : x.repository => x }
  repository      = each.value.repository
  environment     = local.project
  secret_name     = "AZURE_TENANT_ID"
  plaintext_value = data.azurerm_client_config.current.tenant_id
}

# ------------------------------------------------------------------------------
# Create GitHub secret with Subscription ID in each repository.
# ------------------------------------------------------------------------------
resource "github_actions_environment_secret" "azure_cd_subscription_id" {
  for_each        = { for x in local.repositories : x.repository => x }
  repository      = each.value.repository
  environment     = local.project
  secret_name     = "AZURE_SUBSCRIPTION_ID"
  plaintext_value = data.azurerm_subscription.current.subscription_id
}

# ------------------------------------------------------------------------------
# Create GitHub secret with Client ID in each repository.
# ------------------------------------------------------------------------------
resource "github_actions_environment_secret" "azure_cd_client_id" {
  for_each        = { for x in local.repositories : x.repository => x }
  repository      = each.value.repository
  environment     = local.project
  secret_name     = "AZURE_CLIENT_ID"
  plaintext_value = azurerm_user_assigned_identity.identity_cd.client_id
}
