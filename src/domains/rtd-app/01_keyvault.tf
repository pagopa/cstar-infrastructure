data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  resource_group_name = local.aks_resource_group_name
}

locals {
  aks_api_url = var.env_short == "d" ? data.azurerm_kubernetes_cluster.aks.fqdn : data.azurerm_kubernetes_cluster.aks.private_fqdn
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "aks_apiserver_url" {
  name         = "${local.aks_name}-apiserver-url"
  value        = "https://${local.aks_api_url}:443"
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "appinsights-instrumentation-key" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = "appinsights-instrumentation-key"
  value        = "InstrumentationKey=${data.azurerm_application_insights.application_insights.instrumentation_key}"
  content_type = "text/plain"
}

resource "azurerm_key_vault_secret" "appinsights-connection-string" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = "appinsights-connection-string"
  value        = data.azurerm_application_insights.application_insights.connection_string
  content_type = "text/plain"
}
