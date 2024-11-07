# ------------------------------------------------------------------------------
# Groups within Azure Active Directory.
# ------------------------------------------------------------------------------
data "azuread_group" "adgroup_admin" {
  display_name = "${var.prefix}-${var.env_short}-adgroup-admin"
}

data "azuread_group" "adgroup_developers" {
  display_name = "${var.prefix}-${var.env_short}-adgroup-developers"
}

data "azuread_group" "adgroup_externals" {
  display_name = "${var.prefix}-${var.env_short}-adgroup-externals"
}

data "azuread_group" "adgroup_security" {
  display_name = "${var.prefix}-${var.env_short}-adgroup-security"
}