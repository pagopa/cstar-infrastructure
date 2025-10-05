resource "azurerm_resource_group" "sec_rg_idpay" {
  name     = "${local.product}-${var.domain}-sec-rg"
  location = var.location

  tags = var.tags
}

module "key_vault_idpay" {
  source = "./.terraform/modules/__v3__/key_vault"

  name                       = "${local.product}-${var.domain}-kv"
  location                   = azurerm_resource_group.sec_rg_idpay.location
  resource_group_name        = azurerm_resource_group.sec_rg_idpay.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 90
  sku_name                   = "premium"

  tags = var.tags
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "ad_admin_group_policy" {
  key_vault_id = module.key_vault_idpay.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_admin.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Encrypt", "Decrypt", "Backup", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Backup", "Purge", "Recover", "Restore"]
  storage_permissions     = []
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover", ]
}

#
# policy developers
#
resource "azurerm_key_vault_access_policy" "adgroup_developers_policy" {

  key_vault_id = module.key_vault_idpay.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_developers.object_id

  key_permissions         = var.env_short == "d" ? ["Get", "List", "Update", "Create", "Import", "Delete", "Decrypt", "Encrypt"] : ["Get", "List", "Update", "Create", "Import", ]
  secret_permissions      = var.env_short == "d" ? ["Get", "List", "Set", "Delete", ] : ["Get", "List", "Set", ]
  storage_permissions     = []
  certificate_permissions = var.env_short == "d" ? ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover", "ManageContacts", ] : ["Get", "List", "Update", "Create", "Import", "Restore", "Recover", ]
}

#
# policy externals
#

resource "azurerm_key_vault_access_policy" "adgroup_externals_policy" {
  count = var.env_short == "d" ? 1 : 0

  key_vault_id = module.key_vault_idpay.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_externals.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Decrypt", "Encrypt"]
  secret_permissions      = ["Get", "List", "Set", "Delete", ]
  storage_permissions     = []
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover", "ManageContacts", ]
}
