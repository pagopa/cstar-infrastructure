resource "azurerm_resource_group" "msg_rg" {
  name     = format("%s-msg-rg", local.project)
  location = var.location

  tags = var.tags
}


module "event_hub" {
  source                   = "git::https://github.com/pagopa/azurerm.git//eventhub?ref=v1.0.33"
  name                     = format("%s-evh-ns", local.project)
  location                 = var.location
  resource_group_name      = azurerm_resource_group.msg_rg.name
  auto_inflate_enabled     = var.ehns_auto_inflate_enabled
  sku                      = var.ehns_sku_name
  capacity                 = var.ehns_capacity
  maximum_throughput_units = var.ehns_maximum_throughput_units

  virtual_network_id = module.vnet.id
  subnet_id          = module.eventhub_snet.id

  eventhubs = var.eventhubs

  metric_alerts = var.ehns_metric_alerts
  action = [
    {
      action_group_id    = azurerm_monitor_action_group.slack.id
      webhook_properties = null
    },   {
      action_group_id    = azurerm_monitor_action_group.email.id
      webhook_properties = null
    }
  ]

  tags = var.tags
}


resource "azurerm_key_vault_secret" "event_hub_keys" {
  for_each = module.event_hub.key_ids

  #tfsec:ignore:AZU023
  name         = format("evh-%s-%s", replace(each.key, ".", "-"), "key")
  value        = module.event_hub.keys[each.key].primary_key
  content_type = "text/plain"

  key_vault_id = module.key_vault.id
}
