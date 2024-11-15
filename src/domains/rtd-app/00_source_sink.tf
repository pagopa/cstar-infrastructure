data "azurerm_cosmosdb_account" "cosmos_account" {
  name                = "${local.product}-cosmos-mongo-db-account"
  resource_group_name = "${local.product}-db-rg"
}

data "azurerm_storage_account" "blobstorage_account" {
  name                = replace("${local.product}-blobstorage", "-", "")
  resource_group_name = "${local.product}-storage-rg"
}