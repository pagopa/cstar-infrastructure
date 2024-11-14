# ------------------------------------------------------------------------------
# Resource group for security-related stuff.
# ------------------------------------------------------------------------------
resource "azurerm_resource_group" "sec" {
  name     = "${local.project}-sec-rg"
  location = var.location
  tags     = var.tags
}

# ------------------------------------------------------------------------------
# Resource group for app-related stuff.
# ------------------------------------------------------------------------------
resource "azurerm_resource_group" "app" {
  name     = "${local.project}-app-rg"
  location = var.location
  tags     = var.tags
}

# ------------------------------------------------------------------------------
# Resource group for managed identity
# ------------------------------------------------------------------------------
resource "azurerm_resource_group" "managed_identities_rg" {
  name     = "${local.project}-identity-rg"
  location = var.location
  tags     = var.tags
}
