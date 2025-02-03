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

variable "get_access_token_rate_limit" {
  type = object({
    calls  = number
    period = number
  })
  default = {
    calls  = 10
    period = 60
  }
}

variable "get_jwks_rate_limit" {
  type = object({
    calls  = number
    period = number
  })
  default = {
    calls  = 100
    period = 60
  }
}

variable "get_open_id_conf_rate_limit" {
  type = object({
    calls  = number
    period = number
  })
  default = {
    calls  = 100
    period = 60
  }
}

variable "introspect_rate_limit" {
  type = object({
    calls  = number
    period = number
  })
  default = {
    calls  = 10
    period = 60
  }
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

resource "azurerm_api_management_api_operation_policy" "get_access_token" {
  api_name            = azurerm_api_management_api.auth.name
  api_management_name = data.azurerm_api_management.core.name
  resource_group_name = data.azurerm_api_management.core.resource_group_name
  operation_id        = "getAccessToken"
  xml_content = templatefile(
    var.env_short == "d" ? "policies/getAccessToken-dev.xml" : "policies/getAccessToken.xml", {
    calls        = var.get_access_token_rate_limit.calls,
    period       = var.get_access_token_rate_limit.period
  })
}

resource "azurerm_api_management_api_operation_policy" "get_jwks" {
  api_name            = azurerm_api_management_api.auth.name
  api_management_name = data.azurerm_api_management.core.name
  resource_group_name = data.azurerm_api_management.core.resource_group_name
  operation_id        = "getJwks"
  xml_content = templatefile("policies/getJwks.xml", {
    calls  = var.get_jwks_rate_limit.calls,
    period = var.get_jwks_rate_limit.period
  })
}

resource "azurerm_api_management_api_operation_policy" "get_open_id_conf" {
  api_name            = azurerm_api_management_api.auth.name
  api_management_name = data.azurerm_api_management.core.name
  resource_group_name = data.azurerm_api_management.core.resource_group_name
  operation_id        = "getOpenIdConf"
  xml_content = templatefile("policies/getOpenIdConf.xml", {
    calls  = var.get_open_id_conf_rate_limit.calls,
    period = var.get_open_id_conf_rate_limit.period
  })
}

resource "azurerm_api_management_api_operation_policy" "introspect" {
  api_name            = azurerm_api_management_api.auth.name
  api_management_name = data.azurerm_api_management.core.name
  resource_group_name = data.azurerm_api_management.core.resource_group_name
  operation_id        = "introspect"
  xml_content = templatefile("policies/introspect.xml", {
    calls  = var.introspect_rate_limit.calls,
    period = var.introspect_rate_limit.period
  })
}