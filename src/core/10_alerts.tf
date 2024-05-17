## web availability test
locals {

  test_urls = [
    {
      # management.env.cstar.pagopa.it
      host                 = trimsuffix(azurerm_dns_a_record.dns-a-managementcstar.fqdn, "."),
      path                 = "/ServiceStatus",
      expected_http_status = 200
    },
    {
      # portal.env.cstar.pagopa.it
      host                 = trimsuffix(azurerm_dns_a_record.dns_a_apim_dev_portal.fqdn, "."),
      path                 = "",
      expected_http_status = 200
    },
    ## CDN custom domains ##
    # no cdn              ##
  ]

  actions = flatten([
    {
      action_group_id = azurerm_monitor_action_group.slack.id,
    },
    var.env_short == "p" ? [{ action_group_id = azurerm_monitor_action_group.core_send_to_opsgenie.id }] : []
  ])
}

module "web_test_availability_alert_rules_for_api" {
  for_each = { for v in local.test_urls : v.host => v if v != null }
  source   = "git::https://github.com/pagopa/terraform-azurerm-v3.git//application_insights_web_test_preview?ref=v8.13.0"

  subscription_id                   = data.azurerm_subscription.current.subscription_id
  name                              = "${each.value.host}-test-avail"
  location                          = azurerm_resource_group.monitor_rg.location
  resource_group                    = azurerm_resource_group.monitor_rg.name
  application_insight_name          = azurerm_application_insights.application_insights.name
  application_insight_id            = azurerm_application_insights.application_insights.id
  request_url                       = "https://${each.value.host}${each.value.path}"
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

resource "azurerm_application_insights_standard_web_test" "web_test_availability_for_api_cstar" {
  count = var.web_test_api.enable ? 1 : 0

  name                    = "${trimsuffix(azurerm_dns_a_record.dns_a_appgw_api.fqdn, ".")}-test-avail-${azurerm_application_insights.application_insights.name}"
  resource_group_name     = azurerm_resource_group.monitor_rg.name
  location                = azurerm_resource_group.monitor_rg.location
  application_insights_id = azurerm_application_insights.application_insights.id
  geo_locations           = ["emea-nl-ams-azr"]
  description             = "HTTP Standard WebTests ${trimsuffix(azurerm_dns_a_record.dns_a_appgw_api.fqdn, ".")}-test-avail-${azurerm_application_insights.application_insights.name} running on: emea-nl-ams-azr"
  frequency               = 300
  enabled                 = true
  retry_enabled           = false
  timeout                 = 30
  tags = {
    "hidden-link:/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${azurerm_resource_group.monitor_rg.name}/providers/Microsoft.Insights/components/${azurerm_application_insights.application_insights.name}" : "Resource"
  }

  validation_rules {
    expected_status_code        = 400
    ssl_cert_remaining_lifetime = 7
    ssl_check_enabled           = true
  }

  request {
    url       = "https://${trimsuffix(azurerm_dns_a_record.dns_a_appgw_api.fqdn, ".")}"
    body      = null
    http_verb = "GET"
  }
}

resource "azurerm_monitor_metric_alert" "web_test_availability_alert_rules_for_api_cstar" {
  count = var.metric_alert_api_io.enable ? 1 : 0

  name                = "${trimsuffix(azurerm_dns_a_record.dns_a_appgw_api.fqdn, ".")}-test-avail-${azurerm_application_insights.application_insights.name}"
  resource_group_name = azurerm_resource_group.monitor_rg.name
  scopes              = [azurerm_application_insights.application_insights.id]
  description         = "Whenever the average availabilityresults/availabilitypercentage is less than 1"
  severity            = 2
  frequency           = var.metric_alert_api.frequency
  auto_mitigate       = false
  enabled             = true
  window_size         = var.metric_alert_api.window_size


  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "availabilityResults/availabilityPercentage"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 1

    dimension {
      name     = "availabilityResult/name"
      operator = "Include"
      values   = ["${trimsuffix(azurerm_dns_a_record.dns_a_appgw_api.fqdn, ".")}-test-avail-${azurerm_application_insights.application_insights.name}"]
    }
  }

  dynamic "action" {
    for_each = local.actions
    content {
      action_group_id = action.value["action_group_id"]
    }
  }

  depends_on = [
    azurerm_application_insights_standard_web_test.web_test_availability_for_api_cstar
  ]
}


resource "azurerm_application_insights_standard_web_test" "web_test_availability_for_api_io_cstar" {
  count = var.web_test_api_io.enable ? 1 : 0

  name                    = "${trimsuffix(azurerm_dns_a_record.dns_a_appgw_api_io.fqdn, ".")}-test-avail-${azurerm_application_insights.application_insights.name}"
  resource_group_name     = azurerm_resource_group.monitor_rg.name
  location                = azurerm_resource_group.monitor_rg.location
  application_insights_id = azurerm_application_insights.application_insights.id
  geo_locations           = ["emea-nl-ams-azr"]
  description             = "HTTP Standard WebTests ${trimsuffix(azurerm_dns_a_record.dns_a_appgw_api_io.fqdn, ".")}-test-avail-${azurerm_application_insights.application_insights.name} running on: emea-nl-ams-azr"
  frequency               = 300
  enabled                 = true
  retry_enabled           = false
  timeout                 = 30
  tags = {
    "hidden-link:/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${azurerm_resource_group.monitor_rg.name}/providers/Microsoft.Insights/components/${azurerm_application_insights.application_insights.name}" : "Resource"
  }

  request {
    url       = "https://${trimsuffix(azurerm_dns_a_record.dns_a_appgw_api_io.fqdn, ".")}"
    body      = null
    http_verb = "GET"
  }

  validation_rules {
    expected_status_code        = 200
    ssl_cert_remaining_lifetime = 1
    ssl_check_enabled           = false
  }
}

resource "azurerm_monitor_metric_alert" "web_test_availability_alert_rules_for_api_io_cstar" {
  count = var.web_test_api_io.enable ? 1 : 0

  name                = "${trimsuffix(azurerm_dns_a_record.dns_a_appgw_api_io.fqdn, ".")}-test-avail-${azurerm_application_insights.application_insights.name}"
  resource_group_name = azurerm_resource_group.monitor_rg.name
  scopes              = [azurerm_application_insights.application_insights.id]
  description         = "Whenever the average availabilityresults/availabilitypercentage is less than 1"
  severity            = 2
  frequency           = var.metric_alert_api_io.frequency
  auto_mitigate       = false
  enabled             = true
  window_size         = var.metric_alert_api_io.window_size


  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "availabilityResults/availabilityPercentage"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 1

    dimension {
      name     = "availabilityResult/name"
      operator = "Include"
      values   = ["${trimsuffix(azurerm_dns_a_record.dns_a_appgw_api_io.fqdn, ".")}-test-avail-${azurerm_application_insights.application_insights.name}"]
    }
  }

  dynamic "action" {
    for_each = local.actions
    content {
      action_group_id = action.value["action_group_id"]
    }
  }

  depends_on = [
    azurerm_application_insights_standard_web_test.web_test_availability_for_api_io_cstar
  ]
}
