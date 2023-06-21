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
resource "azapi_resource" "alert_CompleteOnboarding" {
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

# alert rule set with azapi
resource "azapi_resource" "alert_RewardOutcomeFile" {
  count = var.idpay_alert_enabled ? 1 : 0

  type      = "Microsoft.Insights/scheduledQueryRules@2022-08-01-preview"
  name      = format("%s-RewardOutcomeFile", var.prefix)
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
            metricMeasureColumn = "Count"
            operator            = "GreaterThanOrEqual"
            query               = "ContainerLog\n| where LogEntry has \"[REWARD_NOTIFICATION_FEEDBACK] Processing import request\"\n    and LogEntry has_any ('idpay-reward-notification')\n    and TimeGenerated between (ago(1d) .. now())\n| extend\n    subject = extract(\"/blobServices/default/containers/refund/blobs/([^/]+/[^/]+/import/[^,\\\"]+)\", 1, LogEntry),\n    timestamp = TimeGenerated\n| summarize minTimestamp = min(timestamp) by subject\n| join kind=leftouter (\n    ContainerLog\n    | where LogEntry has \"[PERFORMANCE_LOG] [REWARD_NOTIFICATION_FEEDBACK]\" and LogEntry has \"/import/\"\n        and LogEntry has_any ('idpay-reward-notification')\n        and TimeGenerated between (ago(1d) .. now())\n    | extend\n        subject = extract(\"/blobServices/default/containers/refund/blobs/([^/]+/[^/]+/import/[^,\\\"]+)\", 1, LogEntry),\n        timestamp = TimeGenerated\n    | summarize maxTimestamp = max(timestamp) by subject\n) on subject\n| extend Duration = coalesce(maxTimestamp, now()) - minTimestamp\n| extend Millis = Duration / 1ms, Alert = Duration > timespan(3h)\n| project Duration, Millis, Alert\n| where Alert == true\n| count"
            threshold           = 1
            timeAggregation     = "Total"
          }
        ]
      }
      description            = "Trigger alert when at least one reward outcome file take more than 3 hours to be processed"
      displayName            = "${var.domain}-${var.env_short}-RewardOutcomeFile"
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

# alert rule set with azapi
resource "azapi_resource" "alert_CosmosServerSideRetry" {
  count = var.idpay_alert_enabled ? 1 : 0

  type      = "Microsoft.Insights/scheduledQueryRules@2022-08-01-preview"
  name      = format("%s-CosmosServerSideRetry", var.prefix)
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
            metricMeasureColumn = "Count"
            operator            = "GreaterThanOrEqual"
            query               = "let startTime = ago(1h);\nlet endTime = now();\nContainerLog\n| where TimeGenerated between (startTime .. endTime)\n| where LogEntry has \"UncategorizedMongoDbException: Request timed out. Retries due to rate limiting: True\"\n| summarize count() by LogEntry, TimeGenerated\n| count"
            threshold           = 1
            timeAggregation     = "Total"
          }
        ]
      }
      description            = "Trigger alert when at least one UncategorizedMongoDbException exception appear"
      displayName            = "${var.domain}-${var.env_short}-CosmosServerSideRetry"
      enabled                = true
      evaluationFrequency    = "PT1H"
      overrideQueryTimeRange = "P2D"
      scopes = [
        data.azurerm_log_analytics_workspace.log_analytics.id
      ]
      severity            = 0
      skipQueryValidation = false
      targetResourceTypes = [
        "microsoft.operationalinsights/workspaces"
      ]
      windowSize = "PT1H"
    }
  })
}

# alert rule set with azapi
resource "azapi_resource" "alert_CreateTransaction" {
  count = var.idpay_alert_enabled ? 1 : 0

  type      = "Microsoft.Insights/scheduledQueryRules@2022-08-01-preview"
  name      = format("%s-CreateTransaction", var.prefix)
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
            dimensions = [
              {
                name     = "operation_Name"
                operator = "Include"
                values = [
                  "*"
                ]
              }
            ]
            failingPeriods = {
              minFailingPeriodsToAlert  = 1
              numberOfEvaluationPeriods = 1
            }
            metricMeasureColumn = "failurePercentage"
            operator            = "GreaterThanOrEqual"
            query               = "let startTime = ago(1d);\nlet endTime = now();\nlet operationName = dynamic([\"d-idpay-qr-code-payment-acquirer;rev=1 - createTransaction\", \"d-idpay-merchants-portal;rev=1 - createTransaction\", \"d-idpay-mil;rev=1 - createTransaction\"]);\nlet totalCount = toscalar(\n    requests\n    | where timestamp between (startTime .. endTime)\n    | where operation_Name in (operationName)\n    | summarize count() \n);\nrequests\n| where timestamp between (startTime .. endTime)\n| where operation_Name in (operationName)\n| where success == false\n| summarize failedCount = sum(itemCount), failurePercentage = round(todouble(sum(itemCount))/totalCount*100, 2) by operation_Name"
            threshold           = 10
            timeAggregation     = "Maximum"
          }
        ]
      }
      description            = "Trigger alert when the percentage of failure it's greater than 10%"
      displayName            = "${var.domain}-${var.env_short}-CreateTransaction"
      enabled                = true
      evaluationFrequency    = "P1D"
      overrideQueryTimeRange = "P2D"
      scopes = [
        data.azurerm_application_insights.application_insights.id
      ]
      severity            = 0
      skipQueryValidation = false
      targetResourceTypes = [
        "microsoft.insights/components"
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
