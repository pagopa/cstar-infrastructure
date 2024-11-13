# ------------------------------------------------------------------------------
# Resource group for app-related stuff.
# ------------------------------------------------------------------------------
resource "azurerm_resource_group" "app" {
  name     = "${local.project}-app-rg"
  location = var.location
  tags     = var.tags
}
