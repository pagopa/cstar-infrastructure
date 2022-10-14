data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_resource_group_name
}

data "azurerm_resource_group" "monitor_rg" {
  name = var.monitor_resource_group_name
}

data "azurerm_monitor_action_group" "slack" {
  resource_group_name = var.monitor_resource_group_name
  name                = local.monitor_action_group_slack_name
}

data "azurerm_monitor_action_group" "email" {
  resource_group_name = var.monitor_resource_group_name
  name                = local.monitor_action_group_email_name
}

data "azurerm_kusto_cluster" "dexp_cluster" {
  count = var.dexp_tae_db_linkes_service.enable ? 1 : 0

  name                = replace(format("%sdataexplorer", local.product), "-", "")
  resource_group_name = var.monitor_resource_group_name
}

data "azurerm_kusto_database" "tae_db" {
  count = var.dexp_tae_db_linkes_service.enable ? 1 : 0

  name                = "tae"
  resource_group_name = var.monitor_resource_group_name
  cluster_name        = data.azurerm_kusto_cluster.dexp_cluster[count.index].name
}

resource "azurerm_kusto_script" "create_tables" {

  count = var.dexp_tae_db_linkes_service.enable ? 1 : 0

  name        = "CreateTables"
  database_id = data.azurerm_kusto_database.tae_db[count.index].id

  script_content                     = file("scripts/create_tables.dexp")
  continue_on_errors_enabled         = true
  force_an_update_when_value_changed = "v6" # change this version to re-execute the script
}

## Alarms

resource "azurerm_monitor_action_group" "send_to_operations" {

  count = var.env_short == "p" ? 1 : 0

  name                = "send_to_operations"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  short_name          = "send_to_ops"

  email_receiver {
    name                    = "send_to_operations"
    email_address           = data.azurerm_key_vault_secret.operations_slack_email[count.index].value
    use_common_alert_schema = true
  }

}