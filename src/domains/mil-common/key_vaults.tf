# ------------------------------------------------------------------------------
# General purpose key vault used to protect secrets.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault" "general" {
  name                          = "${local.project}-gen-kv"
  location                      = azurerm_resource_group.sec.location
  resource_group_name           = azurerm_resource_group.sec.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "premium"
  enabled_for_disk_encryption   = true
  enable_rbac_authorization     = true
  purge_protection_enabled      = true
  public_network_access_enabled = false
  soft_delete_retention_days    = 90
  tags                          = local.tags
}

# ------------------------------------------------------------------------------
# Key vault for cryptographics operations used by idpay microservice.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault" "idpay" {
  name                          = "${local.project}-idpay-kv"
  location                      = azurerm_resource_group.sec.location
  resource_group_name           = azurerm_resource_group.sec.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "premium"
  enabled_for_disk_encryption   = true
  purge_protection_enabled      = true
  public_network_access_enabled = false
  enable_rbac_authorization     = true
  soft_delete_retention_days    = 90
  tags                          = local.tags
}