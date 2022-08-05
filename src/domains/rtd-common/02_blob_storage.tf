data "azurerm_storage_account" "blobstorage_account" {
  name                = replace("${local.product}-blobstorage", "-", "")
  resource_group_name = "${local.product}-storage-rg"
}