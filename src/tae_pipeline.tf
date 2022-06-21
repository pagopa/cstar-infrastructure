resource "azurerm_data_factory_pipeline" "test" {
  
  count = var.enable.tae.adf ? 1 : 0
  resource_group_name = azurerm_resource_group.tae_df_rg[count.index].name

  name            = "test"
  data_factory_id = data.azurerm_data_factory.tae_adf[count.index].id
  variables = {
    "bob" = "item1"
  }
  activities_json = <<JSON
[
    {
        "name": "Append variable1",
        "type": "AppendVariable",
        "dependsOn": [],
        "userProperties": [],
        "typeProperties": {
            "variableName": "bob",
            "value": "something"
        }
    }
]
  JSON
}

resource "azurerm_data_factory_trigger_blob_event" "acquirer_aggregate" {

  count = var.enable.tae.adf ? 1 : 0

  name                = format("%s-tae-acquirer-aggregates-trigger", local.project)
  data_factory_id     = data.azurerm_data_factory.tae_adf[count.index].id
  storage_account_id  = module.cstarblobstorage.id
  events              = ["Microsoft.Storage.BlobCreated"]
  blob_path_ends_with = ".decrypted"
  blob_path_begins_with = "/ade-transactions-decrypted/"
  ignore_empty_blobs  = true
  activated           = true

  annotations = ["AcquirerAggregates"]
  description = "The trigger fires when an acquirer send aggregates files"

  pipeline {
    name = azurerm_data_factory_pipeline.test[count.index].name
    # parameters = {
    #   Env = "Prod"
    # }
  }
}
