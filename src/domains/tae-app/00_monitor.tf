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

data "azurerm_monitor_action_group" "domain" {
  resource_group_name = var.monitor_resource_group_name
  name                = local.alert_action_group_domain_name
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
  force_an_update_when_value_changed = "v7" # change this version to re-execute the script
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

resource "azurerm_monitor_action_group" "send_to_zendesk" {

  count = var.zendesk_action_enabled.enable == true ? 1 : 0

  name                = "send_to_zendesk"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  short_name          = "send_to_zd"

  email_receiver {
    name                    = "send_to_zendesk"
    email_address           = data.azurerm_key_vault_secret.operations_zendesk_email[count.index].value
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
  display_name                     = "${var.domain}-${var.env_short}-a-sender-didnt-send-#ACQ"
  enabled                          = true
  #query_time_range_override        = "PT1H"
  skip_query_validation = false
  action {
    action_groups = [
      azurerm_monitor_action_group.send_to_operations[0].id,
      azurerm_monitor_action_group.send_to_zendesk[0].id
    ]
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
  display_name                     = "cstar-${var.env_short}-sender-auth-failed-authentications-#ACQ"
  enabled                          = true

  skip_query_validation = false
  action {
    action_groups = [
      azurerm_monitor_action_group.send_to_operations[0].id,
      azurerm_monitor_action_group.send_to_zendesk[0].id
    ]
    custom_properties = {
      key  = "value"
      key2 = "value2"
    }
  }

  tags = {
    key = "Sender Monitoring"
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "sender_auth_missing_internal_id" {

  count = var.env_short == "p" ? 1 : 0

  name                = "cstar-${var.env_short}-sender-auth-missing-internal-id"
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
      | where OperationName == "GET /sender-code"
      | where ResultCode == 404
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
  description                      = "Triggers whenever at least one 404 is returned by Sender Auth in response to a request to obtain sender codes associated to a (missing) internal ID."
  display_name                     = "cstar-${var.env_short}-sender-auth-missing-internal-id-#ACQ"
  enabled                          = true

  skip_query_validation = false
  action {
    action_groups = [
      azurerm_monitor_action_group.send_to_operations[0].id,
      azurerm_monitor_action_group.send_to_zendesk[0].id
    ]
    custom_properties = {
      key  = "value"
      key2 = "value2"
    }
  }

  tags = {
    key = "Sender Monitoring"
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "created_file_in_ade_error" {

  count = var.env_short == "p" ? 1 : 0

  name                = "${var.domain}-${var.env_short}-created-file-in-ade-error"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 1
  criteria {
    query                   = <<-QUERY
      let created = StorageBlobLogs
      | where TimeGenerated > ago(5m)
      | where AccountName == "cstar${var.env_short}sftp"
      | where OperationName == "SftpCreate"
      | where Uri startswith "sftp://cstar${var.env_short}sftp.blob.core.windows.net/ade/error/";
      let wrote = StorageBlobLogs
      | where TimeGenerated > ago(5m)
      | where AccountName == "cstar${var.env_short}sftp"
      | where OperationName == "SftpWrite"
      | where Uri startswith "sftp://cstar${var.env_short}sftp.blob.core.windows.net/ade/error/";
      let committed = StorageBlobLogs
      | where TimeGenerated > ago(5m)
      | where AccountName == "cstar${var.env_short}sftp"
      | where OperationName == "SftpCommit"
      | where Uri startswith "sftp://cstar${var.env_short}sftp.blob.core.windows.net/ade/error/";
      created
      | join kind=inner wrote on Uri
      | join kind=inner committed on Uri
      | project Uri
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
  description                      = "Triggers whenever at least one file is created through SFTP to the ade/error directory."
  display_name                     = "${var.domain}-${var.env_short}-created-file-in-ade-error-#ACQ"
  enabled                          = true

  skip_query_validation = false
  action {
    action_groups = [
      azurerm_monitor_action_group.send_to_operations[0].id,
      azurerm_monitor_action_group.send_to_zendesk[0].id
    ]
    custom_properties = {
      key  = "value"
      key2 = "value2"
    }
  }

  tags = {
    key = "Sender Monitoring"
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "sender_fails_blob_upload" {

  count = var.env_short == "p" ? 1 : 0

  name                = "cstar-${var.env_short}-sender-fails-blob-upload"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      AzureDiagnostics
      | where TimeGenerated > ago(5m)
      | where userAgent_s startswith "BatchService/"
      | where requestUri_s startswith "/pagopastorage/"
      | where httpMethod_s == "PUT"
      | where httpStatus_d != 201
      | project requestUri_s
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
  description                      = "Triggers whenever at least one PUT request on /pagopastorage fails."
  display_name                     = "cstar-${var.env_short}-sender-fails-blob-upload-#ACQ"
  enabled                          = true

  skip_query_validation = false
  action {
    action_groups = [
      azurerm_monitor_action_group.send_to_operations[0].id,
      azurerm_monitor_action_group.send_to_zendesk[0].id
    ]
    custom_properties = {
      key  = "value"
      key2 = "value2"
    }
  }

  tags = {
    key = "Sender Monitoring"
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "sender_fails_blob_upload_unauthorized" {

  count = var.env_short == "p" ? 1 : 0

  name                = "cstar-${var.env_short}-sender-fails-blob-upload-unauthorized"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      AppRequests
      | where ResultCode == 401
      | where Name startswith "PUT /pagopastorage/"
      | project TimeGenerated, Filename = substring(Url, 104, 44)
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
  description                      = "Triggers whenever at least one PUT request on /pagopastorage receive 401 response."
  display_name                     = "cstar-${var.env_short}-sender-fails-blob-upload-unauthorized-#ACQ"
  enabled                          = true

  skip_query_validation = false
  action {
    action_groups = [
      azurerm_monitor_action_group.send_to_operations[0].id,
      azurerm_monitor_action_group.send_to_zendesk[0].id
    ]
    custom_properties = {
      key  = "value"
      key2 = "value2"
    }
  }

  tags = {
    key = "Sender Monitoring"
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "ade_removes_ack_file" {

  count = var.env_short == "p" ? 1 : 0

  name                = "${var.domain}-${var.env_short}-ade-removes-ack-file"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      StorageBlobLogs
      | where TimeGenerated >= ago(5m)
      | where AccountName == "cstar${var.env_short}sftp"
      | where OperationName == "SftpRemove"
      | where Uri startswith "sftp://cstar${var.env_short}sftp.blob.core.windows.net/ade/ack/"
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
  description                      = "Triggers whenever at least one request to remove a file from ade/ack is issued through SFTP."
  display_name                     = "${var.domain}-${var.env_short}-ade-removes-ack-file-#ACQ"
  enabled                          = true

  skip_query_validation = false
  action {
    action_groups = [
      azurerm_monitor_action_group.send_to_operations[0].id,
      azurerm_monitor_action_group.send_to_zendesk[0].id
    ]
    custom_properties = {
      key  = "value"
      key2 = "value2"
    }
  }

  tags = {
    key = "Sender Monitoring"
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "not_all_chunks_are_verified_decrypter" {

  count = var.env_short == "p" ? 1 : 0

  name                = "cstar-${var.env_short}-decrypter-not-all-chunks-verified"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 1
  criteria {
    query                   = <<-QUERY
      AppTraces
      | where AppRoleName == "rtddecrypter"
      | where SeverityLevel == 3
      | where Message startswith "Not all chunks are verified, no chunks will be uploaded"
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
  description                      = "Triggers whenever at least one input file has not all of its chunks verified by the decrypter."
  display_name                     = "cstar-${var.env_short}-decrypter-not-all-chunks-verified-#ACQ"
  enabled                          = true

  skip_query_validation = false
  action {
    action_groups = [
      azurerm_monitor_action_group.send_to_operations[0].id,
      azurerm_monitor_action_group.send_to_zendesk[0].id
    ]
    custom_properties = {
      key  = "value"
      key2 = "value2"
    }
  }

  tags = {
    key = "Sender Monitoring"
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "failed_decryption" {

  count = var.env_short == "p" ? 1 : 0

  name                = "cstar-${var.env_short}-decrypter-failed-decryption"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 1
  criteria {
    query                   = <<-QUERY
      AppTraces
      | where AppRoleName == "rtddecrypter"
      | where SeverityLevel == 3
      | where Message startswith "Cannot decrypt"
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
  description                      = "Triggers whenever at least one input file cannot be decrypted."
  display_name                     = "cstar-${var.env_short}-decrypter-failed-decryption-#ACQ"
  enabled                          = true

  skip_query_validation = false
  action {
    action_groups = [
      azurerm_monitor_action_group.send_to_operations[0].id,
      azurerm_monitor_action_group.send_to_zendesk[0].id
    ]
    custom_properties = {
      key  = "value"
      key2 = "value2"
    }
  }

  tags = {
    key = "Sender Monitoring"
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "no_data_in_decryted_file" {

  count = var.env_short == "p" ? 1 : 0

  name                = "cstar-${var.env_short}-decrypter-no-data-in-decrypted-file"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 1
  criteria {
    query                   = <<-QUERY
      AppTraces
      | where AppRoleName == "rtddecrypter"
      | where SeverityLevel == 2
      | where Message startswith "No data found in decrypted file:"
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
  description                      = "Triggers whenever at least one input file contains no data once decrypted."
  display_name                     = "cstar-${var.env_short}-decrypter-no-data-in-decrypted-file-#ACQ"
  enabled                          = true

  skip_query_validation = false
  action {
    action_groups = [
      azurerm_monitor_action_group.send_to_operations[0].id,
      azurerm_monitor_action_group.send_to_zendesk[0].id
    ]
    custom_properties = {
      key  = "value"
      key2 = "value2"
    }
  }

  tags = {
    key = "Sender Monitoring"
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "wrong_name_format" {

  count = var.env_short == "p" ? 1 : 0

  name                = "cstar-${var.env_short}-decrypter-wrong-name-format"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      AppTraces
      | where AppRoleName == "rtddecrypter"
      | where SeverityLevel == 2
      | where Message startswith "Wrong name format:"
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
  description                      = "Triggers whenever at least one input file has a wrong name format (e.g. malformed date)."
  display_name                     = "cstar-${var.env_short}-decrypter-wrong-name-format-#ACQ"
  enabled                          = true

  skip_query_validation = false
  action {
    action_groups = [
      azurerm_monitor_action_group.send_to_operations[0].id,
      azurerm_monitor_action_group.send_to_zendesk[0].id
    ]
    custom_properties = {
      key  = "value"
      key2 = "value2"
    }
  }

  tags = {
    key = "Sender Monitoring"
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "ack_ingestor_failures" {

  count = var.env_short == "p" ? 1 : 0

  name                = "${var.domain}-${var.env_short}-adf-ack-ingestor-failures"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 1
  criteria {
    query                   = <<-QUERY
      AzureDiagnostics
      | where OperationName == "ack_ingestor - Failed"
      | where status_s == "Failed"
      | where pipelineName_s == "ack_ingestor"
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
  description                      = "Triggers whenever at least one ack ingestor pipeline fails."
  display_name                     = "${var.domain}-${var.env_short}-adf-ack-ingestor-failures-#ACQ"
  enabled                          = true

  skip_query_validation = false
  action {
    action_groups = [
      azurerm_monitor_action_group.send_to_operations[0].id,
      azurerm_monitor_action_group.send_to_zendesk[0].id
    ]
    custom_properties = {
      key  = "value"
      key2 = "value2"
    }
  }

  tags = {
    key = "Sender Monitoring"
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "aggregates_ingestor_failures" {

  count = var.env_short == "p" ? 1 : 0

  name                = "${var.domain}-${var.env_short}-adf-aggregates-ingestor-failures"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      AzureDiagnostics
      | where Category == "PipelineRuns"
      | where pipelineName_s == "aggregates_ingestor"
      | where OperationName == "aggregates_ingestor - Failed"
      | where status_s == "Failed"
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
  description                      = "Triggers whenever at least one aggregates ingestor pipeline fails."
  display_name                     = "${var.domain}-${var.env_short}-adf-aggregates-ingestor-failures-#ACQ"
  enabled                          = true

  skip_query_validation = false
  action {
    action_groups = [
      azurerm_monitor_action_group.send_to_operations[0].id,
      azurerm_monitor_action_group.send_to_zendesk[0].id
    ]
    custom_properties = {
      key  = "value"
      key2 = "value2"
    }
  }

  tags = {
    key = "Sender Monitoring"
  }
}
