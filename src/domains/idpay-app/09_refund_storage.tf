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
  source = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=v2.18.0"

  name                       = replace("${var.domain}-refund-storage", "-", "")
  account_kind               = "StorageV2"
  account_tier               = "Standard"
  account_replication_type   = var.storage_account_replication_type
  access_tier                = "Hot"
  versioning_name            = "versioning"
  enable_versioning          = var.storage_enable_versioning
  resource_group_name        = azurerm_resource_group.rg_refund_storage.name
  location                   = var.location
  advanced_threat_protection = var.storage_advanced_threat_protection
  allow_blob_public_access   = false

  blob_properties_delete_retention_policy_days = var.storage_delete_retention_days

  tags = var.tags
}

resource "azurerm_storage_container" "idpay_refund_container" {
  name                  = "refund"
  storage_account_name  = module.idpay_refund_storage.name
  container_access_type = "private"
}

resource "azurerm_eventgrid_system_topic" "idpay_refund_storage_topic" {
  name                   = format("%s-events-refund-storage-topic", local.project)
  location               = var.location
  resource_group_name    = azurerm_resource_group.rg_refund_storage.name
  source_arm_resource_id = module.idpay_refund_storage.id
  topic_type             = "Microsoft.Storage.StorageAccounts"
}

resource "azurerm_eventgrid_system_topic_event_subscription" "idpay_refund_storage_subscription" {
  name                = format("%s-events-refund-storage-subscription", local.project)
  system_topic        = azurerm_eventgrid_system_topic.idpay_refund_storage_topic.name
  resource_group_name = azurerm_resource_group.rg_refund_storage.name

  eventhub_endpoint_id = data.azurerm_eventhub.eventhub_idpay_reward_notification_storage_events.id
}
