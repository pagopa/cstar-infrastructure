# ------------------------------------------------------------------------------
# Federated identity credentials for GitHub repositories.
# ------------------------------------------------------------------------------
resource "azurerm_federated_identity_credential" "identity_credentials_cd" {
  for_each            = { for g in local.repositories : "${g.repository}.environment.${g.subject}" => g } # key must be unique
  resource_group_name = azurerm_resource_group.managed_identities_rg.name
  name                = "${local.project}-github-${each.value.repository}-environment-${each.value.subject}"
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.identity_cd.id
  subject             = "repo:pagopa/${each.value.repository}:environment:${each.value.subject}-cd"
}