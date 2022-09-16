resource "azurerm_servicebus_namespace" "idpay-service-bus-ns" {
  name                = "${local.product}-${var.domain}-sb-ns"
  location            = var.location
  resource_group_name = azurerm_resource_group.msg_rg.name
  sku                 = var.service_bus_namespace.sku

  tags = var.tags
}

#QUEUE
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
