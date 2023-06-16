resource "azurerm_resource_group" "sec_rg" {
  name     = "${local.project}-sec-rg"
  location = var.location

  tags = var.tags
}


module "key_vault" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault?ref=v6.2.1"
  name                = "${local.project}-kv"
  location            = azurerm_resource_group.sec_rg.location
  resource_group_name = azurerm_resource_group.sec_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  tags = var.tags
}

#
# Application Gateway
#

resource "azurerm_user_assigned_identity" "appgateway" {
  resource_group_name = azurerm_resource_group.sec_rg.name
  location            = azurerm_resource_group.sec_rg.location
  name                = "${local.project}-appgateway-identity"

  tags = var.tags
}

resource "azurerm_key_vault_certificate" "apim_internal_custom_domain_cert" {
  name         = "${local.project}-apim-private-custom-domain-cert"
  key_vault_id = module.key_vault.id

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
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]
      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject            = format("CN=%s", trimsuffix(azurerm_private_dns_a_record.private_dns_a_record_api.fqdn, "."))
      validity_in_months = 12
    }
  }
}

data "azurerm_key_vault_certificate" "app_gw_io_cstar" {
  count        = var.app_gateway_api_io_certificate_name != null ? 1 : 0
  name         = var.app_gateway_api_io_certificate_name
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_certificate" "app_gw_cstar" {
  name         = var.app_gateway_api_certificate_name
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_certificate" "portal_cstar" {
  name         = var.app_gateway_portal_certificate_name
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_certificate" "management_cstar" {
  name         = var.app_gateway_management_certificate_name
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "bpd_pm_client_certificate_thumbprint" {
  name         = "BPD-PM-client-certificate-thumbprint"
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "rtd_pm_client-certificate-thumbprint" {
  name         = "RTD-PM-client-certificate-thumbprint"
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "monitor_notification_slack_email" {
  name         = "monitor-notification-slack-email"
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "monitor_notification_email" {
  name         = "monitor-notification-email"
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "alert_core_notification_email" {
  name         = "alert-core-notification-email"
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "alert_core_notification_slack" {
  name         = "alert-core-notification-slack"
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "alert_error_notification_email" {
  name         = "alert-error-notification-email"
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "alert_error_notification_slack" {
  name         = "alert-error-notification-slack"
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "apim_publisher_email" {
  name         = "apim-publisher-email"
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "apim_internal_user_email" {
  name         = "apim-internal-user-email"
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "cruscotto-basic-auth-pwd" {
  name         = "CRUSCOTTO-Basic-Auth-Pwd"
  key_vault_id = module.key_vault.id
}

#
# Security Subscription
#
data "azurerm_key_vault_secret" "sec_sub_id" {
  name         = "sec-subscription-id"
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "sec_workspace_id" {
  count        = var.env_short == "p" ? 1 : 0
  name         = "sec-workspace-id"
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "sec_storage_id" {
  count        = var.env_short == "p" ? 1 : 0
  name         = "sec-storage-id"
  key_vault_id = module.key_vault.id
}

#
# RTD Domain KV
#
data "azurerm_key_vault" "rtd_domain_kv" {
  name                = local.rtd_keyvault_name
  resource_group_name = local.rtd_rg_keyvault_name
}
