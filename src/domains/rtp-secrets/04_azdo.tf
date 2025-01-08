#
# Permissions for identity access to domain key vaults.
#

locals {
  policy_identity = flatten([
    for key, identity in data.azurerm_user_assigned_identity.iac_federated_azdo : [
      for role in local.iac_roles : {
        identity = identity.principal_id
        role     = role
        key_name = "${identity.name}@${role}"
      }
    ]
  ])
}

#
# AZDO
#
data "azurerm_user_assigned_identity" "iac_federated_azdo" {
  for_each            = local.azdo_iac_managed_identities
  name                = each.key
  resource_group_name = local.azdo_managed_identity_rg_name
}


resource "azurerm_role_assignment" "azdevops_iac_managed_identities" {
  for_each = { for c in local.policy_identity : c.key_name => c }

  scope                = azurerm_key_vault.key_vault_core.id
  role_definition_name = each.value.role
  principal_id         = each.value.identity
}
