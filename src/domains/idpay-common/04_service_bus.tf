resource "azurerm_servicebus_namespace" "idpay-service-bus-ns" {
  name                = "${local.product}-${var.domain}-sb-ns"
  location            = var.location
  resource_group_name = azurerm_resource_group.msg_rg.name
  sku                 = var.service_bus_namespace.sku

  tags = var.tags
}

resource "azurerm_servicebus_queue" "idpay-onboarding-request" {
  name                                    = "idpay-onboarding-request"
  namespace_id                            = azurerm_servicebus_namespace.idpay-service-bus-ns.id
  requires_duplicate_detection            = true
  duplicate_detection_history_time_window = "P1D"
  dead_lettering_on_message_expiration    = true
  #  enable_partitioning = true # default false
}
