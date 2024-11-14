# ------------------------------------------------------------------------------
# Identity for GitHub used for continuous delivery.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "identity_cd" {
  resource_group_name = azurerm_resource_group.managed_identities_rg.name
  location            = azurerm_resource_group.managed_identities_rg.location
  name                = "${local.project}-github-cd-id"
  tags                = local.tags
}

# ------------------------------------------------------------------------------
# Identity for auth microservice.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "auth" {
  resource_group_name = azurerm_resource_group.managed_identities_rg.name
  location            = azurerm_resource_group.managed_identities_rg.location
  name                = "${local.project}-auth-id"
  tags                = local.tags
}