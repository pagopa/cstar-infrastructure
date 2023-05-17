data "azurerm_eventhub" "rtd_platform_eventhub" {
  name                = "rtd-platform-events"
  resource_group_name = azurerm_resource_group.msg_rg.name
  namespace_name      = format("%s-evh-ns", local.project) # should be returned by the module
  # depends_on = [
  #   module.event_hub
  # ]
}

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

resource "azurerm_eventgrid_system_topic_event_subscription" "storage_subscription" {
  count               = var.enable_blob_storage_event_grid_integration ? 1 : 0
  name                = format("%s-events-storage-subscription", local.project)
  system_topic        = azurerm_eventgrid_system_topic.storage_topic[count.index].name
  resource_group_name = azurerm_resource_group.rg_storage.name


  eventhub_endpoint_id = data.azurerm_eventhub.rtd_platform_eventhub.id

  delivery_identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_role_assignment.event_grid_sender_role_on_rtd_platform_events
  ]
}

# Assign role to event grid topic to publish over rtd-platform-events
resource "azurerm_role_assignment" "event_grid_sender_role_on_rtd_platform_events" {
  count                = var.enable_blob_storage_event_grid_integration ? 1 : 0
  role_definition_name = "Azure Event Hubs Data Sender"
  principal_id         = azurerm_eventgrid_system_topic.storage_topic[count.index].identity[0].principal_id
  scope                = data.azurerm_eventhub.rtd_platform_eventhub.id
}
