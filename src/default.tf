resource "azurerm_resource_group" "roleassignment_default_rg" {
  name     = "roleassignment-default-rg"
  location = var.location

  tags = var.tags
}
