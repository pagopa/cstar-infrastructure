locals {
  jaas_config_template              = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"%s\";"
  event_hub_rtd_enable_private_link = var.eventhub_sku_name != "Basic" ? 1 : 0
  # no private endpoint on basic sku
  event_hub_rtd_vnets = local.event_hub_rtd_enable_private_link > 0 ? [
    data.azurerm_virtual_network.vnet_integration.id,
    data.azurerm_virtual_network.vnet.id
  ] : []
}

resource "azurerm_resource_group" "msg_rg" {
  name     = "${local.product}-${var.domain}-msg-rg"
  location = var.location

  tags = var.tags
}

resource "azurerm_eventhub_namespace" "event_hub_rtd" {
  name                     = "${local.product}-${var.domain}-evh-ns"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.msg_rg.name
  sku                      = var.eventhub_sku_name
  capacity                 = var.eventhub_capacity
  maximum_throughput_units = var.eventhub_maximum_throughput_units
  zone_redundant           = var.eventhub_zone_redundant
  # no network rulesets set

  tags = var.tags
}

## Create Virtual network configurations
resource "azurerm_private_dns_zone_virtual_network_link" "event_hub_rtd" {
  count = length(local.event_hub_rtd_vnets)

  name = format(
    "%s-private-dns-zone-link-%02d",
    azurerm_eventhub_namespace.event_hub_rtd.name,
    count.index + 1
  )
  resource_group_name   = azurerm_resource_group.msg_rg.name
  private_dns_zone_name = data.azurerm_private_dns_zone.eventhub_private_dns.name
  virtual_network_id    = local.event_hub_rtd_vnets[count.index]

  tags = var.tags
}

## Create private endpoints and dns A record for them
resource "azurerm_private_endpoint" "event_hub_rtd" {
  count = local.event_hub_rtd_enable_private_link

  name                = format("%s-private-endpoint", azurerm_eventhub_namespace.event_hub_rtd.name)
  location            = var.location
  resource_group_name = azurerm_resource_group.msg_rg.name
  subnet_id           = data.azurerm_subnet.eventhub_snet.id

  private_service_connection {
    name = format(
      "%s-private-service-connection",
      azurerm_eventhub_namespace.event_hub_rtd.name
    )
    private_connection_resource_id = azurerm_eventhub_namespace.event_hub_rtd.id
    is_manual_connection           = false
    subresource_names              = ["namespace"]
  }

  private_dns_zone_group {
    name                 = format("%s-private-dns-zone-group", azurerm_eventhub_namespace.event_hub_rtd.name)
    private_dns_zone_ids = concat([], data.azurerm_private_dns_zone.eventhub_private_dns.*.id)
  }
}

resource "azurerm_private_dns_a_record" "private_dns_a_record_event_hub_rtd" {
  count = local.event_hub_rtd_enable_private_link

  name                = "eventhubrtd"
  zone_name           = data.azurerm_private_dns_zone.eventhub_private_dns.name
  resource_group_name = "${local.product}-msg-rg"
  ttl                 = 300
  records             = azurerm_private_endpoint.event_hub_rtd[0].private_service_connection.*.private_ip_address
}
