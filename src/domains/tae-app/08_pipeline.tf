resource "azurerm_data_factory_pipeline" "aggregates_ingestor" {

  name            = "aggregates_ingestor"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  parameters = {
    file = "myFile"
  }
  activities_json = file("pipelines/aggregatesIngestor.json")

  depends_on = [
    azurerm_data_factory_custom_dataset.destination_aggregate,
    azurerm_data_factory_custom_dataset.source_aggregate,
    azurerm_data_factory_custom_dataset.aggregate
  ]
}

resource "azurerm_data_factory_trigger_blob_event" "acquirer_aggregate" {

  name                  = format("%s-acquirer-aggregates-trigger", local.project)
  data_factory_id       = data.azurerm_data_factory.datafactory.id
  storage_account_id    = data.azurerm_storage_account.acquirer_sa.id
  events                = ["Microsoft.Storage.BlobCreated"]
  blob_path_begins_with = "/ade-transactions-decrypted/blobs/AGGADE."
  ignore_empty_blobs    = true
  activated             = true

  annotations = ["AcquirerAggregates"]
  description = "The trigger fires when an acquirer send aggregates files"

  pipeline {
    name = azurerm_data_factory_pipeline.aggregates_ingestor.name
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
    name = "updAggregatesWithAck"
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

  script = file("pipelines/ackIngestor.dataflow")
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
  activated = true
  time_zone = "UTC"

  annotations = ["AdeAcks"]
  description = "The trigger fires every 15 minutes"

  pipeline_name = azurerm_data_factory_pipeline.ack_ingestor.name
  pipeline_parameters = {
    windowStart = "@addminutes(trigger().scheduledTime, -15)",
    windowEnd   = "@trigger().scheduledTime"
  }

  depends_on = [
    azurerm_data_factory_custom_dataset.source_ack,
    azurerm_data_factory_custom_dataset.aggregate
  ]
}
