# ------------------------------------------------------------------------------
# API definition of debt-position microservice.
# ------------------------------------------------------------------------------
variable "debt_position_openapi_descriptor" {
  type = string
}

variable "debt_position_path" {
  type    = string
  default = "mil-debt-position"
}

resource "azurerm_api_management_api" "debt_position" {
  name                = "${local.project}-debt-position"
  resource_group_name = data.azurerm_api_management.core.resource_group_name
  api_management_name = data.azurerm_api_management.core.name
  revision            = "1"
  display_name        = "MIL Debt Position"
  description         = "MIL Debt Position"
  path                = var.debt_position_path
  protocols           = ["https"]
  service_url         = "https://${local.project}-debt-position-ca.${data.azurerm_private_dns_zone.aca.name}"

  subscription_required = false

  import {
    content_format = "openapi-link"
    content_value  = var.debt_position_openapi_descriptor
  }
}

resource "azurerm_api_management_product_api" "debt_position" {
  product_id          = azurerm_api_management_product.mil.product_id
  api_name            = azurerm_api_management_api.debt_position.name
  api_management_name = data.azurerm_api_management.core.name
  resource_group_name = data.azurerm_api_management.core.resource_group_name
}

# ------------------------------------------------------------------------------
# API definition of fee-calculator microservice.
# ------------------------------------------------------------------------------
variable "fee_calculator_openapi_descriptor" {
  type = string
}

variable "fee_calculator_path" {
  type    = string
  default = "mil-fee-calculator"
}

resource "azurerm_api_management_api" "fee_calculator" {
  name                = "${local.project}-fee-calculator"
  resource_group_name = data.azurerm_api_management.core.resource_group_name
  api_management_name = data.azurerm_api_management.core.name
  revision            = "1"
  display_name        = "MIL Fee Calculator"
  description         = "MIL Fee Calculator"
  path                = var.fee_calculator_path
  protocols           = ["https"]
  service_url         = "https://${local.project}-fee-calculator-ca.${data.azurerm_private_dns_zone.aca.name}"

  subscription_required = false

  import {
    content_format = "openapi-link"
    content_value  = var.fee_calculator_openapi_descriptor
  }
}

resource "azurerm_api_management_product_api" "fee_calculator" {
  product_id          = azurerm_api_management_product.mil.product_id
  api_name            = azurerm_api_management_api.fee_calculator.name
  api_management_name = data.azurerm_api_management.core.name
  resource_group_name = data.azurerm_api_management.core.resource_group_name
}

# ------------------------------------------------------------------------------
# API definition of idpay microservice.
# ------------------------------------------------------------------------------
variable "idpay_openapi_descriptor" {
  type = string
}

variable "idpay_path" {
  type    = string
  default = "mil-idpay"
}

resource "azurerm_api_management_api" "idpay" {
  name                = "${local.project}-idpay"
  resource_group_name = data.azurerm_api_management.core.resource_group_name
  api_management_name = data.azurerm_api_management.core.name
  revision            = "1"
  display_name        = "MIL IDPay"
  description         = "MIL IDPay"
  path                = var.idpay_path
  protocols           = ["https"]
  service_url         = "https://${local.project}-idpay-ca.${data.azurerm_private_dns_zone.aca.name}"

  subscription_required = false

  import {
    content_format = "openapi-link"
    content_value  = var.idpay_openapi_descriptor
  }
}

resource "azurerm_api_management_product_api" "idpay" {
  product_id          = azurerm_api_management_product.mil.product_id
  api_name            = azurerm_api_management_api.idpay.name
  api_management_name = data.azurerm_api_management.core.name
  resource_group_name = data.azurerm_api_management.core.resource_group_name
}

# ------------------------------------------------------------------------------
# API definition of pa-pos microservice.
# ------------------------------------------------------------------------------
variable "pa_pos_openapi_descriptor" {
  type = string
}

variable "pa_pos_path" {
  type    = string
  default = "mil-pa-pos"
}

resource "azurerm_api_management_api" "pa_pos" {
  name                = "${local.project}-pa-pos"
  resource_group_name = data.azurerm_api_management.core.resource_group_name
  api_management_name = data.azurerm_api_management.core.name
  revision            = "1"
  display_name        = "MIL PA POS"
  description         = "MIL PA POS"
  path                = var.pa_pos_path
  protocols           = ["https"]
  service_url         = "https://${local.project}-pa-pos-ca.${data.azurerm_private_dns_zone.aca.name}"

  subscription_required = false

  import {
    content_format = "openapi-link"
    content_value  = var.pa_pos_openapi_descriptor
  }
}

resource "azurerm_api_management_product_api" "pa_pos" {
  product_id          = azurerm_api_management_product.mil.product_id
  api_name            = azurerm_api_management_api.pa_pos.name
  api_management_name = data.azurerm_api_management.core.name
  resource_group_name = data.azurerm_api_management.core.resource_group_name
}

# ------------------------------------------------------------------------------
# API definition of payment-notice microservice.
# ------------------------------------------------------------------------------
variable "payment_notice_openapi_descriptor" {
  type = string
}

variable "payment_notice_path" {
  type    = string
  default = "mil-payment-notice"
}

resource "azurerm_api_management_api" "payment_notice" {
  name                = "${local.project}-payment-notice"
  resource_group_name = data.azurerm_api_management.core.resource_group_name
  api_management_name = data.azurerm_api_management.core.name
  revision            = "1"
  display_name        = "MIL Payment Notice"
  description         = "MIL Payment Notice"
  path                = var.payment_notice_path
  protocols           = ["https"]
  service_url         = "https://${local.project}-payment-notice-ca.${data.azurerm_private_dns_zone.aca.name}"

  subscription_required = false

  import {
    content_format = "openapi-link"
    content_value  = var.payment_notice_openapi_descriptor
  }
}

resource "azurerm_api_management_product_api" "payment_notice" {
  product_id          = azurerm_api_management_product.mil.product_id
  api_name            = azurerm_api_management_api.payment_notice.name
  api_management_name = data.azurerm_api_management.core.name
  resource_group_name = data.azurerm_api_management.core.resource_group_name
}