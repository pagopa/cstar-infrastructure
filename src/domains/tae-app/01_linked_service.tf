resource "azurerm_data_factory_linked_service_azure_blob_storage" "storage_account_ls" {

  name            = "${local.product}-sa-linked-service"
  data_factory_id = data.azurerm_data_factory.datafactory.id

  # sas_uri = data.azurerm_storage_account.acquirer_sa[count.index].primary_blob_endpoint
  # key_vault_sas_token {
  #   linked_service_name = azurerm_data_factory_linked_service_key_vault.tae_adf_kv_ls[count.index].name
  #   secret_name         = "cstar-blob-sas-token"
  # }

  service_endpoint     = data.azurerm_storage_account.acquirer_sa.primary_blob_endpoint
  use_managed_identity = true
  storage_kind         = "StorageV2" # not supported in version 2.99 of the module
}


resource "azurerm_data_factory_linked_service_cosmosdb" "cosmos_ls" {
  name            = "${local.product}-cosmos-linked-service"
  data_factory_id = data.azurerm_data_factory.datafactory.id

  database = "tae"

  connection_string = format(
    "AccountEndpoint=%s;AccountKey=%s;Database=tae;",
    data.azurerm_cosmosdb_account.cosmos.endpoint,
    data.azurerm_cosmosdb_account.cosmos.primary_key
  )
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "sftp_ls" {

  name            = "${local.product}-sftp-linked-service"
  data_factory_id = data.azurerm_data_factory.datafactory.id

  # sas_uri = data.azurerm_storage_account.sftp_sa[count.index].primary_blob_endpoint
  # key_vault_sas_token {
  #   linked_service_name = azurerm_data_factory_linked_service_key_vault.tae_adf_kv_ls[count.index].name
  #   secret_name         = "ftp-blob-sas-token"
  # }
  service_endpoint     = data.azurerm_storage_account.sftp_sa.primary_blob_endpoint
  use_managed_identity = true
  storage_kind         = "StorageV2" # not supported in v 2.99 of the azurerm provider
}

resource "azurerm_data_factory_linked_service_kusto" "dexp_tae" {

  count = var.dexp_tae_db_linkes_service.enable ? 1 : 0


  name                 = "${local.product}-dexp-tae-linked-service"
  data_factory_id      = data.azurerm_data_factory.datafactory.id
  kusto_endpoint       = data.azurerm_kusto_cluster.dexp_cluster[count.index].uri
  kusto_database_name  = data.azurerm_kusto_database.tae_db[count.index].name
  use_managed_identity = true
}

resource "azurerm_kusto_database_principal_assignment" "tae_principal_assignment" {

  count = var.dexp_tae_db_linkes_service.enable ? 1 : 0

  name                = "DexpPrincipalAssignment"
  resource_group_name = data.azurerm_kusto_cluster.dexp_cluster[count.index].resource_group_name
  cluster_name        = data.azurerm_kusto_cluster.dexp_cluster[count.index].name
  database_name       = data.azurerm_kusto_database.tae_db[count.index].name

  tenant_id      = data.azurerm_data_factory.datafactory.identity.0.tenant_id
  principal_id   = data.azurerm_data_factory.datafactory.identity.0.principal_id
  principal_type = "App"
  role           = "Admin"
}