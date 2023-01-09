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
      "type": "Int64"
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
      "type": "Int64"
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

resource "azurerm_data_factory_custom_dataset" "integration_aggregates" {
  count = var.env_short == "p" ? 0 : 1 # this resource should exists only in dev and uat

  name            = "IntegrationAggregates"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  type            = "DelimitedText"

  linked_service {
    name = azurerm_data_factory_linked_service_azure_blob_storage.storage_account_ls.name
  }

  type_properties_json = <<JSON
  {
    "location": {
      "type": "AzureBlobStorageLocation",
      "container": "ade-integration-aggregates",
      "fileName": {
        "value": "@dataset().file",
        "type": "Expression"
      }
    },
    "columnDelimiter": ";",
    "compressionCodec": "gzip",
    "encodingName": "UTF-8",
    "escapeChar": "\\",
    "quoteChar": ""
  }
  JSON

  description = "Destination Aggregates sent by Acquirer and stored for integration purposes"
  annotations = ["IntegrationAggregates"]

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
      "type": "Int64"
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
      "folderPath": {
        "type": "Expression",
        "value": "@pipeline().RunId"
      }
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
      "container": "sender-ade-ack"
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

resource "azurerm_data_factory_custom_dataset" "aggregates_log" {

  count = var.dexp_tae_db_linkes_service.enable ? 1 : 0

  name            = "AggregatesLog"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  type            = "AzureDataExplorerTable"

  linked_service {
    name = azurerm_data_factory_linked_service_kusto.dexp_tae[count.index].name
  }

  type_properties_json = <<JSON
  {
    "table": "Aggregates"
  }
  JSON

  description = "Log of Aggregates received from Senders"
  annotations = ["AggregatesLog"]

  schema_json = <<JSON
  [
    {
      "name": "id",
      "type": "string"
    },
    {
      "name": "senderCode",
      "type": "string"
    },
    {
      "name": "operationType",
      "type": "string"
    },
    {
      "name": "transmissionDate",
      "type": "datetime"
    },
    {
      "name": "accountingDate",
      "type": "datetime"
    },
    {
      "name": "numTrx",
      "type": "int"
    },
    {
      "name": "totalAmount",
      "type": "long"
    },
    {
      "name": "currency",
      "type": "string"
    },
    {
      "name": "acquirerId",
      "type": "string"
    },
    {
      "name": "merchantId",
      "type": "string"
    },
    {
      "name": "terminalId",
      "type": "string"
    },
    {
      "name": "fiscalCode",
      "type": "string"
    },
    {
      "name": "vat",
      "type": "string"
    },
    {
      "name": "posType",
      "type": "string"
    },
    {
      "name": "fileName",
      "type": "string"
    },
    {
      "name": "pipelineRun",
      "type": "string"
    },
    {
      "name": "timestamp",
      "type": "datetime"
    }
  ]
  JSON
}

resource "azurerm_data_factory_custom_dataset" "ack_log" {

  count = var.dexp_tae_db_linkes_service.enable ? 1 : 0

  name            = "AcksLog"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  type            = "AzureDataExplorerTable"

  linked_service {
    name = azurerm_data_factory_linked_service_kusto.dexp_tae[count.index].name
  }

  type_properties_json = <<JSON
  {
    "table": "Acks"
  }
  JSON

  description = "Log of Acks received from ADE"
  annotations = ["AcksLog"]

  schema_json = <<JSON
  [
    {
      "name": "id",
      "type": "string"
    },
    {
      "name": "status",
      "type": "int"
    },
    {
      "name": "errorCode",
      "type": "string"
    },
    {
      "name": "fileName",
      "type": "string"
    },
    {
      "name": "pipelineRun",
      "type": "string"
    }
  ]
  JSON
}
