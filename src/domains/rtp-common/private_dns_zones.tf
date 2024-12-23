
# ------------------------------------------------------------------------------
# Cosmos MongoDB private dns zone
# ------------------------------------------------------------------------------

data "azurerm_private_dns_zone" "cosmos_mongo" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = var.core_integr_virtual_network_resource_group_name
}