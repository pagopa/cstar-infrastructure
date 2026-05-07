locals {

  extract_not_acked_files = file("pipelines/lookup-activities/extractNotAckedFilesInCosmos.json")


  if_at_least_one_file_is_not_acked = templatefile("pipelines/if-activities/ifAtLeastOneFileIsNotAcked.json", {
    ack_ingest_and_split_dataflow = file("pipelines/dataflow-activities/ackIngestAndSplit.json")
    copy_to_trigger_event         = file("pipelines/copy-activities/copyToTriggerEvent.json")
  })

  // Invalidate flows whole activities
  invalidate_activity_content = templatefile("pipelines/data-explorer-activities/duplicateAndInvalidateFlow.json", {
    linked_service_name = azurerm_data_factory_linked_service_kusto.dexp_tae_v2[0].name
  })

  purge_activity_content = templatefile("pipelines/data-explorer-activities/purgeInvalidFlow.json", {
    linked_service_name = azurerm_data_factory_linked_service_kusto.dexp_mgmt_tae[0].name
  })

  // Pending flows whole activities

  invalidate_aggregate_activity_content = templatefile("pipelines/data-explorer-activities/invalidateAggregatesFlow.json", {
    linked_service_name = azurerm_data_factory_linked_service_kusto.dexp_tae_v2[0].name
  })

  invalidate_aggregate2022_activity_content = templatefile("pipelines/data-explorer-activities/invalidateAggregates2022Flow.json", {
    linked_service_name = azurerm_data_factory_linked_service_kusto.dexp_tae_v2[0].name
  })

  purge_aggregate_activity = templatefile("pipelines/data-explorer-activities/purgeInvalidatesAggregatesFlow.json", {
    linked_service_name = azurerm_data_factory_linked_service_kusto.dexp_mgmt_tae[0].name
  })

  purge_aggregate2022_activity = templatefile("pipelines/data-explorer-activities/purgeInvalidatesAggregates2022Flow.json", {
    linked_service_name = azurerm_data_factory_linked_service_kusto.dexp_mgmt_tae[0].name
  })

  set_ttl_activity = file("pipelines/copy-activities/deleteInvalidatedFlowFromCosmos.json")

  copy_invalidated_rows_to_csv_temp_activity = templatefile("pipelines/copy-activities/copyInvalidatedRowsToCSVTemp.json", {})

  retrieve_old_merged_records = templatefile("pipelines/copy-activities/RetrieveOldMergedRecords.json", {})

  merge_invalidated_records = templatefile("pipelines/copy-activities/MergeInvalidatedRecords.json", {})

  delete_duplicates = templatefile("pipelines/delete-activities/DeleteDuplicates.json", {})


  invalidate_and_purge_activities = templatefile("pipelines/foreach-activities/invalidateEachFlow.json", {
    copy_invalidated_rows_to_csv_temp_activity = local.copy_invalidated_rows_to_csv_temp_activity,
    invalidate_activity                        = local.invalidate_activity_content,
    purge_activity                             = local.purge_activity_content,
    set_ttl_activity                           = local.set_ttl_activity
  })

  // Pending flows whole activities
  extract_pending_files_activity = file("pipelines/lookup-activities/extractPendingFilesInCosmos.json")

  if_file_is_not_valid_activity = templatefile("pipelines/if-activities/ifFileIsNotValid.json", {
    write_pending_filename_to_file_activity         = file("pipelines/copy-activities/writePendingFilenameToFile.json"),
    write_pending_invalid_filename_to_file_activity = file("pipelines/copy-activities/writePendingInvalidFilenameToFile.json"),
    execute_invalidate_flow_pipeline_activity       = file("pipelines/execute-pipeline-activity/executeInvalidateFlowPipeline.json")
  })



  for_each_pending_file_activity = templatefile("pipelines/foreach-activities/forEachPendingFileInCosmos.json", {
    check_flow_validity_activity  = file("pipelines/lookup-activities/checkFlowValidity.json"),
    if_file_is_not_valid_activity = local.if_file_is_not_valid_activity
  })


  collect_pending_filenames_activity = file("pipelines/copy-activities/collectPendingFilenames.json")

  fail_if_at_least_one_file_is_pending = file("pipelines/fail-activities/failIfAtLeastOneFileIsPending.json")

  if_at_least_one_flow_is_pending = templatefile("pipelines/if-activities/ifAtLeastOneFlowPending.json", {
    collect_pending_filenames_activity   = local.collect_pending_filenames_activity,
    fail_if_at_least_one_file_is_pending = local.fail_if_at_least_one_file_is_pending
  })

  //  Invalidate aggregates activities

  extract_invalid_aggregates_activity = file("pipelines/lookup-activities/extractInvalidAggregates.json")

  for_each_aggregate_flow = templatefile("pipelines/foreach-activities/invalidateEachAggregate.json", {
    invalidate_aggregate_activity     = local.invalidate_aggregate_activity_content,
    invalidate_aggregate2022_activity = local.invalidate_aggregate2022_activity_content,
    purge_aggregate_activity          = local.purge_aggregate_activity,
    purge_aggregate2022_activity      = local.purge_aggregate2022_activity,
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

  activities_json = "[${local.extract_not_acked_files},${local.if_at_least_one_file_is_not_acked}]"

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

resource "azurerm_data_factory_pipeline" "invalidate_aggregates" {
  count = var.flow_invalidator_conf.enable ? 1 : 0

  name            = "invalidate_aggregates"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  parameters = {
    fileName = ""
  }

  activities_json = jsonencode([
    jsondecode(local.extract_invalid_aggregates_activity),
    jsondecode(local.for_each_aggregate_flow)
  ])

  depends_on = [
    azurerm_storage_container.invalidated_aggregates_container,
    azurerm_data_factory_custom_dataset.invalidated_aggregates
  ]

  lifecycle {
    ignore_changes = [parameters]
  }
}

resource "azurerm_data_factory_pipeline" "invalidate_flow" {
  count = var.flow_invalidator_conf.enable ? 1 : 0

  name            = "invalidate_flow"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  parameters = {
    flows = "[\"AGGADE.12345.20221231.010000.001.01000\",\"AGGADE.54321.20221231.010000.001.01000\"]"
  }

  activities_json = jsonencode([
    jsondecode(local.invalidate_and_purge_activities),
    jsondecode(local.retrieve_old_merged_records),
    jsondecode(local.merge_invalidated_records),
    jsondecode(local.delete_duplicates)
  ])

  depends_on = [
    azurerm_data_factory_custom_dataset.aggregates_log,
    azurerm_data_factory_custom_dataset.invalidated_flows
  ]

  lifecycle {
    ignore_changes = [parameters]
  }
}

resource "azurerm_data_factory_pipeline" "pending_files_in_Cosmos" {

  name            = "pending_files_in_Cosmos"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  parameters = {
    // min_days_old must be set to int after apply, Terraform doesn't currently support parameters other than String
    min_days_old = 7
  }
  activities_json = "[${local.extract_pending_files_activity},${local.for_each_pending_file_activity}, ${local.if_at_least_one_flow_is_pending}]"

  depends_on = [
    azurerm_data_factory_custom_dataset.pending_file,
    azurerm_storage_container.pending_for_ack_extraction_container,
    azurerm_data_factory_pipeline.invalidate_flow
  ]

  lifecycle {
    ignore_changes = [parameters]
  }
}

resource "azurerm_data_factory_trigger_schedule" "pending_flows_trigger" {

  name            = format("%s-pending-flows", local.project)
  data_factory_id = data.azurerm_data_factory.datafactory.id

  interval  = var.pending_flows_conf.interval
  frequency = var.pending_flows_conf.frequency
  activated = var.pending_flows_conf.enable
  time_zone = "UTC"

  schedule {
    minutes      = [var.pending_flows_conf.schedule_minutes]
    hours        = [var.pending_flows_conf.schedule_hours]
    days_of_week = var.pending_flows_conf.days_of_week
  }

  annotations = ["PendingFlows"]
  description = format("The trigger fires every %s %s", var.pending_flows_conf.interval, var.pending_flows_conf.frequency)

  pipeline_name = azurerm_data_factory_pipeline.pending_files_in_Cosmos.name
  pipeline_parameters = {
    // min_days_old must be set to int after apply, Terraform doesn't currently support parameters other than String
    min_days_old = 7
  }

  depends_on = [
    azurerm_data_factory_custom_dataset.pending_file,
    azurerm_data_factory_pipeline.pending_files_in_Cosmos
  ]
}

resource "azurerm_data_factory_pipeline" "report_duplicate_aggregates" {
  count = var.report_duplicates_conf.enable ? 1 : 0

  name            = "report_duplicate_aggregates"
  data_factory_id = data.azurerm_data_factory.datafactory.id

  activities_json = templatefile("./pipelines/report-duplicate-aggregates/activities.json", {
    data_explorer_linked_service : azurerm_data_factory_linked_service_kusto.dexp_tae_v2[0].name,
    data_explorer_retry_count : 3
  })

  parameters = {
    year = "2023"
  }

  concurrency = 1

  // Actually is not possible to specify variable type, so ignore variables changes.
  // see https://github.com/hashicorp/terraform-provider-azurerm/issues/13131
  variables = {
    exportTableName = "" // typeof string
    timeRanges      = "" // should be typeof array
    startingDate    = "" // typeof string
  }
  lifecycle {
    ignore_changes = [variables]
  }
}

resource "azurerm_data_factory_pipeline" "report_merchants" {
  count = var.report_merchants_pipeline.enable ? 1 : 0

  name            = "report_merchants"
  data_factory_id = data.azurerm_data_factory.datafactory.id

  activities_json = templatefile("./pipelines/report-merchants/activities.json", {
    data_explorer_linked_service : azurerm_data_factory_linked_service_kusto.dexp_tae_v2[0].name,
    data_explorer_retry_count : 3
  })

  parameters = {
    year = "2022"
  }

  concurrency = 1

  variables = {
    exportTableName = ""   // typeof string
    startingDate    = ""   // typeof string
    endingDate      = ""   // typeof string
    timeSpanInDays  = "7d" // typeof string
  }
}
