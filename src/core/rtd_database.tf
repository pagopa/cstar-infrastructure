data "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                = "${local.project}-cosmos-mongo-db-account"
  resource_group_name = "${local.project}-db-rg"
}

resource "azurerm_cosmosdb_mongo_database" "rtd_db" {

  count = var.enable.rtd.mongodb_storage ? 1 : 0

  name                = "rtd"
  resource_group_name = azurerm_resource_group.db_rg.name
  account_name        = data.azurerm_cosmosdb_account.cosmosdb_account.name

  throughput = var.cosmos_mongo_db_transaction_params.enable_autoscaling || var.cosmos_mongo_db_transaction_params.enable_serverless ? null : var.cosmos_mongo_db_transaction_params.throughput

  dynamic "autoscale_settings" {
    for_each = var.cosmos_mongo_db_transaction_params.enable_autoscaling && !var.cosmos_mongo_db_transaction_params.enable_serverless ? [""] : []
    content {
      max_throughput = var.cosmos_mongo_db_transaction_params.max_throughput
    }
  }
}

resource "azurerm_cosmosdb_mongo_collection" "rtd_enrolled_payment_instrument_collection" {

  count = var.enable.rtd.enrolled_payment_instrument ? 1 : 0

  account_name        = data.azurerm_cosmosdb_account.cosmosdb_account.name
  database_name       = azurerm_cosmosdb_mongo_database.rtd_db[count.index].name
  resource_group_name = azurerm_resource_group.db_rg.name

  name = "enrolled_payment_instrument"

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys   = ["hashPan"]
    unique = true
  }

  index {
    keys = ["enabledApps"]
  }

  index {
    keys = ["hashPanChildren"]
  }

  lifecycle {
    ignore_changes = [
      autoscale_settings
    ]
  }

}

resource "azurerm_cosmosdb_mongo_collection" "sender_auth" {

  count = var.enable.rtd.mongodb_storage ? 1 : 0

  name                = "senderauth"
  resource_group_name = azurerm_resource_group.db_rg.name
  account_name        = data.azurerm_cosmosdb_account.cosmosdb_account.name
  database_name       = azurerm_cosmosdb_mongo_database.rtd_db[count.index].name

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys   = ["apiKey"]
    unique = true
  }

  index {
    keys = ["senderCodes"]
  }

  autoscale_settings {
    max_throughput = 4000 # overridden via azure portal
  }

  lifecycle {
    ignore_changes = [
      autoscale_settings
    ]
  }

}

resource "azurerm_cosmosdb_mongo_collection" "file_register" {

  count = var.enable.rtd.mongodb_storage ? 1 : 0

  name                = "fileregister"
  resource_group_name = azurerm_resource_group.db_rg.name
  account_name        = data.azurerm_cosmosdb_account.cosmosdb_account.name
  database_name       = azurerm_cosmosdb_mongo_database.rtd_db[count.index].name

  index {
    keys = ["name"]
  }

  index {
    keys = ["sender"]
  }

  index {
    keys = ["type"]
  }

  index {
    keys = ["status"]
  }

  index {
    keys   = ["_id"]
    unique = true
  }

  autoscale_settings {
    max_throughput = 4000 # overridden via azure portal
  }

  lifecycle {
    ignore_changes = [
      autoscale_settings
    ]
  }

}

resource "azurerm_cosmosdb_mongo_collection" "rtd_file_reporter_collection" {

  count = var.enable.rtd.mongodb_storage ? 1 : 0

  name                = "filereports"
  account_name        = data.azurerm_cosmosdb_account.cosmosdb_account.name
  database_name       = azurerm_cosmosdb_mongo_database.rtd_db[count.index].name
  resource_group_name = azurerm_resource_group.db_rg.name

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys   = ["senderCode"]
    unique = true
  }

  autoscale_settings {
    max_throughput = 4000 # overridden via azure portal
  }

  lifecycle {
    ignore_changes = [
      autoscale_settings
    ]
  }

}

resource "azurerm_cosmosdb_mongo_collection" "rtd_payment_instrument_collection" {

  count = var.enable.rtd.payment_instrument ? 1 : 0

  account_name        = data.azurerm_cosmosdb_account.cosmosdb_account.name
  database_name       = azurerm_cosmosdb_mongo_database.rtd_db[count.index].name
  resource_group_name = azurerm_resource_group.db_rg.name

  name = "payment_instrument"

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys   = ["paymentInstrumentId"]
    unique = true
  }

  lifecycle {
    ignore_changes = [
      autoscale_settings
    ]
  }

}
