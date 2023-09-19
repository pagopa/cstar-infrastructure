## Event hub private dns zone
data "azurerm_private_dns_zone" "eventhub_private_dns" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = data.azurerm_virtual_network.vnet_core.resource_group_name
}
