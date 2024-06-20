#
# 🇮🇹 Monitor Italy
#
data "azurerm_resource_group" "monitor_weu_rg" {
  name = var.monitor_weu_resource_group_name
}

data "azurerm_log_analytics_workspace" "log_analytics_weu" {
  name                = var.log_analytics_weu_workspace_name
  resource_group_name = var.log_analytics_weu_workspace_resource_group_name
}

data "azurerm_application_insights" "application_insights_weu" {
  name                = local.monitor_appinsights_weu_name
  resource_group_name = data.azurerm_resource_group.monitor_weu_rg.name
}

#
# Action Groups
#
data "azurerm_monitor_action_group" "slack" {
  resource_group_name = data.azurerm_resource_group.monitor_weu_rg.name
  name                = local.monitor_action_group_slack_name
}

data "azurerm_monitor_action_group" "email" {
  resource_group_name = data.azurerm_resource_group.monitor_weu_rg.name
  name                = local.monitor_action_group_email_name
}

locals {
  test_urls = [
    {
      host                 = "${var.dns_zone_prefix}.${var.external_domain}",
      path                 = "/",
      expected_http_status = 200
    },
  ]

}
