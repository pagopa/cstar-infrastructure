# ------------------------------------------------------------------------------
# ACA Environment.
# ------------------------------------------------------------------------------
variable "mcshared_cae_name" {
  type    = string
}

variable "mcshared_cae_resource_group_name" {
  type    = string
}

data "azurerm_container_app_environment" "mil" {
  name                = var.mcshared_cae_name
  resource_group_name = var.mcshared_cae_resource_group_name
}