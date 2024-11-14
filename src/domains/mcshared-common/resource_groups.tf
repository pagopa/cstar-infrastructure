# ------------------------------------------------------------------------------
# Resource group for network-related stuff.
# ------------------------------------------------------------------------------
resource "azurerm_resource_group" "network" {
  name     = "${local.project}-network-rg"
  location = var.location
  tags     = local.tags
}

# ------------------------------------------------------------------------------
# Resource group for security-related stuff.
# ------------------------------------------------------------------------------
resource "azurerm_resource_group" "sec" {
  name     = "${local.project}-sec-rg"
  location = var.location
  tags     = local.tags
}

# ------------------------------------------------------------------------------
# Resource group for data-related stuff.
# ------------------------------------------------------------------------------
resource "azurerm_resource_group" "data" {
  name     = "${local.project}-data-rg"
  location = var.location
  tags     = local.tags
}

# ------------------------------------------------------------------------------
# Resource group for app-related stuff.
# ------------------------------------------------------------------------------
resource "azurerm_resource_group" "app" {
  name     = "${local.project}-app-rg"
  location = var.location
  tags     = local.tags
}

# ------------------------------------------------------------------------------
# Resource group for monitor stuff.
# ------------------------------------------------------------------------------
resource "azurerm_resource_group" "monitor" {
  name     = "${local.project}-monitor-rg"
  location = var.location
  tags     = local.tags
}

# ------------------------------------------------------------------------------
# Resource group for managed identity
# ------------------------------------------------------------------------------
resource "azurerm_resource_group" "managed_identities_rg" {
  name     = "${local.project}-identity-rg"
  location = var.location
  tags     = local.tags
}