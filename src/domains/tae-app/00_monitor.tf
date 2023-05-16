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
  force_an_update_when_value_changed = "v7"
  # change this version to re-execute the script
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
  window_duration      = "P2D"
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
  enabled                          = false
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
      let committed = StorageBlobLogs
      | where TimeGenerated > ago(5m)
      | where AccountName == "cstar${var.env_short}sftp"
      | where OperationName == "SftpCommit"
      | where Uri startswith "sftp://cstar${var.env_short}sftp.blob.core.windows.net/ade/error/";
      created
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
      | where requestUri_s startswith "/pagopastorage/"
      | where httpMethod_s == "PUT"
      | where httpStatus_d !in (201, 400, 401, 409, 413, 503)
      | project
          TimeGenerated,
          Filename = split(requestUri_s, '/')[3],
          Container = split(requestUri_s, '/')[2],
          Status_Code = httpStatus_d
      | order by TimeGenerated desc
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
      | project TimeGenerated,
          Container = split(Url, '/')[4],
          Filename = split(split(Url, '/')[5],'?')[0],
          SAS_token = split(split(Url, '/')[5],'?')[1]
      | order by TimeGenerated desc
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

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "sender_fails_blob_upload_service_unavailable" {

  count = var.env_short == "p" ? 1 : 0

  name                = "cstar-${var.env_short}-sender-fails-blob-upload-service-unavailable"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      AppRequests
      | where ResultCode == 503
      | where Name startswith "PUT /pagopastorage/"
      | project TimeGenerated,
          Container = split(Url, '/')[4],
          Filename = split(split(Url, '/')[5],'?')[0],
          SAS_token = split(split(Url, '/')[5],'?')[1]
      | order by TimeGenerated desc
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
  description                      = "Triggers whenever at least one PUT request on /pagopastorage receive 503 response."
  display_name                     = "cstar-${var.env_short}-sender-fails-blob-upload-service-unavailable-#ACQ"
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
      | where todynamic(Predecessors_s)[0]["InvokedByType"] != "Manual"
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
      | where todynamic(Predecessors_s)[0]["InvokedByType"] != "Manual"
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

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "file_not_created_in_ade_out" {

  count = var.env_short == "p" ? 1 : 0

  name                = "${var.domain}-${var.env_short}-file-not-created-in-ade-out"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "P1D"
  window_duration      = "P1D"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 1
  criteria {
    query                   = <<-QUERY
      let blobsPastDaysIn = StorageBlobLogs
      | where TimeGenerated between (ago(${var.alerts_conf.max_days_just_into_ade_in}d) .. ago(1d))
      | where AccountName == "cstar${var.env_short}sftp"
      | where OperationName == 'PutBlock'
      | where Uri startswith "https://cstar${var.env_short}sftp.blob.core.windows.net:443/ade/in/"
      | project fileName = substring(Uri, 52,38)
      | distinct fileName;
      let blobsPastDaysOut = StorageBlobLogs
      | where TimeGenerated >= ago(${var.alerts_conf.max_days_just_into_ade_in}d)
      | where AccountName == "cstar${var.env_short}sftp"
      | where OperationName in ("SftpCreate", "SftpWrite", "SftpCommit")
      | where Uri startswith "sftp://cstar${var.env_short}sftp.blob.core.windows.net/ade/out/"
      | project fileName = substring(Uri, 48,38)
      | distinct fileName;
      blobsPastDaysIn
      | where fileName !in(blobsPastDaysOut)
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
  description                      = "Triggers whenever a file is not created in ade/out after ${var.alerts_conf.max_days_just_into_ade_in} days."
  display_name                     = "${var.domain}-${var.env_short}-file-not-created-in-ade-out-#ACQ"
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

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "failure_on_sas_token_endpoint" {

  count = var.env_short == "p" ? 1 : 0

  name                = "cstar-${var.env_short}-failed-obtain-sas-token"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      AzureDiagnostics
      | where url_s startswith "https://api.cstar.pagopa.it/rtd/csv-transaction"
      | where url_s endswith "/sas"
      | where isRequestSuccess_b == "false"
      | project TimeGenerated, responseCode_d, apimSubscriptionId_s, url_s
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
  description                      = "Triggers whenever a request to obtain SAS token for either RTD or TAE fails."
  display_name                     = "cstar-${var.env_short}-failed-obtain-sas-token-#ACQ"
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

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "file_already_present_on_fileregister" {

  count = var.env_short == "p" ? 1 : 0

  name                = "cstar-${var.env_short}-file-register-file-already-present"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      AppTraces
      | where AppRoleName == "rtdfileregister"
      | where SeverityLevel == 3
      | where Message startswith "File already present"
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
  description                      = "Triggers whenever at least one input file has the same name of a previously received event in file register."
  display_name                     = "cstar-${var.env_short}-file-register-file-already-present-#ACQ"
  enabled                          = false

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

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "failure_on_sender_ade_ack_list" {

  count = var.env_short == "p" ? 1 : 0

  name                = "tae-${var.env_short}-failed-get-sender-ade-ack-list"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      AzureDiagnostics
      | where url_s has "file-register/sender-ade-ack"
      | where isRequestSuccess_b == "false"
      | project TimeGenerated, backendResponseCode_d, apimSubscriptionId_s, todynamic(errors_s)[0]["message"]
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
  description                      = "Triggers whenever at least one request done to GET sender AdE ACK list fails."
  display_name                     = "tae-${var.env_short}-failed-get-sender-ade-ack-list-#ACQ"
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

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "pgp_file_already_present_on_storage_account" {

  count = var.env_short == "p" ? 1 : 0

  name                = "cstar-${var.env_short}-pgp-file-already-present-on-storage-account"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      AzureDiagnostics
      | where requestUri_s startswith "/pagopastorage/"
      | where httpMethod_s == "PUT"
      | where httpStatus_d == 409
      | project
          TimeGenerated,
          Filename = split(requestUri_s, '/')[3],
          Container = split(requestUri_s, '/')[2],
          Status_Code = httpStatus_d
      | order by TimeGenerated desc
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
  description                      = "Triggers whenever at least one file upload request returns a 409 to the sender. This happens when the pgp file being uploaded has the same name as one already present"
  display_name                     = "cstar-${var.env_short}-pgp-file-already-present-on-storage-account-#ACQ"
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

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "upload_pgp_with_no_content_length" {

  count = var.env_short == "p" ? 1 : 0

  name                = "cstar-${var.env_short}-upload-pgp-with-no-content-length"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      AzureDiagnostics
      | where requestUri_s startswith "/pagopastorage/"
      | where httpMethod_s == "PUT"
      | where httpStatus_d == 400
      | project
          TimeGenerated,
          Filename = split(requestUri_s, '/')[3],
          Container = split(requestUri_s, '/')[2],
          Status_Code = httpStatus_d
      | order by TimeGenerated desc
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
  description                      = "Triggers whenever at least one pgp file upload request has content length 0."
  display_name                     = "cstar-${var.env_short}-upload-pgp-with-no-content-length-#ACQ"
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

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "upload_pgp_with_content_length_over_allowed_size" {

  count = var.env_short == "p" ? 1 : 0

  name                = "cstar-${var.env_short}-upload-pgp-with-content-length-over-allowed-size"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      AzureDiagnostics
      | where requestUri_s startswith "/pagopastorage/"
      | where httpMethod_s == "PUT"
      | where httpStatus_d == 413
      | project
          TimeGenerated,
          Filename = split(requestUri_s, '/')[3],
          Container = split(requestUri_s, '/')[2],
          Status_Code = httpStatus_d
      | order by TimeGenerated desc
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
  description                      = "Triggers whenever at least one pgp file upload request has content length greater than allowed size."
  display_name                     = "cstar-${var.env_short}-upload-pgp-with-content-length-over-allowed-size-#ACQ"
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

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "deprecated_batch_service_version" {

  count = var.env_short == "p" ? 1 : 0

  name                = "cstar-${var.env_short}-deprecated-batch-service-version"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "P1D"
  window_duration      = "P1D"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      AzureDiagnostics
      | where url_s == "https://api.cstar.pagopa.it/rtd/csv-transaction/publickey"
      | where responseCode_d == 403
      | project TimeGenerated, apimSubscriptionId_s
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
  description                      = "Triggers whenever at least one request to get public key request returns a 403 to the sender. This happens when the Batch Service version used to do the request is considered deprecated."
  display_name                     = "cstar-${var.env_short}-deprecated-batch-service-version-#ACQ"
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
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "client-certificate-close-to-expiry-date" {

  count = var.env_short == "p" ? 1 : 0

  name                = "cstar-${var.env_short}-client-certificate-close-to-expiry-date"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "P1D"
  window_duration      = "P2D"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 2
  criteria {
    query                   = <<-QUERY
      AppRequests
      | where Url has "rtd/csv-transaction/publickey"
      | extend normalizedDateString = replace_string(tostring(Properties["Request-X-Client-Certificate-End-Date"]), '  ', ' ')
      | extend dateSplitted = split(normalizedDateString, ' ')
      | extend dateFormattedProperly = strcat(dateSplitted[1], ' ', dateSplitted[0], ' ', dateSplitted[3], ' ', dateSplitted[2], ' ',dateSplitted[4])
      | extend certificateEndDate = todatetime(dateFormattedProperly)
      | extend daysLeftBeforeExpire = datetime_diff('day', certificateEndDate, now())
      | where daysLeftBeforeExpire == 60 or daysLeftBeforeExpire == 30
      | summarize arg_max(LastRequestTimestamp=TimeGenerated, CertificateEndDate=Properties['Request-X-Client-Certificate-End-Date']) by SubscriptionId = tostring(Properties['Subscription Name'])
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
  description                      = "Triggers whenever a client certificate is going to expire in 60 or 30 days."
  display_name                     = "cstar-${var.env_short}-client-certificate-close-to-expiry-date-#ACQ"
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

}

