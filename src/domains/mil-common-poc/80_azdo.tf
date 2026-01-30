resource "azurerm_key_vault_access_policy" "azdevops_iac_managed_identities_read_only" {
  for_each = toset(local.azdo_iac_managed_identities_read)

  key_vault_id = data.azurerm_key_vault.kv_domain.id
  tenant_id    = data.azurerm_key_vault.kv_domain.tenant_id
  object_id    = data.azurerm_user_assigned_identity.iac_federated_azdo[each.key].principal_id

  key_permissions    = ["Get", "List", "Decrypt", "Encrypt", "Verify", "GetRotationPolicy", "Recover"]
  secret_permissions = ["Get", "List", "Set"]

  certificate_permissions = ["List", "Get"]

  storage_permissions = []
}

resource "azurerm_key_vault_access_policy" "azdevops_iac_managed_identities_write" {
  for_each = toset(local.azdo_iac_managed_identities_write)

  key_vault_id = data.azurerm_key_vault.kv_domain.id
  tenant_id    = data.azurerm_key_vault.kv_domain.tenant_id
  object_id    = data.azurerm_user_assigned_identity.iac_federated_azdo[each.key].principal_id

  key_permissions    = ["Get", "List", "Decrypt", "Encrypt", "Verify", "GetRotationPolicy", "Recover"]
  secret_permissions = ["Get", "List", "Set", "Delete", "Recover"]

  certificate_permissions = ["List", "Get"]

  storage_permissions = []
}
