# ------------------------------------------------------------------------------
# Private endpoint from ACA subnet to CosmosDB NoSQL.
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "cosmos_nosql" {
  name                = "${local.project}-cosmos-nosql-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = data.azurerm_subnet.aca.id

  custom_network_interface_name = "${local.project}-cosmos-nosql-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-cosmos-nosql-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.cosmos_nosql.id]
  }

  private_service_connection {
    name                           = "${local.project}-cosmos-nosql-psc"
    private_connection_resource_id = azurerm_cosmosdb_account.rtp.id
    subresource_names              = ["Sql"]
    is_manual_connection           = false
  }

  tags = var.tags
}

# ------------------------------------------------------------------------------
# Private endpoint from "private endpoints" subnet to CosmosDB NoSQL for VPN.
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "cosmos_nosql_vpn" {
  name                = "${local.project}-cosmos-nosql-vpn-pep"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  subnet_id           = data.azurerm_subnet.private_endpoints.id

  custom_network_interface_name = "${local.project}-cosmos-nosql-vpn-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-cosmos-nosql-vpn-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.cosmos_nosql.id]
  }

  private_service_connection {
    name                           = "${local.project}-cosmos-nosql-vpn-psc"
    private_connection_resource_id = azurerm_cosmosdb_account.rtp.id
    subresource_names              = ["Sql"]
    is_manual_connection           = false
  }

  tags = var.tags
}