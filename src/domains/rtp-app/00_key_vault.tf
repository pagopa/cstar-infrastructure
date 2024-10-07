data "azurerm_key_vault" "kv_domain" {
  name                = "${local.project}-kv"
  resource_group_name = "${local.project}-sec-rg"
}
