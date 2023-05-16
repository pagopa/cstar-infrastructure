resource "azurerm_resource_group" "msg_rg" {
  name     = "${local.product}-${var.domain}-msg-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_eventhub_namespace" "event_hub_rtd_namespace" {
  name                     = "${local.product}-${var.domain}-evh-ns"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.msg_rg.name
  sku                      = var.eventhub_rtd_namespace.sku
  capacity                 = var.eventhub_rtd_namespace.capacity
  maximum_throughput_units = var.eventhub_rtd_namespace.maximum_throughput_units
  zone_redundant           = var.eventhub_rtd_namespace.zone_redundant
  auto_inflate_enabled     = var.eventhub_rtd_namespace.auto_inflate_enabled

  network_rulesets {
    default_action = "Deny"
    # list of subnet where eventhub is reachable
    virtual_network_rule {
      subnet_id = data.azurerm_subnet.eventhub_snet.id
    }
    virtual_network_rule {
      subnet_id = data.azurerm_subnet.aks_domain_subnet.id
    }
    virtual_network_rule {
      subnet_id = data.azurerm_subnet.aks_old_subnet.id
    }
    virtual_network_rule {
      subnet_id = data.azurerm_subnet.private_endpoint_snet.id
    }
    trusted_service_access_enabled = true
  }

  tags = var.tags
}

## Create private endpoint and dns A record for it
resource "azurerm_private_endpoint" "event_hub_rtd_namespace" {
  name                = format("%s-private-endpoint", azurerm_eventhub_namespace.event_hub_rtd_namespace.name)
  location            = var.location
  resource_group_name = azurerm_resource_group.msg_rg.name
  subnet_id           = data.azurerm_subnet.eventhub_snet.id

  private_service_connection {
    name = format(
      "%s-private-service-connection",
      azurerm_eventhub_namespace.event_hub_rtd_namespace.name
    )
    private_connection_resource_id = azurerm_eventhub_namespace.event_hub_rtd_namespace.id
    is_manual_connection           = false
    subresource_names              = ["namespace"]
  }

  private_dns_zone_group {
    name                 = format("%s-private-dns-zone-group", azurerm_eventhub_namespace.event_hub_rtd_namespace.name)
    private_dns_zone_ids = concat([], data.azurerm_private_dns_zone.eventhub_private_dns.*.id)
  }
}

## Private endpoint to cstar-d-vnet to enable access from VPN
resource "azurerm_private_endpoint" "evh-cstar-vnet-private-endpoint" {
  # disabled in PROD
  count               = var.env_short == "p" ? 0 : 1
  name                = format("%s-evh-private-endpoint", local.project)
  location            = var.location
  resource_group_name = local.vnet_core_resource_group_name
  subnet_id           = data.azurerm_subnet.private_endpoint_snet.id

  private_dns_zone_group {
    name                 = data.azurerm_private_dns_zone.eventhub_private_dns.name
    private_dns_zone_ids = concat([], data.azurerm_private_dns_zone.eventhub_private_dns.*.id)
  }

  private_service_connection {
    name                           = format("%s-evh-private-service-connection", local.project)
    is_manual_connection           = false
    private_connection_resource_id = azurerm_eventhub_namespace.event_hub_rtd_namespace.id
    subresource_names              = ["namespace"]
  }
}

resource "azurerm_private_dns_a_record" "private_dns_a_record_event_hub_rtd_namespace" {
  name                = "eventhubrtd"
  zone_name           = data.azurerm_private_dns_zone.eventhub_private_dns.name
  resource_group_name = "${local.product}-msg-rg"
  ttl                 = 300
  records             = azurerm_private_endpoint.event_hub_rtd_namespace.private_service_connection.*.private_ip_address
}
