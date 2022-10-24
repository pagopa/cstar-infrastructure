data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_resource_group_name
}

data "azurerm_resource_group" "monitor_rg" {
  name = var.monitor_resource_group_name
}

data "azurerm_monitor_action_group" "slack" {
  resource_group_name = var.monitor_resource_group_name
  name                = local.monitor_action_group_slack_name
}

data "azurerm_monitor_action_group" "email" {
  resource_group_name = var.monitor_resource_group_name
  name                = local.monitor_action_group_email_name
}

data "azurerm_kusto_cluster" "dexp_cluster" {
  count = var.dexp_tae_db_linkes_service.enable ? 1 : 0

  name                = replace(format("%sdataexplorer", local.product), "-", "")
  resource_group_name = var.monitor_resource_group_name
}

data "azurerm_kusto_database" "tae_db" {
  count = var.dexp_tae_db_linkes_service.enable ? 1 : 0

  name                = "tae"
  resource_group_name = var.monitor_resource_group_name
  cluster_name        = data.azurerm_kusto_cluster.dexp_cluster[count.index].name
}

resource "azurerm_kusto_script" "create_tables" {

  count = var.dexp_tae_db_linkes_service.enable ? 1 : 0

  name        = "CreateTables"
  database_id = data.azurerm_kusto_database.tae_db[count.index].id

  script_content                     = file("scripts/create_tables.dexp")
  continue_on_errors_enabled         = true
  force_an_update_when_value_changed = "v6" # change this version to re-execute the script
}

## Alarms

resource "azurerm_monitor_action_group" "send_to_operations" {

  count = var.env_short == "p" ? 1 : 0

  name                = "send_to_operations"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  short_name          = "send_to_ops"

  email_receiver {
    name                    = "send_to_operations"
    email_address           = data.azurerm_key_vault_secret.operations_slack_email[count.index].value
    use_common_alert_schema = true
  }

}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "sender_doesnt_send" {

  count = var.env_short == "p" ? 1 : 0

  name                = "sender-doesnt-send"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "P1D"
  window_duration      = "P1D"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      let today = StorageBlobLogs
        | where OperationName == 'PutBlob'
        | where TimeGenerated >= ago(1d)
        | extend SenderCode = tostring(extract(@".{126,126}ADE\.([\w\d]{5,5})", 1, Uri))
        | where isnotempty(SenderCode)
        | distinct SenderCode;
      let yesterday = StorageBlobLogs
        | where OperationName == 'PutBlob'
        | where TimeGenerated >= ago(2d) and TimeGenerated < ago(1d)
        | extend SenderCode = tostring(extract(@".{126,126}ADE\.([\w\d]{5,5})", 1, Uri))
        | where isnotempty(SenderCode)
        | distinct SenderCode;
      yesterday
        | join kind=leftouter today on SenderCode
        | where isempty(SenderCode1)
        | project SenderCode
      QUERY
    time_aggregation_method = "Count"
    threshold               = 0
    operator                = "GreaterThan"

    # resource_id_column    = "client_CountryOrRegion"
    # metric_measure_column = "CountByCountry"
    # dimension {
    #   name     = "client_CountryOrRegion"
    #   operator = "Exclude"
    #   values   = ["123"]
    # }
    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  auto_mitigation_enabled          = false
  workspace_alerts_storage_enabled = false
  description                      = "In the last 24h at least one sender didn't submitted files"
  display_name                     = "a-sender-didnt-send"
  enabled                          = true
  #query_time_range_override        = "PT1H"
  skip_query_validation = false
  action {
    action_groups = [azurerm_monitor_action_group.send_to_operations[0].id]
    custom_properties = {
      key  = "value"
      key2 = "value2"
    }
  }

  tags = {
    key = "Sender Monitoring"
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "sender_auth_failed_authentications" {

  count = var.env_short == "p" ? 1 : 0

  name                = "cstar-${var.env_short}-sender-auth-failed-authentications"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      AppRequests
      | where TimeGenerated >= ago(5m)
      | where ClientType != "Browser"
      | where AppRoleName == "rtdsenderauth"
      | where OperationName == "GET /authorize/{senderCode}"
      | where ResultCode == 401
      QUERY
    time_aggregation_method = "Count"
    threshold               = 0
    operator                = "GreaterThan"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  auto_mitigation_enabled          = false
  workspace_alerts_storage_enabled = false
  description                      = "Triggers whenever at least one 401 is returned in response to an unauthorized request to sender auth."
  display_name                     = "cstar-${var.env_short}-sender-auth-failed-authentications"
  enabled                          = true

  skip_query_validation = false
  action {
    action_groups = [azurerm_monitor_action_group.send_to_operations[0].id]
    custom_properties = {
      key  = "value"
      key2 = "value2"
    }
  }

  tags = {
    key = "Sender Monitoring"
  }
}
