data "azurerm_eventhub_namespace" "evh_01_namespace" {
  name                = local.idpay_eventhubs.evh01.namespace
  resource_group_name = local.idpay_eventhubs.evh01.resource_group_name
}

data "azurerm_eventhub" "eventhub_idpay_reward_notification_storage_events" {
  name                = "idpay-reward-notification-storage-events"
  namespace_name      = local.idpay_eventhubs.evh01.namespace
  resource_group_name = local.idpay_eventhubs.evh01.resource_group_name
}

data "azurerm_api_management_product" "mock_api_product" {
  count               = var.enable.mock_io_api ? 1 : 0
  product_id          = "mock-api-product"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
}
