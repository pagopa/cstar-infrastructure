{
  "name": "SenderAggregatesToDatastore",
  "type": "Copy",
  "dependsOn": [],
  "policy": {
    "timeout": "7.00:00:00",
    "retry": 0,
    "retryIntervalInSeconds": ${copy_activity_retry_interval_seconds},
    "secureOutput": false,
    "secureInput": false
  },
  "userProperties": [],
  "typeProperties": {
    "source": {
      "type": "DelimitedTextSource",
      "additionalColumns": [
        {
          "name": "fileName",
          "value": {
            "value": "@pipeline().parameters.file",
            "type": "Expression"
          }
        },
        {
          "name": "pipelineRun",
          "value": {
            "value": "@pipeline().RunId",
            "type": "Expression"
          }
        }
      ],
      "storeSettings": {
        "type": "AzureBlobStorageReadSettings",
        "recursive": true,
        "enablePartitionDiscovery": false
      },
      "formatSettings": {
        "type": "DelimitedTextReadSettings",
        "compressionProperties": null
      }
    },
    "sink": {
      "type": "CosmosDbSqlApiSink",
      "writeBatchSize": 1000,
      "maxConcurrentConnections": 2,
      "writeBehavior": "insert"
    },
    "enableStaging": false,
    "translator": {
      "type": "TabularTranslator",
      "mappings": [
        {
          "source": {
            "type": "String",
            "ordinal": "1"
          },
          "sink": {
            "path": "$['senderCode']"
          }
        },
        {
          "source": {
            "type": "String",
            "ordinal": "2"
          },
          "sink": {
            "path": "$['operationType']"
          }
        },
        {
          "source": {
            "type": "DateTime",
            "ordinal": "3"
          },
          "sink": {
            "path": "$['transmissionDate']"
          }
        },
        {
          "source": {
            "type": "DateTime",
            "ordinal": "4"
          },
          "sink": {
            "path": "$['accountingDate']"
          }
        },
        {
          "source": {
            "type": "Int32",
            "ordinal": "5"
          },
          "sink": {
            "path": "$['numTrx']"
          }
        },
        {
          "source": {
            "type": "Int64",
            "ordinal": "6"
          },
          "sink": {
            "path": "$['totalAmount']"
          }
        },
        {
          "source": {
            "type": "String",
            "ordinal": "7"
          },
          "sink": {
            "path": "$['currency']"
          }
        },
        {
          "source": {
            "type": "String",
            "ordinal": "8"
          },
          "sink": {
            "path": "$['acquirerId']"
          }
        },
        {
          "source": {
            "type": "String",
            "ordinal": "9"
          },
          "sink": {
            "path": "$['merchantId']"
          }
        },
        {
          "source": {
            "type": "String",
            "ordinal": "10"
          },
          "sink": {
            "path": "$['terminalId']"
          }
        },
        {
          "source": {
            "type": "String",
            "ordinal": "11"
          },
          "sink": {
            "path": "$['fiscalCode']"
          }
        },
        {
          "source": {
            "type": "String",
            "ordinal": "12"
          },
          "sink": {
            "path": "$['vat']"
          }
        },
        {
          "source": {
            "type": "String",
            "ordinal": "13"
          },
          "sink": {
            "path": "$['posType']"
          }
        },
        {
          "source": {
            "name": "fileName",
            "type": "String"
          },
          "sink": {
            "path": "$['sourceFileName']"
          }
        },
        {
          "source": {
            "name": "pipelineRun",
            "type": "String"
          },
          "sink": {
            "path": "$['ingestPipelineRun']"
          }
        }
      ]
    }
  },
  "inputs": [
    {
      "referenceName": "SourceAggregate",
      "type": "DatasetReference",
      "parameters": {
        "file": {
          "value": "@pipeline().parameters.file",
          "type": "Expression"
        }
      }
    }
  ],
  "outputs": [
    {
      "referenceName": "Aggregate",
      "type": "DatasetReference"
    }
  ]
}
