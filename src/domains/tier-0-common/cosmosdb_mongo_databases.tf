# ------------------------------------------------------------------------------
# CosmosDB Mongo database.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_database" "tier0" {
  account_name        = azurerm_cosmosdb_account.tier0.name
  name                = "mil"
  resource_group_name = azurerm_cosmosdb_account.tier0.resource_group_name
}