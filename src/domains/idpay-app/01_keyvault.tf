data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  resource_group_name = local.aks_resource_group_name
}

# retrieve enrolled payment instrument event hub role to get connection string

data "azurerm_eventhub_authorization_rule" "enrolled_pi_producer_role" {
  name                = "rtd-enrolled-pi-producer-policy"
  namespace_name      = var.eventhub_enrolled_pi.namespace_name
  resource_group_name = var.eventhub_enrolled_pi.resource_group_name
  eventhub_name       = "rtd-enrolled-pi"
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

resource "azurerm_key_vault_secret" "enrolled_pi_producer_connection_uri" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = "${var.domain}-enrolled-pi-producer-connection-uri"
  value        = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"${data.azurerm_eventhub_authorization_rule.enrolled_pi_producer_role.primary_connection_string}\";"
}