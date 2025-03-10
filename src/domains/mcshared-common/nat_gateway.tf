resource "azurerm_nat_gateway" "mc_nat_gateway" {
  name                = "${local.project}-mc-natgw"
  location            = var.location
  resource_group_name = data.azurerm_virtual_network.vnet_core_weu.resource_group_name
  sku_name            = "Standard"

  idle_timeout_in_minutes = 4

  tags = local.tags
}

resource "azurerm_nat_gateway_public_ip_association" "mc_nat_gateway_public_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.mc_nat_gateway.id
  public_ip_address_id = data.azurerm_public_ip.mc_public_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "mc_nat_gateway_subnet_association" {
  subnet_id      = azurerm_subnet.subnet_mcshared_cae.id
  nat_gateway_id = azurerm_nat_gateway.mc_nat_gateway.id
}
