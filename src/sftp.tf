# To fully configure the storage account, there are some manual steps. See
# https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/511738518/Enable+SFTP+with+Azure+Storage+Account

resource "azurerm_resource_group" "sftp" {
  name     = "${local.project}-sftp-rg"
  location = var.location
}

resource "azurerm_advanced_threat_protection" "sftp" {
  target_resource_id = azurerm_storage_account.sftp.id
  enabled            = false
}

resource "azurerm_storage_account" "sftp" {
  name                = replace("${local.project}-sftp", "-", "")
  resource_group_name = azurerm_resource_group.sftp.name
  location            = var.location

  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  access_tier               = "Hot"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = false
  is_hns_enabled            = true

  tags = var.tags
}

resource "azurerm_storage_container" "ade" {
  name                  = "ade"
  storage_account_name  = azurerm_storage_account.sftp.name
  container_access_type = "private"
}
