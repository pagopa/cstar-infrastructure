#
# IdPay
#
module "key_vault_id_pay" {
  source              = "git::https://github.com/pagopa/azurerm.git//key_vault?ref=v2.16.0"
  name                = local.key_vault_id_pay_name
  location            = azurerm_resource_group.sec_rg.location
  resource_group_name = azurerm_resource_group.sec_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  lock_enable         = var.lock_enable

  soft_delete_retention_days = var.key_vault_soft_delete_retention_days
  sku_name                   = var.key_vault_sku_name

  # Security Logs
  sec_log_analytics_workspace_id = var.env_short == "p" ? data.azurerm_key_vault_secret.sec_workspace_id[0].value : null
  sec_storage_id                 = var.env_short == "p" ? data.azurerm_key_vault_secret.sec_storage_id[0].value : null

  tags = var.tags
}
