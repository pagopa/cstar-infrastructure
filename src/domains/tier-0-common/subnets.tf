# ------------------------------------------------------------------------------
# Subnet for ACA.
# ------------------------------------------------------------------------------
variable "aca_snet_cidr" {
  type = string
}

resource "azurerm_subnet" "aca" {
  name                 = "${local.project}-aca-snet"
  resource_group_name  = data.azurerm_virtual_network.intern.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.intern.name
  address_prefixes     = [var.aca_snet_cidr]
}