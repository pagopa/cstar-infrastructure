# ------------------------------------------------------------------------------
# CosmosDB Mongo database.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_database" "mcshared" {
  account_name        = azurerm_cosmosdb_account.mcshared.name
  name                = "mil"
  resource_group_name = azurerm_cosmosdb_account.mcshared.resource_group_name
  
  autoscale_settings {
    max_throughput = 1000
  }
}