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

variable "get_access_token_allowed_origins" {
  type = list(string)
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
  count = var.disable_expose_mil_auth ? 0 : 1

  name                = "${local.project}-auth"
  resource_group_name = data.azurerm_api_management.core.resource_group_name
  api_management_name = data.azurerm_api_management.core.name
  revision            = "1"
  display_name        = "McShared Auth"
  description         = "Authorization Microservice"
  path                = var.auth_path
  protocols           = ["https"]
  service_url         = "https://${local.project}-auth-ca.${azurerm_container_app_environment.mcshared.default_domain}"

  subscription_required = false

  import {
    content_format = "openapi-link"
    content_value  = var.auth_openapi_descriptor
  }

  depends_on = [
    azurerm_container_app_environment.mcshared
  ]
}

resource "azurerm_api_management_product_api" "auth" {
  count = var.disable_expose_mil_auth ? 0 : 1

  product_id          = azurerm_api_management_product.mcshared[count.index].product_id
  api_name            = azurerm_api_management_api.auth[count.index].name
  api_management_name = data.azurerm_api_management.core.name
  resource_group_name = data.azurerm_api_management.core.resource_group_name
}

# ------------------------------------------------------------------------------
# Policy fragments.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_policy_fragment" "rate_limit_by_clientid_claim" {
  count = var.disable_expose_mil_auth ? 0 : 1

  name              = "rate-limit-by-clientid-claim"
  description       = "Rate limit by client id value received as claim of the access token"
  api_management_id = data.azurerm_api_management.core.id
  format            = "rawxml"
  value             = templatefile("policies/fragments/rate-limit-by-clientid-claim.xml", {})
}

resource "azurerm_api_management_policy_fragment" "rate_limit_by_clientid_formparam" {
  count = var.disable_expose_mil_auth ? 0 : 1

  name              = "rate-limit-by-clientid-formparam"
  description       = "Rate limit by client id value received as form param"
  api_management_id = data.azurerm_api_management.core.id
  format            = "rawxml"
  value             = templatefile("policies/fragments/rate-limit-by-clientid-formparam.xml", {})
}

# ------------------------------------------------------------------------------
# Policies.
# ------------------------------------------------------------------------------
locals {
  allowed_origins = join("", formatlist("<origin>%s</origin>", var.get_access_token_allowed_origins))
}
resource "azurerm_api_management_api_operation_policy" "get_access_token" {
  count = var.disable_expose_mil_auth ? 0 : 1

  api_name            = azurerm_api_management_api.auth[count.index].name
  api_management_name = data.azurerm_api_management.core.name
  resource_group_name = data.azurerm_api_management.core.resource_group_name
  operation_id        = "getAccessTokens"
  depends_on          = [azurerm_api_management_policy_fragment.rate_limit_by_clientid_formparam]
  xml_content = templatefile("policies/getAccessToken.xml", {
    calls           = var.get_access_token_rate_limit.calls
    period          = var.get_access_token_rate_limit.period
    allowed_origins = local.allowed_origins
  })
}

resource "azurerm_api_management_api_operation_policy" "get_jwks" {
  count = var.disable_expose_mil_auth ? 0 : 1

  api_name            = azurerm_api_management_api.auth[count.index].name
  api_management_name = data.azurerm_api_management.core.name
  resource_group_name = data.azurerm_api_management.core.resource_group_name
  operation_id        = "getJwks"
  xml_content = templatefile("policies/rate-limit-and-cache.xml", {
    calls  = var.get_jwks_rate_limit.calls
    period = var.get_jwks_rate_limit.period
  })
}

resource "azurerm_api_management_api_operation_policy" "get_open_id_conf" {
  count = var.disable_expose_mil_auth ? 0 : 1

  api_name            = azurerm_api_management_api.auth[count.index].name
  api_management_name = data.azurerm_api_management.core.name
  resource_group_name = data.azurerm_api_management.core.resource_group_name
  operation_id        = "getOpenIdConf"
  xml_content = templatefile("policies/rate-limit-and-cache.xml", {
    calls  = var.get_open_id_conf_rate_limit.calls
    period = var.get_open_id_conf_rate_limit.period
  })
}

resource "azurerm_api_management_api_operation_policy" "introspect" {
  count = var.disable_expose_mil_auth ? 0 : 1

  api_name            = azurerm_api_management_api.auth[count.index].name
  api_management_name = data.azurerm_api_management.core.name
  resource_group_name = data.azurerm_api_management.core.resource_group_name
  operation_id        = "introspect"
  depends_on          = [azurerm_api_management_policy_fragment.rate_limit_by_clientid_claim]
  xml_content = templatefile("policies/introspect.xml", {
    calls  = var.introspect_rate_limit.calls
    period = var.introspect_rate_limit.period
  })
}
