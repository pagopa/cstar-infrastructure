resource "azurerm_data_factory_custom_dataset" "aggregate" {

  name            = "Aggregate"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  type            = "CosmosDbSqlApiCollection"

  linked_service {
    name = azurerm_data_factory_linked_service_cosmosdb.cosmos_ls.name
  }

  type_properties_json = <<JSON
  {
    "collectionName": "aggregates"
  }
  JSON

  description = "Aggregates to be stored in Cosmos"
  annotations = ["Aggregates"]

  schema_json = file("pipelines/aggregatesSchema.json")

}


resource "azurerm_data_factory_custom_dataset" "source_aggregate" {

  name            = "SourceAggregate"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  type            = "DelimitedText"

  linked_service {
    name = azurerm_data_factory_linked_service_azure_blob_storage.storage_account_ls.name
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

  name            = "DestinationAggregate"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  type            = "DelimitedText"

  linked_service {
    name = azurerm_data_factory_linked_service_azure_blob_storage.sftp_ls.name
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
    "compressionCodec": "gzip",
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

  name            = "SourceAck"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  type            = "DelimitedText"

  linked_service {
    name = azurerm_data_factory_linked_service_azure_blob_storage.sftp_ls.name
  }

  type_properties_json = <<JSON
  {
    "location": {
      "type": "AzureBlobStorageLocation",
      "container": "ade",
      "folderPath": "ack"
    },
    "columnDelimiter": ";",
    "encodingName": "UTF-8",
    "quoteChar": ""
  }     
  JSON

  description = "ACKs sent by ADE"
  annotations = ["SourceAcks"]

  parameters = {}

  schema_json = <<JSON
  [
    {
      "name": "id",
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

resource "azurerm_data_factory_custom_dataset" "wrong_fiscal_codes_intermediate" {

  name            = "WrongFiscalCodesIntermediate"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  type            = "DelimitedText"

  linked_service {
    name = azurerm_data_factory_linked_service_azure_blob_storage.storage_account_ls.name
  }

  type_properties_json = <<JSON
  {
    "location": {
      "type": "AzureBlobStorageLocation",
      "container": "tmp",
    },
    "columnDelimiter": ";",
    "encodingName": "UTF-8",
    "escapeChar": "\\",
    "quoteChar": ""
  }
  JSON

  description = "Wrong Fiscal Codes to be intermediately stored"
  annotations = ["WrongFiscalCodesIntermediate"]

  schema_json = <<JSON
  [
    {
      "name": "senderCode",
      "type": "String"
    },
    {
      "name": "acquirerId",
      "type": "String"
    },
    {
      "name": "fiscalCode",
      "type": "String"
    }
  ]
  JSON
}


resource "azurerm_data_factory_custom_dataset" "wrong_fiscal_codes" {

  name            = "WrongFiscalCodes"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  type            = "DelimitedText"

  linked_service {
    name = azurerm_data_factory_linked_service_azure_blob_storage.storage_account_ls.name
  }

  type_properties_json = <<JSON
  {
    "location": {
      "type": "AzureBlobStorageLocation",
      "container": "sender-ade-ack",
    },
    "columnDelimiter": ";",
    "encodingName": "UTF-8",
    "escapeChar": "\\",
    "quoteChar": ""
  }     
  JSON

  description = "Wrong Fiscal Codes to be returned to Senders"
  annotations = ["WrongFiscalCodes"]

  schema_json = <<JSON
  [
    {
      "name": "senderCode",
      "type": "String"
    },
    {
      "name": "acquirerId",
      "type": "String"
    },
    {
      "name": "fiscalCode",
      "type": "String"
    }
  ]
  JSON
}
