# To fully configure the storage account, there are some manual steps. See
# https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/511738518/Enable+SFTP+with+Azure+Storage+Account

resource "azurerm_resource_group" "sftp" {
  name     = "${local.project}-sftp-rg"
  location = var.location
}

module "sftp" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//storage_account?ref=v6.17.0"

  name                = replace("${local.project}-sftp", "-", "")
  resource_group_name = azurerm_resource_group.sftp.name
  location            = azurerm_resource_group.sftp.location

  account_kind                  = "StorageV2"
  account_tier                  = "Standard"
  account_replication_type      = var.sftp_account_replication_type
  access_tier                   = "Hot"
  is_hns_enabled                = true
  is_sftp_enabled               = true
  advanced_threat_protection    = true
  enable_low_availability_alert = false
  public_network_access_enabled = true

  network_rules = {
    default_action             = var.sftp_disable_network_rules ? "Allow" : "Deny"
    bypass                     = ["AzureServices"]
    ip_rules                   = var.sftp_ip_rules
    virtual_network_subnet_ids = []
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "sftp_blob" {
  count = var.sftp_enable_private_endpoint ? 1 : 0

  name                = "${module.sftp.name}-blob-endpoint"
  resource_group_name = azurerm_resource_group.sftp.name
  location            = azurerm_resource_group.sftp.location
  subnet_id           = module.storage_account_snet.id

  private_service_connection {
    name                           = "${module.sftp.name}-blob-endpoint"
    private_connection_resource_id = module.sftp.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage_account.id]
  }

  tags = var.tags
}

resource "azurerm_eventgrid_system_topic" "sftp" {
  name                   = "${local.project}-sftp-topic"
  resource_group_name    = azurerm_resource_group.sftp.name
  location               = azurerm_resource_group.sftp.location
  source_arm_resource_id = module.sftp.id
  topic_type             = "Microsoft.Storage.StorageAccounts"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_eventgrid_system_topic_event_subscription" "sftp" {
  name                 = "${local.project}-sftp-subscription"
  system_topic         = azurerm_eventgrid_system_topic.sftp.name
  resource_group_name  = azurerm_resource_group.sftp.name
  eventhub_endpoint_id = data.azurerm_eventhub.rtd_platform_eventhub.id
  subject_filter {
    subject_begins_with = "/blobServices/default/containers/ade/blobs/"
  }

  delivery_identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_role_assignment.event_grid_sender_role_sftp_on_rtd_platform_events
  ]
}

# Assign role to event grid topic to publish over rtd-platform-events
resource "azurerm_role_assignment" "event_grid_sender_role_sftp_on_rtd_platform_events" {
  role_definition_name = "Azure Event Hubs Data Sender"
  principal_id         = azurerm_eventgrid_system_topic.sftp.identity[0].principal_id
  scope                = data.azurerm_eventhub.rtd_platform_eventhub.id
}


resource "azurerm_storage_container" "ade" {
  name                  = "ade"
  storage_account_name  = module.sftp.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "ade_dirs" {
  for_each               = toset(["in", "out", "error", "ack"])
  name                   = format("%s/.test", each.key)
  storage_account_name   = module.sftp.name
  storage_container_name = azurerm_storage_container.ade.name
  type                   = "Block"
}

resource "azurerm_role_assignment" "data_reader_role" {
  scope                = module.sftp.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = module.apim.principal_id

  depends_on = [
    module.sftp
  ]
}

resource "azurerm_role_assignment" "sftp_data_contributor_role" {
  scope                = module.sftp.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.apim.principal_id

  depends_on = [
    module.sftp
  ]
}

resource "azurerm_storage_container" "consap" {
  name                  = "consap"
  storage_account_name  = module.sftp.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "consap_dirs" {
  for_each               = toset(["Inbox"])
  name                   = format("%s/.test", each.key)
  storage_account_name   = module.sftp.name
  storage_container_name = azurerm_storage_container.consap.name
  type                   = "Block"
}