data "azurerm_private_dns_zone" "ehub" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = data.azurerm_virtual_network.vnet_core.resource_group_name
}

data "azurerm_private_dns_zone" "redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = "${local.product}-vnet-rg"
}
