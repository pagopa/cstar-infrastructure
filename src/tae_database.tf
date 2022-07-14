locals {
  tae_tags = merge(var.tags, { Application = "TAE" })
}

resource "azurerm_resource_group" "tae_db_rg" {
  name     = format("%s-tae-db-rg", local.project)
  location = var.location

  tags = local.tae_tags
}

module "tae_cosmosdb_account" {

  count = var.enable.tae.db_collections ? 1 : 0

  source = "git::https://github.com/pagopa/azurerm.git//cosmosdb_account?ref=v2.15.1"

  name                = format("%s-tae-cosmos-db-account", local.project)
  location            = azurerm_resource_group.tae_db_rg.location
  resource_group_name = azurerm_resource_group.tae_db_rg.name
  offer_type          = var.tae_cosmos_db_params.offer_type
  kind                = var.tae_cosmos_db_params.kind
  capabilities        = var.tae_cosmos_db_params.capabilities
  enable_free_tier    = var.cosmos_mongo_db_params.enable_free_tier


  public_network_access_enabled     = var.tae_cosmos_db_params.public_network_access_enabled
  private_endpoint_enabled          = var.tae_cosmos_db_params.private_endpoint_enabled
  subnet_id                         = module.private_endpoint_snet[count.index].id
  private_dns_zone_ids              = [azurerm_private_dns_zone.cosmos_mongo[count.index].id]
  is_virtual_network_filter_enabled = var.tae_cosmos_db_params.is_virtual_network_filter_enabled

  allowed_virtual_network_subnet_ids = [
    module.adf_snet[count.index].id
  ]

  ip_range = "104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26,0.0.0.0"

  consistency_policy               = var.tae_cosmos_db_params.consistency_policy
  main_geo_location_location       = azurerm_resource_group.db_rg.location
  main_geo_location_zone_redundant = var.tae_cosmos_db_params.main_geo_location_zone_redundant
  additional_geo_locations         = var.tae_cosmos_db_params.additional_geo_locations

  backup_continuous_enabled = var.tae_cosmos_db_params.backup_continuous_enabled

  tags = var.tags
}




resource "azurerm_cosmosdb_sql_database" "transaction_aggregate" {

  count = var.enable.tae.db_collections ? 1 : 0

  name                = "tae"
  resource_group_name = azurerm_resource_group.tae_db_rg.name
  account_name        = module.tae_cosmosdb_account[count.index].name

  throughput = var.tae_cosmos_db_transaction_params.enable_autoscaling || var.tae_cosmos_db_transaction_params.enable_serverless ? null : var.tae_cosmos_db_transaction_params.throughput

  dynamic "autoscale_settings" {
    for_each = var.tae_cosmos_db_transaction_params.enable_autoscaling && !var.tae_cosmos_db_transaction_params.enable_serverless ? [""] : []
    content {
      max_throughput = var.tae_cosmos_db_transaction_params.max_throughput
    }
  }
}

resource "azurerm_cosmosdb_sql_container" "aggregates" {

  count = var.enable.tae.db_collections ? 1 : 0

  name                = "aggregates"
  resource_group_name = azurerm_resource_group.tae_db_rg.name
  account_name        = module.tae_cosmosdb_account[count.index].name
  database_name       = azurerm_cosmosdb_sql_database.transaction_aggregate[count.index].name

  partition_key_path    = "/definition/id"
  partition_key_version = 2

  indexing_policy {
    indexing_mode = "Consistent"

    included_path {
      path = "/*"
    }

    included_path {
      path = "/included/?"
    }

    excluded_path {
      path = "/excluded/?"
    }
  }

  unique_key {
    paths = ["/definition/id"]
  }

  dynamic "autoscale_settings" {
    for_each = var.tae_cosmos_db_transaction_params.enable_autoscaling && !var.tae_cosmos_db_transaction_params.enable_serverless ? [""] : []
    content {
      max_throughput = var.tae_cosmos_db_transaction_params.max_throughput
    }
  }
}