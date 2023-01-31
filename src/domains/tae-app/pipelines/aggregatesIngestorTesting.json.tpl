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
                            "type": "DelimitedTextReadSettings",
                            "compressionProperties": null

                        }
                    },
                    "sink": {
                        "type": "CosmosDbSqlApiSink",
                        "writeBatchSize": 1000,
                        "writeBehavior": "insert",
                        "maxConcurrentConnections": 2
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
                "name": "AggregatesToLog",
                "type": "Copy",
                "dependsOn": [
                    {
                        "activity": "Set rowsCopiedToCosmos",
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
                        "query": {
                            "value": "SELECT * FROM c WHERE c.sourceFileName = \"@{pipeline().parameters.file}\"",
                            "type": "Expression"
                        },
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
                                    "name": "id",
                                    "type": "String"
                                }
                            },
                            {
                                "source": {
                                    "path": "$['senderCode']"
                                },
                                "sink": {
                                    "name": "senderCode",
                                    "type": "String"
                                }
                            },
                            {
                                "source": {
                                    "path": "$['operationType']"
                                },
                                "sink": {
                                    "name": "operationType",
                                    "type": "String"
                                }
                            },
                            {
                                "source": {
                                    "path": "$['transmissionDate']"
                                },
                                "sink": {
                                    "name": "transmissionDate",
                                    "type": "DateTime"
                                }
                            },
                            {
                                "source": {
                                    "path": "$['accountingDate']"
                                },
                                "sink": {
                                    "name": "accountingDate",
                                    "type": "DateTime"
                                }
                            },
                            {
                                "source": {
                                    "path": "$['numTrx']"
                                },
                                "sink": {
                                    "name": "numTrx",
                                    "type": "Int32"
                                }
                            },
                            {
                                "source": {
                                    "path": "$['totalAmount']"
                                },
                                "sink": {
                                    "name": "totalAmount",
                                    "type": "Int64"
                                }
                            },
                            {
                                "source": {
                                    "path": "$['currency']"
                                },
                                "sink": {
                                    "name": "currency",
                                    "type": "String"
                                }
                            },
                            {
                                "source": {
                                    "path": "$['acquirerId']"
                                },
                                "sink": {
                                    "name": "acquirerId",
                                    "type": "String"
                                }
                            },
                            {
                                "source": {
                                    "path": "$['merchantId']"
                                },
                                "sink": {
                                    "name": "merchantId",
                                    "type": "String"
                                }
                            },
                            {
                                "source": {
                                    "path": "$['terminalId']"
                                },
                                "sink": {
                                    "name": "terminalId",
                                    "type": "String"
                                }
                            },
                            {
                                "source": {
                                    "path": "$['fiscalCode']"
                                },
                                "sink": {
                                    "name": "fiscalCode",
                                    "type": "String"
                                }
                            },
                            {
                                "source": {
                                    "path": "$['vat']"
                                },
                                "sink": {
                                    "name": "vat",
                                    "type": "String"
                                }
                            },
                            {
                                "source": {
                                    "path": "$['posType']"
                                },
                                "sink": {
                                    "name": "posType",
                                    "type": "String"
                                }
                            },
                            {
                                "source": {
                                    "path": "$['sourceFileName']"
                                },
                                "sink": {
                                    "name": "fileName",
                                    "type": "String"
                                }
                            },
                            {
                                "source": {
                                    "path": "$['ingestPipelineRun']"
                                },
                                "sink": {
                                    "name": "pipelineRun",
                                    "type": "String"
                                }
                            },
                            {
                                "source": {
                                    "path": "$['_ts']"
                                },
                                "sink": {
                                    "name": "timestamp",
                                    "type": "Int32"
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
            },
            {
                "name": "Set rowsCopiedToCosmos",
                "type": "SetVariable",
                "dependsOn": [
                    {
                        "activity": "SenderAggregatesToDatastore",
                        "dependencyConditions": [
                            "Succeeded"
                        ]
                    }
                ],
                "userProperties": [],
                "typeProperties": {
                    "variableName": "rowsCopiedToCosmos",
                    "value": {
                        "value": "@string(activity('SenderAggregatesToDatastore').output.rowsCopied)",
                        "type": "Expression"
                    }
                }
            },
            {
                "name": "If rowsCopiedToCosmos equals rowsCopiedToLog",
                "type": "IfCondition",
                "dependsOn": [
                    {
                        "activity": "AggregatesToLog",
                        "dependencyConditions": [
                            "Succeeded"
                        ]
                    }
                ],
                "userProperties": [],
                "typeProperties": {
                    "expression": {
                        "value": "@equals(variables('rowsCopiedToCosmos'),string(activity('AggregatesToLog').output.rowsCopied))",
                        "type": "Expression"
                    },
                    "ifFalseActivities": [
                        {
                            "name": "Fail rowsCopiedToCosmos equals rowsCopiedToLog",
                            "type": "Fail",
                            "dependsOn": [],
                            "userProperties": [],
                            "typeProperties": {
                                "message": {
                                    "value": "@concat('rowsCopiedToCosmos (',variables('rowsCopiedToCosmos'),') not equal to rowsCopiedToLog (',string(activity('AggregatesToLog').output.rowsCopied),')')",
                                    "type": "Expression"
                                },
                                "errorCode": "412"
                            }
                        }
                    ],
                    "ifTrueActivities": [
                        {
                            "name": "AggregatesToSftp",
                            "type": "Copy",
                            "dependsOn": [],
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
                        }
                    ]
                }
            },
            {
                "name": "If rowsCopiedToCosmos equals rowsCopiedToSFTP",
                "type": "IfCondition",
                "dependsOn": [
                    {
                        "activity": "If rowsCopiedToCosmos equals rowsCopiedToLog",
                        "dependencyConditions": [
                            "Succeeded"
                        ]
                    }
                ],
                "userProperties": [],
                "typeProperties": {
                    "expression": {
                        "value": "@equals(variables('rowsCopiedToCosmos'),string(activity('AggregatesToSftp').output.rowsCopied))",
                        "type": "Expression"
                    },
                    "ifFalseActivities": [
                        {
                            "name": "Fail rowsCopiedToCosmos equals rowsCopiedToSFTP",
                            "type": "Fail",
                            "dependsOn": [],
                            "userProperties": [],
                            "typeProperties": {
                                "message": {
                                    "value": "@concat('rowsCopiedToCosmos (',variables('rowsCopiedToCosmos'),') not equal to rowsCopiedToLog (',string(activity('AggregatesToSftp').output.rowsCopied),')')",
                                    "type": "Expression"
                                },
                                "errorCode": "412"
                            }
                        }
                    ],
                    "ifTrueActivities": [
                        {
                            "name": "AggregatesOnIntegrationContainer",
                            "type": "Copy",
                            "dependsOn": [],
                            "policy": {
                                "timeout": "0.12:00:00",
                                "retry": 3,
                                "retryIntervalInSeconds": 1800,
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
                                    "preferredRegions": [],
                                    "detectDatetime": true
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
                                    "referenceName": "IntegrationAggregates",
                                    "type": "DatasetReference",
                                    "parameters": {
                                        "file": {
                                            "value": "@{pipeline().parameters.file}.gz",
                                            "type": "Expression"
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            },
            {
                "name": "If rowsCopiedToCosmos equals rowsCopiedOnIntContainer",
                "type": "IfCondition",
                "dependsOn": [
                    {
                        "activity": "If rowsCopiedToCosmos equals rowsCopiedToSFTP",
                        "dependencyConditions": [
                            "Succeeded"
                        ]
                    }
                ],
                "userProperties": [],
                "typeProperties": {
                    "expression": {
                        "value": "@equals(variables('rowsCopiedToCosmos'),string(activity('AggregatesOnIntegrationContainer').output.rowsCopied))",
                        "type": "Expression"
                    },
                    "ifFalseActivities": [
                        {
                            "name": "Fail rowsCopiedToCosmos equals rowsCopiedOnIntContainer",
                            "type": "Fail",
                            "dependsOn": [],
                            "userProperties": [],
                            "typeProperties": {
                                "message": {
                                    "value": "@concat('rowsCopiedToCosmos (',variables('rowsCopiedToCosmos'),') not equal to rowsCopiedToLog (',string(activity('AggregatesOnIntegrationContainer').output.rowsCopied),')')",
                                    "type": "Expression"
                                },
                                "errorCode": "412"
                            }
                        }
                    ]
                }
            }
        ]
