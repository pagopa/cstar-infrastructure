# ------------------------------------------------------------------------------
# Private DNS zone for CosmosDB NoSQL.
#
# TODO: To be moved to core.
# ------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "cosmos_nosql" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = azurerm_resource_group.network.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_nosql_to_intern" {
  name                  = "cosmos_nosql_to_intern"
  resource_group_name   = azurerm_private_dns_zone.cosmos_nosql.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos_nosql.name
  virtual_network_id    = data.azurerm_virtual_network.intern.id
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_nosql_to_core" {
  name                  = "cosmos_nosql_to_core"
  resource_group_name   = azurerm_private_dns_zone.cosmos_nosql.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos_nosql.name
  virtual_network_id    = data.azurerm_virtual_network.core.id
  tags                  = var.tags
}