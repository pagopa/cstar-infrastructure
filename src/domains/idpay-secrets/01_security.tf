# ⚠️ ⚠️ ⚠️ ⚠️
# The KV + KV policy was created in the idpay-common folder. It should be imported here.

#resource "azurerm_resource_group" "sec_rg" {
#  name     = "${local.project}-sec-rg"
#  location = var.location
#
#  tags = var.tags
#}
#
##
## Kv + Policy
##
#
#module "key_vault" {
#  source = "./.terraform/modules/__v3__/key_vault"
#
#  name                          = "${local.product}-${var.domain}-kv"
#  location                      = azurerm_resource_group.sec_rg.location
#  resource_group_name           = azurerm_resource_group.sec_rg.name
#  tenant_id                     = data.azurerm_client_config.current.tenant_id
#  soft_delete_retention_days    = 90
#  public_network_access_enabled = true
#
#  tags = var.tags
#}
#
### ad group policy ##
#resource "azurerm_key_vault_access_policy" "ad_group_policy" {
#  key_vault_id = module.key_vault.id
#
#  tenant_id = data.azurerm_client_config.current.tenant_id
#  object_id = data.azuread_group.adgroup_admin.object_id
#
#  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "GetRotationPolicy", "Encrypt", "Decrypt"]
#  secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Restore"]
#  storage_permissions     = []
#  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover"]
#}
