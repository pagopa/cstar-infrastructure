## Event hub private dns zone
data "azurerm_private_dns_zone" "eventhub_private_dns" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = "${local.product}-msg-rg"
}
