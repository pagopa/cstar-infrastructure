data "azurerm_storage_account" "acquirer_sa" {
  name                = replace("${local.product}-blobstorage", "-", "")
  resource_group_name = "${local.product}-storage-rg"
}

data "azurerm_storage_account" "sftp_sa" {
  name                = replace("${local.product}-sftp", "-", "")
  resource_group_name = "${local.product}-sftp-rg"
}

data "azurerm_cosmosdb_account" "cosmos" {
  name                = "${local.project}-cosmos-db-account"
  resource_group_name = "${local.project}-db-rg"
}
