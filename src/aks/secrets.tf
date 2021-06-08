module "key_vault_secrets_query" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=main"

  resource_group = local.key_vault_resource_group
  key_vault_name = local.key_vault

  secrets = [
    "db-administrator-login",
  ]
}
