resource "azurerm_resource_group" "sec_rg" {
  name     = format("%s-sec-rg", local.project)
  location = var.location

  tags = var.tags
}


module "key_vault" {
  source              = "git::https://github.com/pagopa/azurerm.git//key_vault?ref=v1.0.48"
  name                = format("%s-kv", local.project)
  location            = azurerm_resource_group.sec_rg.location
  resource_group_name = azurerm_resource_group.sec_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  lock_enable         = var.lock_enable

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

data "azuread_group" "adgroup_developers" {
  display_name = format("%s-adgroup-developers", local.project)
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "adgroup_developers_policy" {
  count = var.env_short == "d" ? 1 : 0

  key_vault_id = module.key_vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_developers.object_id

  key_permissions     = ["Get", "List", "Update", "Create", "Import", "Delete", ]
  secret_permissions  = ["Get", "List", "Set", "Delete", ]
  storage_permissions = []
  certificate_permissions = [
    "Get", "List", "Update", "Create", "Import",
    "Delete", "Restore", "Purge", "Recover"
  ]
}

data "azuread_group" "adgroup_externals" {
  display_name = format("%s-adgroup-externals", local.project)
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "adgroup_externals_policy" {
  count = var.env_short == "d" ? 1 : 0

  key_vault_id = module.key_vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_externals.object_id

  key_permissions     = ["Get", "List", "Update", "Create", "Import", "Delete", ]
  secret_permissions  = ["Get", "List", "Set", "Delete", ]
  storage_permissions = []
  certificate_permissions = [
    "Get", "List", "Update", "Create", "Import",
    "Delete", "Restore", "Purge", "Recover"
  ]
}

data "azuread_group" "adgroup_security" {
  display_name = format("%s-adgroup-security", local.project)
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "adgroup_security_policy" {
  count = var.env_short == "d" ? 1 : 0

  key_vault_id = module.key_vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_security.object_id

  key_permissions     = ["Get", "List", "Update", "Create", "Import", "Delete", ]
  secret_permissions  = ["Get", "List", "Set", "Delete", ]
  storage_permissions = []
  certificate_permissions = [
    "Get", "List", "Update", "Create", "Import",
    "Delete", "Restore", "Purge", "Recover"
  ]
}

## azure devops ##
data "azuread_service_principal" "azdo_sp_tls_cert" {
  count        = var.azdo_sp_tls_cert_enabled ? 1 : 0
  display_name = format("azdo-sp-%s-tls-cert", local.project)
}

resource "azurerm_key_vault_access_policy" "azdo_sp_tls_cert" {
  count        = var.azdo_sp_tls_cert_enabled ? 1 : 0
  key_vault_id = module.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_service_principal.azdo_sp_tls_cert[0].object_id

  certificate_permissions = [
    "Get",
    "List",
    "Import",
  ]
}

resource "azurerm_key_vault_access_policy" "cert_renew_policy" {
  count        = var.devops_service_connection_object_id == null ? 0 : 1
  key_vault_id = module.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.devops_service_connection_object_id

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

data "azurerm_key_vault_secret" "apim_publisher_email" {
  name         = "apim-publisher-email"
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "cruscotto-basic-auth-pwd" {
  name         = "CRUSCOTTO-Basic-Auth-Pwd"
  key_vault_id = module.key_vault.id
}