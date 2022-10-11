locals {
  jaas_config_template_idpay = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"%s\";"

  core_event_hub = {
    keys = [
      {
        name          = "rtd-trx-consumer"
        eventhub_name = "rtd-trx"
      },
      {
        name          = "rtd-trx-producer"
        eventhub_name = "rtd-trx"
      }
    ]
  }
}

resource "azurerm_resource_group" "msg_rg" {
  name     = "${local.product}-${var.domain}-msg-rg"
  location = var.location

  tags = var.tags
}

module "event_hub_idpay_00" {

  count = var.enable.idpay.eventhub_idpay_00 ? 1 : 0

  source                   = "git::https://github.com/pagopa/azurerm.git//eventhub?ref=ISB-124-fix-conditional-operator"
  name                     = "${local.product}-${var.domain}-evh-ns-00"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.msg_rg.name
  auto_inflate_enabled     = var.ehns_auto_inflate_enabled
  sku                      = var.ehns_sku_name
  capacity                 = var.ehns_capacity
  maximum_throughput_units = var.ehns_maximum_throughput_units
  zone_redundant           = var.ehns_zone_redundant

  virtual_network_ids = [data.azurerm_virtual_network.vnet_integration.id, data.azurerm_virtual_network.vnet.id]
  subnet_id           = data.azurerm_subnet.eventhub_snet.id

  eventhubs = var.eventhubs_idpay_00

  private_dns_zones = {
    id   = [data.azurerm_private_dns_zone.ehub.id]
    name = [data.azurerm_private_dns_zone.ehub.name]
  }
  private_dns_zone_record_A_name  = "eventhubidpay00"
  private_dns_zone_resource_group = "${local.product}-msg-rg"

  alerts_enabled = var.ehns_alerts_enabled
  metric_alerts  = var.ehns_metric_alerts
  action = [
    {
      action_group_id    = local.monitor_action_group_email_name
      webhook_properties = null
    },
    {
      action_group_id    = local.monitor_action_group_email_name
      webhook_properties = null
    }
  ]

  tags = var.tags
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "event_hub_keys_idpay_00" {
  for_each = module.event_hub_idpay_00[0].key_ids

  name         = format("evh-%s-%s-idpay-00", replace(each.key, ".", "-"), "jaas-config")
  value        = format(local.jaas_config_template_idpay, module.event_hub_idpay_00[0].keys[each.key].primary_connection_string)
  content_type = "text/plain"

  key_vault_id = module.key_vault_idpay.id
}

module "event_hub_idpay_01" {

  count = var.enable.idpay.eventhub_idpay_00 ? 1 : 0

  source                   = "git::https://github.com/pagopa/azurerm.git//eventhub?ref=ISB-124-fix-conditional-operator"
  name                     = "${local.product}-${var.domain}-evh-ns-01"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.msg_rg.name
  auto_inflate_enabled     = var.ehns_auto_inflate_enabled
  sku                      = var.ehns_sku_name
  capacity                 = var.ehns_capacity
  maximum_throughput_units = var.ehns_maximum_throughput_units
  zone_redundant           = var.ehns_zone_redundant

  virtual_network_ids = [data.azurerm_virtual_network.vnet_integration.id, data.azurerm_virtual_network.vnet.id]
  subnet_id           = data.azurerm_subnet.eventhub_snet.id

  eventhubs = var.eventhubs_idpay_01

  private_dns_zones = {
    id   = [data.azurerm_private_dns_zone.ehub.id]
    name = [data.azurerm_private_dns_zone.ehub.name]
  }
  private_dns_zone_record_A_name  = "eventhubidpay01"
  private_dns_zone_resource_group = "${local.product}-msg-rg"

  alerts_enabled = var.ehns_alerts_enabled
  metric_alerts  = var.ehns_metric_alerts
  action = [
    {
      action_group_id    = local.monitor_action_group_email_name
      webhook_properties = null
    },
    {
      action_group_id    = local.monitor_action_group_email_name
      webhook_properties = null
    }
  ]

  tags = var.tags
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "event_hub_keys_idpay_01" {
  for_each = module.event_hub_idpay_01[0].key_ids

  name         = format("evh-%s-%s-idpay-01", replace(each.key, ".", "-"), "jaas-config")
  value        = format(local.jaas_config_template_idpay, module.event_hub_idpay_01[0].keys[each.key].primary_connection_string)
  content_type = "text/plain"

  key_vault_id = module.key_vault_idpay.id
}

data "azurerm_eventhub_authorization_rule" "core_event_hub_keys" {
  for_each = {
    for index, key in local.core_event_hub.keys :
    key.name => key
  }

  name                = each.value.name
  namespace_name      = local.core.event_hub.namespace_name
  eventhub_name       = each.value.eventhub_name
  resource_group_name = local.core.event_hub.resource_group_name
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "core_event_hub_keys" {
  for_each = {
    for index, key in data.azurerm_eventhub_authorization_rule.core_event_hub_keys :
    key.name => key
  }

  name         = "evh-${each.value.eventhub_name}-${each.key}-jaas-config"
  value        = format(local.jaas_config_template_idpay, each.value.primary_connection_string)
  content_type = "text/plain"

  key_vault_id = module.key_vault_idpay.id
}