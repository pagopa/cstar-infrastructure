data "azurerm_key_vault" "kv" {
  name                = "${local.product}-${var.domain}-kv"
  resource_group_name = "${local.product}-${var.domain}-sec-rg"
}

data "azurerm_key_vault_secret" "operations_slack_email" {

  count = var.env_short == "p" ? 1 : 0

  name         = "operations-slack-channel-email"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "operations_zendesk_email" {

  count = var.zendesk_action_enabled.enable == true ? 1 : 0

  name         = "operations-zendesk-email"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "opsgenie_webhook_url" {
  count = var.env_short == "p" ? 1 : 0

  name         = "opsgenie-tae-webhook-url"
  key_vault_id = data.azurerm_key_vault.kv.id
}
