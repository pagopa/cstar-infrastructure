resource "azurerm_data_factory_custom_dataset" "aggregate" {

  count = var.enable.tae.adf ? 1 : 0

  name            = "Aggregate"
  data_factory_id = data.azurerm_data_factory.tae_adf[count.index].id
  type            = "CosmosDbMongoDbApiCollection"

  linked_service {
    name = azurerm_data_factory_linked_service_cosmosdb_mongoapi.tae_adf_mongo_linked_service[count.index].name
  }

  type_properties_json = <<JSON
  {
    "collection": "aggregates"
  }
  JSON

  description = "Aggregates to be stored in Cosmos/MongoDB"
  annotations = ["Aggregates"]

  #   schema_json = <<JSON
  # {
  #   "type": "object",
  #   "properties": {
  #     "name": {
  #       "type": "object",
  #       "properties": {
  #         "firstName": {
  #           "type": "string"
  #         },
  #         "lastName": {
  #           "type": "string"
  #         }
  #       }
  #     },
  #     "age": {
  #       "type": "integer"
  #     }
  #   }
  # }
  # JSON
}

resource "azurerm_data_factory_dataset_delimited_text" "acquirer_aggregate" {

  count = var.enable.tae.adf ? 1 : 0

  name                = "AcquirerAggregate"
  resource_group_name = azurerm_resource_group.tae_df_rg[count.index].name
  data_factory_id     = data.azurerm_data_factory.tae_adf[count.index].id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.tae_adf_sa_linked_service[count.index].name

  azure_blob_storage_location {
    container = "ade_transaction_decrypter"
  }

  column_delimiter = ";"
}