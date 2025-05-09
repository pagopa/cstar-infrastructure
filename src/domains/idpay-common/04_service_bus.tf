resource "azurerm_servicebus_namespace" "idpay-service-bus-ns" {
  name                = "${local.product}-${var.domain}-sb-ns"
  location            = var.location
  resource_group_name = azurerm_resource_group.msg_rg.name
  sku                 = var.service_bus_namespace.sku
  minimum_tls_version = "1.2"

  tags = var.tags
}

resource "azurerm_servicebus_namespace_authorization_rule" "idpay-service-bus-ns-manager" {
  name         = "idpay-service-bus-ns-manager"
  namespace_id = azurerm_servicebus_namespace.idpay-service-bus-ns.id

  listen = true
  send   = true
  manage = true
}

resource "azurerm_key_vault_secret" "idpay-service-bus-ns-manager-sas-key" {

  name         = "idpay-service-bus-ns-manager-sas-key"
  value        = azurerm_servicebus_namespace_authorization_rule.idpay-service-bus-ns-manager.primary_connection_string
  content_type = "text/plain"

  key_vault_id = module.key_vault_idpay.id
}

#QUEUE Onboarding Request
resource "azurerm_servicebus_queue" "idpay-onboarding-request" {
  name                                    = "idpay-onboarding-request"
  namespace_id                            = azurerm_servicebus_namespace.idpay-service-bus-ns.id
  requires_duplicate_detection            = true
  duplicate_detection_history_time_window = "P1D"
  dead_lettering_on_message_expiration    = true
  #  enable_partitioning = true # default false
}

resource "azurerm_servicebus_queue_authorization_rule" "idpay-onboarding-request-producer" {
  name     = "idpay-onboarding-request-producer"
  queue_id = azurerm_servicebus_queue.idpay-onboarding-request.id

  listen = false
  send   = true
  manage = false
}

#processor have to read and send bck the data with a delay if there is the need to reprocess
resource "azurerm_servicebus_queue_authorization_rule" "idpay-onboarding-request-processor" {
  name     = "idpay-onboarding-request-processor"
  queue_id = azurerm_servicebus_queue.idpay-onboarding-request.id

  listen = true
  send   = true
  manage = false
}

#KEY-VAULT Secret

resource "azurerm_key_vault_secret" "idpay-onboarding-request-producer-sas-key" {

  name         = "idpay-onboarding-request-producer-sas-key"
  value        = azurerm_servicebus_queue_authorization_rule.idpay-onboarding-request-producer.primary_connection_string
  content_type = "text/plain"

  key_vault_id = module.key_vault_idpay.id
}

resource "azurerm_key_vault_secret" "idpay-onboarding-request-processor-sas-key" {

  name         = "idpay-onboarding-request-processor-sas-key"
  value        = azurerm_servicebus_queue_authorization_rule.idpay-onboarding-request-processor.primary_connection_string
  content_type = "text/plain"

  key_vault_id = module.key_vault_idpay.id
}


#QUEUE Payment Timeout

resource "azurerm_servicebus_queue" "idpay-payment-timeout" {
  name                                    = "idpay-payment-timeout"
  namespace_id                            = azurerm_servicebus_namespace.idpay-service-bus-ns.id
  requires_duplicate_detection            = true
  duplicate_detection_history_time_window = "P1D"
  dead_lettering_on_message_expiration    = true
  #  enable_partitioning = true # default false
}


resource "azurerm_servicebus_queue_authorization_rule" "idpay-payment-timeout-consumer" {
  name     = "idpay-payment-timeout-consumer"
  queue_id = azurerm_servicebus_queue.idpay-payment-timeout.id

  listen = true
  send   = false
  manage = false
}

resource "azurerm_key_vault_secret" "idpay-payment-timeout-consumer-sas-key" {

  name         = "idpay-payment-timeout-consumer-sas-key"
  value        = azurerm_servicebus_queue_authorization_rule.idpay-payment-timeout-consumer.primary_connection_string
  content_type = "text/plain"

  key_vault_id = module.key_vault_idpay.id
}
