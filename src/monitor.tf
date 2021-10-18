resource "azurerm_resource_group" "monitor_rg" {
  name     = format("%s-monitor-rg", local.project)
  location = var.location

  tags = var.tags
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = format("%s-law", local.project)
  location            = azurerm_resource_group.monitor_rg.location
  resource_group_name = azurerm_resource_group.monitor_rg.name
  sku                 = var.law_sku
  retention_in_days   = var.law_retention_in_days
  daily_quota_gb      = var.law_daily_quota_gb

  tags = var.tags
}

# Application insights
resource "azurerm_application_insights" "application_insights" {
  name                = format("%s-appinsights", local.project)
  location            = azurerm_resource_group.monitor_rg.location
  resource_group_name = azurerm_resource_group.monitor_rg.name
  application_type    = "other"

  tags = var.tags
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "application_insights_key" {
  name         = "appinsights-instrumentation-key"
  value        = azurerm_application_insights.application_insights.instrumentation_key
  content_type = "text/plain"

  key_vault_id = module.key_vault.id
}

resource "azurerm_monitor_action_group" "email" {
  name                = "PagoPA"
  resource_group_name = azurerm_resource_group.monitor_rg.name
  short_name          = "PagoPA"

  email_receiver {
    name                    = "sendtooperations"
    email_address           = data.azurerm_key_vault_secret.monitor_notification_email.value
    use_common_alert_schema = true
  }

  tags = var.tags
}

resource "azurerm_monitor_action_group" "slack" {
  name                = "SlackPagoPA"
  resource_group_name = azurerm_resource_group.monitor_rg.name
  short_name          = "SlackPagoPA"

  email_receiver {
    name                    = "sendtoslack"
    email_address           = data.azurerm_key_vault_secret.monitor_notification_slack_email.value
    use_common_alert_schema = true
  }

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "activity_log" {
  count                          = var.env_short == "p" ? 1 : 0
  name                           = "SecurityLogs"
  target_resource_id             = format("/subscriptions/%s", data.azurerm_key_vault_secret.sec_sub_id.value)
  log_analytics_workspace_id     = data.azurerm_key_vault_secret.sec_workspace_id[0].value
  storage_account_id             = data.azurerm_key_vault_secret.sec_storage_id[0].value

  log {

    category = "Administrative"
    enabled = true
    retention_policy {
      enabled = true
      days = 365
    }
  }

  log {

    category  = "Security"
    enabled = true
    retention_policy {
      enabled = true
      days = 365
    }
  }

  log {

    category = "Alert"
    enabled = true
    retention_policy {
      enabled = true
      days = 365
    }
  }
}
