#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "appinsights-instrumentation-key" {
  key_vault_id = data.azurerm_key_vault.kv_domain.id
  name         = "appinsights-instrumentation-key"
  value        = data.azurerm_application_insights.application_insights.connection_string
  content_type = "text/plain"
}
