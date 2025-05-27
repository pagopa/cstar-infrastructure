# ------------------------------------------------------------------------------
# Identity for GitHub used for continuous delivery.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "identity_cd" {
  resource_group_name = azurerm_resource_group.managed_identities_rg.name
  location            = azurerm_resource_group.managed_identities_rg.location
  name                = "${local.project}-github-cd-id"
  tags                = var.tags
}

# ------------------------------------------------------------------------------
# Identity for rtp-activator microservice.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "activator" {
  resource_group_name = azurerm_resource_group.managed_identities_rg.name
  location            = azurerm_resource_group.managed_identities_rg.location
  name                = "${local.project}-activator-id"
  tags                = var.tags
}

# ------------------------------------------------------------------------------
# Identity for rtp-sender microservice.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "sender" {
  resource_group_name = azurerm_resource_group.managed_identities_rg.name
  location            = azurerm_resource_group.managed_identities_rg.location
  name                = "${local.project}-sender-id"
  tags                = var.tags
}
