resource "azurerm_data_factory_pipeline" "aggregates_ingestor" {
  count = var.env_short == "p" ? 1 : 0 # this resource should exists only in prod

  name            = "aggregates_ingestor"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  parameters = {
    file = "myFile"
  }
  activities_json = templatefile("pipelines/aggregatesIngestor.json.tpl" ,{
    copy_activity_retries = var.aggregates_ingestor_conf.copy_activity_retries
    copy_activity_retry_interval_seconds = var.aggregates_ingestor_conf.copy_activity_retry_interval_seconds
  })

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
  activities_json = templatefile("pipelines/aggregatesIngestorTesting.json.tpl" ,{
    copy_activity_retries = var.aggregates_ingestor_conf.copy_activity_retries
    copy_activity_retry_interval_seconds = var.aggregates_ingestor_conf.copy_activity_retry_interval_seconds
  })

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

resource "azurerm_data_factory_pipeline" "bulk_delete_aggregates_pipeline" {
  count = var.env_short == "p" ? 0 : 1 # this resource should exists only in dev and uat

  name            = "bulk_delete_aggregates"
  data_factory_id = data.azurerm_data_factory.datafactory.id

  activities_json = file("pipelines/bulkDeleteAggregates.json")

  depends_on = [
    azurerm_data_factory_custom_dataset.aggregate,
    azurerm_data_factory_data_flow.bulk_delete_aggregates
  ]
}

resource "azurerm_data_factory_trigger_schedule" "bulk_delete_overnight_trigger" {
  count = var.env_short == "p" ? 0 : 1 # this resource should exists only in dev and uat

  name            = format("%s-bulk-delete-overnigh-trigger", local.project)
  data_factory_id = data.azurerm_data_factory.datafactory.id

  interval  = var.bulk_delete_aggregates_conf.interval
  frequency = var.bulk_delete_aggregates_conf.frequency

  schedule {
    hours   = [var.bulk_delete_aggregates_conf.hours]
    minutes = [var.bulk_delete_aggregates_conf.minutes]
  }

  activated = var.bulk_delete_aggregates_conf.enable
  time_zone = "UTC"

  annotations = ["BulkDelete"]
  description = "The trigger fires every day at 3AM"

  pipeline_name = azurerm_data_factory_pipeline.bulk_delete_aggregates_pipeline[0].name

  depends_on = [
    azurerm_data_factory_custom_dataset.aggregate
  ]
}

resource "azurerm_monitor_diagnostic_setting" "acquirer_aggregate_diagnostic_settings" {
  count = var.env_short == "p" ? 1 : 0 # this resource should exists only in prod

  name                       = "acquirer-aggregate-diagnostic-settings"
  target_resource_id         = data.azurerm_data_factory.datafactory.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics.id

  log {
    category       = null
    category_group = "allLogs"
    enabled        = true
    retention_policy {
      enabled = true
      days    = 365
    }
  }


  metric {
    category = "AllMetrics"
    enabled  = false
    retention_policy {
      enabled = false
    }
  }
}
