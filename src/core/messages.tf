# STILL CONTAINS A PRIVATE ENDPOINT
resource "azurerm_resource_group" "msg_rg" {

  count = 1

  name     = format("%s-msg-rg", local.project)
  location = var.location

  tags = var.tags
}