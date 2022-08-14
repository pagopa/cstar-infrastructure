{
    "swagger": "2.0",
    "info": {
        "title": "BPD HB Winning Transactions API",
        "version": "",
        "description": "Api and Models"
    },
    "host": "${host}",
    "basePath": "/bpd/hb/winning-transactions",
    "schemes": ["https"],
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
    "security": [{
        "apiKeyHeader": []
    }, {
        "apiKeyQuery": []
    }],
    "paths": {
        "/total-cashback": {
            "get": {
                "description": "getTotalCashback",
                "operationId": "getgettotalcashback",
                "summary": "getTotalCashback",
                "parameters": [{
                    "name": "awardPeriodId",
                    "in": "query",
                    "description": "Format - int64. identificativo univoco del periodo di premiazione",
                    "required": true,
                    "type": "integer"
                }, {
                    "name": "fiscalCode",
                    "in": "query",
                    "description": "id dell’utente, che corrisponde al codice fiscale",
                    "required": true,
                    "type": "string"
                }],
                "produces": ["application/json"],
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "$ref": "#/definitions/TotalCashbackResource"
                        },
                        "examples": {
                            "application/json": "{\r\n  \"totalCashback\": 0.0,\r\n  \"transactionNumber\": 0.0\r\n}"
                        }
                    },
                    "401": {
                        "description": "Unauthorized"
                    },
                    "404": {
                        "description": "Not Found"
                    },
                    "500": {
                        "description": ""
                    }
                }
            }
        }
    },
    "definitions": {
        "BpdWinning-transactionsGet200ApplicationJson;charset=UTF-8Response": {
            "type": "array",
            "items": {
                "$ref": "#/definitions/WinningTransactionResource"
            }
        },
        "OperationType": {
            "title": "OperationType",
            "type": "object",
            "properties": {
                "code": {
                    "type": "string"
                },
                "description": {
                    "type": "string"
                }
            }
        },
        "WinningTransactionDTO": {
            "title": "WinningTransactionDTO",
            "required": ["acquirerCode", "acquirerId", "amount", "awardPeriodId", "bin", "correlationId", "hpan", "idTrxAcquirer", "idTrxIssuer", "mcc", "merchantId", "operationType", "score", "terminalId", "trxDate"],
            "type": "object",
            "properties": {
                "acquirerCode": {
                    "description": "codice univoco rilasciato da pagoPa SpA",
                    "type": "string"
                },
                "acquirerId": {
                    "description": "nel caso di transazione con carta rappresenta il valore omonimo veicolato nei tracciati dei circuiti internazionali",
                    "type": "string"
                },
                "amount": {
                    "description": "in centesimi di euro (es: 10 = 1000) ed in valore assoluto",
                    "type": "number"
                },
                "amountCurrency": {
                    "type": "string"
                },
                "awardPeriodId": {
                    "format": "int64",
                    "description": "identificativo univoco del periodo di premiazione",
                    "type": "integer"
                },
                "bin": {
                    "description": "swagger.winningTransaction.bin",
                    "type": "string"
                },
                "circuitType": {
                    "type": "string"
                },
                "correlationId": {
                    "description": "Identificativo di correlazione fra operazione di pagamento ed eventuale storno/reversa",
                    "type": "string"
                },
                "hpan": {
                    "description": "swagger.winningTransaction.hpan",
                    "type": "string"
                },
                "idTrxAcquirer": {
                    "description": "identificativo univoco della transazione a livello di Acquirer (all'interno di uno specifico periodo temporale, puÃ² coincidere per esempio con RRN+STAN)",
                    "type": "string"
                },
                "idTrxIssuer": {
                    "description": "codice autorizzativo rilasciato dall' Issuer (es: AuthCode)",
                    "type": "string"
                },
                "mcc": {
                    "description": "Merchant Category Code",
                    "type": "string"
                },
                "mccDescription": {
                    "type": "string"
                },
                "merchantId": {
                    "description": "Identificativo univoco del negozio fisico presso l'Acquirer. serve ad identificare l'esercente e la categoria merceologica.",
                    "type": "string"
                },
                "operationType": {
                    "description": "tipologia operazione, la codifica Ã¨ la stessa utilizzata nel file standard csv",
                    "type": "string"
                },
                "score": {
                    "description": "punteggio della transazione",
                    "type": "number"
                },
                "terminalId": {
                    "description": "swagger.winningTransaction.terminalId",
                    "type": "string"
                },
                "trxDate": {
                    "format": "date-time",
                    "description": "timestamp dell'operazione di pagamento effettuata presso l'esercente",
                    "type": "string"
                }
            }
        },
        "WinningTransactionResource": {
            "title": "WinningTransactionResource",
            "required": ["acquirerCode", "awardPeriodId", "correlationId", "hashPan", "idTrxAcquirer", "idTrxIssuer", "mcc", "operationType", "score", "trxDate"],
            "type": "object",
            "properties": {
                "acquirerCode": {
                    "description": "codice univoco rilasciato da pagoPa SpA",
                    "type": "string"
                },
                "awardPeriodId": {
                    "format": "int64",
                    "description": "identificativo univoco del periodo di premiazione",
                    "type": "integer"
                },
                "correlationId": {
                    "description": "Identificativo di correlazione fra operazione di pagamento ed eventuale storno/reversa",
                    "type": "string"
                },
                "hashPan": {
                    "description": "id dello strumento di pagamento, che corrisponde all'hash del PAN (Primary Account Number) del metodo di pagamento",
                    "type": "string"
                },
                "idTrxAcquirer": {
                    "description": "identificativo univoco della transazione a livello di Acquirer (all'interno di uno specifico periodo temporale, puÃ² coincidere per esempio con RRN+STAN)",
                    "type": "string"
                },
                "idTrxIssuer": {
                    "description": "codice autorizzativo rilasciato dall' Issuer (es: AuthCode)",
                    "type": "string"
                },
                "mcc": {
                    "description": "Merchant Category Code",
                    "type": "string"
                },
                "operationType": {
                    "$ref": "#/definitions/OperationType"
                },
                "score": {
                    "description": "punteggio della transazione",
                    "type": "number"
                },
                "trxDate": {
                    "format": "date-time",
                    "description": "timestamp dell'operazione di pagamento effettuata presso l'esercente",
                    "type": "string"
                }
            }
        },
        "TotalCashbackResource": {
            "type": "object",
            "required": ["totalCashback", "transactionNumber"],
            "properties": {
                "totalCashback": {
                    "type": "number",
                    "description": "Cashback transazione, indicato con segno '-' in caso di storno"
                },
                "transactionNumber": {
                    "type": "number",
                    "description": "Numero delle transazioni effettuate dall'utente"
                }
            },
            "title": "TotalCashbackResource"
        }
    },
    "tags": []
}