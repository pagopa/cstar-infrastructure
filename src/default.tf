resource "azurerm_resource_group" "default_roleassignment_rg" {
  name     = "default-roleassignment-rg"
  location = var.location

  tags = var.tags
}
