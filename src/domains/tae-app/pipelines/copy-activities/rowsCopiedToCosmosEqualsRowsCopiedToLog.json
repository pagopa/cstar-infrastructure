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
}