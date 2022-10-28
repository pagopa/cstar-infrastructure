module "key_vault_secrets_query" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v1.0.7"

  resource_group = local.key_vault_resource_group
  key_vault_name = local.key_vault_name

  # This list should be specialized for environment
  secrets = var.secrets_to_be_read_from_kv
}

# allow to retrieve secrets from RTD domain kv. This MUST be deleted
# when cluster migrate to new one.
module "key_vault_domain_rtd_secrets_query" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v1.0.7"

  resource_group = var.secrets_from_rtd_domain_kv.resource_group
  key_vault_name = var.secrets_from_rtd_domain_kv.keyvault

  # This list should be specialized for environment
  secrets = var.secrets_from_rtd_domain_kv.secrets
}
