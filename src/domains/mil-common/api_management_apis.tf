# ------------------------------------------------------------------------------
# API definition of auth microservice.
# ------------------------------------------------------------------------------
variable "auth_openapi_descriptor" {
  type = string
}

variable "auth_path" {
  type    = string
  default = "auth"
}

resource "azurerm_api_management_api" "auth" {
  name                = "${local.project}-auth"
  resource_group_name = data.azurerm_api_management.core.resource_group_name
  api_management_name = data.azurerm_api_management.core.name
  revision            = "1"
  display_name        = "McShared Auth"
  description         = "Authorization Microservice"
  path                = var.auth_path
  protocols           = ["https"]
  service_url         = "https://${local.project}-auth-ca.${azurerm_private_dns_zone.aca.name}"

  subscription_required = false

  import {
    content_format = "openapi-link"
    content_value  = var.auth_openapi_descriptor
  }
}

resource "azurerm_api_management_product_api" "auth" {
  product_id          = azurerm_api_management_product.mcshared.product_id
  api_name            = azurerm_api_management_api.auth.name
  api_management_name = data.azurerm_api_management.core.name
  resource_group_name = data.azurerm_api_management.core.resource_group_name
}