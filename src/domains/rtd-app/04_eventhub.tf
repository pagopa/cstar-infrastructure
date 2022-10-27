data "azurerm_resource_group" "msg_rg" {
  name = "${local.product}-${var.domain}-msg-rg"
}

data "azurerm_eventhub_namespace" "event_hub_rtd" {
  name                = "${local.product}-${var.domain}-evh-ns"
  resource_group_name = data.azurerm_resource_group.msg_rg.name
}

#
# Eventhub rtd-pi-to-app
#
resource "azurerm_eventhub" "event_hub_rtd_pi_to_app" {
  name                = var.event_hub_rtd_pi_to_app.name
  message_retention   = var.event_hub_rtd_pi_to_app.retention
  partition_count     = var.event_hub_rtd_pi_to_app.partitions
  namespace_name      = data.azurerm_eventhub_namespace.event_hub_rtd.name
  resource_group_name = data.azurerm_resource_group.msg_rg.name
}

resource "azurerm_eventhub_consumer_group" "event_hub_rtd_pi_to_app_consumer" {
  count               = length(var.event_hub_rtd_pi_to_app.consumers)
  name                = var.event_hub_rtd_pi_to_app.consumers[count.index]
  eventhub_name       = azurerm_eventhub.event_hub_rtd_pi_to_app.name
  namespace_name      = data.azurerm_eventhub_namespace.event_hub_rtd.name
  resource_group_name = data.azurerm_resource_group.msg_rg.name
  depends_on          = [azurerm_eventhub.event_hub_rtd_pi_to_app]
}

resource "azurerm_eventhub_authorization_rule" "event_hub_rtd_pi_to_app_policy" {
  count               = length(var.event_hub_rtd_pi_to_app.policies)
  name                = var.event_hub_rtd_pi_to_app.policies[count.index].name
  eventhub_name       = azurerm_eventhub.event_hub_rtd_pi_to_app.name
  namespace_name      = data.azurerm_eventhub_namespace.event_hub_rtd.name
  resource_group_name = data.azurerm_resource_group.msg_rg.name
  listen              = var.event_hub_rtd_pi_to_app.policies[count.index].listen
  send                = var.event_hub_rtd_pi_to_app.policies[count.index].send
  manage              = var.event_hub_rtd_pi_to_app.policies[count.index].manage
  depends_on          = [azurerm_eventhub.event_hub_rtd_pi_to_app]
}


#
# Eventhub rtd-pi-from-app
#
resource "azurerm_eventhub" "event_hub_rtd_pi_from_app" {
  name                = var.event_hub_rtd_pi_from_app.name
  message_retention   = var.event_hub_rtd_pi_from_app.retention
  partition_count     = var.event_hub_rtd_pi_from_app.partitions
  namespace_name      = data.azurerm_eventhub_namespace.event_hub_rtd.name
  resource_group_name = data.azurerm_resource_group.msg_rg.name
}

resource "azurerm_eventhub_consumer_group" "event_hub_rtd_pi_from_app_consumer" {
  count               = length(var.event_hub_rtd_pi_from_app.consumers)
  name                = var.event_hub_rtd_pi_from_app.consumers[count.index]
  eventhub_name       = azurerm_eventhub.event_hub_rtd_pi_from_app.name
  namespace_name      = data.azurerm_eventhub_namespace.event_hub_rtd.name
  resource_group_name = data.azurerm_resource_group.msg_rg.name
  depends_on          = [azurerm_eventhub.event_hub_rtd_pi_from_app]
}

resource "azurerm_eventhub_authorization_rule" "event_hub_rtd_pi_from_app_policy" {
  count               = length(var.event_hub_rtd_pi_from_app.policies)
  name                = var.event_hub_rtd_pi_from_app.policies[count.index].name
  eventhub_name       = azurerm_eventhub.event_hub_rtd_pi_from_app.name
  namespace_name      = data.azurerm_eventhub_namespace.event_hub_rtd.name
  resource_group_name = data.azurerm_resource_group.msg_rg.name
  listen              = var.event_hub_rtd_pi_from_app.policies[count.index].listen
  send                = var.event_hub_rtd_pi_from_app.policies[count.index].send
  manage              = var.event_hub_rtd_pi_from_app.policies[count.index].manage
  depends_on          = [azurerm_eventhub.event_hub_rtd_pi_from_app]
}

#
# Eventhub rtd-split-by-pi
#
resource "azurerm_eventhub" "event_hub_rtd_split_by_pi" {
  name                = var.event_hub_rtd_split_by_pi.name
  message_retention   = var.event_hub_rtd_split_by_pi.retention
  partition_count     = var.event_hub_rtd_split_by_pi.partitions
  namespace_name      = data.azurerm_eventhub_namespace.event_hub_rtd.name
  resource_group_name = data.azurerm_resource_group.msg_rg.name
}

resource "azurerm_eventhub_consumer_group" "event_hub_rtd_split_by_pi_consumer" {
  count               = length(var.event_hub_rtd_split_by_pi.consumers)
  name                = var.event_hub_rtd_split_by_pi.consumers[count.index]
  eventhub_name       = azurerm_eventhub.event_hub_rtd_split_by_pi.name
  namespace_name      = data.azurerm_eventhub_namespace.event_hub_rtd.name
  resource_group_name = data.azurerm_resource_group.msg_rg.name
  depends_on          = [azurerm_eventhub.event_hub_rtd_split_by_pi]
}

resource "azurerm_eventhub_authorization_rule" "event_hub_rtd_split_by_pi_policy" {
  count               = length(var.event_hub_rtd_split_by_pi.policies)
  name                = var.event_hub_rtd_split_by_pi.policies[count.index].name
  eventhub_name       = azurerm_eventhub.event_hub_rtd_split_by_pi.name
  namespace_name      = data.azurerm_eventhub_namespace.event_hub_rtd.name
  resource_group_name = data.azurerm_resource_group.msg_rg.name
  listen              = var.event_hub_rtd_split_by_pi.policies[count.index].listen
  send                = var.event_hub_rtd_split_by_pi.policies[count.index].send
  manage              = var.event_hub_rtd_split_by_pi.policies[count.index].manage
  depends_on          = [azurerm_eventhub.event_hub_rtd_split_by_pi]
}
