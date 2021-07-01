
resource "postgresql_role" "user" {
  for_each = local.users_map

  name            = each.key
  login           = true
  superuser       = false
  create_database = false
  create_role     = false
  inherit         = true
  replication     = false
  password        = data.azurerm_key_vault_secret.user_password[each.key].value
}

data "azurerm_key_vault_secret" "user_password" {
  for_each = local.users_map

  name         = "db-${lower(replace(each.key, "_", "-"))}-password"
  key_vault_id = local.key_vault_id
}

resource "postgresql_grant" "user_privileges" {
  count = length(local.grants)

  database    = local.grants[count.index].database
  schema      = local.grants[count.index].schema
  role        = postgresql_role.user[local.grants[count.index].username].name
  object_type = local.grants[count.index].object_type
  privileges  = local.grants[count.index].privileges
}
