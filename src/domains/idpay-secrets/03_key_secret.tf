data "external" "terrasops" {
  program = [
    "bash", "terrasops.sh"
  ]
  query = {
    env = "${var.location_short}-${var.env}"
  }
}

locals {
  all_enc_secrets_value = can(data.external.terrasops.result) ? flatten([
    for k, v in data.external.terrasops.result : {
      value = v
      key   = k
    }
  ]) : []

  config_secret_data = jsondecode(file(local.input_file))
  all_config_secrets_value = flatten([
    for kc, vc in local.config_secret_data : {
      value = vc
      key   = kc
    }
  ])

  all_secrets_value = concat(local.all_config_secrets_value, local.all_enc_secrets_value)
}

## SOPS secrets

## Upload all encrypted secrets
resource "azurerm_key_vault_secret" "secret" {
  for_each = { for i, v in local.all_secrets_value : local.all_secrets_value[i].key => i }

  key_vault_id = data.azurerm_key_vault.key_vault.id
  name         = local.all_secrets_value[each.value].key
  value        = local.all_secrets_value[each.value].value

  depends_on = [
    azurerm_key_vault_key.sops_key,
    data.external.terrasops,
  ]

  tags = merge(
    local.tags, {
      "SOPS" : "True"
    }
  )
}
