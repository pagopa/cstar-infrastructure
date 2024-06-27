data "azurerm_eventhub" "rtd_platform_eventhub" {
  name                = "rtd-platform-events"
  resource_group_name = data.azurerm_resource_group.msg_rg.name
  namespace_name      = data.azurerm_eventhub_namespace.event_hub_rtd.name
  depends_on = [
    azurerm_eventhub.event_hub_rtd_hub
  ]
}

# Blob storage evengrid to platform-events
data "azurerm_eventgrid_system_topic" "storage_topic" {
  name                = "${local.product}-events-storage-topic"
  resource_group_name = data.azurerm_resource_group.rg_storage.name
}

resource "azurerm_eventgrid_system_topic_event_subscription" "storage_subscription" {
  count               = var.enable.blob_storage_event_grid_integration ? 1 : 0
  name                = "${local.project}-events-storage-subscription"
  system_topic        = data.azurerm_eventgrid_system_topic.storage_topic.name
  resource_group_name = data.azurerm_resource_group.rg_storage.name

  eventhub_endpoint_id = data.azurerm_eventhub.rtd_platform_eventhub.id

  delivery_identity {
    type = "SystemAssigned"
  }

  included_event_types = [
    "Microsoft.Storage.BlobCreated",
    "Microsoft.Storage.BlobDeleted"
  ]

  depends_on = [
    azurerm_role_assignment.event_grid_sender_role_on_rtd_platform_events
  ]
}

# Assign role to event grid topic storage-topic to publish over rtd-platform-events
resource "azurerm_role_assignment" "event_grid_sender_role_on_rtd_platform_events" {
  count                = var.enable.blob_storage_event_grid_integration ? 1 : 0
  role_definition_name = "Azure Event Hubs Data Sender"
  principal_id         = data.azurerm_eventgrid_system_topic.storage_topic.identity[0].principal_id
  scope                = data.azurerm_eventhub.rtd_platform_eventhub.id

  depends_on = [
    azurerm_eventhub.event_hub_rtd_hub
  ]
}

# SFTP storage eventgrid to platform-events
data "azurerm_eventgrid_system_topic" "sftp" {
  name                = "${local.product}-sftp-topic"
  resource_group_name = "${local.product}-sftp-rg"
}

resource "azurerm_eventgrid_system_topic_event_subscription" "sftp" {
  count                = var.enable.blob_storage_event_grid_integration ? 1 : 0
  name                 = "${local.project}-sftp-subscription"
  system_topic         = data.azurerm_eventgrid_system_topic.sftp.name
  resource_group_name  = "${local.product}-sftp-rg"
  eventhub_endpoint_id = data.azurerm_eventhub.rtd_platform_eventhub.id
  subject_filter {
    subject_begins_with = "/blobServices/default/containers/ade/blobs/"
  }

  delivery_identity {
    type = "SystemAssigned"
  }

  included_event_types = [
    "Microsoft.Storage.BlobCreated",
    "Microsoft.Storage.BlobDeleted"
  ]

  depends_on = [
    azurerm_role_assignment.event_grid_sender_role_sftp_on_rtd_platform_events
  ]
}

resource "azurerm_eventgrid_system_topic_event_subscription" "sftp_wallet" {
  count                = var.enable.blob_storage_event_grid_integration ? 1 : 0
  name                 = "${local.project}-sftp-wallet-subscription"
  system_topic         = data.azurerm_eventgrid_system_topic.sftp.name
  resource_group_name  = "${local.product}-sftp-rg"
  eventhub_endpoint_id = data.azurerm_eventhub.rtd_platform_eventhub.id

  included_event_types = [
    "Microsoft.Storage.BlobCreated",
    "Microsoft.Storage.BlobDeleted",
    "Microsoft.Storage.BlobRenamed"
  ]

  subject_filter {
    subject_begins_with = "/blobServices/default/containers/nexi/blobs/"
  }

  included_event_types = [
    "Microsoft.Storage.BlobCreated",
    "Microsoft.Storage.BlobDeleted",
    "Microsoft.Storage.BlobRenamed"
  ]

  delivery_identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_role_assignment.event_grid_sender_role_sftp_on_rtd_platform_events
  ]
}

# Assign role to event grid topic sftp to publish over rtd-platform-events
resource "azurerm_role_assignment" "event_grid_sender_role_sftp_on_rtd_platform_events" {
  count                = var.enable.blob_storage_event_grid_integration ? 1 : 0
  role_definition_name = "Azure Event Hubs Data Sender"
  principal_id         = data.azurerm_eventgrid_system_topic.sftp.identity[0].principal_id
  scope                = data.azurerm_eventhub.rtd_platform_eventhub.id
  depends_on = [
    azurerm_eventhub.event_hub_rtd_hub
  ]
}
