# ------------------------------------------------------------------------------
# Private DNS zone for CosmosDB NoSQL.
#
# TODO: To be moved to core.
# ------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "cosmos_mongo" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = azurerm_resource_group.network.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_mongo_to_intern" {
  name                  = "cosmos_mongo_to_intern"
  resource_group_name   = azurerm_private_dns_zone.cosmos_mongo.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos_mongo.name
  virtual_network_id    = data.azurerm_virtual_network.intern.id
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_mongo_to_core" {
  name                  = "cosmos_mongo_to_core"
  resource_group_name   = azurerm_private_dns_zone.cosmos_mongo.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos_mongo.name
  virtual_network_id    = data.azurerm_virtual_network.core.id
  tags                  = var.tags
}