# Private DNS Zone for API Management

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

#
# Records for private dns zone
#
resource "azurerm_private_dns_a_record" "private_dns_a_record_api" {
  name                = "apim"
  zone_name           = azurerm_private_dns_zone.private_private_dns_zone.name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  ttl                 = var.dns_default_ttl_sec
  records             = module.apim.*.private_ip_addresses[0]
}

# dev portal
resource "azurerm_private_dns_a_record" "private_dns_a_record_portal" {
  name                = "portal"
  zone_name           = azurerm_private_dns_zone.private_private_dns_zone.name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  ttl                 = var.dns_default_ttl_sec
  records             = module.apim.*.private_ip_addresses[0]
}

# apim management
resource "azurerm_private_dns_a_record" "private_dns_a_record_management" {
  name                = "management"
  zone_name           = azurerm_private_dns_zone.private_private_dns_zone.name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  ttl                 = var.dns_default_ttl_sec
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

resource "azurerm_private_dns_zone_virtual_network_link" "storage_account_vnet_integration" {
  name                  = module.vnet_integration.name
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_account.name
  virtual_network_id    = module.vnet_integration.id
}

resource "azurerm_private_dns_a_record" "storage_account_tkm" {
  count = var.dns_storage_account_tkm != null ? 1 : 0

  name                = var.dns_storage_account_tkm.name
  zone_name           = azurerm_private_dns_zone.storage_account.name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  ttl                 = var.dns_default_ttl_sec
  records             = var.dns_storage_account_tkm.ips
}

# Cosmos MongoDB private dns zone

resource "azurerm_private_dns_zone" "cosmos_mongo" {
  count = var.cosmos_mongo_db_params.enabled ? 1 : 0

  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_vnet" {
  count = var.cosmos_mongo_db_params.enabled ? 1 : 0

  name                  = module.vnet.name
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos_mongo[count.index].name
  virtual_network_id    = module.vnet.id
  registration_enabled  = false

  tags = var.tags
}

# Private DNS Zone for Azure Data Factory

resource "azurerm_private_dns_zone" "adf" {
  name                = "privatelink.datafactory.azure.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "adf_vnet" {
  name                  = format("%s-adf-private-dns-zone-link", local.project)
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.adf.name
  virtual_network_id    = module.vnet.id
}
