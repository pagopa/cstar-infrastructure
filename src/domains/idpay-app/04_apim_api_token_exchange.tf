#
# IDPAY API for token exchange
#

locals {
  idpay_cdn_storage_account_name = replace(format("%s-%s-sa", local.project, "idpaycdn"), "-", "") #"cstardweuidpayidpaycdnsa"
  idpay-portal-hostname          = "welfare.${data.azurerm_dns_zone.public.name}"
  idpay-oidc-config_url          = "https://${local.idpay-portal-hostname}/selfcare/openid-configuration.json"
  selfcare-issuer                = "https://${var.env != "prod" ? "${var.env}." : ""}selfcare.pagopa.it"
}

## Upload file for oidc configuration
resource "local_file" "oidc_configuration_file" {
  filename = "./.terraform/tmp/openid-configuration.json"

  content = templatefile("./api/idpay_token_exchange/openid-configuration.json.tpl", {
    selfcare-issuer = local.selfcare-issuer
  })

}

resource "null_resource" "upload_oidc_configuration" {
  triggers = {
    "changes-in-config" : filemd5("./api/idpay_token_exchange/openid-configuration.json.tpl")
    "changes-in-issuer" : local.selfcare-issuer,
    "changes-in-position" : local.idpay-oidc-config_url
  }

  provisioner "local-exec" {
    command = <<EOT
              result=$(az storage azcopy blob upload --container '$web' --account-name ${replace(format("%s-%s-sa", local.project, "idpaycdn"), "-", "")} --source ${local_file.oidc_configuration_file.filename} --account-key ${data.azurerm_key_vault_secret.cdn_storage_access_secret.value} --destination "selfcare/openid-configuration.json")
              echo $result | grep "Final Job Status: Completed"
          EOT
  }
}

data "azurerm_key_vault_secret" "cdn_storage_access_secret" {
  name         = "web-storage-access-key"
  key_vault_id = data.azurerm_key_vault.kv.id
}

#Security certificate for signing JWT
resource "azurerm_key_vault_certificate" "idpay_jwt_signing_cert" {
  name         = "${local.project}-${var.domain}-jwt-signing-cert"
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

      subject            = "CN=${local.project}-${var.domain}-jwt-signing-cert"
      validity_in_months = 12
    }
  }
}

resource "azurerm_api_management_certificate" "idpay_token_exchange_cert_jwt" {
  name                = "${local.project}-${var.domain}-token-exchange-jwt"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  key_vault_secret_id = azurerm_key_vault_certificate.idpay_jwt_signing_cert.versionless_secret_id
}

resource "azurerm_api_management_api" "idpay_token_exchange" {
  name                = "${var.env_short}-idpay-token-exchange"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  revision              = "1"
  display_name          = "IDPAY Token Exchange"
  path                  = "idpay/welfare"
  subscription_required = false
  #service_url           = ""
  protocols = ["https"]

}

resource "azurerm_api_management_api_operation" "idpay_token_exchange" {
  operation_id        = "idpay-token-exchange"
  api_name            = azurerm_api_management_api.idpay_token_exchange.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Token Exchange"
  method              = "POST"
  url_template        = "/token"
  description         = "Endpoint for selfcare token exchange"
}

resource "azurerm_api_management_api_operation_policy" "idpay_token_exchange_policy" {
  depends_on = [null_resource.upload_oidc_configuration]

  api_name            = azurerm_api_management_api_operation.idpay_token_exchange.api_name
  api_management_name = azurerm_api_management_api_operation.idpay_token_exchange.api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_token_exchange.resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_token_exchange.operation_id

  xml_content = templatefile("./api/idpay_token_exchange/jwt_exchange.xml.tpl", {
    openid-config-url           = local.idpay-oidc-config_url,
    selfcare-issuer             = local.selfcare-issuer,
    jwt_cert_signing_thumbprint = azurerm_api_management_certificate.idpay_token_exchange_cert_jwt.thumbprint,
    idpay-portal-hostname       = local.idpay-portal-hostname,
    origins                     = local.origins.base
  })

}

##TEST API used for automated test
resource "azurerm_api_management_api_operation" "idpay_token_exchange_test" {
  count               = var.env_short != "p" ? 1 : 0
  operation_id        = "idpay_token_exchange_test"
  api_name            = azurerm_api_management_api.idpay_token_exchange.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Token Exchange Test"
  method              = "POST"
  url_template        = "/token/test"
  description         = "Endpoint for selfcare token exchange test"
}

resource "azurerm_api_management_api_operation_policy" "idpay_token_exchange_policy_test" {
  count               = var.env_short != "p" ? 1 : 0
  api_name            = azurerm_api_management_api_operation.idpay_token_exchange_test[0].api_name
  api_management_name = azurerm_api_management_api_operation.idpay_token_exchange_test[0].api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_token_exchange_test[0].resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_token_exchange_test[0].operation_id

  xml_content = templatefile("./api/idpay_token_exchange/jwt_token_test.xml.tpl", {
    ingress_load_balancer_hostname = var.ingress_load_balancer_hostname,
    jwt_cert_signing_thumbprint    = azurerm_api_management_certificate.idpay_token_exchange_cert_jwt.thumbprint
  })

}
