# ------------------------------------------------------------------------------
# Subnet for ACA.
# ------------------------------------------------------------------------------
variable "aca_subnet_name" {
  type = string
}

variable "aca_subnet_resource_group_name" {
  type = string
}

variable "aca_virtual_network_name" {
  type = string
}

data "azurerm_subnet" "aca" {
  name                 = var.aca_subnet_name
  resource_group_name  = var.aca_subnet_resource_group_name
  virtual_network_name = var.aca_virtual_network_name
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