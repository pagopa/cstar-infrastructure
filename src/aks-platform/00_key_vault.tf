# data "azurerm_resource_group" "rg_kv" {
#   name = var.key_vault_rg_name
# }

# #
# # 🔐 KV
# #
# data "azurerm_key_vault" "kv" {
#   name                = var.key_vault_name
#   resource_group_name = var.key_vault_rg_name
# }
