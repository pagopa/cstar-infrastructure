#Security certificate for signing JWT
resource "azurerm_key_vault_certificate" "idpay_merchants_jwt_signing_cert" {
  name         = "${local.project}-${var.domain}-merchants-jwt-signing-cert"
  key_vault_id = data.azurerm_key_vault.kv.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.2"]
      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject            = "CN=${local.project}-${var.domain}-merchants-jwt-signing-cert"
      validity_in_months = 12
    }
  }
}

resource "azurerm_api_management_certificate" "idpay_merchants_token_exchange_cert_jwt" {
  name                = "${local.project}-${var.domain}-merchants-token-exchange-jwt"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  key_vault_secret_id = azurerm_key_vault_certificate.idpay_merchants_jwt_signing_cert.versionless_secret_id
}

resource "azurerm_api_management_api" "idpay_merchants_token_exchange" {
  name                = "${var.env_short}-idpay-token-exchange-merchants"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  revision              = "1"
  display_name          = "IDPAY Token Exchange for Merchants Portal"
  path                  = "idpay/merchant/token"
  subscription_required = false
  #service_url           = ""
  protocols = ["https"]

}

resource "azurerm_api_management_api_operation" "idpay_merchants_token_exchange" {
  operation_id        = "idpay-token-exchange-merchants"
  api_name            = azurerm_api_management_api.idpay_merchants_token_exchange.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Token Exchange for Merchants Portal"
  method              = "POST"
  url_template        = "/"
  description         = "Endpoint for selfcare token exchange towards merchants portal"
}

resource "azurerm_api_management_api_operation_policy" "idpay_merchants_token_exchange_policy" {
  api_name            = azurerm_api_management_api_operation.idpay_merchants_token_exchange.api_name
  api_management_name = azurerm_api_management_api_operation.idpay_merchants_token_exchange.api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_merchants_token_exchange.resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_merchants_token_exchange.operation_id

  xml_content = templatefile("./api/idpay_token_exchange/jwt_exchange_merchants.xml.tpl", {
    openid-config-url           = local.idpay-oidc-config_url,
    selfcare-issuer             = local.selfcare-issuer,
    jwt_cert_signing_thumbprint = azurerm_api_management_certificate.idpay_merchants_token_exchange_cert_jwt.thumbprint,
    idpay-portal-hostname       = local.idpay-portal-hostname,
    origins                     = local.origins.base
  })

  depends_on = [azapi_resource.apim-merchant-id-retriever]

}
