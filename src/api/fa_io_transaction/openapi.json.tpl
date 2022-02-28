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
                                        "acquirerCode": "12345",
                                        "acquirerId": 1,
                                        "amount": 10,
                                        "amountCurrency": "EUR",
                                        "bin": 123456,
                                        "circuitType": "01",
                                        "correlationId": 0,
                                        "enabled": true,
                                        "hpan": "r083u1r083i1jf83n1rc1nt9v3yn0t2ur39vt2mt028t08ty208t10t208ty240",
                                        "idTrxAcquirer": 123154534314,
                                        "idTrxIssuer": 13435135134141,
                                        "insertDate": "2020-01-01T12:00:00+02:00",
                                        "insertUser": "insertUser",
                                        "mcc": "string",
                                        "mccDescr": "string",
                                        "merchantId": "2020_12345678910_0000001",
                                        "operationType": "00",
                                        "status": "enabled",
                                        "terminalId": "123456",
                                        "trxDate": "2019-12-31T12:00:00+02:00",
                                        "updateDate": "2020-01-01T12:00:00+02:00",
                                        "updateUser": "updateUser"
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
                    "type": "string"
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