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

resource "azurerm_private_dns_zone_virtual_network_link" "internal_cstar_to_secure_hub_vnets" {
  for_each = local.secure_hub_vnets

  name                  = "${each.value.name}-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.private_private_dns_zone.name
  virtual_network_id    = each.value.id
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

resource "azurerm_private_dns_zone_virtual_network_link" "storage_private_endpoint_aks_link" {
  for_each              = { for vnet_aks_domain in module.vnet_aks : vnet_aks_domain.name => vnet_aks_domain.id }
  name                  = "${each.key}-blobstorage-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_account.name
  virtual_network_id    = each.value
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

resource "azurerm_private_dns_zone_virtual_network_link" "aks_cosmosdb_private_virtual_network_link" {
  for_each              = { for n in var.aks_networks : n.domain_name => n }
  name                  = "${local.project}-aks-comosdb-${each.key}-private-dns-zone-link"
  resource_group_name   = azurerm_private_dns_zone.cosmos_mongo[0].resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos_mongo[0].name
  virtual_network_id    = module.vnet_aks[each.key].id
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

resource "azurerm_private_dns_zone" "ehub" {
  count = 1

  name                = "privatelink.servicebus.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

data "azurerm_private_dns_zone" "eventhub_private_dns_zone" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name
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

# Private DNS zones for Data Explorer
resource "azurerm_private_dns_zone" "kusto" {
  name                = "privatelink.westeurope.kusto.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_private_dns_zone" "queue" {
  name                = "privatelink.queue.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_private_dns_zone" "table" {
  name                = "privatelink.table.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

#
# Container app
#
resource "azurerm_private_dns_zone" "container_app" {
  name                = "privatelink.azurecontainerapps.io"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "container_app_link" {
  for_each = { for vnet in data.azurerm_resources.vnets.resources : vnet.id => vnet }

  name                  = "dnslink-${each.value.name}"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.container_app.name
  virtual_network_id    = each.value.id
  tags                  = var.tags
}
