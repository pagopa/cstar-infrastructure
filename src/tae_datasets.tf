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

  schema_json = <<JSON
  [
    {
      "name": "id",
      "type": "String"
    },
    {
      "name": "senderCode",
      "type": "String"
    },
    {
      "name": "operationType",
      "type": "String"
    },
    {
      "name": "transmissionDate",
      "type": "Date"
    },
    {
      "name": "accountingDate",
      "type": "Date"
    },
    {
      "name": "numTrx",
      "type": "Int32"
    },
    {
      "name": "totalAmount",
      "type": "Int32"
    },
    {
      "name": "acquirerId",
      "type": "String"
    },
    {
      "name": "merchantId",
      "type": "String"
    },
    {
      "name": "terminalId",
      "type": "String"
    },
    {
      "name": "fiscalCode",
      "type": "String"
    },
    {
      "name":  "vat",
      "type": "String"
    },
    {
      "name":  "posType",
      "type": "String"
    },
    {
      "name":  "fileName",
      "type": "String"
    },
    {
      "name":  "recordId",
      "type": "String"
    }
  ]
  JSON
}


resource "azurerm_data_factory_custom_dataset" "source_aggregate" {

  count = var.enable.tae.adf ? 1 : 0

  name            = "SourceAggregate"
  data_factory_id = data.azurerm_data_factory.tae_adf[count.index].id
  type            = "DelimitedText"

  linked_service {
    name = azurerm_data_factory_linked_service_azure_blob_storage.tae_adf_sa_linked_service[count.index].name
  }

  type_properties_json = <<JSON
  {
    "location": {
      "type": "AzureBlobStorageLocation",
      "container": "ade-transactions-decrypted",
      "fileName": {
        "value": "@dataset().file",
        "type": "Expression"
      }
    },
    "columnDelimiter": ";",
    "encodingName": "UTF-8"
  }     
  JSON

  description = "Source Aggregates sent by Acquirer"
  annotations = ["SourceAggregates"]

  parameters = {
    file = "myFile"
  }

  schema_json = <<JSON
  [
    {
      "name": "senderCode",
      "type": "String"
    },
    {
      "name": "operationType",
      "type": "String"
    },
    {
      "name": "transmissionDate",
      "type": "Date"
    },
    {
      "name": "accountingDate",
      "type": "Date"
    },
    {
      "name": "numTrx",
      "type": "Int32"
    },
    {
      "name": "totalAmount",
      "type": "Int32"
    },
    {
      "name": "currency",
      "type": "String"
    },
    {
      "name": "acquirerId",
      "type": "String"
    },
    {
      "name": "merchantId",
      "type": "String"
    },
    {
      "name": "terminalId",
      "type": "String"
    },
    {
      "name": "fiscalCode",
      "type": "String"
    },
    {
      "name":  "vat",
      "type": "String"
    },
    {
      "name":  "posType",
      "type": "String"
    }
  ]
  JSON
}

resource "azurerm_data_factory_custom_dataset" "destination_aggregate" {

  count = var.enable.tae.adf ? 1 : 0

  name            = "DestinationAggregate"
  data_factory_id = data.azurerm_data_factory.tae_adf[count.index].id
  type            = "DelimitedText"

  linked_service {
    name = azurerm_data_factory_linked_service_azure_blob_storage.tae_adf_sftp_linked_service[count.index].name
  }

  type_properties_json = <<JSON
  {
    "location": {
      "type": "AzureBlobStorageLocation",
      "container": "ade",
      "folderPath": "in",
      "fileName": {
        "value": "@dataset().file",
        "type": "Expression"
      }
    },
    "columnDelimiter": ";",
    "encodingName": "UTF-8",
    "quoteChar": ""
  }     
  JSON

  description = "Destination Aggregates for ADE"
  annotations = ["DestinationAggregates"]

  parameters = {
    file = "myFile"
  }

  schema_json = <<JSON
  [
    {
      "name": "recordId",
      "type": "String"
    },
    {
      "name": "senderCode",
      "type": "String"
    },
    {
      "name": "operationType",
      "type": "String"
    },
    {
      "name": "transmissionDate",
      "type": "Date"
    },
    {
      "name": "accountingDate",
      "type": "Date"
    },
    {
      "name": "numTrx",
      "type": "Int32"
    },
    {
      "name": "totalAmount",
      "type": "Int32"
    },
    {
      "name": "currency",
      "type": "String"
    },
    {
      "name": "acquirerId",
      "type": "String"
    },
    {
      "name": "merchantId",
      "type": "String"
    },
    {
      "name": "terminalId",
      "type": "String"
    },
    {
      "name": "fiscalCode",
      "type": "String"
    },
    {
      "name":  "vat",
      "type": "String"
    },
    {
      "name":  "posType",
      "type": "String"
    }
  ]
  JSON
}

resource "azurerm_data_factory_custom_dataset" "source_ack" {

  count = var.enable.tae.adf ? 1 : 0

  name            = "SourceAck"
  data_factory_id = data.azurerm_data_factory.tae_adf[count.index].id
  type            = "DelimitedText"

  linked_service {
    name = azurerm_data_factory_linked_service_azure_blob_storage.tae_adf_sftp_linked_service[count.index].name
  }

  type_properties_json = <<JSON
  {
    "location": {
      "type": "AzureBlobStorageLocation",
      "container": "ade/ack",
      "fileName": {
        "value": "@dataset().file",
        "type": "Expression"
      }
    },
    "columnDelimiter": ";",
    "encodingName": "UTF-8",
    "quoteChar": ""
  }     
  JSON

  description = "ACKs sent by ADE"
  annotations = ["SourceAcks"]

  parameters = {
    file = "myFile"
  }

  schema_json = <<JSON
  [
    {
      "name": "recordId",
      "type": "String"
    },
    {
      "name": "status",
      "type": "Int32"
    },
    {
      "name": "errorCode",
      "type": "String"
    }
  ]
  JSON
}