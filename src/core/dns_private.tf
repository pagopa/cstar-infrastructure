# Private DNS Zone for API Management

#
# internal.cstar.pagopa.it
#
resource "azurerm_private_dns_zone" "private_private_dns_zone" {
  name                = var.internal_private_domain
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_private_dns_zone_virtual_network_link" {
  name                  = "${local.project}-api-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.private_private_dns_zone.name
  virtual_network_id    = module.vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_integration_dns_zone_virtual_network_link" {
  name                  = "${local.project}-integration-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.private_private_dns_zone.name
  virtual_network_id    = module.vnet_integration.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "internal_cstar_to_vnet_pair" {
  name                  = "${local.project}-pair-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.private_private_dns_zone.name
  virtual_network_id    = module.vnet_pair.id
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

#
# Private DNS Zone for Postgres Databases
#
resource "azurerm_private_dns_zone" "postgres" {
  name                = "private.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_vnet" {
  name                  = "${local.project}-postgres-vnet-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = module.vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_to_pair" {
  name                  = module.vnet_pair.name
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = module.vnet_pair.id
}

# Just for migration purposes, it will be removed
resource "azurerm_private_dns_zone" "postgres_old" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.db_rg.name
  tags                = var.tags
}

# Just for migration purposes, it will be removed
resource "azurerm_private_dns_zone_virtual_network_link" "postgres_vnet_old" {
  name                  = "${local.project}-postgresql-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.db_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.postgres_old.name
  virtual_network_id    = module.vnet.id
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_vnet_old_to_pair" {
  name                  = module.vnet_pair.name
  resource_group_name   = azurerm_resource_group.db_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.postgres_old.name
  virtual_network_id    = module.vnet_pair.id
  tags                  = var.tags
}

#
# Private DNS Zone for Storage Accounts
#
resource "azurerm_private_dns_zone" "storage_account" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_account_vnet" {
  name                  = "${local.project}-storage-account-vnet-private-dns-zone-link"
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

resource "azurerm_private_dns_zone_virtual_network_link" "storage_link_to_pair" {
  name                  = module.vnet_pair.name
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_account.name
  virtual_network_id    = module.vnet_pair.id
}

resource "azurerm_private_dns_a_record" "storage_account_tkm" {
  count = var.dns_storage_account_tkm != null ? 1 : 0

  name                = var.dns_storage_account_tkm.name
  zone_name           = azurerm_private_dns_zone.storage_account.name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  ttl                 = var.dns_default_ttl_sec
  records             = var.dns_storage_account_tkm.ips
}

#
# Cosmos MongoDB private dns zone
#
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

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_link_to_pair" {
  count = var.cosmos_mongo_db_params.enabled ? 1 : 0

  name                  = module.vnet_pair.name
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos_mongo[count.index].name
  virtual_network_id    = module.vnet_pair.id
  registration_enabled  = false

  tags = var.tags
}

#
# Private DNS Zone for Azure Data Factory
#
resource "azurerm_private_dns_zone" "adf" {
  count = var.enable.tae.adf ? 1 : 0

  name                = "privatelink.datafactory.azure.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "adf_vnet" {
  count = var.enable.tae.adf ? 1 : 0

  name                  = "${local.project}-adf-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.adf[count.index].name
  virtual_network_id    = module.vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "adf_link_to_pair" {
  count = var.enable.tae.adf ? 1 : 0

  name                  = module.vnet_pair.name
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.adf[count.index].name
  virtual_network_id    = module.vnet_pair.id
}


#
# Private DNS zone for EventHub
#
# When BPD queue will be removed this zone will be destroyed.
# THIS MUST BE CONVERTED AS RESOURCE AND IMPORTED
data "azurerm_private_dns_zone" "eventhub_private_dns_zone" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = "${local.project}-msg-rg"
}

# *-vnet and *-integration-vnet private network links are already created by "eventhub" pagopa module
resource "azurerm_private_dns_zone_virtual_network_link" "aks_eventhub_private_virtual_network_link" {
  for_each              = { for n in var.aks_networks : n.domain_name => n }
  name                  = "${local.project}-aks-eventhub-${each.key}-private-dns-zone-link"
  resource_group_name   = data.azurerm_private_dns_zone.eventhub_private_dns_zone.resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.eventhub_private_dns_zone.name
  virtual_network_id    = module.vnet_aks[each.key].id
}

resource "azurerm_private_dns_zone_virtual_network_link" "event_hub_link_to_pair" {
  name                  = module.vnet_pair.name
  resource_group_name   = data.azurerm_private_dns_zone.eventhub_private_dns_zone.resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.eventhub_private_dns_zone.name
  virtual_network_id    = module.vnet_pair.id
}


#
# Private DNS Zone for Redis
#
resource "azurerm_private_dns_zone" "redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "redis_link_to_vnet" {

  name                  = module.vnet.name
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.redis.name
  virtual_network_id    = module.vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "redis_link_to_vnet_pair" {

  name                  = module.vnet_pair.name
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.redis.name
  virtual_network_id    = module.vnet_pair.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "redis_link_to_vnet_aks" {
  for_each              = { for n in var.aks_networks : n.domain_name => n }
  name                  = module.vnet_aks[each.key].name
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.redis.name
  virtual_network_id    = module.vnet_aks[each.key].id
}


