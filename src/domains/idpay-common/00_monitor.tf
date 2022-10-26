data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_resource_group_name
}

data "azurerm_resource_group" "monitor_rg" {
  name = var.monitor_resource_group_name
}

data "azurerm_monitor_action_group" "slack" {
  resource_group_name = var.monitor_resource_group_name
  name                = local.monitor_action_group_slack_name
}

data "azurerm_monitor_action_group" "email" {
  resource_group_name = var.monitor_resource_group_name
  name                = local.monitor_action_group_email_name
}

data "azurerm_key_vault_secret" "alert_domain_notification_email" {
  name         = "alert-${var.domain}-notification-email"
  key_vault_id = module.key_vault_idpay.id
}

data "azurerm_key_vault_secret" "alert_domain_notification_slack" {
  name         = "alert-${var.domain}-notification-slack"
  key_vault_id = module.key_vault_idpay.id
}

resource "azurerm_monitor_action_group" "domain" {
  name                = "${var.prefix}${var.env_short}${var.domain}"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  short_name          = "${var.prefix}${var.env_short}${var.domain}"

  email_receiver {
    name                    = "email"
    email_address           = data.azurerm_key_vault_secret.alert_domain_notification_email.value
    use_common_alert_schema = true
  }

  email_receiver {
    name                    = "slack"
    email_address           = data.azurerm_key_vault_secret.alert_domain_notification_slack.value
    use_common_alert_schema = true
  }

  tags = var.tags
}
