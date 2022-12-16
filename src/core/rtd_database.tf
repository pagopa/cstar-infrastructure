module "cosmosdb_account_mongodb" {

  count = var.enable.rtd.mongodb_storage ? 1 : 0

  source = "git::https://github.com/pagopa/azurerm.git//cosmosdb_account?ref=v2.15.1"

  name                 = format("%s-cosmos-mongo-db-account", local.project)
  location             = azurerm_resource_group.db_rg.location
  resource_group_name  = azurerm_resource_group.db_rg.name
  offer_type           = var.cosmos_mongo_db_params.offer_type
  kind                 = var.cosmos_mongo_db_params.kind
  capabilities         = var.cosmos_mongo_db_params.capabilities
  mongo_server_version = var.cosmos_mongo_db_params.server_version
  enable_free_tier     = var.cosmos_mongo_db_params.enable_free_tier

  public_network_access_enabled     = var.cosmos_mongo_db_params.public_network_access_enabled
  private_endpoint_enabled          = var.cosmos_mongo_db_params.private_endpoint_enabled
  subnet_id                         = module.private_endpoint_snet[count.index].id
  private_dns_zone_ids              = [azurerm_private_dns_zone.cosmos_mongo[count.index].id]
  is_virtual_network_filter_enabled = var.cosmos_mongo_db_params.is_virtual_network_filter_enabled

  allowed_virtual_network_subnet_ids = [
    module.k8s_snet.id,
    module.adf_snet[count.index].id
  ]

  ip_range = "104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26,0.0.0.0"

  consistency_policy               = var.cosmos_mongo_db_params.consistency_policy
  main_geo_location_location       = azurerm_resource_group.db_rg.location
  main_geo_location_zone_redundant = var.cosmos_mongo_db_params.main_geo_location_zone_redundant
  additional_geo_locations         = var.cosmos_mongo_db_params.additional_geo_locations

  backup_continuous_enabled = var.cosmos_mongo_db_params.backup_continuous_enabled

  tags = var.tags
}

resource "azurerm_cosmosdb_mongo_database" "rtd_db" {

  count = var.enable.rtd.mongodb_storage ? 1 : 0

  name                = "rtd"
  resource_group_name = azurerm_resource_group.db_rg.name
  account_name        = module.cosmosdb_account_mongodb[count.index].name

  throughput = var.cosmos_mongo_db_transaction_params.enable_autoscaling || var.cosmos_mongo_db_transaction_params.enable_serverless ? null : var.cosmos_mongo_db_transaction_params.throughput

  dynamic "autoscale_settings" {
    for_each = var.cosmos_mongo_db_transaction_params.enable_autoscaling && !var.cosmos_mongo_db_transaction_params.enable_serverless ? [""] : []
    content {
      max_throughput = var.cosmos_mongo_db_transaction_params.max_throughput
    }
  }
}

resource "azurerm_key_vault_secret" "mongo_db_connection_uri" {

  count = var.enable.rtd.mongodb_storage ? 1 : 0

  name         = "mongo-db-connection-uri"
  value        = module.cosmosdb_account_mongodb[count.index].connection_strings[0]
  key_vault_id = module.key_vault.id
}

resource "azurerm_cosmosdb_mongo_collection" "rtd_enrolled_payment_instrument_collection" {

  count = var.enable.rtd.enrolled_payment_instrument ? 1 : 0

  account_name        = module.cosmosdb_account_mongodb[count.index].name
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
}

resource "azurerm_cosmosdb_mongo_collection" "sender_auth" {

  count = var.enable.rtd.mongodb_storage ? 1 : 0

  name                = "senderauth"
  resource_group_name = azurerm_resource_group.db_rg.name
  account_name        = module.cosmosdb_account_mongodb[count.index].name
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

}

resource "azurerm_cosmosdb_mongo_collection" "file_register" {

  count = var.enable.rtd.mongodb_storage ? 1 : 0

  name                = "fileregister"
  resource_group_name = azurerm_resource_group.db_rg.name
  account_name        = module.cosmosdb_account_mongodb[count.index].name
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
  account_name        = module.cosmosdb_account_mongodb[count.index].name
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

}
