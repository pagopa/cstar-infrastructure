resource "azurerm_cosmosdb_mongo_database" "transaction_aggregate" {

  count = var.enable.tae.db_collections ? 1 : 0

  name                = "tae"
  resource_group_name = azurerm_resource_group.db_rg.name
  account_name        = module.cosmosdb_account_mongodb[count.index].name

  throughput = var.cosmos_mongo_db_transaction_params.enable_autoscaling || var.cosmos_mongo_db_transaction_params.enable_serverless ? null : var.cosmos_mongo_db_transaction_params.throughput

  dynamic "autoscale_settings" {
    for_each = var.cosmos_mongo_db_transaction_params.enable_autoscaling && !var.cosmos_mongo_db_transaction_params.enable_serverless ? [""] : []
    content {
      max_throughput = var.cosmos_mongo_db_transaction_params.enable_serverless.max_throughput
    }
  }
}

resource "azurerm_cosmosdb_mongo_collection" "aggregates" {

  count = var.enable.tae.db_collections ? 1 : 0

  name                = "aggregates"
  resource_group_name = azurerm_resource_group.db_rg.name
  account_name        = module.cosmosdb_account_mongodb[count.index].name
  database_name       = azurerm_cosmosdb_mongo_database.transaction_aggregate[count.index].name

  default_ttl_seconds = "777"
  shard_key           = "uniqueKey"
  # throughput          = 400

  index {
    keys   = ["_id"]
    unique = true
  }
}