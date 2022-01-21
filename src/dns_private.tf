resource "azurerm_private_dns_zone" "private_private_dns_zone" {
  name                = var.internal_private_domain
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_private_dns_zone_virtual_network_link" {
  name                  = format("%s-api-private-dns-zone-link", local.project)
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.private_private_dns_zone.name
  virtual_network_id    = module.vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_integration_dns_zone_virtual_network_link" {
  name                  = format("%s-integration-private-dns-zone-link", local.project)
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.private_private_dns_zone.name
  virtual_network_id    = module.vnet_integration.id
}

resource "azurerm_private_dns_a_record" "private_dns_a_record_api" {
  name                = "apim"
  zone_name           = azurerm_private_dns_zone.private_private_dns_zone.name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  ttl                 = 300
  records             = module.apim.*.private_ip_addresses[0]
}

# dev portal
resource "azurerm_private_dns_a_record" "private_dns_a_record_portal" {
  name                = "portal"
  zone_name           = azurerm_private_dns_zone.private_private_dns_zone.name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  ttl                 = 300
  records             = module.apim.*.private_ip_addresses[0]
}

# apim management
resource "azurerm_private_dns_a_record" "private_dns_a_record_management" {
  name                = "management"
  zone_name           = azurerm_private_dns_zone.private_private_dns_zone.name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  ttl                 = 300
  records             = module.apim.*.private_ip_addresses[0]
}

# Private DNS Zone for Postgres Databases

resource "azurerm_private_dns_zone" "postgres" {
  name                = "private.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_vnet" {
  name                  = format("%s-postgres-vnet-private-dns-zone-link", local.project)
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = module.vnet.id
}

# Private DNS Zone for Storage Accounts

resource "azurerm_private_dns_zone" "storage_account" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_account_vnet" {
  name                  = format("%s-storage-account-vnet-private-dns-zone-link", local.project)
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_account.name
  virtual_network_id    = module.vnet.id
}
# Cosmos MongoDB private dns zone

resource "azurerm_private_dns_zone" "cosmos_mongo" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_vnet" {
  name                  = module.vnet.name
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos_mongo.name
  virtual_network_id    = module.vnet.id
  registration_enabled  = false

  tags = var.tags
}
