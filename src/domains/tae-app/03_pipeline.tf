locals {
  invalidate_activity_content = templatefile("pipelines/data-explorer-activities/duplicateAndInvalidateFlow.json", {
    linked_service_name = azurerm_data_factory_linked_service_kusto.dexp_tae_v2[0].name
  })

  purge_activity_content = templatefile("pipelines/data-explorer-activities/purgeInvalidFlow.json", {
    linked_service_name = azurerm_data_factory_linked_service_kusto.dexp_mgmt_tae[0].name
  })

  set_ttl_activity = file("pipelines/copy-activities/deleteInvalidatedFlowFromCosmos.json")

  invalidate_and_purge_activities = templatefile("pipelines/foreach-activities/invalidateEachFlow.json", {
    invalidate_activity = local.invalidate_activity_content,
    purge_activity      = local.purge_activity_content,
    set_ttl_activity    = local.set_ttl_activity
  })

}

resource "azurerm_data_factory_pipeline" "aggregates_ingestor" {
  count = var.env_short == "p" ? 1 : 0 # this resource should exists only in prod

  name            = "aggregates_ingestor"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  parameters = {
    file = "myFile"
  }
  variables = {
    rowsCopiedToCosmos = ""
  }
  activities_json = "[${templatefile("pipelines/copy-activities/senderAggregatesToDatastore.json", {
    copy_activity_retries                = var.aggregates_ingestor_conf.copy_activity_retries
    copy_activity_retry_interval_seconds = var.aggregates_ingestor_conf.copy_activity_retry_interval_seconds
    })},${file("pipelines/copy-activities/setRowsCopiedToCosmos.json")},${templatefile("pipelines/copy-activities/aggregatesToLog.json", {
    copy_activity_retries                = var.aggregates_ingestor_conf.copy_activity_retries
    copy_activity_retry_interval_seconds = var.aggregates_ingestor_conf.copy_activity_retry_interval_seconds
    })},${templatefile("pipelines/copy-activities/rowsCopiedToCosmosEqualsRowsCopiedToLog.json", {
    copy_activity_retries                = var.aggregates_ingestor_conf.copy_activity_retries
    copy_activity_retry_interval_seconds = var.aggregates_ingestor_conf.copy_activity_retry_interval_seconds
    })},${templatefile("pipelines/copy-activities/rowsCopiedToCosmosEqualsRowsCopiedToSFTP.json", {
    copy_activity_retries                = var.aggregates_ingestor_conf.copy_activity_retries
    copy_activity_retry_interval_seconds = var.aggregates_ingestor_conf.copy_activity_retry_interval_seconds
  })}]"

  depends_on = [
    azurerm_data_factory_custom_dataset.destination_aggregate,
    azurerm_data_factory_custom_dataset.source_aggregate,
    azurerm_data_factory_custom_dataset.aggregate
  ]
}

resource "azurerm_data_factory_trigger_blob_event" "acquirer_aggregate" {
  count = var.env_short == "p" ? 1 : 0 # this resource should exists only in prod

  name                  = format("%s-acquirer-aggregates-trigger", local.project)
  data_factory_id       = data.azurerm_data_factory.datafactory.id
  storage_account_id    = data.azurerm_storage_account.acquirer_sa.id
  events                = ["Microsoft.Storage.BlobCreated"]
  blob_path_begins_with = "/ade-transactions-decrypted/blobs/AGGADE."
  ignore_empty_blobs    = true
  activated             = var.aggregates_ingestor_conf.enable

  annotations = ["AcquirerAggregates"]
  description = "The trigger fires when an acquirer send aggregates files"

  pipeline {
    name = azurerm_data_factory_pipeline.aggregates_ingestor[0].name
    parameters = {
      # folder = "@triggerBody().folderPath"
      file = "@triggerBody().fileName"
    }
  }

  depends_on = [
    azurerm_data_factory_custom_dataset.destination_aggregate,
    azurerm_data_factory_custom_dataset.source_aggregate,
    azurerm_data_factory_custom_dataset.aggregate
  ]
}

