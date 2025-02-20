data "azurerm_resource_group" "rtp_rg_storage" {
  name = "${local.project}-storage-rg"
}

data "azurerm_storage_account" "rtp_blob_storage_account" {
  name                = replace("${local.project}-blobstorage", "-", "")
  resource_group_name = data.azurerm_resource_group.rtp_rg_storage.name
}
