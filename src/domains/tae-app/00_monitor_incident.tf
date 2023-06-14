resource "azurerm_monitor_scheduled_query_rules_alert_v2" "cstar-ade-in-missing-files" {

  count = var.env_short == "p" ? 1 : 0

  name                = "tae-${var.env_short}-missing-senders-files-ade"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location

  evaluation_frequency = "P1D"
  window_duration      = "P1D"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0

  auto_mitigation_enabled          = false
  workspace_alerts_storage_enabled = false
  description                      = "Triggers whenever less of 50% of sender's files aren't forwarded to ADE for at least 5 senders."
  display_name                     = "tae-${var.env_short}-missing-senders-files-ade#INC"
  enabled                          = true

  skip_query_validation = false

  action {
    // no action
  }

  criteria {
    metric_measure_column   = "AffectedSenders"
    time_aggregation_method = "Total"
    threshold               = 5
    operator                = "GreaterThanOrEqual"
    query                   = <<-QUERY
      let regexExtractSenderCode = @"AGGADE\.([^\.]*)";
      let sendToAdeInTable = (
          StorageBlobLogs
          | where AccountName == 'cstarpsftp'
          | where OperationName in ('PutBlock', 'SftpCreate')
              and StatusCode == 201
              and Uri has "ade/in"
              and TimeGenerated >= ago(1d)
          | extend SenderCode = tostring(extract(regexExtractSenderCode, 1, Uri))
          | extend FilenameAdeIn = tostring(extract(@"in\/((.*?)\.gz)", 2, Uri))
          | distinct FilenameAdeIn, SenderCode
          | summarize CountAdeIn = count() by FilenameAdeIn, SenderCode
      );
      StorageBlobLogs
      | where AccountName == 'cstarpblobstorage'
      | where OperationName in ('PutBlob', 'PutBlock')
          and StatusCode == 201
          and Uri has "ade-transactions-decrypted"
          and TimeGenerated >= ago(1d) and TimeGenerated < ago(30m)
      | extend Filename = tostring(extract(@"ade-transactions-decrypted\/([^?]*)", 1, Uri))
      | extend SenderCode = tostring(extract(regexExtractSenderCode, 1, Filename))
      | distinct SenderCode, Filename, Uri // avoid duplicate records
      | summarize CountDecrypted = count() by Filename, SenderCode
      | join kind=leftouter (sendToAdeInTable) on $left.Filename == $right.FilenameAdeIn
      | project
          SenderCode,
          Filename,
          Decrypted = CountDecrypted,
          AdeIn = iif(isnull(CountAdeIn), 0, CountAdeIn)
      | summarize FilesDecrypted=sum(Decrypted), FilesAdeIn=sum(AdeIn) by SenderCode
      | extend Rate=min_of((todouble(FilesAdeIn) / FilesDecrypted) * 100, 100) // cause decrypted is phased out about 30min, percentage can exceed 100%
      | where Rate < 0.5
      | summarize AffectedSenders = count()
      QUERY

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }
}

