resource "azurerm_resource_group" "db_rg" {
  name     = format("%s-db-rg", local.project)
  location = var.location

  tags = var.tags
}


module "cosmosdb_account_mongodb" {

  count = var.cosmos_mongo_db_params.enabled ? 1 : 0

  source = "git::https://github.com/pagopa/azurerm.git//cosmosdb_account?ref=v2.15.1"

  name                 = format("%s-cosmos-mongo-db-account", local.project)
  location             = azurerm_resource_group.db_rg.location
  resource_group_name  = azurerm_resource_group.db_rg.name
  offer_type           = var.cosmos_mongo_db_params.offer_type
  kind                 = "MongoDB"
  capabilities         = var.cosmos_mongo_db_params.capabilities
  mongo_server_version = var.cosmos_mongo_db_params.server_version

  public_network_access_enabled     = var.cosmos_mongo_db_params.public_network_access_enabled
  private_endpoint_enabled          = var.cosmos_mongo_db_params.private_endpoint_enabled
  subnet_id                         = module.cosmos_mongodb_snet[count.index].id
  private_dns_zone_ids              = [azurerm_private_dns_zone.cosmos_mongo[count.index].id]
  is_virtual_network_filter_enabled = var.cosmos_mongo_db_params.is_virtual_network_filter_enabled

  consistency_policy               = var.cosmos_mongo_db_params.consistency_policy
  main_geo_location_location       = azurerm_resource_group.db_rg.location
  main_geo_location_zone_redundant = var.cosmos_mongo_db_params.main_geo_location_zone_redundant
  additional_geo_locations         = var.cosmos_mongo_db_params.additional_geo_locations

  backup_continuous_enabled = var.cosmos_mongo_db_params.backup_continuous_enabled

  tags = var.tags
}

resource "azurerm_cosmosdb_mongo_database" "idpay" {

  count = 1

  name                = "idpay"
  resource_group_name = azurerm_resource_group.db_rg.name
  account_name        = module.cosmosdb_account_mongodb[count.index].name

  throughput = var.cosmos_mongo_db_transaction_params.enable_autoscaling || var.cosmos_mongo_db_transaction_params.enable_serverless ? null : var.cosmos_mongo_db_transaction_params.throughput

  dynamic "autoscale_settings" {
    for_each = var.cosmos_mongo_db_transaction_params.enable_autoscaling && !var.cosmos_mongo_db_transaction_params.enable_serverless ? [""] : []
    content {
      max_throughput = var.cosmos_mongo_db_transaction_params.enable_serverless.max_throughput
    }
  }
}

# Collections
module "mongdb_collection_onboarding_citizen" {
  source = "git::https://github.com/pagopa/azurerm.git//cosmosdb_mongodb_collection?ref=v2.3.0"

  count = 1
  name                = "onboarding_citizen"
  resource_group_name = azurerm_resource_group.mongodb_rg.name

  cosmosdb_mongo_account_name  = module.cosmosdb_account_mongodb[count.index].name
  cosmosdb_mongo_database_name = azurerm_cosmosdb_mongo_database.idpay[count.index].name

  lock_enable = true
}