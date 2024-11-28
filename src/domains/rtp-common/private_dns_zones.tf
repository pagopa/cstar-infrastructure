# ------------------------------------------------------------------------------
# Private DNS zone for CosmosDB NoSQL.
#
# TODO: To be moved to core.
# ------------------------------------------------------------------------------
# Cosmos MongoDB private dns zone
data "azurerm_private_dns_zone" "cosmos_mongo" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = var.core_integr_virtual_network_resource_group_name
}


resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_mongo_to_intern" {
  name                  = "cosmos_mongo_to_intern"
  resource_group_name   = azurerm_cosmosdb_mongo_database.db_rtp.resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.cosmos_mongo.name
  virtual_network_id    = data.azurerm_virtual_network.intern.id
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_mongo_to_core" {
  name                  = "cosmos_mongo_to_core"
  resource_group_name   = azurerm_cosmosdb_mongo_database.db_rtp.resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.cosmos_mongo.name
  virtual_network_id    = data.azurerm_virtual_network.core.id
  tags                  = var.tags
}