# ------------------------------------------------------------------------------
# Private endpoint from ACA subnet to CosmosDB mongo.
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "cosmos_mongo" {
  name                = "${local.project}-cosmos-mongo-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = data.azurerm_subnet.aca.id

  custom_network_interface_name = "${local.project}-cosmos-mongo-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-cosmos-mongo-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.cosmos_mongo.id]
  }

  private_service_connection {
    name                           = "${local.project}-cosmos-mongo-psc"
    private_connection_resource_id = azurerm_cosmosdb_account.rtp.id
    subresource_names              = ["MongoDB"]
    is_manual_connection           = false
  }

  tags = var.tags
}

# ------------------------------------------------------------------------------
# Private endpoint from "private endpoints" subnet to CosmosDB Mongo for VPN.
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "cosmos_mongo_vpn" {
  name                = "${local.project}-cosmos-mongo-vpn-pep"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  subnet_id           = data.azurerm_subnet.private_endpoints.id

  custom_network_interface_name = "${local.project}-cosmos-mongo-vpn-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-cosmos-mongo-vpn-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.cosmos_mongo.id]
  }

  private_service_connection {
    name                           = "${local.project}-cosmos-mongo-vpn-psc"
    private_connection_resource_id = azurerm_cosmosdb_account.rtp.id
    subresource_names              = ["MongoDB"]
    is_manual_connection           = false
  }

  tags = var.tags
}