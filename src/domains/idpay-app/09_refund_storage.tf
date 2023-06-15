#
# Storage for refunds API
#
resource "azurerm_resource_group" "rg_refund_storage" {
  name     = "${local.product}-${var.domain}-storage-rg"
  location = var.location
  tags     = var.tags
}

#tfsec:ignore:azure-storage-default-action-deny
module "idpay_refund_storage" {
  source                          = "git::https://github.com/pagopa/terraform-azurerm-v3.git//storage_account?ref=v6.15.2"
  name                            = replace("${var.domain}${var.env_short}-refund-storage", "-", "")
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = var.storage_account_replication_type
  access_tier                     = "Hot"
  blob_versioning_enabled         = var.storage_enable_versioning
  resource_group_name             = azurerm_resource_group.rg_refund_storage.name
  location                        = var.location
  advanced_threat_protection      = var.storage_advanced_threat_protection
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = var.storage_public_network_access_enabled

  blob_delete_retention_days = var.storage_delete_retention_days

  tags = var.tags
}

resource "azurerm_storage_container" "idpay_refund_container" {
  name                  = "refund"
  storage_account_name  = module.idpay_refund_storage.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "idpay_merchant_container" {
  name                  = "merchant"
  storage_account_name  = module.idpay_refund_storage.name
  container_access_type = "private"
}

resource "azurerm_key_vault_secret" "refund_storage_access_key" {
  name         = "refund-storage-access-key"
  value        = module.idpay_refund_storage.primary_access_key
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv.id
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "refund_storage_connection_string" {
  name         = "refund-storage-connection-string"
  value        = module.idpay_refund_storage.primary_connection_string
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv.id
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "refund_storage_blob_connection_string" {
  name         = "refund-storage-blob-connection-string"
  value        = module.idpay_refund_storage.primary_blob_connection_string
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_eventgrid_system_topic" "idpay_refund_storage_topic" {
  name                   = format("%s-events-refund-storage-topic", local.project)
  location               = var.location
  resource_group_name    = azurerm_resource_group.rg_refund_storage.name
  source_arm_resource_id = module.idpay_refund_storage.id
  topic_type             = "Microsoft.Storage.StorageAccounts"

  identity {
    type = "SystemAssigned"
  }
}

# Assign role to event grid topic to publish over refund_storage_topic
resource "azurerm_role_assignment" "event_grid_sender_role_on_refund_storage_topic" {
  role_definition_name = "Azure Event Hubs Data Sender"
  principal_id         = azurerm_eventgrid_system_topic.idpay_refund_storage_topic.identity[0].principal_id
  scope                = data.azurerm_eventhub.eventhub_idpay_reward_notification_storage_events.id

  depends_on = [azurerm_eventgrid_system_topic.idpay_refund_storage_topic]
}

/* cannot use delivery_property with plugin 2.99, creating through azapi_resource.idpay_refund_storage_topic_event_subscription instead
resource "azurerm_eventgrid_system_topic_event_subscription" "idpay_refund_storage_subscription" {
  name                = format("%s-events-refund-storage-subscription", local.project)
  system_topic        = azurerm_eventgrid_system_topic.idpay_refund_storage_topic.name
  resource_group_name = azurerm_resource_group.rg_refund_storage.name

  eventhub_endpoint_id = data.azurerm_eventhub.eventhub_idpay_reward_notification_storage_events.id

  delivery_property {
    header_name  = "PartitionKey"
    type         = "Dynamic"
    source_field = "data.clientRequestId"
  }
}*/

resource "azapi_resource" "idpay_refund_storage_topic_event_subscription" {
  type      = "Microsoft.EventGrid/systemTopics/eventSubscriptions@2021-12-01"
  name      = format("%s-events-refund-storage-subscription", local.project)
  parent_id = azurerm_eventgrid_system_topic.idpay_refund_storage_topic.id

  body = jsonencode({
    "properties" : {
      "deliveryWithResourceIdentity" : {
        "identity" : {
          "type" : "SystemAssigned"
        }
        "destination" : {
          "endpointType" : "EventHub",
          "properties" : {
            "deliveryAttributeMappings" : [
              {
                "name" : "PartitionKey",
                "properties" : {
                  "sourceField" : "data.clientRequestId"
                },
                "type" : "Dynamic"
              }
            ],
            "resourceId" : data.azurerm_eventhub.eventhub_idpay_reward_notification_storage_events.id
          }
        },
      },
      "eventDeliverySchema" : "EventGridSchema",
      "filter" : {
        "includedEventTypes" : [
          "Microsoft.Storage.BlobCreated"
        ],
      },
      "labels" : [],
      "retryPolicy" : {
        "eventTimeToLiveInMinutes" : 1440,
        "maxDeliveryAttempts" : 30
      },
    }
  })

  response_export_values = ["*"]
}
