resource "azurerm_data_factory_pipeline" "aggregates_ingestor" {

  count               = var.enable.tae.adf ? 1 : 0
  resource_group_name = azurerm_resource_group.tae_df_rg[count.index].name

  name            = "aggregates_ingestor"
  data_factory_id = data.azurerm_data_factory.tae_adf[count.index].id
  parameters = {
    file = "myFile"
  }
  activities_json = file("pipelines/aggregatesIngestor.json")
}

resource "azurerm_data_factory_trigger_blob_event" "acquirer_aggregate" {

  count = var.enable.tae.adf ? 1 : 0

  name                  = format("%s-tae-acquirer-aggregates-trigger", local.project)
  data_factory_id       = data.azurerm_data_factory.tae_adf[count.index].id
  storage_account_id    = module.cstarblobstorage.id
  events                = ["Microsoft.Storage.BlobCreated"]
  blob_path_ends_with   = ".decrypted"
  blob_path_begins_with = "/ade-transactions-decrypted/"
  ignore_empty_blobs    = true
  activated             = false

  annotations = ["AcquirerAggregates"]
  description = "The trigger fires when an acquirer send aggregates files"

  pipeline {
    name = azurerm_data_factory_pipeline.aggregates_ingestor[count.index].name
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

resource "azurerm_data_factory_pipeline" "ack_ingestor" {

  count               = var.enable.tae.adf ? 1 : 0
  resource_group_name = azurerm_resource_group.tae_df_rg[count.index].name

  name            = "ack_ingestor"
  data_factory_id = data.azurerm_data_factory.tae_adf[count.index].id

  parameters = {
    windowStart = "windowStartTime"
    windowEnd   = "windowEndTime"
  }
  activities_json = file("pipelines/ackIngestor.json")
}

resource "azurerm_data_factory_trigger_schedule" "ade_ack" {

  count = var.enable.tae.adf ? 1 : 0

  name                = format("%s-tae-ade-ack-trigger", local.project)
  resource_group_name = azurerm_resource_group.tae_df_rg[count.index].name
  data_factory_id     = data.azurerm_data_factory.tae_adf[count.index].id

  interval  = 15
  frequency = "Minute"
  activated = false

  annotations = ["AdeAcks"]
  description = "The trigger fires every 15 minutes"

  pipeline_name = azurerm_data_factory_pipeline.ack_ingestor[count.index].name
  pipeline_parameters = {
    windowStart = "@addminutes(trigger().scheduledTime, -15)",
    windowEnd   = "@trigger().scheduledTime"
  }

  depends_on = [
    azurerm_data_factory_custom_dataset.source_ack,
    azurerm_data_factory_custom_dataset.aggregate
  ]
}
