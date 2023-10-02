
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

resource "azurerm_storage_container" "cstar_hashed_pans_par" {
  count = var.enable.hashed_pans_container ? 1 : 0

  name                  = "cstar-hashed-pans-par"
  storage_account_name  = data.azurerm_storage_account.cstarblobstorage.name
  container_access_type = "private"
}
# Container for decrypted sender ADE acks (wrong fiscal codes)
resource "azurerm_storage_container" "sender_ade_ack" {
  count                 = var.enable.tae_blob_containers ? 1 : 0
  name                  = "sender-ade-ack"
  storage_account_name  = data.azurerm_storage_account.cstarblobstorage.name
  container_access_type = "private"
}
