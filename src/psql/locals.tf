

locals {
  users_map = { for user in var.users : user.name => user }

  grants = { for grant in flatten([for user in var.users : [for grant in user.grants :
    {
      database : grant.database
      username : user.name
      schema : grant.schema
      object_type : grant.object_type
      privileges : grant.privileges
  }]]) : "${grant.username}_${grant.database}_${grant.schema != null ? format("%s_", grant.schema) : "_"}${grant.object_type}" => grant }

  project = format("%s-%s", var.prefix, var.env_short)

  key_vault_name           = format("%s-kv", local.project)
  key_vault_resource_group = format("%s-sec-rg", local.project)
  key_vault_id             = "${data.azurerm_subscription.current.id}/resourceGroups/${local.key_vault_resource_group}/providers/Microsoft.KeyVault/vaults/${local.key_vault_name}"

  psql_username = var.psql_username != null ? var.psql_username : data.azurerm_key_vault_secret.psql_admin_username[0].value
  psql_password = var.psql_password != null ? var.psql_password : data.azurerm_key_vault_secret.psql_admin_password[0].value
}
