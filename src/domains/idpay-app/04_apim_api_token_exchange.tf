#
# IDPAY API for token exchange
#

locals {
  idpay_cdn_storage_account_name = replace(format("%s-%s-sa", local.project, "idpaycdn"), "-", "") #"cstardweuidpayidpaycdnsa"
  idpay-oidc-config_url = "https://${local.idpay_cdn_storage_account_name}.blob.core.windows.net/idpay-fe-oidc-config/openid-configuration.json"
  idpay-portal-hostname = "welfare.${data.azurerm_dns_zone.public.name}"
  selfcare-issuer = "https://${var.env != "prod"? "${var.env}." : ""}selfcare.pagopa.it"
}

# Container for oidc configuration
resource "azurerm_storage_container" "idpay_oidc_config" {
  name                  = "idpay-fe-oidc-config"
  storage_account_name  = local.idpay_cdn_storage_account_name
  container_access_type = "blob"
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
    "changes-in-config" : md5(local_file.oidc_configuration_file.content)
  }

  provisioner "local-exec" {
    command = <<EOT
              az storage azcopy blob upload --container ${azurerm_storage_container.idpay_oidc_config.name} --account-name ${replace(format("%s-%s-sa", local.project, "idpaycdn"), "-", "")} --source ${local_file.oidc_configuration_file.filename} --account-key ${data.azurerm_key_vault_secret.cdn_storage_access_secret.value}
          EOT
  }
}

data "azurerm_key_vault_secret" "cdn_storage_access_secret" {
  name         = "web-storage-access-key"
  key_vault_id =  data.azurerm_key_vault.kv.id
}

/*
module "idpay_jwt_exchange" {
  source = "git::https://github.com/pagopa/azurerm.git//jwt_keys?ref=v2.12.1"

  jwt_name         = "${var.domain}-jwt-exchange"
  key_vault_id     = data.azurerm_key_vault.kv.id
  cert_common_name = "idpay.welfare.pagopa.it"
  cert_password    = ""
  tags             = var.tags
}

resource "pkcs12_from_pem" "idpay_jwt_pkcs12" {
  password        = ""
  cert_pem        = module.idpay_jwt_exchange.certificate_data_pem
  private_key_pem = module.idpay_jwt_exchange.jwt_private_key_pem
}

resource "azurerm_api_management_certificate" "idpay_token_exchange_cert_jwt" {
  name                = "${var.env_short}-${var.domain}-token-exchange-jwt"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  data                = pkcs12_from_pem.idpay_jwt_pkcs12.result
}
/
*/
/*
data "azurerm_key_vault_certificate" "idpay_jwt_signing_cert" {
  name         = "bonus-dev-cstar-pagopa-it"
  key_vault_id = data.azurerm_key_vault.kv.id
}
*/
#Security certificate for signing JWT
resource "azurerm_key_vault_certificate" "idpay_jwt_signing_cert" {
  name         = "${var.env_short}-${var.domain}-jwt-signing-cert"
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

      subject            = "CN=${var.env_short}-${var.domain}-jwt-signing-cert"
      validity_in_months = 12
    }
  }
}

resource "azurerm_api_management_certificate" "idpay_token_exchange_cert_jwt" {
  name                = "${var.env_short}-${var.domain}-token-exchange-jwt"
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
  protocols             = ["https"]

}

resource "azurerm_api_management_api_operation" "idpay_token_exchange" {
  operation_id        = "idpay-token-exchange"
  api_name            = azurerm_api_management_api.idpay_token_exchange.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Token Exchange"
  method              = "GET"
  url_template        = "/"
  description         = "Endpoint for selfcare token exchange"
}

resource "azurerm_api_management_api_operation_policy" "idpay_token_exchange_policy" {
  api_name            = azurerm_api_management_api_operation.idpay_token_exchange.api_name
  api_management_name = azurerm_api_management_api_operation.idpay_token_exchange.api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_token_exchange.resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_token_exchange.operation_id

  xml_content = templatefile("./api/idpay_token_exchange/jwt_exchange.xml.tpl", {
    openid-config-url             = local.idpay-oidc-config_url,
    selfcare-issuer               = local.selfcare-issuer,
    jwt_cert_signing_thumbprint   = azurerm_api_management_certificate.idpay_token_exchange_cert_jwt.thumbprint,
    idpay-portal-hostname         = local.idpay-portal-hostname
  })

}
