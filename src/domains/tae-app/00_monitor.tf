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