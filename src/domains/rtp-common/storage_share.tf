
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
  name                 = "${local.project}-jks-file-share"
  storage_account_name = azurerm_storage_account.rtp_files_storage_account.name
  quota                = 1
}

resource "azurerm_container_app_environment_storage" "rtp_sender_file_share_storage" {
  name                         = "${local.project}-sender-fss"
  container_app_environment_id = data.azurerm_container_app_environment.rtp-cae.id
  account_name                 = data.azurerm_storage_account.rtp_files_storage_account.name
  share_name                   = data.azurerm_storage_share.rtp_jks_file_share.name
  access_key                   = data.azurerm_storage_account.rtp_files_storage_account.primary_access_key
  access_mode                  = "ReadWrite"
}

