
data "azurerm_application_insights" "appinsights" {
  name                = "${var.prefix}-${var.env_short}-appinsights"
  resource_group_name = "${var.prefix}-${var.env_short}-monitor-rg"
}

# ------------------------------------------------------------------------------
# Storing AppInsights endpoint in the rtp key vault.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "appinisights_connection_string_kv" {
  name         = "appinsights-connection-string"
  value        = data.azurerm_application_insights.appinsights.connection_string
  key_vault_id = data.azurerm_key_vault.kv_domain.id
  tags         = var.tags
}