resource "azurerm_data_factory_pipeline" "aggregates_ingestor_testing" {
  count = var.env_short == "p" ? 0 : 1 # this resource should exists only in dev and uat

  name            = "aggregates_ingestor_testing"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  parameters = {
    file = "myFile"
  }
  variables = {
    rowsCopiedToCosmos = ""
  }
  activities_json = "[${templatefile("pipelines/copy-activities/senderAggregatesToDatastore.json", {
    copy_activity_retries                = var.aggregates_ingestor_conf.copy_activity_retries
    copy_activity_retry_interval_seconds = var.aggregates_ingestor_conf.copy_activity_retry_interval_seconds
    })},${file("pipelines/copy-activities/setRowsCopiedToCosmos.json")},${templatefile("pipelines/copy-activities/aggregatesToLog.json", {
    copy_activity_retries                = var.aggregates_ingestor_conf.copy_activity_retries
    copy_activity_retry_interval_seconds = var.aggregates_ingestor_conf.copy_activity_retry_interval_seconds
    })},${templatefile("pipelines/copy-activities/rowsCopiedToCosmosEqualsRowsCopiedToLog.json", {
    copy_activity_retries                = var.aggregates_ingestor_conf.copy_activity_retries
    copy_activity_retry_interval_seconds = var.aggregates_ingestor_conf.copy_activity_retry_interval_seconds
    })},${templatefile("pipelines/copy-activities/rowsCopiedToCosmosEqualsRowsCopiedToSFTPTesting.json", {
    copy_activity_retries                = var.aggregates_ingestor_conf.copy_activity_retries
    copy_activity_retry_interval_seconds = var.aggregates_ingestor_conf.copy_activity_retry_interval_seconds
    })},${templatefile("pipelines/copy-activities/rowsCopiedToCosmosEqualsRowsCopiedOnIntContainer.json", {
    copy_activity_retries                = var.aggregates_ingestor_conf.copy_activity_retries
    copy_activity_retry_interval_seconds = var.aggregates_ingestor_conf.copy_activity_retry_interval_seconds
  })}]"

  depends_on = [
    azurerm_data_factory_custom_dataset.destination_aggregate,
    azurerm_data_factory_custom_dataset.source_aggregate,
    azurerm_data_factory_custom_dataset.aggregate,
    azurerm_data_factory_custom_dataset.integration_aggregates
  ]
}

resource "azurerm_data_factory_trigger_blob_event" "acquirer_aggregate_testing" {
  count = var.env_short == "p" ? 0 : 1 # this resource should exists only in dev and uat

  name                  = format("%s-acquirer-aggregates-trigger", local.project)
  data_factory_id       = data.azurerm_data_factory.datafactory.id
  storage_account_id    = data.azurerm_storage_account.acquirer_sa.id
  events                = ["Microsoft.Storage.BlobCreated"]
  blob_path_begins_with = "/ade-transactions-decrypted/blobs/AGGADE."
  ignore_empty_blobs    = true
  activated             = var.aggregates_ingestor_conf.enable

  annotations = ["AcquirerAggregatesTesting"]
  description = "The trigger fires when an acquirer send aggregates files"

  pipeline {
    name = azurerm_data_factory_pipeline.aggregates_ingestor_testing[0].name
    parameters = {
      # folder = "@triggerBody().folderPath"
      file = "@triggerBody().fileName"
    }
  }

  depends_on = [
    azurerm_data_factory_custom_dataset.destination_aggregate,
    azurerm_data_factory_custom_dataset.source_aggregate,
    azurerm_data_factory_custom_dataset.aggregate,
    azurerm_data_factory_custom_dataset.integration_aggregates
  ]
}

resource "azurerm_data_factory_data_flow" "ack_joinupdate" {

  name            = "ackjoinupdate"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  source {
    name = "sourceAck"

    dataset {
      name = azurerm_data_factory_custom_dataset.source_ack.name
    }
  }

  source {
    name = "aggregates"

    dataset {
      name = azurerm_data_factory_custom_dataset.aggregate.name
    }
  }

  sink {
    name = "acksLog"

    dataset {
      name = azurerm_data_factory_custom_dataset.ack_log[0].name
    }
  }

  sink {
    name = "aggregatesWithAck"

    dataset {
      name = azurerm_data_factory_custom_dataset.aggregate.name
    }
  }

  sink {
    name = "wrongFiscalCodesByAcquirer"

    dataset {
      name = azurerm_data_factory_custom_dataset.wrong_fiscal_codes_intermediate.name
    }
  }

  transformation {
    name = "addPipelineRunId"
  }

  transformation {
    name = "deleteAggregatesWithAck"
  }

  transformation {
    name = "addFileName"
  }

  transformation {
    name = "joinAcksWithAggregatesOnId"
  }

  transformation {
    name = "projectSenderAdeAck"
  }

  transformation {
    name = "selectByStatusNotOk"
  }

  transformation {
    name = "projectOnlyOneID"
  }

  transformation {
    name        = "addttl"
    description = "Adds ttl column"
  }

  script = templatefile("pipelines/ackIngestor.dataflow", {
    throughput-cap = var.ack_ingestor_conf.sink_thoughput_cap
  })
}

resource "azurerm_data_factory_data_flow" "bulk_delete_aggregates" {
  count = var.env_short == "p" ? 0 : 1 # this resource should exists only in dev and uat

  name            = "bulkDeleteAggregates"
  data_factory_id = data.azurerm_data_factory.datafactory.id

  source {
    name = "aggregates"

    dataset {
      name = azurerm_data_factory_custom_dataset.aggregate.name
    }
  }

  sink {
    name = "aggregatesWithAck"

    dataset {
      name = azurerm_data_factory_custom_dataset.aggregate.name
    }
  }

  transformation {
    name        = "addttl"
    description = "Adds ttl column"
  }

  transformation {
    name = "deleteAggregatesWithAck"
  }

  script = templatefile("pipelines/bulkDeleteAggregates.dataflow", {
    throughput-cap          = var.bulk_delete_aggregates_conf.sink_thoughput_cap
    write-throughput-budget = var.bulk_delete_aggregates_conf.sink_write_throughput_budget
  })
}

