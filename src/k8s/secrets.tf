module "key_vault_secrets_query" {
  source         = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v6.15.2"
  resource_group = local.key_vault_resource_group
  key_vault_name = local.key_vault_name

  # This list should be specialized for environment
  secrets = var.secrets_to_be_read_from_kv
}

# allow to retrieve secrets from RTD domain kv. This MUST be deleted
# when cluster migrate to new one.

