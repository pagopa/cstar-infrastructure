# access key for kafka connect with manage access
resource "azurerm_eventhub_namespace_authorization_rule" "evh_namespace_access_key_00" {
  count               = 1
  name                = "kafka-connect-access-key"
  namespace_name      = "${local.product}-${var.domain}-evh-ns-00"
  resource_group_name = "cstar-${var.env_short}-idpay-msg-rg"
  manage              = true
  listen              = true
  send                = true
}

resource "azurerm_key_vault_secret" "event_hub_root_key_idpay_00" {
  name         = "evh-root-sasl-jaas-config-idpay-00"
  value        = format("org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"%s\";", azurerm_eventhub_namespace_authorization_rule.evh_namespace_access_key_00[0].primary_connection_string)
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv.id
}


data "azurerm_cosmosdb_account" "idpay_cosmos_db" {
  name                = "cstar-${var.env_short}-cosmos-mongo-db-account"
  resource_group_name = "cstar-${var.env_short}-db-rg"
}

resource "terracurl_request" "cosmos_connector" {
  name         = "cosmos_connector"
  url          = "https://${var.ingress_load_balancer_hostname}/idpaykafkaconnect/connectors/cosmos-connector/config"
  method       = "PUT"
  request_body = file("cosmos_connector.json")
  response_codes = [
    200,
    201,
    204
  ]

  headers = {
    Content-Type = "application/json"
  }
}
