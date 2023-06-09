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
