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
# Assignement of role "Key Vault Crypto Officer" on idpay key vault to identity
# of idpay microservice.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "crypto_officer_on_idpay_kv_to_idpay_identity" {
  scope                = azurerm_key_vault.idpay.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_user_assigned_identity.idpay.principal_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Certificates Officer" on idpay key vault to
# identity of idpay microservice.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "certificates_officer_on_idpay_kv_to_idpay_identity" {
  scope                = azurerm_key_vault.idpay.id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = azurerm_user_assigned_identity.idpay.principal_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Secrets Officer" on idpay key vault to identity
# of idpay microservice.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "secrets_officer_on_idpay_kv_to_idpay_identity" {
  scope                = azurerm_key_vault.idpay.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azurerm_user_assigned_identity.idpay.principal_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Secrets Officer" on general key vault to
# identity of idpay microservice.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "secrets_user_on_general_kv_to_idpay_identity" {
  scope                = data.azurerm_key_vault.general.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.idpay.principal_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Storage Blob Data Reader" on conf storage to identity of
# payment-notice microservice.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "data_reader_on_conf_storage_to_payment_notice_identity" {
  scope                = azurerm_storage_account.conf.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.payment_notice.principal_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Storage Blob Data Reader" on conf storage to identity of
# fee-calculator microservice.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "data_reader_on_conf_storage_to_fee_calculator_identity" {
  scope                = azurerm_storage_account.conf.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.fee_calculator.principal_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Administrator" on idpay key vault to
# adgroup_admin.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "admin_on_idpay_kv_to_adgroup_admin" {
  scope                = azurerm_key_vault.idpay.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_group.adgroup_admin.object_id
}