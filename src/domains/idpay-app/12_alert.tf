resource "azurerm_monitor_action_group" "slackIdpay" {

  count = var.idpay_alert_enabled ? 1 : 0

  name                = "slackIdpay"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  short_name          = "send_to_idpay_slack"

  email_receiver {
    name                    = "slackIdpay"
    email_address           = data.azurerm_key_vault_secret.alert-slack-idpay[count.index].value
    use_common_alert_schema = true
  }

}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "CompleteOnboarding" {

  count = var.idpay_alert_enabled ? 1 : 0

  name                = "CompleteOnboarding"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "P1D"
  window_duration      = "P2D"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      let apps = dynamic(['idpay-onboarding-workflow']);
  let threshold = timespan(3h);
  let startTime = ago(24h);
  let endTime = now();
  let logs =
    ContainerLog
    | where LogEntry has "[PERFORMANCE_LOG] [SAVE_CONSENT]" and LogEntry has_any (apps) and TimeGenerated between (startTime .. endTime)
    | extend
        userId = extract("userId: ([^,]+)", 1, LogEntry),
        initiativeId = extract("initiativeId: ([^,]+)", 1, LogEntry),
        timestamp = TimeGenerated //todatetime(extract(@"(\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\.\d{3})", 0, LogEntry))
    | summarize minTimestamp = min(timestamp) by userId, initiativeId;
  let completedLogs =
    ContainerLog
    | where LogEntry has "[PERFORMANCE_LOG] [COMPLETE_ONBOARDING]" and LogEntry has_any (apps) and TimeGenerated between (startTime .. endTime)
    | extend
        userId = extract("userId: ([^,]+)", 1, LogEntry),
        initiativeId = extract("initiativeId: ([^,]+)", 1, LogEntry),
        timestamp = TimeGenerated //todatetime(extract(@"(\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\.\d{3})", 0, LogEntry))
    | summarize maxTimestamp = max(timestamp) by userId, initiativeId;
  let joinedLogs =
    logs
    | join kind=leftouter (completedLogs) on userId, initiativeId
    | extend Duration = coalesce(maxTimestamp, now()) - minTimestamp
    | extend Millis = Duration / 1ms, Alert = Duration > threshold
    | project Duration, Millis, Alert;
  let totalAlerts = toscalar(joinedLogs | count);
  let durationAlerts = toscalar(joinedLogs | where Alert == true | count);
  let percentage = round(100.0 * durationAlerts / totalAlerts, 2);
  print Percent = percentage
      QUERY
    time_aggregation_method = "Total"
    threshold               = 10
    operator                = "GreaterThan"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  auto_mitigation_enabled          = false
  workspace_alerts_storage_enabled = false
  description                      = "Trigger alert when the Rule Engine can't process the requests of onboarding"
  display_name                     = "${var.domain}-${var.env_short}-Complete Onboarding"
  enabled                          = true
  query_time_range_override        = "P2D"
  skip_query_validation            = false
  action {
    action_groups = [
      azurerm_monitor_action_group.slackIdpay[0].id
    ]
    custom_properties = {}
  }

  tags = var.tags
}
