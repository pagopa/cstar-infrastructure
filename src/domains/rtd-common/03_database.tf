data "azurerm_resource_group" "db_rg" {
  name = format("%s-db-rg", local.product)
}

module "cosmosdb_account_mongodb" {

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cosmosdb_account?ref=v6.2.1"

  name                 = format("%s-cosmos-mongo-db-account", local.product)
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

resource "azurerm_key_vault_secret" "cstar_kv_mongo_db_connection_uri" {
  name         = "mongo-db-connection-uri"
  value        = module.cosmosdb_account_mongodb.connection_strings[0]
  key_vault_id = data.azurerm_key_vault.key_vault_cstar.id
  content_type = ""
}

