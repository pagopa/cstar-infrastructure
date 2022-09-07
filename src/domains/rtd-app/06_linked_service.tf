data "azurerm_key_vault" "key_vault" {
  name                = "${local.product}-kv"
  resource_group_name = "${local.product}-sec-rg"
}

data "azurerm_key_vault_secret" "mongodb_connection_uri" {
  name         = "mongo-db-connection-uri"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

resource "azurerm_data_factory_linked_service_cosmosdb_mongoapi" "cosmos_linked_service" {
  name            = "${local.product}-cosmos-linked-service"
  data_factory_id = data.azurerm_data_factory.datafactory.id

  database = "rtd"

  connection_string = data.azurerm_key_vault_secret.mongodb_connection_uri.value

}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "storage_account_linked_service" {

  name            = "${local.product}-sa-linked-service"
  data_factory_id = data.azurerm_data_factory.datafactory.id

  connection_string    = data.azurerm_storage_account.blobstorage_account.primary_blob_connection_string
  use_managed_identity = true

  storage_kind = "BlobStorage"
}
