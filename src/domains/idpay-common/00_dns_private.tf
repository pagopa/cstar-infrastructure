data "azurerm_private_dns_zone" "ehub" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = "${local.product}-msg-rg"
}