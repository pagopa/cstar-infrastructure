# ------------------------------------------------------------------------------
# Resource group for data-related stuff.
# ------------------------------------------------------------------------------
resource "azurerm_resource_group" "data" {
  name     = "${local.project}-data-rg"
  location = var.location
  tags     = var.tags
}

# ------------------------------------------------------------------------------
# Resource group for front-end stuff.
# ------------------------------------------------------------------------------
resource "azurerm_resource_group" "rtp_frontend_rg" {
  name     = "${local.project}-fe-rg"
  location = var.location
  tags     = var.tags
}

# ------------------------------------------------------------------------------
# Resource group for network-related stuff.
# ------------------------------------------------------------------------------
resource "azurerm_resource_group" "network" {
  name     = "${local.project}-network-rg"
  location = var.location
  tags     = var.tags
}