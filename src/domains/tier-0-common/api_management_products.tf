# ------------------------------------------------------------------------------
# APIM.
# ------------------------------------------------------------------------------
variable "core_apim_name" {
  type = string
}

variable "core_apim_resource_group_name" {
  type = string
}

data "azurerm_api_management" "core" {
  name                = var.core_apim_name
  resource_group_name = var.core_apim_resource_group_name
}

# ------------------------------------------------------------------------------
# Product.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_product" "tier0" {
  resource_group_name   = data.azurerm_api_management.core.resource_group_name
  product_id            = "tier-0"
  api_management_name   = data.azurerm_api_management.core.name
  display_name          = "Tier-0"
  description           = "Common services."
  subscription_required = false
  published             = true
}