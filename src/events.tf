resource "azurerm_eventgrid_system_topic" "storage_topic" {
  count = contains(["d"], var.env_short) ? 1 : 0 
  name                   = format("%s-events-storage-topic", local.project)
  location               = var.location
  resource_group_name    = azurerm_resource_group.rg_storage.name
  source_arm_resource_id = module.cstarblobstorage.id
  topic_type             = "Microsoft.Storage.StorageAccounts"
}

data "azurerm_eventhub" "rtd_platform_eventhub" {
  count = contains(["d"], var.env_short) ? 1 : 0 
  name                = "rtd-platform-events"
  resource_group_name = azurerm_resource_group.msg_rg.name
  namespace_name      = format("%s-evh-ns", local.project) # should be returned by the module
}


resource "azurerm_eventgrid_system_topic_event_subscription" "storage_subscription" {
  count = contains(["d"], var.env_short) ? 1 : 0 
  name                = format("%s-events-storage-subscription", local.project)
  system_topic        = azurerm_eventgrid_system_topic.storage_topic.name
  resource_group_name = azurerm_resource_group.rg_storage.name

  eventhub_endpoint_id = data.azurerm_eventhub.rtd_platform_eventhub.id

  depends_on = [
    azurerm_eventgrid_system_topic.storage_topic
  ]
}