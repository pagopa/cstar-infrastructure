# ------------------------------------------------------------------------------
# ACA Environment.
# ------------------------------------------------------------------------------
resource "azurerm_container_app_environment" "rtp" {
  name                           = "${local.project}-cae"
  location                       = azurerm_resource_group.app.location
  resource_group_name            = azurerm_resource_group.app.name
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.log_analytics.id
  internal_load_balancer_enabled = true
  infrastructure_subnet_id       = azurerm_subnet.aca.id
  tags                           = var.tags
  zone_redundancy_enabled        = false
}