resource "azurerm_data_factory_pipeline" "ack_ingestor" {

  name            = "ack_ingestor"
  data_factory_id = data.azurerm_data_factory.datafactory.id

  parameters = {
    windowStart = "windowStartTime"
    windowEnd   = "windowEndTime"
  }
  activities_json = file("pipelines/ackIngestor.json")

  depends_on = [
    azurerm_data_factory_custom_dataset.source_ack,
    azurerm_data_factory_custom_dataset.aggregate,
    azurerm_data_factory_data_flow.ack_joinupdate
  ]
}

resource "azurerm_data_factory_trigger_schedule" "ade_ack" {

  name            = format("%s-ade-ack-trigger", local.project)
  data_factory_id = data.azurerm_data_factory.datafactory.id

  interval  = var.ack_ingestor_conf.interval
  frequency = var.ack_ingestor_conf.frequency
  activated = var.ack_ingestor_conf.enable
  time_zone = "UTC"

  annotations = ["AdeAcks"]
  description = format("The trigger fires every %s minutes", var.ack_ingestor_conf.interval)

  pipeline_name = azurerm_data_factory_pipeline.ack_ingestor.name
  pipeline_parameters = {
    windowStart = format("@addminutes(trigger().scheduledTime, -%s)", var.ack_ingestor_conf.interval)
    windowEnd   = "@trigger().scheduledTime"
  }

  depends_on = [
    azurerm_data_factory_custom_dataset.source_ack,
    azurerm_data_factory_custom_dataset.aggregate
  ]
}

resource "azurerm_data_factory_pipeline" "delete_aggregates_by_timestamp_pipeline" {
  count = var.env_short == "p" ? 0 : 1 # this resource should exists only in dev and uat

  name            = "delete_aggregates_by_timestamp"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  parameters = {
    start_ing      = "0",
    start_cleaning = "0",
    schedule_time  = "0",
    coeff          = 24
  }

  variables = {
    query  = ""
    ts_min = ""
  }

  activities_json = file("pipelines/deleteAggregatesByTimestamp.json")

  depends_on = [
    azurerm_data_factory_custom_dataset.aggregate,
  ]
}

resource "azurerm_monitor_diagnostic_setting" "acquirer_aggregate_diagnostic_settings" {
  count = var.env_short == "p" ? 1 : 0 # this resource should exists only in prod

  name                           = "acquirer-aggregate-diagnostic-settings"
  target_resource_id             = data.azurerm_data_factory.datafactory.id
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.log_analytics.id
  log_analytics_destination_type = "AzureDiagnostics"

  metric {
    category = "AllMetrics"
    enabled  = false
  }

  enabled_log {
    category       = "ActivityRuns"
    category_group = null
  }

  enabled_log {
    category       = "PipelineRuns"
    category_group = null
  }

  enabled_log {
    category       = "TriggerRuns"
    category_group = null
  }

  # enabled_log {
  #   category = "SSISIntegrationRuntimeLogs"
  # }

  # enabled_log {
  #   category = "SSISPackageEventMessageContext"
  # }

  # enabled_log {
  #   category = "SSISPackageEventMessages"
  # }

  # enabled_log {
  #   category = "SSISPackageExecutableStatistics"
  # }

  # enabled_log {
  #   category = "SSISPackageExecutionComponentPhases"
  # }

  # enabled_log {
  #   category = "SSISPackageExecutionDataStatistics"
  # }

  # enabled_log {
  #   category = "SandboxActivityRuns"
  # }

  # enabled_log {
  #   category = "SandboxPipelineRuns"
  # }

  # enabled_log {
  #   category = "AirflowDagProcessingLogs"
  # }

  # enabled_log {
  #   category = "AirflowSchedulerLogs"
  # }

  # enabled_log {
  #   category = "AirflowTaskLogs"
  # }

  # enabled_log {
  #   category = "AirflowWebLogs"
  # }

  # enabled_log {
  #   category = "AirflowWorkerLogs"
  # }
}

resource "azurerm_data_factory_pipeline" "invalidate_flow" {
  count = var.flow_invalidator_conf.enable ? 1 : 0

  name            = "invalidate_flow"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  parameters = {
    flows = "[\"AGGADE.12345.20221231.010000.001.01000\",\"AGGADE.54321.20221231.010000.001.01000\"]"
  }
  activities_json = "[${local.invalidate_and_purge_activities}]"

  depends_on = [
    azurerm_data_factory_custom_dataset.aggregates_log
  ]
}

resource "azurerm_data_factory_pipeline" "report_duplicate_aggregates" {
  name            = "report_duplicate_aggregates"
  data_factory_id = data.azurerm_data_factory.datafactory.id

  activities_json = templatefile("./pipelines/report-duplicate-aggregates/activities.json", {
    data_explorer_linked_service : azurerm_data_factory_linked_service_kusto.dexp_tae_v2[0].name,
    data_explorer_retry_count : 3
  })

  parameters = {
    year = "2022"
  }

  variables = {
    exportTableName   = ""
    month_start_dates = ""
    startingDate      = ""
  }

  concurrency = 1
}
