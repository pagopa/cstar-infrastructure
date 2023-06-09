# Container for decrypted file containing aggregates
resource "azurerm_storage_container" "ade_transactions_decrypted" {
  count                 = var.enable.tae.blob_containers ? 1 : 0
  name                  = "ade-transactions-decrypted"
  storage_account_name  = module.cstarblobstorage.name
  container_access_type = "private"
}

# Container for the ade ack ingestor pipeline
resource "azurerm_storage_container" "tmp_container" {
  count                 = var.enable.tae.blob_containers ? 1 : 0
  name                  = "tmp"
  storage_account_name  = module.cstarblobstorage.name
  container_access_type = "private"
}

# Container for sender integration
resource "azurerm_storage_container" "sender_integration_container" {
  count                 = var.enable.tae.api && var.enable.tae.blob_containers && (var.env_short != "p") ? 1 : 0
  name                  = "ade-integration-aggregates"
  storage_account_name  = module.cstarblobstorage.name
  container_access_type = "private"
}
