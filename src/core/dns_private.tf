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
# resource "azurerm_private_dns_zone" "postgres" {
#   name                = "private.postgres.database.azure.com"
#   resource_group_name = azurerm_resource_group.rg_vnet.name
# }
#
# resource "azurerm_private_dns_zone_virtual_network_link" "postgres_vnet" {
#   name                  = "${local.project}-postgres-vnet-private-dns-zone-link"
#   resource_group_name   = azurerm_resource_group.rg_vnet.name
#   private_dns_zone_name = azurerm_private_dns_zone.postgres.name
#   virtual_network_id    = module.vnet.id
# }
#
# resource "azurerm_private_dns_zone_virtual_network_link" "postgres_to_pair" {
#   name                  = module.vnet_pair.name
#   resource_group_name   = azurerm_resource_group.rg_vnet.name
#   private_dns_zone_name = azurerm_private_dns_zone.postgres.name
#   virtual_network_id    = module.vnet_pair.id
# }

#---------------------------------------------------------------
# Postgres Flexible Server private dns zone
#---------------------------------------------------------------
resource "azurerm_private_dns_zone" "postgres_flexible" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_flexible_private_endpoint_to_secure_hub_vnets" {
  for_each = local.secure_hub_vnets

  name                  = "${each.value.name}-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.postgres_flexible.name
  virtual_network_id    = each.value.id
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

resource "azurerm_private_dns_zone_virtual_network_link" "storage_private_endpoint_to_secure_hub_vnets" {
  for_each = local.secure_hub_vnets

  name                  = "${each.value.name}-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_account.name
  virtual_network_id    = each.value.id
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
# Storage Queue
#
resource "azurerm_private_dns_zone" "queue" {
  name                = "privatelink.queue.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "queue_private_endpoint_to_secure_hub_vnets" {
  for_each = local.all_vnets

  name                  = "${each.value.name}-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.queue.name
  virtual_network_id    = each.value.id
}

#
# Storage Table
#
resource "azurerm_private_dns_zone" "table" {
  name                = "privatelink.table.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "table_private_endpoint_to_secure_hub_vnets" {
  for_each = local.all_vnets

  name                  = "${each.value.name}-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.table.name
  virtual_network_id    = each.value.id
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

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_private_endpoint_to_secure_hub_vnets" {
  for_each = local.secure_hub_vnets

  name                  = "${each.value.name}-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos_mongo[0].name
  virtual_network_id    = each.value.id
}

#
# Data Factory - Private DNS Zone
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

resource "azurerm_private_dns_zone_virtual_network_link" "datafactory_private_endpoint_to_secure_hub_vnets" {
  for_each = local.secure_hub_vnets

  name                  = "${each.value.name}-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.adf[0].name
  virtual_network_id    = each.value.id
}


#
# EventHub - Private DNS zone
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

resource "azurerm_private_dns_zone_virtual_network_link" "eventhub_private_endpoint_to_secure_hub_vnets" {
  for_each = local.secure_hub_vnets

  name                  = "${each.value.name}-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.ehub[0].name
  virtual_network_id    = each.value.id
}

#
# REDIS Private DNS Zone
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

resource "azurerm_private_dns_zone_virtual_network_link" "redis_private_endpoint_to_secure_hub_vnets" {
  for_each = local.secure_hub_vnets

  name                  = "${each.value.name}-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.redis.name
  virtual_network_id    = each.value.id
}

#
# Data Explorer for Private DNS zones
#
resource "azurerm_private_dns_zone" "kusto" {
  name                = "privatelink.westeurope.kusto.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "kusto_private_endpoint_to_secure_hub_vnets" {
  for_each = local.secure_hub_vnets

  name                  = "${each.value.name}-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.kusto.name
  virtual_network_id    = each.value.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "kusto_link_to_vnet_frontend" {

  name                  = module.vnet.name
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.kusto.name
  virtual_network_id    = module.vnet.id
}

#
# Container app - private dns zone
#
resource "azurerm_private_dns_zone" "container_app" {
  name                = "privatelink.${var.location}.azurecontainerapps.io"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "container_app_link" {
  for_each = local.all_vnets

  name                  = "dnslink-${each.value.name}"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.container_app.name
  virtual_network_id    = each.value.id
  tags                  = var.tags
}

# ------------------------------------------------------------------------------
# Private DNS zone for key vaults.
# ------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "key_vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "key_vault_private_endpoint_to_secure_hub_vnets" {
  for_each = local.secure_hub_vnets

  name                  = "${each.value.name}-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault.name
  virtual_network_id    = each.value.id
}

#
# Prometheus Private DNS Zone
#
resource "azurerm_private_dns_zone" "prometheus_dns_zone" {
  name                = "privatelink.${var.location}.prometheus.monitor.azure.com"
  resource_group_name = module.vnet.resource_group_name
}

# Create virtual network link for workspace private dns zone
resource "azurerm_private_dns_zone_virtual_network_link" "prometheus_dns_zone_vnet_link" {
  name                  = module.vnet.name
  resource_group_name   = module.vnet.resource_group_name
  virtual_network_id    = module.vnet.id
  private_dns_zone_name = azurerm_private_dns_zone.prometheus_dns_zone.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "prometheus_weu_private_endpoint_to_secure_hub_vnets" {
  for_each = local.secure_hub_vnets

  name                  = "${each.value.name}-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.prometheus_dns_zone.name
  virtual_network_id    = each.value.id
}
