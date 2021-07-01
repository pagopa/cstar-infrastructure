resource "random_string" "user" {
  for_each = local.users_map

  length  = 16
  special = true
  upper   = true
}

resource "postgresql_role" "user" {
  for_each = local.users_map

  name            = each.key
  login           = true
  superuser       = false
  create_database = false
  create_role     = false
  inherit         = true
  replication     = false
  password        = random_string.user[each.key].result
}

resource "azurerm_key_vault_secret" "user_password" {
  for_each = local.users_map

  #tfsec:ignore:AZU023
  name         = "db-${lower(replace(each.key, "_", "-"))}-password"
  value        = postgresql_role.user[each.key].password
  key_vault_id = local.key_vault_id
  content_type = "text/plain"
}

resource "postgresql_grant" "user_privileges" {
  count = length(local.grants)

  database    = local.grants[count.index].database
  schema      = local.grants[count.index].schema
  role        = postgresql_role.user[local.grants[count.index].username].name
  object_type = local.grants[count.index].object_type
  privileges  = local.grants[count.index].privileges
}
