# ------------------------------------------------------------------------------
# Product.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_product" "mil" {
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  product_id   = "mil"
  display_name = "MIL Multi-channel Integration Layer"
  description  = "MIL Multi-channel Integration Layer"

  subscription_required = false
  published             = true
}

resource "azurerm_api_management_product_policy" "mil_api_product" {

  product_id          = azurerm_api_management_product.mil.product_id
  api_management_name = azurerm_api_management_product.mil.api_management_name
  resource_group_name = azurerm_api_management_product.mil.resource_group_name

  xml_content = file("./api_product/mil/policy.xml")
}


# ------------------------------------------------------------------------------
# API definition mil-papos.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_api" "papos" {
  name                  = "${local.project}-papos"
  resource_group_name   = data.azurerm_resource_group.apim_rg.name
  api_management_name   = data.azurerm_api_management.apim_core.name
  revision              = "1"
  display_name          = "MIL PAPOS API"
  description           = "PA POS Microservice for MIL Multi-channel Integration Layer of SW Client Project"
  path                  = var.mil_papos_path
  protocols             = ["https"]
  service_url           = format("https://%s/%s", var.ingress_load_balancer_hostname, var.mil_papos_address)
  subscription_required = false

  import {
    content_format = "openapi"
    content_value  = templatefile("./api/mil_papos/openapi.yaml", {})
  }
}

resource "azurerm_api_management_product_api" "papos" {
  product_id          = azurerm_api_management_product.mil.product_id
  api_name            = azurerm_api_management_api.papos.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
}


# ------------------------------------------------------------------------------
# API definition mil-auth
# ------------------------------------------------------------------------------
resource "azurerm_api_management_api" "auth" {
  name                  = "${local.project}-auth"
  resource_group_name   = data.azurerm_resource_group.apim_rg.name
  api_management_name   = data.azurerm_api_management.apim_core.name
  revision              = "1"
  display_name          = "MIL AUTH API"
  description           = "Authorization Microservice for Multi-channel Integration Layer of SW Client Project"
  path                  = var.mil_auth_path
  protocols             = ["https"]
  service_url           = format("https://%s/%s", var.ingress_load_balancer_hostname, var.mil_auth_address)
  subscription_required = false

  import {
    content_format = "openapi-link"
    content_value  = var.mil_auth_openapi_descriptor
  }
}

resource "azurerm_api_management_product_api" "auth" {
  product_id          = azurerm_api_management_product.mil.product_id
  api_name            = azurerm_api_management_api.auth.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
}

# ------------------------------------------------------------------------------
# API diagnostic mil-papos
# ------------------------------------------------------------------------------
resource "azurerm_api_management_api_diagnostic" "papos" {
  identifier               = "applicationinsights"
  resource_group_name      = data.azurerm_resource_group.apim_rg.name
  api_management_name      = data.azurerm_api_management.apim_core.name
  api_name                 = azurerm_api_management_api.papos.name
  api_management_logger_id = local.apim_logger_id

  sampling_percentage       = 100.0
  always_log_errors         = true
  log_client_ip             = true
  verbosity                 = "verbose"
  http_correlation_protocol = "W3C"

  frontend_request {
    body_bytes = 8192
    headers_to_log = [
      "RequestId",
      "Version",
      "AcquirerId",
      "MerchantId",
      "Channel",
      "TerminalId"
    ]
  }

  frontend_response {
    body_bytes = 8192
    headers_to_log = [
      "Location"
    ]
  }

  backend_request {
    body_bytes = 8192
    headers_to_log = [
      "RequestId",
      "Version",
      "AcquirerId",
      "MerchantId",
      "Channel",
      "TerminalId"
    ]
  }

  backend_response {
    body_bytes = 8192
    headers_to_log = [
      "Location"
    ]
  }
}

# ------------------------------------------------------------------------------
# API diagnostic mil-auth
# ------------------------------------------------------------------------------
resource "azurerm_api_management_api_diagnostic" "auth" {
  identifier                = "applicationinsights"
  resource_group_name       = data.azurerm_resource_group.apim_rg.name
  api_management_name       = data.azurerm_api_management.apim_core.name
  api_name                  = azurerm_api_management_api.auth.name
  api_management_logger_id  = local.apim_logger_id
  sampling_percentage       = 100.0
  always_log_errors         = true
  log_client_ip             = true
  verbosity                 = "verbose"
  http_correlation_protocol = "W3C"

  frontend_request {
    body_bytes = 8192
    headers_to_log = [
      "RequestId",
      "Version",
      "AcquirerId",
      "MerchantId",
      "Channel",
      "TerminalId"
    ]
  }

  frontend_response {
    body_bytes = 8192
    headers_to_log = [
      "CorrelationId",
      "Cache-Control"
    ]
  }

  backend_request {
    body_bytes = 8192
    headers_to_log = [
      "RequestId",
      "Version",
      "AcquirerId",
      "MerchantId",
      "Channel",
      "TerminalId"
    ]
  }

  backend_response {
    body_bytes = 8192
    headers_to_log = [
      "CorrelationId",
      "Cache-Control"
    ]
  }
}
