data "azurerm_storage_account" "acquirer_sa" {
  name                = replace(format("%s-blobstorage", local.product), "-", "")
  resource_group_name = format("%s-storage-rg", local.product)
}

data "azurerm_storage_account" "sftp_sa" {
  name                = replace(format("%s-sftp", local.product), "-", "")
  resource_group_name = format("%s-sftp-rg", local.product)
}