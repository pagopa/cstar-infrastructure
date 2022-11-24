data "azurerm_eventhub" "eventhub_idpay_reward_notification_storage_events" {
  name                = "idpay-reward-notification-storage-events"
  namespace_name      = local.idpay_eventhubs.evh01.namespace
  resource_group_name = local.idpay_eventhubs.evh01.resource_group_name
}
