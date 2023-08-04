# storage eventgrid topic
data "azurerm_eventhub" "rtd_platform_eventhub" {
  name                = "rtd-platform-events"
  resource_group_name = data.azurerm_resource_group.msg_rg.name
  namespace_name      = data.azurerm_eventhub_namespace.event_hub_rtd.name
  depends_on = [
    azurerm_eventhub.event_hub_rtd_hub
  ]
}

data "azurerm_eventgrid_system_topic" "storage_topic" {
  name                = format("%s-events-storage-topic", local.product)
  resource_group_name = data.azurerm_resource_group.rg_storage.name
}

resource "azurerm_eventgrid_system_topic_event_subscription" "storage_subscription" {
  count               = var.enable.blob_storage_event_grid_integration ? 1 : 0
  name                = format("%s-events-storage-subscription", local.project)
  system_topic        = data.azurerm_eventgrid_system_topic.storage_topic.name
  resource_group_name = data.azurerm_resource_group.rg_storage.name

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
  count                = var.enable.blob_storage_event_grid_integration ? 1 : 0
  role_definition_name = "Azure Event Hubs Data Sender"
  principal_id         = data.azurerm_eventgrid_system_topic.storage_topic.identity[0].principal_id
  scope                = data.azurerm_eventhub.rtd_platform_eventhub.id

  depends_on = [
    azurerm_eventhub.event_hub_rtd_hub
  ]
}
