# Container for decrypted file containing aggregates
resource "azurerm_storage_container" "ade_transactions_decrypted" {
  count                 = var.tae_blob_storage.enable ? 1 : 0
  name                  = "ade-transactions-decrypted"
  storage_account_name  = data.azurerm_storage_account.acquirer_sa.name
  container_access_type = "private"
}


# Container for the ade ack ingestor pipeline
resource "azurerm_storage_container" "tmp_container" {
  count                 = var.tae_blob_storage.enable ? 1 : 0
  name                  = "tmp"
  storage_account_name  = data.azurerm_storage_account.acquirer_sa.name
  container_access_type = "private"
}

# Container for sender integration
resource "azurerm_storage_container" "sender_integration_container" {
  count                 = var.tae_blob_storage.enable && (var.env_short != "p") ? 1 : 0
  name                  = "ade-integration-aggregates"
  storage_account_name  = data.azurerm_storage_account.acquirer_sa.name
  container_access_type = "private"
}

# Container for reports on files pending for ack
resource "azurerm_storage_container" "pending_for_ack_extraction_container" {
  count                 = var.tae_blob_storage.enable ? 1 : 0
  name                  = "pending-for-ack"
  storage_account_name  = data.azurerm_storage_account.acquirer_sa.name
  container_access_type = "private"
}

# Container for invalidated aggregates
resource "azurerm_storage_container" "invalidated_aggregates_container" {
  count                 = var.tae_blob_storage.enable ? 1 : 0
  name                  = "aggregates-to-be-invalidated"
  storage_account_name  = data.azurerm_storage_account.acquirer_sa.name
  container_access_type = "private"
}
