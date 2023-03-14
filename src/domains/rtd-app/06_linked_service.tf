resource "azurerm_data_factory_linked_service_cosmosdb_mongoapi" "cosmos_linked_service" {
  name            = "${local.product}-cosmos-linked-service"
  data_factory_id = data.azurerm_data_factory.datafactory.id

  database = "rtd"

  connection_string = format(
    "AccountEndpoint=%s;AccountKey=%s;Database=rtd;",
    data.azurerm_cosmosdb_account.cosmos_account.endpoint,
    data.azurerm_cosmosdb_account.cosmos_account.primary_key
  )

  server_version_is_32_or_higher = true
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "storage_account_linked_service" {

  name            = "${local.product}-sa-linked-service"
  data_factory_id = data.azurerm_data_factory.datafactory.id

  service_endpoint     = data.azurerm_storage_account.blobstorage_account.primary_blob_endpoint
  use_managed_identity = true

  # cause is not supported in version 2.99 of azurerm,
  # changes are actually ignored
  storage_kind = "StorageV2"
  lifecycle {
    ignore_changes = [storage_kind]
  }
}
