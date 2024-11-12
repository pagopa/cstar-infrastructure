# ------------------------------------------------------------------------------
# Role assignements to identity of GitHub, used for continuous delivery.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "identity_subscription_role_assignment_cd" {
  for_each             = toset(["Contributor"])
  scope                = data.azurerm_subscription.current.id
  role_definition_name = each.value
  principal_id         = azurerm_user_assigned_identity.identity_cd.principal_id
}

resource "azurerm_role_assignment" "identity_rg_role_assignment_cd" {
  count                = length(local.resource_groups_roles_cd)
  scope                = local.resource_groups_roles_cd[count.index].resource_group_id
  role_definition_name = local.resource_groups_roles_cd[count.index].role
  principal_id         = azurerm_user_assigned_identity.identity_cd.principal_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Crypto Officer" on auth key vault to identity
# of auth microservice.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "crypto_officer_on_auth_kv_to_auth_identity" {
  scope                = azurerm_key_vault.auth.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_user_assigned_identity.auth.principal_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Secrets Officer" on general key vault to
# identity of auth microservice.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "secrets_user_on_general_kv_to_auth_identity" {
  scope                = azurerm_key_vault.general.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.auth.principal_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Storage Blob Data Reader" on auth storage to identity of
# auth microservice.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "data_reader_on_auth_storage_to_auth_identity" {
  scope                = azurerm_storage_account.auth.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.auth.principal_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Administrator" on general key vault to
# adgroup_admin.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "admin_on_general_kv_to_adgroup_admin" {
  scope                = azurerm_key_vault.general.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_group.adgroup_admin.object_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Administrator" on auth key vault to
# adgroup_admin.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "admin_on_auth_kv_to_adgroup_admin" {
  scope                = azurerm_key_vault.auth.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_group.adgroup_admin.object_id
}