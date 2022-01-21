resource "azurerm_resource_group" "db_rg" {
  name     = format("%s-db-rg", local.project)
  location = var.location

  tags = var.tags
}

data "azurerm_key_vault_secret" "db_administrator_login" {
  name         = "db-administrator-login"
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "db_administrator_login_password" {
  name         = "db-administrator-login-password"
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "pgres_flex_admin_login" {
  name         = "pgres-flex-admin-login"
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "pgres_flex_admin_pwd" {
  name         = "pgres-flex-admin-pwd"
  key_vault_id = module.key_vault.id
}

#tfsec:ignore:azure-database-no-public-access
module "postgresql" {
  source                           = "git::https://github.com/pagopa/azurerm.git//postgresql_server?ref=v1.0.51"
  name                             = format("%s-postgresql", local.project)
  location                         = azurerm_resource_group.db_rg.location
  resource_group_name              = azurerm_resource_group.db_rg.name
  virtual_network_id               = module.vnet.id
  subnet_id                        = module.db_snet.id
  administrator_login              = data.azurerm_key_vault_secret.db_administrator_login.value
  administrator_login_password     = data.azurerm_key_vault_secret.db_administrator_login_password.value
  sku_name                         = var.db_sku_name
  storage_mb                       = var.db_storage_mb
  db_version                       = 10
  geo_redundant_backup_enabled     = var.db_geo_redundant_backup_enabled
  enable_replica                   = var.db_enable_replica
  ssl_minimal_tls_version_enforced = "TLS1_2"
  public_network_access_enabled    = true
  lock_enable                      = var.lock_enable

  network_rules         = var.db_network_rules
  replica_network_rules = var.db_replica_network_rules

  configuration         = var.db_configuration
  configuration_replica = var.db_configuration

  alerts_enabled                        = var.db_alerts_enabled
  monitor_metric_alert_criteria         = var.db_metric_alerts
  replica_monitor_metric_alert_criteria = var.db_metric_alerts
  action = [
    {
      action_group_id    = azurerm_monitor_action_group.email.id
      webhook_properties = null
    },
    {
      action_group_id    = azurerm_monitor_action_group.slack.id
      webhook_properties = null
    }
  ]
  replica_action = [
    {
      action_group_id    = azurerm_monitor_action_group.email.id
      webhook_properties = null
    },
    {
      action_group_id    = azurerm_monitor_action_group.slack.id
      webhook_properties = null
    }
  ]

  tags = var.tags
}

# created by scripts
# resource "azurerm_postgresql_database" "bpd_db" {
#   name                = "bpd"
#   resource_group_name = azurerm_resource_group.db_rg.name
#   server_name         = module.postgresql.name
#   charset             = "UTF8"
#   collation           = "English_United States.1252"
# }

# resource "azurerm_postgresql_database" "rtd_db" {
#   name                = "rtd"
#   resource_group_name = azurerm_resource_group.db_rg.name
#   server_name         = module.postgresql.name
#   charset             = "UTF8"
#   collation           = "English_United States.1252"
# }

# resource "azurerm_postgresql_database" "fa_db" {
#   name                = "fa"
#   resource_group_name = azurerm_resource_group.db_rg.name
#   server_name         = module.postgresql.name
#   charset             = "UTF8"
#   collation           = "English_United States.1252"
# }


module "postgres_flexible_server" {

  count = var.pgres_flex_params.enabled ? 1 : 0

  source              = "git::https://github.com/pagopa/azurerm.git//postgres_flexible_server?ref=v2.1.14"
  name                = format("%s-flexible-postgresql", local.project)
  location            = azurerm_resource_group.db_rg.location
  resource_group_name = azurerm_resource_group.db_rg.name

  private_endpoint = {
    enabled   = true
    subnet_id = module.postgres_flexible_snet.id
    private_dns_zone = {
      id   = azurerm_private_dns_zone.postgres.id
      name = azurerm_private_dns_zone.postgres.name
      rg   = azurerm_resource_group.rg_vnet.name
    }
  }

  administrator_login    = data.azurerm_key_vault_secret.pgres_flex_admin_login.value
  administrator_password = data.azurerm_key_vault_secret.pgres_flex_admin_pwd.value

  sku_name                     = var.pgres_flex_params.sku_name
  db_version                   = var.pgres_flex_params.db_version
  storage_mb                   = var.pgres_flex_params.storage_mb
  zone                         = var.pgres_flex_params.zone
  backup_retention_days        = var.pgres_flex_params.backup_retention_days
  geo_redundant_backup_enabled = var.pgres_flex_params.geo_redundant_backup_enabled
  create_mode                  = var.pgres_flex_params.create_mode

  tags = var.tags

  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgres_vnet]
}

module "cosmosdb_account_mongodb" {

  count = var.cosmos_mongo_db_params.enabled ? 1 : 0

  source = "git::https://github.com/pagopa/azurerm.git//cosmosdb?ref=v2.0.19"

  name                 = format("%s-cosmos-mongo-db-account", local.project)
  location             = azurerm_resource_group.db_rg.location
  resource_group_name  = azurerm_resource_group.db_rg.name
  offer_type           = var.cosmos_mongo_db_params.offer_type
  kind                 = var.cosmos_mongo_db_params.kind
  capabilities         = var.cosmos_mongo_db_params.capabilities
  mongo_server_version = var.cosmos_mongo_db_params.server_version

  public_network_access_enabled     = var.cosmos_mongo_db_params.public_network_access_enabled
  private_endpoint_enabled          = var.cosmos_mongo_db_params.private_endpoint_enabled
  subnet_id                         = module.cosmos_mongodb_snet.id
  private_dns_zone_ids              = [azurerm_private_dns_zone.cosmos_mongo.id]
  is_virtual_network_filter_enabled = var.cosmos_mongo_db_params.is_virtual_network_filter_enabled

  consistency_policy               = var.cosmos_mongo_db_params.consistency_policy
  main_geo_location_location       = azurerm_resource_group.db_rg.location
  main_geo_location_zone_redundant = var.cosmos_mongo_db_params.main_geo_location_zone_redundant
  additional_geo_locations         = var.cosmos_mongo_db_params.additional_geo_locations

  backup_continuous_enabled = var.cosmos_mongo_db_params.backup_continuous_enabled

  tags = var.tags
}

resource "azurerm_cosmosdb_mongo_database" "transaction" {

  count = var.cosmos_mongo_db_params.enabled ? 1 : 0

  name                = "transaction"
  resource_group_name = azurerm_resource_group.db_rg.name
  account_name        = module.cosmosdb_account_mongodb.name

  throughput = var.cosmos_mongo_db_transaction_params.enable_autoscaling || var.cosmos_mongo_db_transaction_params.enable_serverless ? null : var.cosmos_mongo_db_transaction_params.throughput

  dynamic "autoscale_settings" {
    for_each = var.cosmos_mongo_db_transaction_params.enable_autoscaling && !var.cosmos_mongo_db_transaction_params.enable_serverless ? [""] : []
    content {
      max_throughput = var.cosmos_mongo_db_transaction_params.enable_serverless.max_throughput
    }
  }
}