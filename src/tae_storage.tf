# Container for decrypted file containing aggregates
resource "azurerm_storage_container" "ade_transactions_decrypted" {
  count                 = var.enable.tae.blob_containers ? 1 : 0
  name                  = "ade-transactions-decrypted"
  storage_account_name  = module.cstarblobstorage.name
  container_access_type = "private"
}

# Container for decrypted sender ADE acks (wrong fiscal codes)
resource "azurerm_storage_container" "sender_ade_ack" {
  count                 = var.enable.tae.blob_containers ? 1 : 0
  name                  = "sender-ade-ack"
  storage_account_name  = module.cstarblobstorage.name
  container_access_type = "private"
}