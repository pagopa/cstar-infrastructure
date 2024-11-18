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
