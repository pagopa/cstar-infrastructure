{
    "swagger": "2.0",
    "info": {
        "title": "FA IO Transaction Api",
        "version": "1.0",
        "description": "Api and Models"
    },
    "host": "${host}",
    "basePath": "/fa/io/transaction",
    "schemes": [
        "https"
    ],
    "securityDefinitions": {
        "apiKeyHeader": {
            "type": "apiKey",
            "name": "Ocp-Apim-Subscription-Key",
            "in": "header"
        },
        "apiKeyQuery": {
            "type": "apiKey",
            "name": "subscription-key",
            "in": "query"
        }
    },
    "security": [
        {
            "apiKeyHeader": []
        },
        {
            "apiKeyQuery": []
        }
    ],
    "paths": {
        "/list": {
            "get": {
                "description": "getTransactionList",
                "operationId": "getTransactionListUsingGET",
                "summary": "getTransactionList",
                "tags": [
                    "Fatturazione Automatica Transaction Controller"
                ],
                "parameters": [
                    {
                        "name": "hpan",
                        "in": "query",
                        "description": "id dello strumento di pagamento, che corrisponde all'hash del PAN (Primary Account Number) del metodo di pagamento",
                        "required": false,
                        "type": "string"
                    }
                ],
                "produces": [
                    "application/json;charset=UTF-8"
                ],
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "$ref": "#/definitions/TransactionResource"
                        },
                        "examples": {
                            "application/json;charset=UTF-8": {
                                "transactionList": [
                                    {
                                        "acquirerCode": "string",
                                        "acquirerId": 0,
                                        "amount": 0,
                                        "amountCurrency": "string",
                                        "bin": 0,
                                        "circuitType": "string",
                                        "correlationId": 0,
                                        "enabled": true,
                                        "hpan": "string",
                                        "idTrxAcquirer": 0,
                                        "idTrxIssuer": 0,
                                        "insertDate": "string",
                                        "insertUser": "string",
                                        "mcc": "string",
                                        "mccDescr": "string",
                                        "merchantId": 0,
                                        "operationType": "string",
                                        "status": "string",
                                        "terminalId": "string",
                                        "trxDate": "string",
                                        "updateDate": "string",
                                        "updateUser": "string"
                                    }
                                ]
                            }
                        }
                    },
                    "401": {
                        "description": "Unauthorized"
                    },
                    "403": {
                        "description": "Forbidden"
                    },
                    "404": {
                        "description": "Not Found"
                    }
                }
            }
        }
    },
    "definitions": {
        "Transaction": {
            "title": "Transaction",
            "type": "object",
            "properties": {
                "acquirerCode": {
                    "type": "string"
                },
                "acquirerId": {
                    "format": "int64",
                    "type": "integer"
                },
                "amount": {
                    "format": "int64",
                    "type": "integer"
                },
                "amountCurrency": {
                    "type": "string"
                },
                "bin": {
                    "format": "int64",
                    "type": "integer"
                },
                "circuitType": {
                    "type": "string"
                },
                "correlationId": {
                    "format": "int64",
                    "type": "integer"
                },
                "enabled": {
                    "type": "boolean"
                },
                "hpan": {
                    "type": "string"
                },
                "idTrxAcquirer": {
                    "format": "int64",
                    "type": "integer"
                },
                "idTrxIssuer": {
                    "format": "int64",
                    "type": "integer"
                },
                "insertDate": {
                    "format": "date-time",
                    "type": "string"
                },
                "insertUser": {
                    "type": "string"
                },
                "mcc": {
                    "type": "string"
                },
                "mccDescr": {
                    "type": "string"
                },
                "merchantId": {
                    "format": "int64",
                    "type": "integer"
                },
                "operationType": {
                    "type": "string"
                },
                "status": {
                    "type": "string"
                },
                "terminalId": {
                    "type": "string"
                },
                "trxDate": {
                    "format": "date-time",
                    "type": "string"
                },
                "updateDate": {
                    "format": "date-time",
                    "type": "string"
                },
                "updateUser": {
                    "type": "string"
                }
            }
        },
        "TransactionResource": {
            "title": "TransactionResource",
            "type": "object",
            "properties": {
                "transactionList": {
                    "type": "array",
                    "items": {
                        "$ref": "#/definitions/Transaction"
                    }
                }
            }
        }
    },
    "tags": [
        {
            "name": "Fatturazione Automatica Transaction Controller",
            "description": "Fa Transaction Controller Impl"
        }
    ]
}