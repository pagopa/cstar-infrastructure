{
    "openapi": "3.0.1",
    "info": {
        "title": "BPD IO Winning Transactions API",
        "description": "Api and Models",
        "version": "v2"
    },
    "servers": [{
        "url": "https://${host}/bpd/io/winning-transactions/v2"
    }],
    "paths": {
        "/total-cashback": {
            "get": {
                "tags": ["Bonus Pagamenti Digitali winning-transaction Controller"],
                "summary": "getTotalCashback",
                "description": "getTotalCashback",
                "operationId": "getTotalScoreUsingGET",
                "parameters": [{
                    "name": "awardPeriodId",
                    "in": "query",
                    "description": "awardPeriodId",
                    "required": true,
                    "schema": {
                        "type": "integer"
                    }
                }, {
                    "name": "Authorization",
                    "in": "header",
                    "description": "Bearer Token",
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
                                    "totalCashback": 0.708740587556467,
                                    "transactionNumber": 0
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
        },
        "/": {
            "get": {
                "tags": ["Bonus Pagamenti Digitali winning-transaction Controller"],
                "summary": "findWinningTransactions",
                "description": "findWinningTransactions",
                "operationId": "findwinningtransactionsusingget",
                "parameters": [{
                    "name": "awardPeriodId",
                    "in": "query",
                    "description": "awardPeriodId",
                    "required": true,
                    "schema": {
                        "type": "integer"
                    }
                }, {
                    "name": "hpan",
                    "in": "query",
                    "description": "id dello strumento di pagamento, che corrisponde all'hash del PAN (Primary Account Number) del metodo di pagamento",
                    "schema": {
                        "type": "string"
                    }
                }, {
                    "name": "limit",
                    "in": "query",
                    "description": "Limite massimo di elementi contenuti nella pagina di risposta",
                    "schema": {
                        "type": "integer"
                    }
                }, {
                    "name": "nextCursor",
                    "in": "query",
                    "description": "Id cursore da usare per la prossima richiesta per proseguire con la prossima pagina",
                    "schema": {
                        "type": "integer"
                    }
                }, {
                    "name": "Authorization",
                    "in": "header",
                    "description": "Bearer Token",
                    "required": true,
                    "schema": {
                        "type": "string"
                    }
                }],
                "responses": {
                    "200": {
                        "description": "OK",
                        "content": {
                            "application/json-patch+json": {
                                "schema": {
                                    "$ref": "#/components/schemas/WinningTransactionPageResource"
                                },
                                "example": {
                                    "nextCursor": 0,
                                    "prevCursor": 0,
                                    "transactions": [{
                                        "date": "string",
                                        "transactions": [{
                                            "amount": 0.667390344674136,
                                            "awardPeriodId": 0,
                                            "cashback": 0.52070866549666,
                                            "circuitType": "string",
                                            "hashPan": "string",
                                            "idTrx": "string",
                                            "idTrxAcquirer": "string",
                                            "idTrxIssuer": "string",
                                            "trxDate": "string"
                                        }]
                                    }]
                                }
                            }
                        }
                    },
                    "401": {
                        "description": "Unauthorized"
                    },
                    "500": {
                        "description": ""
                    }
                }
            }
        },
        "/clone/total-cashback": {
            "get": {
                "summary": "getTotalCashback (clone)",
                "description": "getTotalCashback",
                "operationId": "5ff1bbf8952e49ee1d720853",
                "parameters": [{
                    "name": "awardPeriodId",
                    "in": "query",
                    "description": "awardPeriodId",
                    "required": true,
                    "schema": {
                        "type": "integer"
                    }
                }, {
                    "name": "Authorization",
                    "in": "header",
                    "description": "Bearer Token",
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
                                    "totalCashback": 0.708740587556467,
                                    "transactionNumber": 0
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
        },
        "/countbyday": {
            "get": {
                "summary": "getCountByDay",
                "description": "getCountByDay",
                "operationId": "603564be9dbc61ba660487f6",
                "parameters": [{
                    "name": "awardPeriodId",
                    "in": "query",
                    "description": "awardPeriodId",
                    "required": true,
                    "schema": {
                        "type": "integer"
                    }
                }, {
                    "name": "hpan",
                    "in": "query",
                    "description": "id dello strumento di pagamento, che corrisponde all'hash del PAN (Primary Account Number) del metodo di pagamento",
                    "schema": {
                        "type": "string"
                    }
                }, {
                    "name": "Authorization",
                    "in": "header",
                    "description": "Bearer Token",
                    "required": true,
                    "schema": {
                        "type": "string"
                    }
                }],
                "responses": {
                    "200": {
                        "description": "OK",
                        "content": {
                            "application/json-patch+json": {
                                "schema": {
                                    "$ref": "#/components/schemas/TrxCountByDayResourceArray"
                                },
                                "example": [{
                                    "count": "string",
                                    "trxDate": "string"
                                }]
                            }
                        }
                    },
                    "401": {
                        "description": "Unauthorized"
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
                        "type": "integer",
                        "description": "Numero delle transazioni effettuate dall'utente",
                        "format": "int64"
                    }
                },
                "example": {
                    "totalCashback": 0.708740587556467,
                    "transactionNumber": "0.0"
                }
            },
            "TrxCountByDayResourceArray": {
                "type": "array",
                "items": {
                    "$ref": "#/components/schemas/TrxCountByDayResource"
                },
                "example": [{
                    "count": "string",
                    "trxDate": "string"
                }]
            },
            "WinningTransactionMilestoneResource": {
                "title": "WinningTransactionMilestoneResource",
                "required": ["amount", "awardPeriodId", "cashback", "circuitType", "hashPan", "idTrx", "idTrxAcquirer", "idTrxIssuer", "trxDate"],
                "type": "object",
                "properties": {
                    "amount": {
                        "type": "number",
                        "description": "in centesimi di euro (es: 10• = 1000) ed in valore assoluto"
                    },
                    "awardPeriodId": {
                        "type": "integer",
                        "description": "identificativo univoco del periodo di premiazione",
                        "format": "int64"
                    },
                    "cashback": {
                        "type": "number",
                        "description": "Cashback transazione, indicato con segno \"-\" in caso di storno"
                    },
                    "circuitType": {
                        "type": "string",
                        "description": "Circuito sul quale è stata effettuata la transazione"
                    },
                    "hashPan": {
                        "type": "string",
                        "description": "id dello strumento di pagamento, che corrisponde all'hash del PAN (Primary Account Number) del metodo di pagamento"
                    },
                    "idTrx": {
                        "type": "string",
                        "description": "Identificativo alfanumerico della transazione"
                    },
                    "idTrxAcquirer": {
                        "type": "string",
                        "description": "identificativo univoco della transazione a livello di Acquirer (all'interno di uno specifico periodo temporale, può coincidere per esempio con RRN+STAN)"
                    },
                    "idTrxIssuer": {
                        "type": "string",
                        "description": "codice autorizzativo rilasciato dall' Issuer (es: AuthCode)"
                    },
                    "trxDate": {
                        "type": "string",
                        "description": "timestamp dell'operazione di pagamento effettuata presso l'esercente",
                        "format": "date-time"
                    }
                },
                "example": {
                    "amount": 0.600811258744409,
                    "awardPeriodId": "0.0",
                    "cashback": 0.808863304868079,
                    "circuitType": "string",
                    "hashPan": "string",
                    "idTrx": "string",
                    "idTrxAcquirer": "string",
                    "idTrxIssuer": "string",
                    "trxDate": "string"
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
                },
                "example": {
                    "acquirerCode": "string",
                    "awardPeriodId": "0.0",
                    "correlationId": "string",
                    "hashPan": "string",
                    "idTrxAcquirer": "string",
                    "idTrxIssuer": "string",
                    "mcc": "string",
                    "operationType": {
                        "code": "string",
                        "description": "string"
                    },
                    "score": 0.167294266293353,
                    "trxDate": "string"
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
                },
                "example": {
                    "code": "string",
                    "description": "string"
                }
            },
            "WinningTransactionResourceArray": {
                "type": "array",
                "items": {
                    "$ref": "#/components/schemas/WinningTransactionResource"
                },
                "example": [{
                    "acquirerCode": "string",
                    "awardPeriodId": 0,
                    "correlationId": "string",
                    "hashPan": "string",
                    "idTrxAcquirer": "string",
                    "idTrxIssuer": "string",
                    "mcc": "string",
                    "operationType": {
                        "code": "string",
                        "description": "string"
                    },
                    "score": 0.656647718252125,
                    "trxDate": "string"
                }]
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
                        "type": "string"
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
                        "description": "identificativo univoco dello strumento di pagamento"
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
                        "description": "identificativo del terminale su cui è avvenuta la transazione"
                    },
                    "trxDate": {
                        "type": "string",
                        "description": "timestamp dell'operazione di pagamento effettuata presso l'esercente",
                        "format": "date-time"
                    }
                }
            },
            "WinningTransactionsOfTheDayResource": {
                "title": "WinningTransactionsOfTheDay",
                "required": ["date", "transactions"],
                "type": "object",
                "properties": {
                    "date": {
                        "type": "string",
                        "description": "La data del giorno di riferimento",
                        "format": "date"
                    },
                    "transactions": {
                        "type": "array",
                        "items": {
                            "$ref": "#/components/schemas/WinningTransactionMilestoneResource"
                        }
                    }
                },
                "description": "Oggetto che raggruppa le transazioni effettuate in una giornata",
                "example": {
                    "date": "string",
                    "transactions": [{
                        "amount": 0.00818701718203352,
                        "awardPeriodId": 0,
                        "cashback": 0.829968689336061,
                        "circuitType": "string",
                        "hashPan": "string",
                        "idTrx": "string",
                        "idTrxAcquirer": "string",
                        "idTrxIssuer": "string",
                        "trxDate": "string"
                    }]
                }
            },
            "TrxCountByDayResource": {
                "title": "TrxCountByDayResource",
                "required": ["count", "trxDate"],
                "type": "object",
                "properties": {
                    "count": {
                        "type": "integer",
                        "description": "numero di transazioni presenti per data",
                        "format": "int64"
                    },
                    "trxDate": {
                        "type": "string",
                        "description": "data di riferimento delle transazioni",
                        "format": "date"
                    }
                },
                "example": {
                    "count": "0.0",
                    "trxDate": "string"
                }
            },
            "WinningTransactionPageResource": {
                "title": "WinningTransactionPage",
                "required": ["transactions"],
                "type": "object",
                "properties": {
                    "nextCursor": {
                        "type": "integer",
                        "description": "Id cursore da usare per la prossima richiesta per proseguire con la prossima pagina",
                        "format": "int32"
                    },
                    "prevCursor": {
                        "type": "integer",
                        "description": "Id cursore da usare per la richiesta precedente per proseguire con la pagina precedente",
                        "format": "int32"
                    },
                    "transactions": {
                        "type": "array",
                        "items": {
                            "$ref": "#/components/schemas/WinningTransactionsOfTheDayResource"
                        }
                    }
                },
                "example": {
                    "nextCursor": 0,
                    "prevCursor": 0,
                    "transactions": [{
                        "date": "string",
                        "transactions": [{
                            "amount": 0.667390344674136,
                            "awardPeriodId": 0,
                            "cashback": 0.52070866549666,
                            "circuitType": "string",
                            "hashPan": "string",
                            "idTrx": "string",
                            "idTrxAcquirer": "string",
                            "idTrxIssuer": "string",
                            "trxDate": "string"
                        }]
                    }]
                }
            }
        }
    }
}