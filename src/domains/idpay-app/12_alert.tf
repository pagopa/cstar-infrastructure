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

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "CompleteOnboarding" {

  count               = var.idpay_alert_enabled ? 1 : 0
  name                = format("%s-CompleteOnboarding", var.prefix)
  location            = data.azurerm_resource_group.monitor_rg.location
  resource_group_name = data.azurerm_resource_group.monitor_rg.name

  evaluation_frequency = "P1D"
  window_duration      = "P1D"
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
    operator                = "GreaterThanOrEqual"
    metric_measure_column   = "Percent"

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

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "RewardOutcomeFile" {

  count               = var.idpay_alert_enabled ? 1 : 0
  name                = format("%s-RewardOutcomeFile", var.prefix)
  location            = data.azurerm_resource_group.monitor_rg.location
  resource_group_name = data.azurerm_resource_group.monitor_rg.name

  evaluation_frequency = "P1D"
  window_duration      = "P1D"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      ContainerLog
| where LogEntry has "[REWARD_NOTIFICATION_FEEDBACK] Processing import request"
    and LogEntry has_any ('idpay-reward-notification')
    and TimeGenerated between (ago(1d) .. now())
| extend
    subject = extract("/blobServices/default/containers/refund/blobs/([^/]+/[^/]+/import/[^,\"]+)", 1, LogEntry),
    timestamp = TimeGenerated
| summarize minTimestamp = min(timestamp) by subject
| join kind=leftouter (
    ContainerLog
    | where LogEntry has "[PERFORMANCE_LOG] [REWARD_NOTIFICATION_FEEDBACK]" and LogEntry has "/import/"
        and LogEntry has_any ('idpay-reward-notification')
        and TimeGenerated between (ago(1d) .. now())
    | extend
        subject = extract("/blobServices/default/containers/refund/blobs/([^/]+/[^/]+/import/[^,\"]+)", 1, LogEntry),
        timestamp = TimeGenerated
    | summarize maxTimestamp = max(timestamp) by subject
    )
    on subject
| extend Duration = coalesce(maxTimestamp, now()) - minTimestamp
| extend Millis = Duration / 1ms, Alert = Duration > timespan(3h)
| project Duration, Millis, Alert
| where Alert == true
| count
      QUERY
    time_aggregation_method = "Total"
    threshold               = 1
    operator                = "GreaterThanOrEqual"
    metric_measure_column   = "Count"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  auto_mitigation_enabled          = false
  workspace_alerts_storage_enabled = false
  description                      = "Trigger alert when at least one reward outcome file take more than 3 hours to be processed"
  display_name                     = "${var.domain}-${var.env_short}-RewardOutcomeFile"
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

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "CosmosServerSideRetry" {

  count               = var.idpay_alert_enabled ? 1 : 0
  name                = format("%s-CosmosServerSideRetry", var.prefix)
  location            = data.azurerm_resource_group.monitor_rg.location
  resource_group_name = data.azurerm_resource_group.monitor_rg.name

  evaluation_frequency = "PT1H"
  window_duration      = "PT1H"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      let startTime = ago(1h);
let endTime = now();
ContainerLog
| where TimeGenerated between (startTime .. endTime)
| where LogEntry has "UncategorizedMongoDbException: Request timed out. Retries due to rate limiting: True"
| summarize count() by LogEntry, TimeGenerated
| count
      QUERY
    time_aggregation_method = "Total"
    threshold               = 1
    operator                = "GreaterThanOrEqual"
    metric_measure_column   = "Count"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  auto_mitigation_enabled          = false
  workspace_alerts_storage_enabled = false
  description                      = "Trigger alert when at least one UncategorizedMongoDbException exception appear"
  display_name                     = "${var.domain}-${var.env_short}-CosmosServerSideRetry"
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

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "CreateTransaction" {

  count               = var.idpay_alert_enabled ? 1 : 0
  name                = format("%s-CreateTransaction", var.prefix)
  location            = data.azurerm_resource_group.monitor_rg.location
  resource_group_name = data.azurerm_resource_group.monitor_rg.name

  evaluation_frequency = "P1D"
  window_duration      = "P1D"
  scopes               = [data.azurerm_application_insights.application_insights.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
let startTime = ago(1d);
let endTime = now();
let operationName = dynamic(["d-idpay-qr-code-payment-acquirer;rev=1 - createTransaction",
"d-idpay-merchants-portal;rev=1 - createTransaction",
"d-idpay-mil;rev=1 - createTransaction"]);
let totalCount =
    requests
| where timestamp between (startTime .. endTime)
| where operation_Name in (operationName)
| summarize Total = count() by operation_Name;
let data = requests
| where timestamp between (startTime .. endTime)
| where operation_Name in (operationName)
| where success == false;
data
| join kind=inner totalCount on operation_Name
| summarize Count = count(), failedCount = sum(itemCount) by operation_Name, Total
| project  operation_Name, Total, failedCount, failurePercentage = round(todouble(failedCount)/Total*100, 2)
      QUERY
    time_aggregation_method = "Maximum"
    threshold               = 10
    operator                = "GreaterThanOrEqual"
    metric_measure_column   = "failurePercentage"
    dimension {
      name     = "operation_Name"
      operator = "Include"
      values   = ["*"]
    }
    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  auto_mitigation_enabled          = false
  workspace_alerts_storage_enabled = false
  description                      = "Trigger alert when the percentage of failure it's greater than 10%"
  display_name                     = "${var.domain}-${var.env_short}-CreateTransaction"
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
