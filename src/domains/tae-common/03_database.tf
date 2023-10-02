resource "azurerm_resource_group" "db_rg" {
  name     = "${local.project}-db-rg"
  location = var.location

  tags = var.tags
}

module "cosmosdb_account" {

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cosmosdb_account?ref=v6.15.2"

  name                = "${local.project}-cosmos-db-account"
  domain              = var.domain
  location            = azurerm_resource_group.db_rg.location
  resource_group_name = azurerm_resource_group.db_rg.name
  offer_type          = var.cosmos_dbms_params.offer_type
  kind                = var.cosmos_dbms_params.kind
  capabilities        = var.cosmos_dbms_params.capabilities
  enable_free_tier    = var.cosmos_dbms_params.enable_free_tier


  public_network_access_enabled     = var.cosmos_dbms_params.public_network_access_enabled
  private_endpoint_enabled          = var.cosmos_dbms_params.private_endpoint_enabled
  subnet_id                         = data.azurerm_subnet.private_endpoint_snet.id
  private_dns_zone_ids              = [data.azurerm_private_dns_zone.cosmos.id]
  is_virtual_network_filter_enabled = var.cosmos_dbms_params.is_virtual_network_filter_enabled

  allowed_virtual_network_subnet_ids = [
    data.azurerm_subnet.private_endpoint_snet.id
  ]

  ip_range = "104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26,0.0.0.0"

  consistency_policy               = var.cosmos_dbms_params.consistency_policy
  main_geo_location_location       = azurerm_resource_group.db_rg.location
  main_geo_location_zone_redundant = var.cosmos_dbms_params.main_geo_location_zone_redundant
  additional_geo_locations         = var.cosmos_dbms_params.additional_geo_locations

  backup_continuous_enabled = var.cosmos_dbms_params.backup_continuous_enabled

  tags = var.tags
}




resource "azurerm_cosmosdb_sql_database" "transaction_aggregate" {

  name                = "tae"
  resource_group_name = azurerm_resource_group.db_rg.name
  account_name        = module.cosmosdb_account.name

  throughput = var.cosmos_db_aggregates_params.enable_autoscaling || var.cosmos_db_aggregates_params.enable_serverless ? null : var.cosmos_db_aggregates_params.throughput

  dynamic "autoscale_settings" {
    for_each = var.cosmos_db_aggregates_params.enable_autoscaling && !var.cosmos_db_aggregates_params.enable_serverless ? [""] : []
    content {
      max_throughput = var.cosmos_db_aggregates_params.max_throughput # override via portal
    }
  }

  lifecycle {
    ignore_changes = [
      autoscale_settings
    ]
  }
}

resource "azurerm_cosmosdb_sql_container" "aggregates" {

  name                = "aggregates"
  resource_group_name = azurerm_resource_group.db_rg.name
  account_name        = module.cosmosdb_account.name
  database_name       = azurerm_cosmosdb_sql_database.transaction_aggregate.name

  partition_key_path    = "/terminalId"
  partition_key_version = 2

  dynamic "autoscale_settings" {
    for_each = var.cosmos_db_aggregates_params.enable_autoscaling && !var.cosmos_db_aggregates_params.enable_serverless ? [""] : []
    content {
      max_throughput = var.cosmos_db_aggregates_params.max_throughput # override via portal
    }
  }

  lifecycle {
    ignore_changes = [
      autoscale_settings
    ]
  }

  default_ttl = -1

}
