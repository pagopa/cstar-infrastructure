# Azure AD
data "azuread_group" "adgroup_admin" {
  display_name = "${local.product}-adgroup-admin"
}

data "azuread_group" "adgroup_developers" {
  display_name = "${local.product}-adgroup-developers"
}

data "azuread_group" "adgroup_externals" {
  display_name = "${local.product}-adgroup-externals"
}

data "azuread_group" "adgroup_security" {
  display_name = "${local.product}-adgroup-security"
}

#
# AZDO
#

data "azurerm_user_assigned_identity" "iac_federated_azdo" {
  for_each = local.azdo_iac_managed_identities

  name                = each.key
  resource_group_name = local.azdo_managed_identity_rg_name
}
