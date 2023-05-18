data "azurerm_resource_group" "db_rg" {
  name = format("%s-db-rg", local.product)
}

module "cosmosdb_account_mongodb" {

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cosmosdb_account?ref=v6.2.1"

  name                 = "${local.product}-cosmos-mongo-db-account"
  location             = data.azurerm_resource_group.db_rg.location
  resource_group_name  = data.azurerm_resource_group.db_rg.name
  offer_type           = var.cosmos_mongo_db_params.offer_type
  kind                 = var.cosmos_mongo_db_params.kind
  capabilities         = var.cosmos_mongo_db_params.capabilities
  mongo_server_version = var.cosmos_mongo_db_params.server_version
  enable_free_tier     = var.cosmos_mongo_db_params.enable_free_tier

  // work around to comply with current module interface
  domain                            = ""
  public_network_access_enabled     = var.cosmos_mongo_db_params.public_network_access_enabled
  private_endpoint_enabled          = var.cosmos_mongo_db_params.private_endpoint_enabled
  subnet_id                         = data.azurerm_subnet.private_endpoint_snet.id
  private_dns_zone_ids              = [data.azurerm_private_dns_zone.cosmos_mongo.id]
  is_virtual_network_filter_enabled = var.cosmos_mongo_db_params.is_virtual_network_filter_enabled

  enable_provisioned_throughput_exceeded_alert = false

  allowed_virtual_network_subnet_ids = [
    data.azurerm_subnet.aks_old_subnet.id,
    data.azurerm_subnet.adf_snet.id
  ]

  ip_range = "104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26,0.0.0.0"

  consistency_policy               = var.cosmos_mongo_db_params.consistency_policy
  main_geo_location_location       = data.azurerm_resource_group.db_rg.location
  main_geo_location_zone_redundant = var.cosmos_mongo_db_params.main_geo_location_zone_redundant
  additional_geo_locations         = var.cosmos_mongo_db_params.additional_geo_locations

  backup_continuous_enabled = var.cosmos_mongo_db_params.backup_continuous_enabled

  tags = var.tags
}

# Create connection string secret to cstar kv
resource "azurerm_key_vault_secret" "cstar_kv_mongo_db_connection_uri" {
  name         = "mongo-db-connection-uri"
  value        = module.cosmosdb_account_mongodb.connection_strings[0]
  key_vault_id = data.azurerm_key_vault.key_vault_cstar.id
  content_type = ""
}

# Create connection string secret to domain kv
resource "azurerm_key_vault_secret" "mongo_db_connection_uri" {
  key_vault_id = module.key_vault_domain.id
  name         = azurerm_key_vault_secret.cstar_kv_mongo_db_connection_uri.name
  value        = azurerm_key_vault_secret.cstar_kv_mongo_db_connection_uri.value
  content_type = azurerm_key_vault_secret.cstar_kv_mongo_db_connection_uri.content_type
}

# RTD database
resource "azurerm_cosmosdb_mongo_database" "rtd_db" {

  name                = "rtd"
  resource_group_name = data.azurerm_resource_group.db_rg.name
  account_name        = module.cosmosdb_account_mongodb.name

  throughput = var.cosmos_mongo_db_transaction_params.enable_autoscaling || var.cosmos_mongo_db_transaction_params.enable_serverless ? null : var.cosmos_mongo_db_transaction_params.throughput

  dynamic "autoscale_settings" {
    for_each = var.cosmos_mongo_db_transaction_params.enable_autoscaling && !var.cosmos_mongo_db_transaction_params.enable_serverless ? [""] : []
    content {
      max_throughput = var.cosmos_mongo_db_transaction_params.max_throughput
    }
  }
}

resource "azurerm_cosmosdb_mongo_collection" "rtd_enrolled_payment_instrument_collection" {
  count               = var.enable.enrolled_payment_instrument ? 1 : 0
  account_name        = module.cosmosdb_account_mongodb.name
  database_name       = azurerm_cosmosdb_mongo_database.rtd_db.name
  resource_group_name = data.azurerm_resource_group.db_rg.name

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
  name                = "senderauth"
  resource_group_name = data.azurerm_resource_group.db_rg.name
  account_name        = module.cosmosdb_account_mongodb.name
  database_name       = azurerm_cosmosdb_mongo_database.rtd_db.name

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
  name                = "fileregister"
  resource_group_name = data.azurerm_resource_group.db_rg.name
  account_name        = module.cosmosdb_account_mongodb.name
  database_name       = azurerm_cosmosdb_mongo_database.rtd_db.name

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
  name                = "filereports"
  resource_group_name = data.azurerm_resource_group.db_rg.name
  account_name        = module.cosmosdb_account_mongodb.name
  database_name       = azurerm_cosmosdb_mongo_database.rtd_db.name

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
  count = var.enable.payment_instrument ? 1 : 0

  resource_group_name = data.azurerm_resource_group.db_rg.name
  account_name        = module.cosmosdb_account_mongodb.name
  database_name       = azurerm_cosmosdb_mongo_database.rtd_db.name

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
