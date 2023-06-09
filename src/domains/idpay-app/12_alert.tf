resource "azurerm_monitor_action_group" "slackIdpay" {

  count = var.idpay_alert_enabled ? 1 : 0

  name                = "SlackIdpay"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  short_name          = "Slack-idpay"

  email_receiver {
    name                    = "SlackIdpay"
    email_address           = data.azurerm_key_vault_secret.alert-slack-idpay[count.index].value
    use_common_alert_schema = true
  }

}
resource "azurerm_monitor_scheduled_query_rules_alert" "CompleteOnboarding" {
  count               = var.idpay_alert_enabled ? 1 : 0
  name                = format("%s-CompleteOnboarding", var.prefix)
  location            = data.azurerm_resource_group.monitor_rg.location
  resource_group_name = data.azurerm_resource_group.monitor_rg.name

  action {
    action_group = [
    azurerm_monitor_action_group.slackIdpay[0].id]
    email_subject = "[IDPAY][ALERT] Complete Onboarding"
  }
  data_source_id = data.azurerm_log_analytics_workspace.log_analytics.id
  description    = "Trigger alert when the Rule Engine can't process the requests of onboarding"
  enabled        = true
  query          = <<-QUERY
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
  severity       = 0
  frequency      = 1440
  time_window    = 1440
  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 10
    metric_trigger {
      operator            = "GreaterThanOrEqual"
      threshold           = 10
      metric_trigger_type = "Total"
      metric_column       = "Percent"
    }
  }
}
