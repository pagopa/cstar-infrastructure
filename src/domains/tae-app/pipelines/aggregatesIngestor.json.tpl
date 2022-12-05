[
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
                    "type": "DelimitedTextReadSettings"
                }
            },
            "sink": {
                "type": "CosmosDbSqlApiSink",
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
    },
    {
        "name": "AggregatesToSftp",
        "type": "Copy",
        "dependsOn": [
            {
                "activity": "AggregatesToLog",
                "dependencyConditions": [
                    "Succeeded"
                ]
            }
        ],
        "policy": {
            "timeout": "7.00:00:00",
            "retry": ${copy_activity_retries},
            "retryIntervalInSeconds": ${copy_activity_retry_interval_seconds},
            "secureOutput": false,
            "secureInput": false
        },
        "userProperties": [],
        "typeProperties": {
            "source": {
                "type": "CosmosDbSqlApiSource",
                "query": {
                    "value": "SELECT * FROM c WHERE c.sourceFileName = \"@{pipeline().parameters.file}\"",
                    "type": "Expression"
                },
                "preferredRegions": []
            },
            "sink": {
                "type": "DelimitedTextSink",
                "storeSettings": {
                    "type": "AzureBlobStorageWriteSettings"
                },
                "formatSettings": {
                    "type": "DelimitedTextWriteSettings",
                    "quoteAllText": true,
                    "fileExtension": ".txt"
                }
            },
            "enableStaging": false,
            "translator": {
                "type": "TabularTranslator",
                "mappings": [
                    {
                        "source": {
                            "path": "$['id']"
                        },
                        "sink": {
                            "type": "String",
                            "ordinal": 1
                        }
                    },
                    {
                        "source": {
                            "path": "$['senderCode']"
                        },
                        "sink": {
                            "type": "String",
                            "ordinal": 2
                        }
                    },
                    {
                        "source": {
                            "path": "$['operationType']"
                        },
                        "sink": {
                            "type": "String",
                            "ordinal": 3
                        }
                    },
                    {
                        "source": {
                            "path": "$['transmissionDate']"
                        },
                        "sink": {
                            "type": "DateTime",
                            "format": "yyyy-MM-dd",
                            "ordinal": 4
                        }
                    },
                    {
                        "source": {
                            "path": "$['accountingDate']"
                        },
                        "sink": {
                            "type": "DateTime",
                            "format": "yyyy-MM-dd",
                            "ordinal": 5
                        }
                    },
                    {
                        "source": {
                            "path": "$['numTrx']"
                        },
                        "sink": {
                            "type": "Int32",
                            "ordinal": 6
                        }
                    },
                    {
                        "source": {
                            "path": "$['totalAmount']"
                        },
                        "sink": {
                            "type": "Int64",
                            "ordinal": 7
                        }
                    },
                    {
                        "source": {
                            "path": "$['currency']"
                        },
                        "sink": {
                            "type": "String",
                            "ordinal": 8
                        }
                    },
                    {
                        "source": {
                            "path": "$['acquirerId']"
                        },
                        "sink": {
                            "type": "String",
                            "ordinal": 9
                        }
                    },
                    {
                        "source": {
                            "path": "$['merchantId']"
                        },
                        "sink": {
                            "type": "String",
                            "ordinal": 10
                        }
                    },
                    {
                        "source": {
                            "path": "$['terminalId']"
                        },
                        "sink": {
                            "type": "String",
                            "ordinal": 11
                        }
                    },
                    {
                        "source": {
                            "path": "$['fiscalCode']"
                        },
                        "sink": {
                            "type": "String",
                            "ordinal": 12
                        }
                    },
                    {
                        "source": {
                            "path": "$['vat']"
                        },
                        "sink": {
                            "type": "String",
                            "ordinal": 13
                        }
                    },
                    {
                        "source": {
                            "path": "$['posType']"
                        },
                        "sink": {
                            "type": "String",
                            "ordinal": 14
                        }
                    }
                ]
            }
        },
        "inputs": [
            {
                "referenceName": "Aggregate",
                "type": "DatasetReference"
            }
        ],
        "outputs": [
            {
                "referenceName": "DestinationAggregate",
                "type": "DatasetReference",
                "parameters": {
                    "file": "@{pipeline().parameters.file}.gz"
                }
            }
        ]
    },
    {
        "name": "AggregatesToLog",
        "type": "Copy",
        "dependsOn": [
            {
                "activity": "SenderAggregatesToDatastore",
                "dependencyConditions": [
                    "Succeeded"
                ]
            }
        ],
        "policy": {
            "timeout": "0.12:00:00",
            "retry": ${copy_activity_retries},
            "retryIntervalInSeconds": ${copy_activity_retry_interval_seconds},
            "secureOutput": false,
            "secureInput": false
        },
        "userProperties": [],
        "typeProperties": {
            "source": {
                "type": "CosmosDbSqlApiSource",
                "query": "SELECT * FROM c WHERE c.sourceFileName = \"@{pipeline().parameters.file}\"",
                "preferredRegions": []
            },
            "sink": {
                "type": "AzureDataExplorerSink"
            },
            "enableStaging": false,
            "translator": {
                "type": "TabularTranslator",
                "mappings": [
                    {
                        "source": {
                            "path": "$['id']"
                        },
                        "sink": {
                            "type": "String",
                            "name": "id"
                        }
                    },
                    {
                        "source": {
                            "path": "$['senderCode']"
                        },
                        "sink": {
                            "type": "String",
                            "name": "senderCode"
                        }
                    },
                    {
                        "source": {
                            "path": "$['operationType']"
                        },
                        "sink": {
                            "type": "String",
                            "name": "operationType"
                        }
                    },
                    {
                        "source": {
                            "path": "$['transmissionDate']"
                        },
                        "sink": {
                            "type": "DateTime",
                            "name": "transmissionDate"
                        }
                    },
                    {
                        "source": {
                            "path": "$['accountingDate']"
                        },
                        "sink": {
                            "type": "DateTime",
                            "name": "accountingDate"
                        }
                    },
                    {
                        "source": {
                            "path": "$['numTrx']"
                        },
                        "sink": {
                            "type": "Int32",
                            "name": "numTrx"
                        }
                    },
                    {
                        "source": {
                            "path": "$['totalAmount']"
                        },
                        "sink": {
                            "type": "Int64",
                            "name": "totalAmount"
                        }
                    },
                    {
                        "source": {
                            "path": "$['currency']"
                        },
                        "sink": {
                            "type": "String",
                            "name": "currency"
                        }
                    },
                    {
                        "source": {
                            "path": "$['acquirerId']"
                        },
                        "sink": {
                            "type": "String",
                            "name": "acquirerId"
                        }
                    },
                    {
                        "source": {
                            "path": "$['merchantId']"
                        },
                        "sink": {
                            "type": "String",
                            "name": "merchantId"
                        }
                    },
                    {
                        "source": {
                            "path": "$['terminalId']"
                        },
                        "sink": {
                            "type": "String",
                            "name": "terminalId"
                        }
                    },
                    {
                        "source": {
                            "path": "$['fiscalCode']"
                        },
                        "sink": {
                            "type": "String",
                            "name": "fiscalCode"
                        }
                    },
                    {
                        "source": {
                            "path": "$['vat']"
                        },
                        "sink": {
                            "type": "String",
                            "name": "vat"
                        }
                    },
                    {
                        "source": {
                            "path": "$['posType']"
                        },
                        "sink": {
                            "type": "String",
                            "name": "posType"
                        }
                    },
                    {
                        "source": {
                            "path": "$['sourceFileName']"
                        },
                        "sink": {
                            "type": "String",
                            "name": "fileName"
                        }
                    },
                    {
                        "source": {
                            "path": "$['ingestPipelineRun']"
                        },
                        "sink": {
                            "type": "String",
                            "name": "pipelineRun"
                        }
                    },
                    {
                        "source": {
                            "path": "$['_ts']"
                        },
                        "sink": {
                            "type": "Int32",
                            "name": "timestamp"
                        }
                    }
                ]
            }
        },
        "inputs": [
            {
                "referenceName": "Aggregate",
                "type": "DatasetReference"
            }
        ],
        "outputs": [
            {
                "referenceName": "AggregatesLog",
                "type": "DatasetReference"
            }
        ]
    }
]
