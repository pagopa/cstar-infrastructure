# Used by BPD pipelines
resource "azurerm_data_factory_linked_service_azure_blob_storage" "storage_account_linked_service" {

  count = var.env_short == "p" ? 1 : 0

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
