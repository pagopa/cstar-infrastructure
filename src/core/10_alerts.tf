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
    {
      # api.env.cstar.pagopa.it
      host                 = trimsuffix(azurerm_dns_a_record.dns_a_appgw_api.fqdn, "."),
      path                 = "",
      expected_http_status = 400
    },
    {
      # management.env.cstar.pagopa.it
      host                 = trimsuffix(azurerm_dns_a_record.dns_a_appgw_api_io.fqdn, "."),
      path                 = "",
      expected_http_status = 200
    },
    ## CDN custom domains ##
    # no cdn              ##
  ]

}

module "web_test_availability_alert_rules_for_api" {
  for_each = { for v in local.test_urls : v.host => v if v != null }
  source   = "git::https://github.com/pagopa/terraform-azurerm-v3.git//application_insights_web_test_preview?ref=v6.2.1"

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
