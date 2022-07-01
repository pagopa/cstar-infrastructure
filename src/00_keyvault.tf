data "azurerm_key_vault" "kv_idpay" {
  name                = local.idpay_keyvault_name
  resource_group_name = local.idpay_rg_keyvault_name
}
