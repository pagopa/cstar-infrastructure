data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_resource_group_name
}

resource "azurerm_resource_group" "grafana_rg" {
  name     = "${local.project}-rg"
  location = var.location
  tags = var.tags
}

resource "azurerm_dashboard_grafana" "grafana_dashboard" {
  name                              = local.project
  resource_group_name               = azurerm_resource_group.grafana_rg.name
  location                          = var.location
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = true
  zone_redundancy_enabled           = true
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}

resource "azurerm_role_assignment" "grafana_dashboard_monitoring_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.grafana_dashboard.identity[0].principal_id
}

module "auto_dashboard" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//grafana_dashboard?ref=grafana-automatic-dashboard"
  grafana_url = azurerm_dashboard_grafana.grafana_dashboard.endpoint
  grafana_api_key = "xyz"
  prefix  = var.prefix
  monitor_workspace = data.azurerm_log_analytics_workspace.log_analytics.id
}
