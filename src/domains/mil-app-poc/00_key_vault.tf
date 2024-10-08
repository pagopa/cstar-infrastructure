data "azurerm_key_vault" "kv_domain" {
  name                = local.kv_domain_name
  resource_group_name = local.kv_domain_rg_name
}

data "azurerm_key_vault" "kv_auth" {
  name                = local.kv_auth_name
  resource_group_name = local.kv_domain_rg_name
}