resource "azurerm_resource_group" "sec_rg" {
  name     = "${local.project}-sec-rg"
  location = var.location

  tags = local.tags
}

module "key_vault_core" {
  source = "./.terraform/modules/__v4__/key_vault"

  name                       = "${local.project}-kv"
  location                   = azurerm_resource_group.sec_rg.location
  resource_group_name        = azurerm_resource_group.sec_rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 90

  tags = local.tags
}

module "key_vault_auth" {
  source = "./.terraform/modules/__v4__/key_vault"

  name                       = "${local.project}-auth-kv"
  location                   = azurerm_resource_group.sec_rg.location
  resource_group_name        = azurerm_resource_group.sec_rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 90

  tags = local.tags
}

module "key_vault_idpay" {
  source = "./.terraform/modules/__v4__/key_vault"

  name                       = "${local.project}-idpay-kv"
  location                   = azurerm_resource_group.sec_rg.location
  resource_group_name        = azurerm_resource_group.sec_rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 90

  tags = local.tags
}

#
# POLICY
#
locals {
  kvs = toset([module.key_vault_core.id, module.key_vault_auth.id, module.key_vault_idpay.id])
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "ad_group_policy" {
  for_each     = local.kvs
  key_vault_id = each.key

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_admin.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Encrypt", "Decrypt", "Backup", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Backup", "Purge", "Recover", "Restore"]
  storage_permissions     = []
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover", ]
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "adgroup_developers_policy" {

  for_each     = var.env_short != "p" ? local.kvs : []
  key_vault_id = each.key

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
  for_each     = var.env_short != "p" ? local.kvs : []
  key_vault_id = each.key

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_externals.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Encrypt", "Decrypt", "GetRotationPolicy"]
  secret_permissions      = ["Get", "List", "Set", "Delete", ]
  storage_permissions     = []
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover"]
}

#
# Permissions for identity access to domain key vaults.
#

locals {
  policy_identity = flatten([
    for key, identity in data.azurerm_user_assigned_identity.iac_federated_azdo : [
      for kv in local.kvs : {
        identity = identity.principal_id
        kv       = kv
        key_name = "${identity.name}@${kv}"
      }
    ]
  ])
}

resource "azurerm_key_vault_access_policy" "azdevops_iac_managed_identities" {
  for_each = { for c in local.policy_identity : c.key_name => c }

  key_vault_id = each.value.kv
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.value.identity

  key_permissions         = ["Get", "List", "Decrypt", "Verify", "GetRotationPolicy"]
  secret_permissions      = ["Get", "List", "Set"]
  certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get"]
  storage_permissions     = []
}
