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

## web availabolity test
locals {

  test_urls = [
    {
      host                 = trimsuffix(azurerm_dns_a_record.dns-a-managementcstar.fqdn, "."),
      path                 = "/ServiceStatus",
      expected_http_status = 200
    },
    {
      host                 = trimsuffix(azurerm_dns_a_record.dns_a_apim_dev_portal.fqdn, "."),
      path                 = "",
      expected_http_status = 200
    },
    {
      host                 = trimsuffix(azurerm_dns_a_record.dns_a_appgw_api.fqdn, "."),
      path                 = "",
      expected_http_status = 400
    },
    {
      host                 = trimsuffix(azurerm_dns_a_record.dns_a_appgw_api_io.fqdn, "."),
      path                 = "",
      expected_http_status = 200
    },
    ## CDN custom domains ##
    # no cdn              ##
  ]

}

module "web_test_api" {
  for_each = { for v in local.test_urls : v.host => v if v != null }
  source   = "git::https://github.com/pagopa/azurerm.git//application_insights_web_test_preview?ref=v2.8.2"

  subscription_id                   = data.azurerm_subscription.current.subscription_id
  name                              = format("%s-test", each.value.host)
  location                          = azurerm_resource_group.monitor_rg.location
  resource_group                    = azurerm_resource_group.monitor_rg.name
  application_insight_name          = azurerm_application_insights.application_insights.name
  request_url                       = format("https://%s%s", each.value.host, each.value.path)
  ssl_cert_remaining_lifetime_check = 7
  expected_http_status              = each.value.expected_http_status

  actions = [
    {
      action_group_id = azurerm_monitor_action_group.email.id,
    },
    {
      action_group_id = azurerm_monitor_action_group.slack.id,
    },
  ]

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

  optimized_auto_scale {
    minimum_instances = var.dexp_params.autoscale.min_instances
    maximum_instances = var.dexp_params.autoscale.max_instances
  }

  public_network_access_enabled = var.dexp_params.public_network_access_enabled
  double_encryption_enabled     = var.dexp_params.double_encryption_enabled
  engine                        = "V3"

  tags = var.tags

}