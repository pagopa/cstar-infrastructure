{
    "openapi": "3.0.1",
    "info": {
        "title": "BPD HB Winning Transactions API",
        "description": "Api and Models",
        "version": "v2"
    },
    "servers": [{
        "url": "https://${host}/bpd/hb/winning-transactions/v2"
    }],
    "paths": {
        "/total-cashback": {
            "get": {
                "summary": "getTotalCashback",
                "description": "getTotalCashback",
                "operationId": "getgettotalcashback",
                "parameters": [{
                    "name": "awardPeriodId",
                    "in": "query",
                    "description": "Format - int64. identificativo univoco del periodo di premiazione",
                    "required": true,
                    "schema": {
                        "type": "integer"
                    }
                }, {
                    "name": "fiscalCode",
                    "in": "header",
                    "description": "id dell’utente, che corrisponde al codice fiscale",
                    "required": true,
                    "schema": {
                        "type": "string"
                    }
                }],
                "responses": {
                    "200": {
                        "description": "OK",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/TotalCashbackResource"
                                },
                                "example": {
                                    "totalCashback": 10,
                                    "transactionNumber": 1
                                }
                            }
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
    "components": {
        "schemas": {
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
                        "type": "string",
                        "description": "codice univoco rilasciato da pagoPa SpA"
                    },
                    "acquirerId": {
                        "type": "string",
                        "description": "nel caso di transazione con carta rappresenta il valore omonimo veicolato nei tracciati dei circuiti internazionali"
                    },
                    "amount": {
                        "type": "number",
                        "description": "in centesimi di euro (es: 10 = 1000) ed in valore assoluto"
                    },
                    "amountCurrency": {
                        "type": "string"
                    },
                    "awardPeriodId": {
                        "type": "integer",
                        "description": "identificativo univoco del periodo di premiazione",
                        "format": "int64"
                    },
                    "bin": {
                        "type": "string",
                        "description": "swagger.winningTransaction.bin"
                    },
                    "circuitType": {
                        "type": "string"
                    },
                    "correlationId": {
                        "type": "string",
                        "description": "Identificativo di correlazione fra operazione di pagamento ed eventuale storno/reversa"
                    },
                    "hpan": {
                        "type": "string",
                        "description": "swagger.winningTransaction.hpan"
                    },
                    "idTrxAcquirer": {
                        "type": "string",
                        "description": "identificativo univoco della transazione a livello di Acquirer (all'interno di uno specifico periodo temporale, puÃ² coincidere per esempio con RRN+STAN)"
                    },
                    "idTrxIssuer": {
                        "type": "string",
                        "description": "codice autorizzativo rilasciato dall' Issuer (es: AuthCode)"
                    },
                    "mcc": {
                        "type": "string",
                        "description": "Merchant Category Code"
                    },
                    "mccDescription": {
                        "type": "string"
                    },
                    "merchantId": {
                        "type": "string",
                        "description": "Identificativo univoco del negozio fisico presso l'Acquirer. serve ad identificare l'esercente e la categoria merceologica."
                    },
                    "operationType": {
                        "type": "string",
                        "description": "tipologia operazione, la codifica Ã¨ la stessa utilizzata nel file standard csv"
                    },
                    "score": {
                        "type": "number",
                        "description": "punteggio della transazione"
                    },
                    "terminalId": {
                        "type": "string",
                        "description": "swagger.winningTransaction.terminalId"
                    },
                    "trxDate": {
                        "type": "string",
                        "description": "timestamp dell'operazione di pagamento effettuata presso l'esercente",
                        "format": "date-time"
                    }
                }
            },
            "WinningTransactionResource": {
                "title": "WinningTransactionResource",
                "required": ["acquirerCode", "awardPeriodId", "correlationId", "hashPan", "idTrxAcquirer", "idTrxIssuer", "mcc", "operationType", "score", "trxDate"],
                "type": "object",
                "properties": {
                    "acquirerCode": {
                        "type": "string",
                        "description": "codice univoco rilasciato da pagoPa SpA"
                    },
                    "awardPeriodId": {
                        "type": "integer",
                        "description": "identificativo univoco del periodo di premiazione",
                        "format": "int64"
                    },
                    "correlationId": {
                        "type": "string",
                        "description": "Identificativo di correlazione fra operazione di pagamento ed eventuale storno/reversa"
                    },
                    "hashPan": {
                        "type": "string",
                        "description": "id dello strumento di pagamento, che corrisponde all'hash del PAN (Primary Account Number) del metodo di pagamento"
                    },
                    "idTrxAcquirer": {
                        "type": "string",
                        "description": "identificativo univoco della transazione a livello di Acquirer (all'interno di uno specifico periodo temporale, puÃ² coincidere per esempio con RRN+STAN)"
                    },
                    "idTrxIssuer": {
                        "type": "string",
                        "description": "codice autorizzativo rilasciato dall' Issuer (es: AuthCode)"
                    },
                    "mcc": {
                        "type": "string",
                        "description": "Merchant Category Code"
                    },
                    "operationType": {
                        "$ref": "#/components/schemas/OperationType"
                    },
                    "score": {
                        "type": "number",
                        "description": "punteggio della transazione"
                    },
                    "trxDate": {
                        "type": "string",
                        "description": "timestamp dell'operazione di pagamento effettuata presso l'esercente",
                        "format": "date-time"
                    }
                }
            },
            "TotalCashbackResource": {
                "title": "TotalCashbackResource",
                "required": ["totalCashback", "transactionNumber"],
                "type": "object",
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
                "example": {
                    "totalCashback": 10,
                    "transactionNumber": 1
                }
            },
            "WinningTransactionResourceArray": {
                "type": "array",
                "items": {
                    "$ref": "#/components/schemas/WinningTransactionResource"
                }
            }
        },
        "securitySchemes": {
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
        }
    },
    "security": [{
        "apiKeyHeader": []
    }, {
        "apiKeyQuery": []
    }]
}