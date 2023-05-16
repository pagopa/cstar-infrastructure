locals {
  # Private DNS record storage accounts
  cstarblobstorage_private_fqdn = "${data.azurerm_storage_account.cstarblobstorage.name}.privatelink.blob.core.windows.net"
}

data "azurerm_resource_group" "rg_storage" {
  name = format("%s-storage-rg", local.product)
}

data "azurerm_storage_account" "cstarblobstorage" {
  name                = replace(format("%s-blobstorage", local.product), "-", "")
  resource_group_name = data.azurerm_resource_group.rg_storage.name
}

resource "azurerm_storage_container" "cstar_hashed_pans" {
  count = var.enable.hashed_pans_container ? 1 : 0

  name                  = "cstar-hashed-pans"
  storage_account_name  = data.azurerm_storage_account.cstarblobstorage.name
  container_access_type = "private"
}
