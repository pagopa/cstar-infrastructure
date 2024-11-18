# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Administrator" on general key vault to
# adgroup_admin.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "admin_on_general_kv_to_adgroup_admin" {
  scope                = azurerm_key_vault.general.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_group.adgroup_admin.object_id
}