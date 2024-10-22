resource "azurerm_resource_group" "sec_rg" {
  name     = "${local.project}-sec-rg"
  location = var.location

  tags = var.tags
}

module "key_vault_core" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault?ref=v8.21.0"

  name                       = "${local.project}-kv"
  location                   = azurerm_resource_group.sec_rg.location
  resource_group_name        = azurerm_resource_group.sec_rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 90

  tags = var.tags
}

#
# POLICY
#
locals {
  kvs = [module.key_vault_core.id]
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "ad_group_policy" {
  key_vault_id = module.key_vault_core.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_admin.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Encrypt", "Decrypt", "Backup", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Backup", "Purge", "Recover", "Restore"]
  storage_permissions     = []
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover", ]
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "adgroup_developers_policy" {
  count = var.env_short != "p" ? 1 : 0

  key_vault_id = module.key_vault_core.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_developers.object_id

  key_permissions     = ["Get", "List", "Update", "Create", "Import", "Delete", "Encrypt", "Decrypt", "Recover", "Rotate", "GetRotationPolicy"]
  secret_permissions  = ["Get", "List", "Set", "Delete", "Recover", ]
  storage_permissions = []
  certificate_permissions = [
    "Get", "List", "Update", "Create", "Import",
    "Delete", "Restore", "Purge", "Recover"
  ]
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "adgroup_externals_policy" {
  count = var.env_short != "p" ? 1 : 0

  key_vault_id = module.key_vault_core.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_externals.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Encrypt", "Decrypt", "GetRotationPolicy"]
  secret_permissions      = ["Get", "List", "Set", "Delete", ]
  storage_permissions     = []
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover"]
}


################
##   Secrets  ##
################

# create json letsencrypt inside kv
# requierd: Docker
module "letsencrypt_rtp" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//letsencrypt_credential?ref=v8.21.0"

  prefix            = var.prefix
  env               = var.env_short
  key_vault_name    = module.key_vault_core.name
  subscription_name = local.subscription_name
}


#
# IaC
#

#pagopaspa-cstar-platform-iac-projects-{subscription}
data "azuread_service_principal" "platform_iac_sp" {
  display_name = "pagopaspa-cstar-platform-iac-projects-${data.azurerm_subscription.current.subscription_id}"
}

resource "azurerm_key_vault_access_policy" "azdevops_platform_iac_policy" {
  key_vault_id = module.key_vault_core.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_service_principal.platform_iac_sp.object_id

  key_permissions         = ["Get", "List", "Import", ]
  secret_permissions      = ["Get", "List", "Set", ]
  certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get", "Import"]

  storage_permissions = []
}

#azdo-sp-plan-cstar-<env>
data "azuread_service_principal" "iac_sp_plan" {
  display_name = "azdo-sp-plan-cstar-${var.env}"
}

resource "azurerm_key_vault_access_policy" "iac_sp_plan_policy" {
  key_vault_id = module.key_vault_core.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_service_principal.iac_sp_plan.object_id

  key_permissions         = ["Get", "List", "Import", ]
  secret_permissions      = ["Get", "List", "Set", ]
  certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get", "Import"]

  storage_permissions = []
}
