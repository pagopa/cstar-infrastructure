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
  count = var.dexp_db.enable ? 1 : 0

  name                = replace(format("%sdataexplorer", local.product), "-", "")
  resource_group_name = var.monitor_resource_group_name
}

resource "azurerm_kusto_database" "database" {
  count = var.dexp_db.enable ? 1 : 0

  name                = "tae"
  resource_group_name = var.monitor_resource_group_name
  location            = data.azurerm_kusto_cluster.dexp_cluster[count.index].location
  cluster_name        = data.azurerm_kusto_cluster.dexp_cluster[count.index].name

  hot_cache_period   = var.dexp_db.hot_cache_period
  soft_delete_period = var.dexp_db.soft_delete_period
}