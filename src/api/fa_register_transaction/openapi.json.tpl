{
    "swagger": "2.0",
    "info": {
        "title": "FA Transaction Api",
        "version": "1.0",
        "description": "Api and Models"
    },
    "host": "${host}",
    "basePath": "/fa/ext/transaction",
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
        "/pos/invoice/request/{transactionId}": {
            "post": {
                "description": "createPosTransaction",
                "operationId": "createPosTransactionUsingPOST",
                "summary": "createPosTransaction",
                "tags": [
                    "Fatturazione Automatica Transaction Controller"
                ],
                "parameters": [
                    {
                        "name": "transactionId",
                        "in": "path",
                        "description": "identificativo della transazione",
                        "required": true,
                        "type": "string"
                    },
                    {
                        "name": "posTransactionRequestDTO",
                        "in": "body",
                        "schema": {
                            "$ref": "#/definitions/PosTransactionRequestDTO"
                        }
                    }
                ],
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json;charset=UTF-8"
                ],
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "type": "string"
                        },
                        "examples": {
                            "application/json;charset=UTF-8": "string"
                        }
                    },
                    "201": {
                        "description": "Created"
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
        "PosTransactionRequestDTO": {
            "title": "PosTransactionRequestDTO",
            "required": [
                "acquirerId",
                "amount",
                "binCard",
                "customerParamDesc",
                "merchantId",
                "terminalId",
                "trxDate",
                "vatNumber"
            ],
            "type": "object",
            "properties": {
                "acquirerId": {
                    "format": "int64",
                    "description": "nel caso di transazione con carta rappresenta il valore omonimo veicolato nei tracciati dei circuiti internazionali",
                    "type": "integer"
                },
                "amount": {
                    "format": "int64",
                    "description": "in centesimi di euro (es: 10 = 1000) ed in valore assoluto",
                    "type": "integer"
                },
                "binCard": {
                    "description": "codice Bin relativo allo strumento di pagamento",
                    "type": "string"
                },
                "customerParamDesc": {
                    "description": "parametro che identifica se il Compratore richiede la fattura tramite CF oppure P.IVA",
                    "enum": [
                        "FISCAL_CODE",
                        "VAT_NUMBER"
                    ],
                    "type": "string"
                },
                "merchantId": {
                    "format": "int64",
                    "description": "Identificativo univoco del negozio fisico presso lAcquirer. serve ad identificare lesercente e la categoria merceologica",
                    "type": "integer"
                },
                "terminalId": {
                    "format": "int64",
                    "description": "identificativo del terminale dell'esercente",
                    "type": "integer"
                },
                "trxDate": {
                    "format": "date-time",
                    "description": "timestamp delloperazione di pagamento effettuata presso lesercente",
                    "type": "string"
                },
                "vatNumber": {
                    "description": "partita iva associata al merchant",
                    "type": "string"
                }
            },
            "example": {
                "acquirerId": 0,
                "amount": 0,
                "binCard": "string",
                "customerParamDesc": "FISCAL_CODE",
                "merchantId": 0,
                "terminalId": 0,
                "trxDate": "string",
                "vatNumber": "string"
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