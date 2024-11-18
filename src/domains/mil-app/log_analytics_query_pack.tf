# ------------------------------------------------------------------------------
# Query pack.
# ------------------------------------------------------------------------------
resource "azurerm_log_analytics_query_pack" "mil" {
  name                = "${local.project}-pack"
  location            = azurerm_resource_group.monitor.location
  resource_group_name = azurerm_resource_group.monitor.name
  tags                = local.tags
}