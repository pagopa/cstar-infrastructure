resource "azurerm_eventgrid_system_topic" "storage_topic" {
  count                  = var.enable_blob_storage_event_grid_integration ? 1 : 0
  name                   = format("%s-events-storage-topic", local.project)
  location               = var.location
  resource_group_name    = azurerm_resource_group.rg_storage.name
  source_arm_resource_id = module.cstarblobstorage.id
  topic_type             = "Microsoft.Storage.StorageAccounts"

  identity {
    type = "SystemAssigned"
  }
}
