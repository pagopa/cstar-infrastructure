# ------------------------------------------------------------------------------
# Resource group for security stuff.
# ------------------------------------------------------------------------------
resource "azurerm_resource_group" "sec_rg" {
  name     = "${local.project}-sec-rg"
  location = var.location
  tags     = var.tags
}

# ------------------------------------------------------------------------------
# Domain key vault.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault" "key_vault_core" {
  name                          = "${local.project}-kv"
  location                      = azurerm_resource_group.sec_rg.location
  resource_group_name           = azurerm_resource_group.sec_rg.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "premium"
  enabled_for_disk_encryption   = true
  enable_rbac_authorization     = true
  purge_protection_enabled      = true
  public_network_access_enabled = true # TODO: This must be private and private-enpoints must be created!
  soft_delete_retention_days    = 90
  tags                          = var.tags
}

# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Administrator" on domain key vault to
# adgroup_admin.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "admin_on_domain_kv_to_adgroup_admin" {
  scope                = azurerm_key_vault.key_vault_core.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_group.adgroup_admin.object_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Administrator" on domain key vault to
# adgroup_developers for DEV and UAT environments.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "admin_on_domain_kv_to_adgroup_developers" {
  count                = var.env_short != "p" ? 1 : 0
  scope                = azurerm_key_vault.key_vault_core.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_group.adgroup_developers.object_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Administrator" on domain key vault to
# adgroup_externals for DEV and UAT environments.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "admin_on_domain_kv_to_adgroup_externals" {
  count                = var.env_short != "p" ? 1 : 0
  scope                = azurerm_key_vault.key_vault_core.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_group.adgroup_externals.object_id
}

# ------------------------------------------------------------------------------
# Creates Let's Encrypt credential storing them in the domain key vault.
# This requires Docker.
# ------------------------------------------------------------------------------
module "letsencrypt_rtp" {
  source            = "git::https://github.com/pagopa/terraform-azurerm-v3.git//letsencrypt_credential?ref=v8.21.0"
  prefix            = var.prefix
  env               = var.env_short
  key_vault_name    = azurerm_key_vault.key_vault_core.name
  subscription_name = local.subscription_name
}

# ------------------------------------------------------------------------------
# Assignement of the following roles to IaC service principals on domain key
# vault:
#   - Key Vault Crypto Officer
#   - Key Vault Certificates Officer
#   - Key Vault Secrets Officer
#
# TODO
# ----
# Evaluate the possibility of creating custom role with the following
# permissions:
#   - keys........: Get, List, Import
#   - secrets.....: Get, List, Set
#   - certificates: SetIssuers, DeleteIssuers, Purge, List, Get, Import
# ------------------------------------------------------------------------------
locals {
  iac_roles = [
    "Key Vault Crypto Officer",
    "Key Vault Certificates Officer",
    "Key Vault Secrets Officer"
  ]
}

data "azuread_service_principal" "platform_iac_sp" {
  display_name = "pagopaspa-cstar-platform-iac-projects-${data.azurerm_subscription.current.subscription_id}"
}

resource "azurerm_role_assignment" "role_on_domain_kv_to_platform_iac_sp" {
  for_each             = toset(local.iac_roles)
  scope                = azurerm_key_vault.key_vault_core.id
  role_definition_name = each.value
  principal_id         = data.azuread_service_principal.platform_iac_sp.object_id
}

data "azuread_service_principal" "iac_sp_plan" {
  display_name = "azdo-sp-plan-cstar-${var.env}"
}

resource "azurerm_role_assignment" "role_on_domain_kv_to_iac_sp_plan" {
  for_each             = toset(local.iac_roles)
  scope                = azurerm_key_vault.key_vault_core.id
  role_definition_name = each.value
  principal_id         = data.azuread_service_principal.iac_sp_plan.object_id
}