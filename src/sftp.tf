# To fully configure the storage account, there are some manual steps. See
# https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/511738518/Enable+SFTP+with+Azure+Storage+Account

resource "azurerm_resource_group" "sftp" {
  name     = "${local.project}-sftp-rg"
  location = var.location
}

module "sftp" { # add private endpoint (dns zone storage account) per uat-prod
  source = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=v2.18.0"

  name                = replace("${local.project}-sftp", "-", "")
  resource_group_name = azurerm_resource_group.sftp.name
  location            = azurerm_resource_group.sftp.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = var.sftp_account_replication_type
  access_tier              = "Hot"
  is_hns_enabled           = true

  network_rules = {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    ip_rules                   = var.sftp_ip_rules
    virtual_network_subnet_ids = []
  }

  tags = var.tags
}

resource "azurerm_eventgrid_system_topic" "sftp" {
  name                   = "${local.project}-sftp-topic"
  resource_group_name    = azurerm_resource_group.sftp.name
  location               = azurerm_resource_group.sftp.location
  source_arm_resource_id = module.sftp.id
  topic_type             = "Microsoft.Storage.StorageAccounts"
}

resource "azurerm_eventhub_namespace" "sftp" {
  name                = "${local.project}-sftp"
  location            = azurerm_resource_group.sftp.location
  resource_group_name = azurerm_resource_group.sftp.name
  sku                 = "Standard"
  capacity            = 1
}

resource "azurerm_eventhub" "sftp" { # use event hub esistente
  name                = "${local.project}-sftp"
  namespace_name      = azurerm_eventhub_namespace.sftp.name
  resource_group_name = azurerm_resource_group.sftp.name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventgrid_system_topic_event_subscription" "sftp" {
  name                = "${local.project}-sftp-subscription"
  system_topic        = azurerm_eventgrid_system_topic.sftp.name
  resource_group_name = azurerm_resource_group.sftp.name

  eventhub_endpoint_id = azurerm_eventhub.sftp.id
}

resource "azurerm_storage_container" "ade" {
  name                  = "ade"
  storage_account_name  = module.sftp.name
  container_access_type = "private"
}

