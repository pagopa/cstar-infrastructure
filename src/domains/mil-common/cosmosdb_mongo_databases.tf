# ------------------------------------------------------------------------------
# CosmosDB Mongo database.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_database" "mil" {
  account_name        = azurerm_cosmosdb_account.mil.name
  name                = "mil"
  resource_group_name = azurerm_cosmosdb_account.mil.resource_group_name
}