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
# alert rule set with azapi
resource "azapi_resource" "CompleteOnboarding" {
  count = var.idpay_alert_enabled ? 1 : 0

  type      = "Microsoft.Insights/scheduledQueryRules@2022-08-01-preview"
  name      = format("%s-CompleteOnboarding", var.prefix)
  location  = "westeurope"
  parent_id = data.azurerm_resource_group.monitor_rg.id
  tags = {
    IDPAY = "IDPAY"
  }
  body = jsonencode({
    properties = {
      actions = {
        actionGroups = [
          azurerm_monitor_action_group.slackIdpay[0].id
        ]
        customProperties = {}
      }
      autoMitigate                          = false
      checkWorkspaceAlertsStorageConfigured = false
      criteria = {
        allOf = [
          {
            dimensions = []
            failingPeriods = {
              minFailingPeriodsToAlert  = 1
              numberOfEvaluationPeriods = 1
            }
            metricMeasureColumn = "Percent"
            operator            = "GreaterThanOrEqual"
            query               = "let apps = dynamic(['idpay-onboarding-workflow']);\nlet threshold = timespan(3h);\nlet startTime = ago(24h);\nlet endTime = now();\nlet logs =\n    ContainerLog\n    | where LogEntry has \"[PERFORMANCE_LOG] [SAVE_CONSENT]\" and LogEntry has_any (apps) and TimeGenerated between (startTime .. endTime)\n    | extend\n        userId = extract(\"userId: ([^,]+)\", 1, LogEntry),\n        initiativeId = extract(\"initiativeId: ([^,]+)\", 1, LogEntry),\n        timestamp = TimeGenerated //todatetime(extract(@\"(\\d{4}-\\d{2}-\\d{2}\\s\\d{2}:\\d{2}:\\d{2}\\.\\d{3})\", 0, LogEntry))\n    | summarize minTimestamp = min(timestamp) by userId, initiativeId;\nlet completedLogs =\n    ContainerLog\n    | where LogEntry has \"[PERFORMANCE_LOG] [COMPLETE_ONBOARDING]\" and LogEntry has_any (apps) and TimeGenerated between (startTime .. endTime)\n    | extend\n        userId = extract(\"userId: ([^,]+)\", 1, LogEntry),\n        initiativeId = extract(\"initiativeId: ([^,]+)\", 1, LogEntry),\n        timestamp = TimeGenerated //todatetime(extract(@\"(\\d{4}-\\d{2}-\\d{2}\\s\\d{2}:\\d{2}:\\d{2}\\.\\d{3})\", 0, LogEntry))\n    | summarize maxTimestamp = max(timestamp) by userId, initiativeId;\nlet joinedLogs =\n    logs\n    | join kind=leftouter (completedLogs) on userId, initiativeId\n    | extend Duration = coalesce(maxTimestamp, now()) - minTimestamp\n    | extend Millis = Duration / 1ms, Alert = Duration > threshold\n    | project Duration, Millis, Alert;\nlet totalAlerts = toscalar(joinedLogs | count);\nlet durationAlerts = toscalar(joinedLogs | where Alert == true | count);\nlet percentage = round(100.0 * durationAlerts / totalAlerts, 2);\n//let formattedPercentage = strcat(tostring(percentage), '%');\n//joinedLogs\nprint Percent = percentage\n"
            threshold           = 10
            timeAggregation     = "Total"
          }
        ]
      }
      description            = "The Rule Engine couldn't process the requests of onboarding"
      displayName            = "${var.domain}-${var.env_short}-Complete Onboarding"
      enabled                = true
      evaluationFrequency    = "P1D"
      overrideQueryTimeRange = "P2D"
      scopes = [
        data.azurerm_log_analytics_workspace.log_analytics.id
      ]
      severity            = 0
      skipQueryValidation = false
      targetResourceTypes = [
        "microsoft.operationalinsights/workspaces"
      ]
      windowSize = "P1D"
    }
  })
}

# In this moment this version is not supported by the 2.99 plugin,
# once the plugin is updated we can proceed with this version of alert,
# in the meantime the alert it's being set with azapi

#resource "azurerm_monitor_scheduled_query_rules_alert_v2" "CompleteOnboarding" {
#
#  count               = var.idpay_alert_enabled ? 1 : 0
#  name                = format("%s-CompleteOnboarding", var.prefix)
#  location            = data.azurerm_resource_group.monitor_rg.location
#  resource_group_name = data.azurerm_resource_group.monitor_rg.name
#
#  evaluation_frequency = "P1D"
#  window_duration      = "P2D"
#  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
#  severity             = 0
#  criteria {
#    query                   = <<-QUERY
#      let apps = dynamic(['idpay-onboarding-workflow']);
#  let threshold = timespan(3h);
#  let startTime = ago(24h);
#  let endTime = now();
#  let logs =
#    ContainerLog
#    | where LogEntry has "[PERFORMANCE_LOG] [SAVE_CONSENT]" and LogEntry has_any (apps) and TimeGenerated between (startTime .. endTime)
#    | extend
#        userId = extract("userId: ([^,]+)", 1, LogEntry),
#        initiativeId = extract("initiativeId: ([^,]+)", 1, LogEntry),
#        timestamp = TimeGenerated //todatetime(extract(@"(\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\.\d{3})", 0, LogEntry))
#    | summarize minTimestamp = min(timestamp) by userId, initiativeId;
#  let completedLogs =
#    ContainerLog
#    | where LogEntry has "[PERFORMANCE_LOG] [COMPLETE_ONBOARDING]" and LogEntry has_any (apps) and TimeGenerated between (startTime .. endTime)
#    | extend
#        userId = extract("userId: ([^,]+)", 1, LogEntry),
#        initiativeId = extract("initiativeId: ([^,]+)", 1, LogEntry),
#        timestamp = TimeGenerated //todatetime(extract(@"(\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\.\d{3})", 0, LogEntry))
#    | summarize maxTimestamp = max(timestamp) by userId, initiativeId;
#  let joinedLogs =
#    logs
#    | join kind=leftouter (completedLogs) on userId, initiativeId
#    | extend Duration = coalesce(maxTimestamp, now()) - minTimestamp
#    | extend Millis = Duration / 1ms, Alert = Duration > threshold
#    | project Duration, Millis, Alert;
#  let totalAlerts = toscalar(joinedLogs | count);
#  let durationAlerts = toscalar(joinedLogs | where Alert == true | count);
#  let percentage = round(100.0 * durationAlerts / totalAlerts, 2);
#  print Percent = percentage
#      QUERY
#    time_aggregation_method = "Total"
#    threshold               = 10
#    operator                = "GreaterThanOrEqual"
#
#    failing_periods {
#      minimum_failing_periods_to_trigger_alert = 1
#      number_of_evaluation_periods             = 1
#    }
#  }
#
#  auto_mitigation_enabled          = false
#  workspace_alerts_storage_enabled = false
#  description                      = "Trigger alert when the Rule Engine can't process the requests of onboarding"
#  display_name                     = "${var.domain}-${var.env_short}-Complete Onboarding"
#  enabled                          = true
#  query_time_range_override        = "P2D"
#  skip_query_validation            = false
#  action {
#    action_groups = [
#      azurerm_monitor_action_group.slackIdpay[0].id
#    ]
#    custom_properties = {}
#  }
#
#  tags = var.tags
#}
