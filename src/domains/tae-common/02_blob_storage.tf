data "azurerm_storage_account" "acquirer_sa" {
  name                = replace("${local.project}-blobstorage", "-", "")
  resource_group_name = "${local.project}-storage-rg"
}

data "azurerm_storage_account" "sftp_sa" {
  name                = replace("${local.project}-sftp", "-", "")
  resource_group_name = "${local.project}-sftp-rg"
}
