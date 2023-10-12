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
  value        = data.azurerm_application_insights.application_insights.connection_string
  content_type = "text/plain"
}

resource "azurerm_key_vault_secret" "enrolled_pi_producer_connection_uri" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = "${var.domain}-enrolled-pi-producer-connection-uri"
  value        = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"\";"
}

resource "azurerm_key_vault_secret" "revoked_pi_consumer_connection_uri" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = "${var.domain}-revoked-pi-consumer-connection-uri"
  value        = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"\";"
}

data "azurerm_key_vault_secret" "alert-slack-idpay" {

  count = var.idpay_alert_enabled ? 1 : 0

  name         = "alert-idpay-notification-slack"
  key_vault_id = data.azurerm_key_vault.kv.id
}
resource "azurerm_key_vault_key" "idpay-mil-key" {
  name         = "idpay-mil-key"
  key_vault_id = data.azurerm_key_vault.kv.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt"
  ]
}

resource "azurerm_key_vault_key" "idpay-pinblock-key" {
  name         = "idpay-pinblock-key"
  key_vault_id = data.azurerm_key_vault.kv.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt"
  ]
}

resource "azurerm_key_vault_secret" "idpay-mil-key-secret" {
  name         = "idpay-mil-key-secret"
  value        = azurerm_key_vault_key.idpay-mil-key.public_key_pem
  content_type = "text/plain"
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_api_management_named_value" "idpay-mil-named-value" {

  name                = format("%s-idpay-mil-named-value", var.env_short)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  display_name = "idpay-mil-named-value"
  secret       = true
  value_from_key_vault {
    secret_id = azurerm_key_vault_secret.idpay-mil-key-secret.versionless_id
  }

}
