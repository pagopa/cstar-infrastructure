resource "azurerm_data_factory_pipeline" "hashpan_csv_pipeline" {
  name            = "hashpan_csv_pipeline"
  data_factory_id = data.azurerm_data_factory.datafactory.id

  activities_json = file("pipelines/hashpan_csv_pipeline.json")

  depends_on = [
    azurerm_data_factory_custom_dataset.binary_destination_dataset,
    azurerm_data_factory_custom_dataset.binary_source_dataset,
    azurerm_data_factory_custom_dataset.enrolled_payment_instrument_dataset,
    azurerm_data_factory_custom_dataset.hpans_blob_csv_destination
  ]
}

resource "azurerm_data_factory_trigger_tumbling_window" "every_5_min_trigger" {

  data_factory_id = data.azurerm_data_factory.datafactory.id
  frequency       = "Minute"
  interval        = 5
  name            = "every5MinTrigger"
  start_time      = "2022-08-03T14:50:00Z"

  pipeline {
    name = azurerm_data_factory_pipeline.hashpan_csv_pipeline.name
  }

  activated = var.enable_hpan_pipeline_periodic_trigger

  depends_on = [
    azurerm_data_factory_pipeline.hashpan_csv_pipeline
  ]
}