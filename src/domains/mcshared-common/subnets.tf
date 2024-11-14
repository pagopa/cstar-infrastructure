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

# ------------------------------------------------------------------------------
# Private endpoints subnet.
# ------------------------------------------------------------------------------
variable "core_private_endpoints_subnet_name" {
  type    = string
  default = "private-endpoint-snet"
}

data "azurerm_subnet" "private_endpoints" {
  name                 = var.core_private_endpoints_subnet_name
  virtual_network_name = var.core_virtual_network_name
  resource_group_name  = var.core_virtual_network_resource_group_name
}