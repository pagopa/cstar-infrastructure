# ------------------------------------------------------------------------------
# CosmosDB Mongo collection used by payment-notice microservice.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_collection" "payment_transactions" {
  account_name        = azurerm_cosmosdb_mongo_database.mil.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mil.name
  name                = "paymentTransactions"
  resource_group_name = azurerm_cosmosdb_mongo_database.mil.resource_group_name

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys = [
      "paymentTransaction.terminalId",
      "paymentTransaction.merchantId",
      "paymentTransaction.channel",
      "paymentTransaction.acquirerId",
      "paymentTransaction.insertTimestamp"
    ]
    unique = false
  }

  index {
    keys = [
      "paymentTransaction.insertTimestamp"
    ]
    unique = false
  }
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo collection used by idpay microservice.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_collection" "idpay_transactions" {
  account_name        = azurerm_cosmosdb_mongo_database.mil.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mil.name
  name                = "idpayTransactions"
  resource_group_name = azurerm_cosmosdb_mongo_database.mil.resource_group_name

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys = [
      "transactionId"
    ]
    unique = false
  }

  index {
    keys = [
      "idpayTransaction.terminalId",
      "idpayTransaction.merchantId",
      "idpayTransaction.channel",
      "idpayTransaction.acquirerId",
      "idpayTransaction.timestamp",
      "idpayTransaction.status"
    ]
    unique = false
  }
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo collection used by pa-pos microservice.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_collection" "terminals" {
  account_name        = azurerm_cosmosdb_mongo_database.mil.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mil.name
  name                = "terminals"
  resource_group_name = azurerm_cosmosdb_mongo_database.mil.resource_group_name

  index {
    keys   = ["_id"]
    unique = true
  }
}

resource "azurerm_cosmosdb_mongo_collection" "transactions" {
  account_name        = azurerm_cosmosdb_mongo_database.mil.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mil.name
  name                = "transactions"
  resource_group_name = azurerm_cosmosdb_mongo_database.mil.resource_group_name

  index {
    keys   = ["_id"]
    unique = true
  }
}

resource "azurerm_cosmosdb_mongo_collection" "bulkload_statuses" {
  account_name        = azurerm_cosmosdb_mongo_database.mil.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mil.name
  name                = "bulkLoadStatuses"
  resource_group_name = azurerm_cosmosdb_mongo_database.mil.resource_group_name

  index {
    keys   = ["_id"]
    unique = true
  }
}