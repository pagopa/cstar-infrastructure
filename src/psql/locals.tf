

locals {
  users_map = { for user in var.users : user.name => user }

  grants = flatten([for user in var.users : [for grant in user.grants : {
    database : grant.database
    username : user.name
    object_type : grant.object_type
    privileges : grant.privileges
  }]])

  project = format("%s-%s", var.prefix, var.env_short)

  key_vault_name           = format("%s-kv", local.project)
  key_vault_resource_group = format("%s-sec-rg", local.project)
  key_vault_id             = "${data.azurerm_subscription.current.id}/resourceGroups/${local.key_vault_resource_group}/providers/Microsoft.KeyVault/vaults/${local.key_vault_name}"
}
