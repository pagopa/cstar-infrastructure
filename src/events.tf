resource "azurerm_eventgrid_system_topic" "storage_topic" {
  count                  = var.enable_blob_storage_event_grid_integration ? 1 : 0
  name                   = format("%s-events-storage-topic", local.project)
  location               = var.location
  resource_group_name    = azurerm_resource_group.rg_storage.name
  source_arm_resource_id = module.cstarblobstorage.id
  topic_type             = "Microsoft.Storage.StorageAccounts"
}

resource "azurerm_eventgrid_system_topic" "keyvault_topic" {
  count                  = var.enable.rtd.key_vault_event_grid_integration ? 1 : 0
  name                   = format("%s-events-keyvault-topic", local.project)
  location               = var.location
  resource_group_name    = azurerm_resource_group.sec_rg.name
  source_arm_resource_id = module.key_vault.id
  topic_type             = "Microsoft.KeyVault.vaults"
}

data "azurerm_eventhub" "rtd_platform_eventhub" {
  count               = var.enable_blob_storage_event_grid_integration || var.enable.rtd.key_vault_event_grid_integration ? 1 : 0
  name                = "rtd-platform-events"
  resource_group_name = azurerm_resource_group.msg_rg.name
  namespace_name      = format("%s-evh-ns", local.project) # should be returned by the module
  depends_on = [
    module.event_hub
  ]
}

resource "azurerm_eventgrid_system_topic_event_subscription" "storage_subscription" {
  count               = var.enable_blob_storage_event_grid_integration ? 1 : 0
  name                = format("%s-events-storage-subscription", local.project)
  system_topic        = azurerm_eventgrid_system_topic.storage_topic[count.index].name
  resource_group_name = azurerm_resource_group.rg_storage.name

  eventhub_endpoint_id = data.azurerm_eventhub.rtd_platform_eventhub[count.index].id

  depends_on = [
    azurerm_eventgrid_system_topic.storage_topic
  ]
}

resource "azurerm_eventgrid_system_topic_event_subscription" "keyvault_subscription" {
  count               = var.enable.rtd.key_vault_event_grid_integration ? 1 : 0
  name                = format("%s-events-keyvault-subscription", local.project)
  system_topic        = azurerm_eventgrid_system_topic.keyvault_topic[count.index].name
  resource_group_name = azurerm_resource_group.sec_rg.name

  eventhub_endpoint_id = data.azurerm_eventhub.rtd_platform_eventhub[count.index].id
  included_event_types = [
    "Microsoft.KeyVault.CertificateNearExpiry",
    "Microsoft.KeyVault.CertificateExpired",
    "Microsoft.KeyVault.KeyNearExpiry",
    "Microsoft.KeyVault.KeyExpired",
    "Microsoft.KeyVault.SecretNearExpiry",
    "Microsoft.KeyVault.SecretExpired",
    "Microsoft.KeyVault.SecretNewVersionCreated",
  ]

  depends_on = [
    azurerm_eventgrid_system_topic.keyvault_topic
  ]
}
