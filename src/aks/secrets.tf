module "key_vault_secrets_query" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v1.0.7"

  resource_group = local.key_vault_resource_group
  key_vault_name = local.key_vault

  secrets = [
    "db-administrator-login",
    "db-bpd-login",
    "db-bpd-password",
  ]
}
