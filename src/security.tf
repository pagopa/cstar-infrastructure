resource "azurerm_resource_group" "sec_rg" {
  name     = format("%s-sec-rg", local.project)
  location = var.location

  tags = var.tags
}


module "key_vault" {
  source              = "git::https://github.com/pagopa/azurerm.git//key_vault?ref=v1.0.7"
  name                = format("%s-kv", local.project)
  location            = azurerm_resource_group.sec_rg.location
  resource_group_name = azurerm_resource_group.sec_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  // terraform_cloud_object_id = data.azurerm_client_config.current.client_id

  tags = var.tags
}

## api management policy ## 
resource "azurerm_key_vault_access_policy" "api_management_policy" {
  key_vault_id = module.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.apim.principal_id

  key_permissions         = []
  secret_permissions      = ["Get", "List"]
  certificate_permissions = ["Get", "List"]
  storage_permissions     = []
}

# terraform cloud policy
/*
resource "azurerm_key_vault_access_policy" "terraform_cloud_policy" {
  key_vault_id = module.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = ["Get", "List", "Update", "Create", "Import", "Delete",
    "Recover", "Backup", "Restore"
  ]

  secret_permissions = ["Get", "List", "Set", "Delete", "Recover", "Backup",
    "Restore"
  ]

  certificate_permissions = ["Get", "List", "Update", "Create", "Import",
    "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers",
    "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"
  ]

  storage_permissions = []

}
*/

## user assined identity: (application gateway) ##
resource "azurerm_key_vault_access_policy" "app_gateway_policy" {
  key_vault_id            = module.key_vault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = azurerm_user_assigned_identity.appgateway.principal_id
  key_permissions         = ["Get", "List"]
  secret_permissions      = ["Get", "List"]
  certificate_permissions = ["Get", "List", "Purge"]
  storage_permissions     = []
}


data "azuread_group" "adgroup_admin" {
  display_name = format("%s-adgroup-admin", local.project)
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "ad_group_policy" {
  key_vault_id = module.key_vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_admin.object_id

  key_permissions     = ["Get", "List", "Update", "Create", "Import", "Delete", ]
  secret_permissions  = ["Get", "List", "Set", "Delete", ]
  storage_permissions = []
  certificate_permissions = [
    "Get", "List", "Update", "Create", "Import",
    "Delete", "Restore", "Purge", "Recover"
  ]
}


## azure devops ##
resource "azurerm_key_vault_access_policy" "cert_renew_policy" {
  count        = var.devops_service_connection_object_id == null ? 0 : 1
  key_vault_id = module.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.devops_service_connection_object_id

  key_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
  ]

  certificate_permissions = [
    "Get",
    "List",
    "Import",
  ]
}


resource "azurerm_user_assigned_identity" "appgateway" {
  resource_group_name = azurerm_resource_group.sec_rg.name
  location            = azurerm_resource_group.sec_rg.location
  name                = format("%s-appgateway-identity", local.project)

  tags = var.tags
}

resource "azurerm_key_vault_certificate" "apim_proxy_endpoint_cert" {
  depends_on = [
    azurerm_key_vault_access_policy.api_management_policy
  ]

  name         = local.apim_cert_name_proxy_endpoint
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
      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject            = format("CN=%s", trim(azurerm_private_dns_a_record.private_dns_a_record_api.fqdn, "."))
      validity_in_months = 12

      subject_alternative_names {
        dns_names = [
          trim(azurerm_private_dns_a_record.private_dns_a_record_api.fqdn, "."),
        ]
      }
    }
  }
}
resource "azurerm_key_vault_certificate" "app_gw_io_cstar" {
  count        = var.app_gateway_api_io_certificate_name != null ? 0 : 1
  name         = format("%s-cert-api-io", local.project)
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
      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject            = var.env_short == "p" ? "CN=api-io.cstar.pagopa.it" : format("CN=api-io.%s.cstar.pagopa.it", lower(var.tags["Environment"]))
      validity_in_months = 12

      subject_alternative_names {
        dns_names = [
          var.env_short == "p" ? "api-io.cstar.pagopa.it" : format("api-io.%s.cstar.pagopa.it", lower(var.tags["Environment"])),
        ]
      }
    }
  }
}

resource "azurerm_key_vault_certificate" "app_gw_cstar" {
  count        = var.app_gateway_api_certificate_name != null ? 0 : 1
  name         = format("%s-cert-api", local.project)
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
      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject            = var.env_short == "p" ? "CN=api.%s.cstar.pagopa.it" : format("CN=api.%s.cstar.pagopa.it", lower(var.tags["Environment"]))
      validity_in_months = 12

      subject_alternative_names {
        dns_names = [
          var.env_short == "p" ? "api.cstar.pagopa.it" : format("api.%s.cstar.pagopa.it", lower(var.tags["Environment"])),
        ]
      }
    }
  }
}

data "azurerm_key_vault_certificate" "app_gw_io_cstar" {
  count        = var.app_gateway_api_io_certificate_name != null ? 1 : 0
  name         = var.app_gateway_api_io_certificate_name
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_certificate" "app_gw_cstar" {
  count        = var.app_gateway_api_certificate_name != null ? 1 : 0
  name         = var.app_gateway_api_certificate_name
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "bpd_pm_client_certificate_thumbprint" {
  name         = "BPD-PM-client-certificate-thumbprint"
  key_vault_id = module.key_vault.id
}
