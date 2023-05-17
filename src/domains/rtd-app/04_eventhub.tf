locals {
  jaas_template = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"%s\";"
}

data "azurerm_resource_group" "msg_rg" {
  name = "${local.product}-${var.domain}-msg-rg"
}

data "azurerm_eventhub_namespace" "event_hub_rtd" {
  name                = "${local.product}-${var.domain}-evh-ns"
  resource_group_name = data.azurerm_resource_group.msg_rg.name
}

#
# Eventhub queues for rtd namespace
#
resource "azurerm_eventhub" "event_hub_rtd_hub" {
  count               = length(var.event_hub_hubs)
  name                = var.event_hub_hubs[count.index].name
  partition_count     = var.event_hub_hubs[count.index].partitions
  message_retention   = var.event_hub_hubs[count.index].retention
  namespace_name      = data.azurerm_eventhub_namespace.event_hub_rtd.name
  resource_group_name = data.azurerm_resource_group.msg_rg.name
}

#
# Eventhub consumer groups
#
resource "azurerm_eventhub_consumer_group" "event_hub_rtd_consumer_group" {
  for_each = merge([for hub in var.event_hub_hubs : { for consumer in hub.consumers : hub.name => consumer }]...)

  eventhub_name       = each.key
  name                = each.value
  namespace_name      = data.azurerm_eventhub_namespace.event_hub_rtd.name
  resource_group_name = data.azurerm_resource_group.msg_rg.name
  depends_on          = [azurerm_eventhub.event_hub_rtd_hub]
}

resource "azurerm_eventhub_authorization_rule" "event_hub_rtd_policy" {
  for_each = merge([for hub in var.event_hub_hubs : { for policy in hub.policies : policy.name => { hub_name = hub.name, policy = policy } }]...)

  name                = each.value.policy.name
  eventhub_name       = each.value.hub_name
  namespace_name      = data.azurerm_eventhub_namespace.event_hub_rtd.name
  resource_group_name = data.azurerm_resource_group.msg_rg.name
  listen              = each.value.policy.listen
  send                = each.value.policy.send
  manage              = each.value.policy.manage
  depends_on          = [azurerm_eventhub.event_hub_rtd_hub]
}

# Copy connection string to kv
resource "azurerm_key_vault_secret" "event_hub_rtd_jaas_connection_string" {
  for_each = merge([for hub in var.event_hub_hubs : { for policy in hub.policies : policy.name => { hub_name = hub.name, policy = policy } }]...)
  name     = format("evh-%s-rtd", "${each.value.hub_name}-${each.key}")
  value = format(
    local.jaas_template,
    azurerm_eventhub_authorization_rule.event_hub_rtd_policy[each.key].primary_connection_string
  )
  content_type = "text/plain"
  key_vault_id = data.azurerm_key_vault.kv.id
}
