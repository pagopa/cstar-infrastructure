# ------------------------------------------------------------------------------
# Virtual network which hosts AKS and ACA.
# ------------------------------------------------------------------------------
variable "core_intern_virtual_network_name" {
  type = string
}

variable "core_intern_virtual_network_resource_group_name" {
  type = string
}

data "azurerm_virtual_network" "intern" {
  name                = var.core_intern_virtual_network_name
  resource_group_name = var.core_intern_virtual_network_resource_group_name
}
