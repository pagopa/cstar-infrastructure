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
  workspace_id        = azurerm_log_analytics_workspace.log_analytics_workspace.id

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

resource "azurerm_monitor_action_group" "core" {
  name                = "${var.prefix}${var.env_short}core"
  resource_group_name = azurerm_resource_group.monitor_rg.name
  short_name          = "${var.prefix}${var.env_short}core"

  email_receiver {
    name                    = "email"
    email_address           = data.azurerm_key_vault_secret.alert_core_notification_email.value
    use_common_alert_schema = true
  }

  email_receiver {
    name                    = "slack"
    email_address           = data.azurerm_key_vault_secret.alert_core_notification_slack.value
    use_common_alert_schema = true
  }

  tags = var.tags
}

resource "azurerm_monitor_action_group" "error" {
  name                = "${var.prefix}${var.env_short}error"
  resource_group_name = azurerm_resource_group.monitor_rg.name
  short_name          = "${var.prefix}${var.env_short}error"

  email_receiver {
    name                    = "email"
    email_address           = data.azurerm_key_vault_secret.alert_error_notification_email.value
    use_common_alert_schema = true
  }

  email_receiver {
    name                    = "slack"
    email_address           = data.azurerm_key_vault_secret.alert_error_notification_slack.value
    use_common_alert_schema = true
  }

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "activity_log" {
  count                      = var.env_short == "p" ? 1 : 0
  name                       = "SecurityLogs"
  target_resource_id         = format("/subscriptions/%s", data.azurerm_subscription.current.subscription_id)
  log_analytics_workspace_id = data.azurerm_key_vault_secret.sec_workspace_id[0].value
  storage_account_id         = data.azurerm_key_vault_secret.sec_storage_id[0].value

  log {
    category = "Administrative"
    enabled  = true
  }

  log {
    category = "Security"
    enabled  = true
  }

  log {
    category = "Alert"
    enabled  = true
  }

  log {
    category = "Autoscale"
    enabled  = false
  }

  log {
    category = "Policy"
    enabled  = false
  }

  log {
    category = "Recommendation"
    enabled  = false
  }

  log {
    category = "ResourceHealth"
    enabled  = false
  }

  log {
    category = "ServiceHealth"
    enabled  = false
  }
}

resource "azurerm_monitor_diagnostic_setting" "apim_diagnostic_settings" {
  count = var.env_short == "p" ? 1 : 0 # this resource should exists only in prod

  name                           = "apim-diagnostic-settings"
  target_resource_id             = module.apim.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log_analytics_workspace.id
  log_analytics_destination_type = "AzureDiagnostics"

  log {
    category = "GatewayLogs"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "WebSocketConnectionLogs"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false
    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "appgw_maz_diagnostic_settings" {
  # this resource should exists only in prod
  count = var.env_short == "p" ? 1 : 0

  name                       = "appgw-maz-diagnostic-settings"
  target_resource_id         = module.app_gw_maz.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  log {
    category = "ApplicationGatewayAccessLog"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "ApplicationGatewayPerformanceLog"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "ApplicationGatewayFirewallLog"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 365
    }
  }


  metric {
    category = "AllMetrics"
    enabled  = false
    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_kusto_cluster" "data_explorer_cluster" {
  count = var.dexp_params.enabled ? 1 : 0

  name                = replace(format("%sdataexplorer", local.project), "-", "")
  location            = azurerm_resource_group.monitor_rg.location
  resource_group_name = azurerm_resource_group.monitor_rg.name

  sku {
    name     = var.dexp_params.sku.name
    capacity = var.dexp_params.sku.capacity
  }

  dynamic "optimized_auto_scale" {
    for_each = var.dexp_params.autoscale.enabled ? [1] : []

    content {
      minimum_instances = var.dexp_params.autoscale.min_instances
      maximum_instances = var.dexp_params.autoscale.max_instances
    }
  }

  auto_stop_enabled             = false
  public_network_access_enabled = var.dexp_params.public_network_access_enabled
  double_encryption_enabled     = var.dexp_params.double_encryption_enabled
  engine                        = "V3"

  tags = var.tags
}
