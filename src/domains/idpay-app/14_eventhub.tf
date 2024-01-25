locals {
  enable_evh = 1 //var.env_short == "d" ? 1 : 0
  mongodb_connection_uri_template = "mongodb://%s:%s@%s.mongo.cosmos.azure.com:10255/?ssl=true&replicaSet=globaldb&retrywrites=false&maxIdleTimeMS=120000&appName=@%s@"
  jaas_config_template_idpay = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"%s\";"
}

# eventhub for POC
resource "azurerm_eventhub_namespace" "cdc_evh" {
  count               = local.enable_evh
  name                = "idpay-cdc"
  location            = var.location
  resource_group_name = "cstar-${var.env_short}-idpay-msg-rg"
  sku                 = "Standard"
  zone_redundant      = true
  minimum_tls_version = 1.2
  network_rulesets {
    default_action = "Allow"
  }
}

# access key for kafka connect with manage access
resource "azurerm_eventhub_namespace_authorization_rule" "evh_namespace_access_key" {
  count               = local.enable_evh
  name                = "kafka-connect-access-key"
  namespace_name      = azurerm_eventhub_namespace.cdc_evh[0].name
  resource_group_name = "cstar-${var.env_short}-idpay-msg-rg"
  manage              = true
  listen              = true
  send                = true
}

resource "azurerm_key_vault_secret" "event_hub_root_key_idpay_00" {
  name         = "evh-root-jaas-config-idpay-00"
  value        = format(local.jaas_config_template_idpay, azurerm_eventhub_namespace_authorization_rule.evh_namespace_access_key[0].primary_connection_string)
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv.id
}
