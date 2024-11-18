# ------------------------------------------------------------------------------
# CosmosDB Mongo database.
# ------------------------------------------------------------------------------
data "azurerm_cosmosdb_mongo_database" "mil" {
  account_name        = data.azurerm_cosmosdb_account.mil.name
  name                = "mil"
  resource_group_name = data.azurerm_cosmosdb_account.mil.resource_group_name
}