# ------------------------------------------------------------------------------
# Create GitHub secret with Tenant ID for each repository.
# ------------------------------------------------------------------------------
resource "github_actions_environment_secret" "azure_cd_tenant_id" {
  for_each        = { for x in local.repositories : x.repository => x }
  repository      = each.value.repository
  environment     = local.project
  secret_name     = "AZURE_TENANT_ID"
  plaintext_value = data.azurerm_client_config.current.tenant_id
}

# ------------------------------------------------------------------------------
# Create GitHub secret with Subscription ID for each repository.
# ------------------------------------------------------------------------------
resource "github_actions_environment_secret" "azure_cd_subscription_id" {
  for_each        = { for x in local.repositories : x.repository => x }
  repository      = each.value.repository
  environment     = local.project
  secret_name     = "AZURE_SUBSCRIPTION_ID"
  plaintext_value = data.azurerm_subscription.current.subscription_id
}

# ------------------------------------------------------------------------------
# Create GitHub secret with Client ID for each repository.
# ------------------------------------------------------------------------------
resource "github_actions_environment_secret" "azure_cd_client_id" {
  for_each        = { for x in local.repositories : x.repository => x }
  repository      = each.value.repository
  environment     = local.project
  secret_name     = "AZURE_CLIENT_ID"
  plaintext_value = azurerm_user_assigned_identity.identity_cd.client_id
}