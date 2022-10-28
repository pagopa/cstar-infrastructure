data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  resource_group_name = local.aks_resource_group_name
}

# retrieve enrolled pim hub to take partition count
data "azurerm_eventhub" "enrolled_pi_hub" {
  name                = var.eventhub_pim.enrolled_pi_eventhub
  namespace_name      = var.eventhub_pim.namespace_enrolled_pi
  resource_group_name = var.eventhub_pim.resource_group_name
}

data "azurerm_eventhub" "revoked_pi_hub" {
  name                = var.eventhub_pim.revoked_pi_eventhub
  namespace_name      = var.eventhub_pim.namespace_revoked_pi
  resource_group_name = var.eventhub_pim.resource_group_name
}

# retrieve enrolled payment instrument event hub role to get connection string
data "azurerm_eventhub_authorization_rule" "enrolled_pi_producer_role" {
  name                = "rtd-enrolled-pi-producer-policy"
  namespace_name      = var.eventhub_pim.namespace_enrolled_pi
  resource_group_name = var.eventhub_pim.resource_group_name
  eventhub_name       = var.eventhub_pim.enrolled_pi_eventhub
}

# retrieve enrolled payment instrument event hub role to get connection string
data "azurerm_eventhub_authorization_rule" "revoked_pi_consumer_role" {
  name                = "rtd-revoked-pi-consumer-policy"
  namespace_name      = var.eventhub_pim.namespace_revoked_pi
  resource_group_name = var.eventhub_pim.resource_group_name
  eventhub_name       = var.eventhub_pim.revoked_pi_eventhub
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

resource "azurerm_key_vault_secret" "revoked_pi_consumer_connection_uri" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = "${var.domain}-revoked-pi-consumer-connection-uri"
  value        = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"${data.azurerm_eventhub_authorization_rule.revoked_pi_consumer_role.primary_connection_string}\";"
}
