# ------------------------------------------------------------------------------
# CosmosDB Mongo collection for clients used by auth microservice.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_collection" "clients" {
  account_name        = azurerm_cosmosdb_mongo_database.tier0.account_name
  database_name       = azurerm_cosmosdb_mongo_database.tier0.name
  name                = "clients"
  resource_group_name = azurerm_cosmosdb_mongo_database.tier0.resource_group_name

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys = [
      "clientId"
    ]
    unique = true
  }
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo collection for roles used by auth microservice.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_collection" "roles" {
  account_name        = azurerm_cosmosdb_mongo_database.tier0.account_name
  database_name       = azurerm_cosmosdb_mongo_database.tier0.name
  name                = "roles"
  resource_group_name = azurerm_cosmosdb_mongo_database.tier0.resource_group_name

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys   = ["id"]
    unique = true
  }

  index {
    keys = [
      "clientId",
      "acquirerId",
      "channel",
      "merchantId",
      "terminalId"
    ]
    unique = true
  }
}