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
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//postgresql_server?ref=v6.2.1"
  name                = format("%s-postgresql", local.project)
  location            = azurerm_resource_group.db_rg.location
  resource_group_name = azurerm_resource_group.db_rg.name

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


  private_endpoint = {
    enabled              = true
    virtual_network_id   = module.vnet.id
    subnet_id            = module.db_snet.id
    private_dns_zone_ids = [azurerm_private_dns_zone.postgres_old.id]
  }

  allowed_subnets = [module.db_snet.id]

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

module "postgres_flexible_server" {

  count = var.pgres_flex_params.enabled ? 1 : 0

  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//postgres_flexible_server?ref=v6.2.1"
  name                = format("%s-flexible-postgresql", local.project)
  location            = azurerm_resource_group.db_rg.location
  resource_group_name = azurerm_resource_group.db_rg.name


  pgbouncer_enabled         = false
  high_availability_enabled = false
  private_endpoint_enabled  = true
  //private_dns_zone         = azurerm_private_dns_zone.postgres.id
  delegated_subnet_id = module.postgres_flexible_snet.id

  /*  private_endpoint = {
    enabled   = true
    subnet_id = module.postgres_flexible_snet.id
    private_dns_zone = {
      id   = azurerm_private_dns_zone.postgres.id
      name = azurerm_private_dns_zone.postgres.name
      rg   = azurerm_resource_group.rg_vnet.name
    }
  } */

  administrator_login    = data.azurerm_key_vault_secret.pgres_flex_admin_login.value
  administrator_password = data.azurerm_key_vault_secret.pgres_flex_admin_pwd.value

  custom_metric_alerts = {}
  alerts_enabled       = false

  sku_name                     = var.pgres_flex_params.sku_name
  db_version                   = var.pgres_flex_params.db_version
  storage_mb                   = var.pgres_flex_params.storage_mb
  zone                         = var.pgres_flex_params.zone
  backup_retention_days        = var.pgres_flex_params.backup_retention_days
  geo_redundant_backup_enabled = var.pgres_flex_params.geo_redundant_backup_enabled
  create_mode                  = var.pgres_flex_params.create_mode

  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id


  tags = var.tags

  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgres_vnet]
}
