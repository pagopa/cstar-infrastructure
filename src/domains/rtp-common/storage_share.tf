resource "azurerm_resource_group" "rtp_rg_storage_share" {
  name     = "${local.project}-storage-share-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "rtp_files_storage_account" {
  name                       = replace("${local.project}-storageshare", "-", "")
  resource_group_name        = azurerm_resource_group.rtp_rg_storage_share.name
  location                   = azurerm_resource_group.rtp_rg_storage_share.location
  https_traffic_only_enabled = true
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  tags                       = var.tags
}

resource "azurerm_storage_share" "rtp_jks_file_share" {
  name                 = "${local.project}-ks-file-share"
  storage_account_name = azurerm_storage_account.rtp_files_storage_account.name
  quota                = 1
}