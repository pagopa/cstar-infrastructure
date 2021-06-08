{
    "openapi": "3.0.1",
    "info": {
        "title": "BPD HB Citizen API",
        "description": "Api and Models",
        "version": "v2"
    },
    "servers": [{
        "url": "https://${host}/bpd/hb/citizens/v2"
    }],
    "paths": {
        "/": {
            "get": {
                "tags": ["Bonus Pagamenti Digitali Citizen Controller"],
                "summary": "find",
                "description": "find",
                "operationId": "find",
                "parameters": [{
                    "name": "flagTechnicalAccount",
                    "in": "query",
                    "description": "booleano per abilitare la gestione dei conti tecnici. Se True e IBAN tecnico, verrà restituito un placeholder sul campo payoffInstr",
                    "schema": {
                        "type": "boolean"
                    }
                }, {
                    "name": "x-request-id",
                    "in": "header",
                    "description": "UUID for request identification",
                    "schema": {
                        "type": "string"
                    }
                }, {
                    "name": "id",
                    "in": "header",
                    "description": "id univoco che corrisponde al codice fiscale dell'utente",
                    "required": true,
                    "schema": {
                        "type": "string"
                    }
                }],
                "responses": {
                    "200": {
                        "description": "OK",
                        "content": {
                            "application/json;charset=UTF-8": {
                                "schema": {
                                    "$ref": "#/components/schemas/CitizenResource"
                                },
                                "example": {
                                    "enabled": true,
                                    "fiscalCode": "string",
                                    "payoffInstr": "string",
                                    "payoffInstrType": "string",
                                    "timestampTC": "string",
                                    "technicalAccountHolder": "string",
                                    "issuerCardId": "string"
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
            },
            "patch": {
                "tags": ["Bonus Pagamenti Digitali Citizen Controller"],
                "summary": "updatePaymentMethod",
                "description": "updatePaymentMethod",
                "operationId": "updatePaymentMethod",
                "parameters": [{
                    "name": "x-request-id",
                    "in": "header",
                    "description": "UUID for request identification",
                    "schema": {
                        "type": "string"
                    }
                }],
                "requestBody": {
                    "description": "citizen",
                    "content": {
                        "application/json": {
                            "schema": {
                                "$ref": "#/components/schemas/CitizenPatchDTO"
                            },
                            "example": {
                                "id": "string",
                                "accountHolderCF": "string",
                                "accountHolderName": "string",
                                "accountHolderSurname": "string",
                                "payoffInstr": "string",
                                "payoffInstrType": "string",
                                "technicalAccountHolder": "string"
                            }
                        }
                    }
                },
                "responses": {
                    "200": {
                        "description": "OK",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/CitizenPatchResource"
                                },
                                "example": {
                                    "validationStatus": "string"
                                }
                            }
                        }
                    },
                    "400": {
                        "description": "Bad Request"
                    },
                    "401": {
                        "description": "Unauthorized"
                    },
                    "500": {
                        "description": ""
                    }
                }
            },
            "put": {
                "tags": ["Bonus Pagamenti Digitali Citizen Controller"],
                "summary": "enrollmentCitizenHB",
                "description": "enrollmentCitizenHB",
                "operationId": "enrollmentCitizenHB",
                "requestBody": {
                    "content": {
                        "application/json": {
                            "schema": {
                                "$ref": "#/components/schemas/CitizenDTO"
                            },
                            "example": {
                                "id": "string"
                            }
                        }
                    }
                },
                "responses": {
                    "200": {
                        "description": "OK",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/CitizenResource"
                                },
                                "example": {
                                    "enabled": true,
                                    "fiscalCode": "string",
                                    "payoffInstr": "string",
                                    "payoffInstrType": "string",
                                    "timestampTC": "string",
                                    "technicalAccountHolder": "string",
                                    "issuerCardId": "string"
                                }
                            }
                        }
                    },
                    "401": {
                        "description": ""
                    },
                    "500": {
                        "description": ""
                    }
                }
            },
            "delete": {
                "tags": ["Bonus Pagamenti Digitali Citizen Controller"],
                "summary": "delete",
                "description": "delete",
                "operationId": "delete",
                "parameters": [{
                    "name": "id",
                    "in": "header",
                    "description": "id univoco che corrisponde al codice fiscale dell'utente",
                    "required": true,
                    "schema": {
                        "type": "string"
                    }
                }],
                "responses": {
                    "204": {
                        "description": ""
                    },
                    "400": {
                        "description": ""
                    },
                    "409": {
                        "description": ""
                    },
                    "500": {
                        "description": ""
                    }
                }
            }
        },
        "/ranking": {
            "get": {
                "tags": ["Bonus Pagamenti Digitali Citizen Controller"],
                "summary": "findRanking",
                "description": "findRanking",
                "operationId": "findRanking",
                "parameters": [{
                    "name": "awardPeriodId",
                    "in": "query",
                    "description": "identificativo univoco del periodo di premiazione",
                    "schema": {
                        "type": "integer"
                    }
                }, {
                    "name": "x-request-id",
                    "in": "header",
                    "description": "UUID for request identification",
                    "schema": {
                        "type": "string"
                    }
                }, {
                    "name": "id",
                    "in": "header",
                    "description": "id univoco che corrisponde al codice fiscale dell'utente",
                    "required": true,
                    "schema": {
                        "type": "string"
                    }
                }],
                "responses": {
                    "200": {
                        "description": "OK",
                        "content": {
                            "application/json;charset=UTF-8": {
                                "schema": {
                                    "$ref": "#/components/schemas/CitizenRankingResourceArray"
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
            "CitizenPatchResource": {
                "title": "CitizenPatchResource",
                "required": ["validationStatus"],
                "type": "object",
                "properties": {
                    "validationStatus": {
                        "type": "string",
                        "description": "Stato di validazione a seguito della chiamata al servizio di checkIban."
                    }
                },
                "example": {
                    "validationStatus": "string"
                }
            },
            "CitizenRankingResource": {
                "title": "CitizenRankingResource",
                "required": ["totalParticipants", "ranking", "maxTransactionNumber", "minTransactionNumber", "transactionNumber", "awardPeriodId"],
                "type": "object",
                "properties": {
                    "totalParticipants": {
                        "type": "integer",
                        "description": "numero totale di partecipanti al Bonus Pagamenti Digitali",
                        "format": "int64"
                    },
                    "ranking": {
                        "type": "integer",
                        "description": "posizione della graduatoria riferita al periodo di premiazione corrente",
                        "format": "int64"
                    },
                    "maxTransactionNumber": {
                        "type": "integer",
                        "description": "Numero massimo di transazioni effettuate dagli utenti che rientrano nel 'rimborso speciale'",
                        "format": "int64"
                    },
                    "minTransactionNumber": {
                        "type": "integer",
                        "description": "Numero minimo di transazioni effettuate dagli utenti che rientrano nel 'rimborso speciale'",
                        "format": "int64"
                    },
                    "transactionNumber": {
                        "type": "integer",
                        "description": "Numero di transazioni effettuate dall’utente",
                        "format": "int64"
                    },
                    "awardPeriodId": {
                        "type": "integer",
                        "description": "identificativo univoco del periodo di premiazione",
                        "format": "int64"
                    }
                }
            },
            "CitizenDeleteResource": {
                "title": "CitizenDeleteResource",
                "required": ["channel"],
                "type": "object",
                "properties": {
                    "channel": {
                        "type": "string",
                        "description": "Canale che identifica univocamente l’issuer che invoca l’API sulla piattaforma. Valorizzato con il codice ABI dell’Issuer chiamante"
                    }
                },
                "example": {
                    "channel": "string"
                }
            },
            "CitizenDTO": {
                "title": "CitizenDTO",
                "required": ["id"],
                "type": "object",
                "properties": {
                    "id": {
                        "type": "string",
                        "description": "id dell'utente, che corrisponde al codice fiscale"
                    }
                }
            },
            "MilestoneResource": {
                "type": "object",
                "properties": {
                    "type": {
                        "type": "string"
                    },
                    "required": {
                        "type": "array",
                        "items": {
                            "type": "string"
                        }
                    },
                    "properties": {
                        "type": "object",
                        "properties": {
                            "cashbackNorm": {
                                "type": "object",
                                "properties": {
                                    "type": {
                                        "type": "string"
                                    },
                                    "description": {
                                        "type": "string"
                                    }
                                }
                            },
                            "idTrxMinTransactionNumber": {
                                "type": "object",
                                "properties": {
                                    "type": {
                                        "type": "string"
                                    },
                                    "description": {
                                        "type": "string"
                                    }
                                }
                            },
                            "idTrxPivot": {
                                "type": "object",
                                "properties": {
                                    "type": {
                                        "type": "string"
                                    },
                                    "description": {
                                        "type": "string"
                                    }
                                }
                            },
                            "maxCashback": {
                                "type": "object",
                                "properties": {
                                    "type": {
                                        "type": "string"
                                    },
                                    "description": {
                                        "type": "string"
                                    }
                                }
                            },
                            "totalCashback": {
                                "type": "object",
                                "properties": {
                                    "type": {
                                        "type": "string"
                                    },
                                    "description": {
                                        "type": "string"
                                    }
                                }
                            }
                        }
                    },
                    "title": {
                        "type": "string"
                    }
                },
                "example": {
                    "type": "string",
                    "required": ["string"],
                    "properties": {
                        "cashbackNorm": {
                            "type": "string",
                            "description": "string"
                        },
                        "idTrxMinTransactionNumber": {
                            "type": "string",
                            "description": "string"
                        },
                        "idTrxPivot": {
                            "type": "string",
                            "description": "string"
                        },
                        "maxCashback": {
                            "type": "string",
                            "description": "string"
                        },
                        "totalCashback": {
                            "type": "string",
                            "description": "string"
                        }
                    },
                    "title": "string"
                }
            },
            "CitizenRankingMilestoneResource": {
                "type": "object",
                "properties": {
                    "type": {
                        "type": "string"
                    },
                    "required": {
                        "type": "array",
                        "items": {
                            "type": "string"
                        }
                    },
                    "properties": {
                        "type": "object",
                        "properties": {
                            "awardPeriodId": {
                                "type": "object",
                                "properties": {
                                    "type": {
                                        "type": "string"
                                    },
                                    "format": {
                                        "type": "string"
                                    },
                                    "description": {
                                        "type": "string"
                                    }
                                }
                            },
                            "maxTransactionNumber": {
                                "type": "object",
                                "properties": {
                                    "type": {
                                        "type": "string"
                                    },
                                    "format": {
                                        "type": "string"
                                    },
                                    "description": {
                                        "type": "string"
                                    }
                                }
                            },
                            "milestoneResource": {
                                "type": "object",
                                "properties": {
                                    "$ref": {
                                        "type": "string"
                                    }
                                }
                            },
                            "minTransactionNumber": {
                                "type": "object",
                                "properties": {
                                    "type": {
                                        "type": "string"
                                    },
                                    "format": {
                                        "type": "string"
                                    },
                                    "description": {
                                        "type": "string"
                                    }
                                }
                            },
                            "ranking": {
                                "type": "object",
                                "properties": {
                                    "type": {
                                        "type": "string"
                                    },
                                    "format": {
                                        "type": "string"
                                    },
                                    "description": {
                                        "type": "string"
                                    }
                                }
                            },
                            "totalParticipants": {
                                "type": "object",
                                "properties": {
                                    "type": {
                                        "type": "string"
                                    },
                                    "format": {
                                        "type": "string"
                                    },
                                    "description": {
                                        "type": "string"
                                    }
                                }
                            },
                            "transactionNumber": {
                                "type": "object",
                                "properties": {
                                    "type": {
                                        "type": "string"
                                    },
                                    "format": {
                                        "type": "string"
                                    },
                                    "description": {
                                        "type": "string"
                                    }
                                }
                            }
                        }
                    },
                    "title": {
                        "type": "string"
                    }
                },
                "example": {
                    "type": "string",
                    "required": ["string"],
                    "properties": {
                        "awardPeriodId": {
                            "type": "string",
                            "format": "string",
                            "description": "string"
                        },
                        "maxTransactionNumber": {
                            "type": "string",
                            "format": "string",
                            "description": "string"
                        },
                        "milestoneResource": {
                            "$ref": "#/components/schemas/MilestoneResource"
                        },
                        "minTransactionNumber": {
                            "type": "string",
                            "format": "string",
                            "description": "string"
                        },
                        "ranking": {
                            "type": "string",
                            "format": "string",
                            "description": "string"
                        },
                        "totalParticipants": {
                            "type": "string",
                            "format": "string",
                            "description": "string"
                        },
                        "transactionNumber": {
                            "type": "string",
                            "format": "string",
                            "description": "string"
                        }
                    },
                    "title": "string"
                }
            },
            "CitizenRankingMilestoneResourceArray": {
                "type": "array",
                "items": {
                    "$ref": "#/components/schemas/CitizenRankingMilestoneResource"
                },
                "example": [{
                    "type": "string",
                    "required": ["string"],
                    "properties": {
                        "awardPeriodId": {
                            "type": "string",
                            "format": "string",
                            "description": "string"
                        },
                        "maxTransactionNumber": {
                            "type": "string",
                            "format": "string",
                            "description": "string"
                        },
                        "milestoneResource": {
                            "$ref": "#/components/schemas/MilestoneResource"
                        },
                        "minTransactionNumber": {
                            "type": "string",
                            "format": "string",
                            "description": "string"
                        },
                        "ranking": {
                            "type": "string",
                            "format": "string",
                            "description": "string"
                        },
                        "totalParticipants": {
                            "type": "string",
                            "format": "string",
                            "description": "string"
                        },
                        "transactionNumber": {
                            "type": "string",
                            "format": "string",
                            "description": "string"
                        }
                    },
                    "title": "string"
                }]
            },
            "CitizenPatchDTO": {
                "title": "CitizenPatchDTO",
                "required": ["id", "accountHolderCF", "accountHolderName", "accountHolderSurname", "payoffInstr", "payoffInstrType"],
                "type": "object",
                "properties": {
                    "id": {
                        "type": "string",
                        "description": "id dell'utente, che corrisponde al codice fiscale"
                    },
                    "accountHolderCF": {
                        "type": "string",
                        "description": "CF dell'intestatario dell'IBAN"
                    },
                    "accountHolderName": {
                        "type": "string",
                        "description": "Nome dell'intestatario dell'IBAN"
                    },
                    "accountHolderSurname": {
                        "type": "string",
                        "description": "Cognome dell'intestatario dell'IBAN"
                    },
                    "payoffInstr": {
                        "type": "string",
                        "description": "identificativo dello strumento di pagamento per la riscossione del premio"
                    },
                    "payoffInstrType": {
                        "enum": ["IBAN"],
                        "type": "string",
                        "description": "tipologia di strumento di pagamento per la riscossione del premio"
                    },
                    "technicalAccountHolder": {
                        "type": "string",
                        "description": "Ragione sociale dell’Issuer presso il quale è stato aperto il conto. Esempio: CONTO TECNICO srl"
                    },
                    "issuerCardId": {
                        "type": "string",
                        "description": "Identificativo univoco dello strumento di pagamento rilasciato dall'issuer"
                    }
                },
                "example": {
                    "id": "string",
                    "accountHolderCF": "string",
                    "accountHolderName": "string",
                    "accountHolderSurname": "string",
                    "payoffInstr": "string",
                    "payoffInstrType": "string",
                    "technicalAccountHolder": "string"
                }
            },
            "CitizenResource": {
                "title": "CitizenResource",
                "required": ["enabled", "fiscalCode", "payoffInstr", "payoffInstrType", "timestampTC"],
                "type": "object",
                "properties": {
                    "enabled": {
                        "type": "boolean",
                        "description": "stato dell'abilitazione al servizio da parte del citizen"
                    },
                    "fiscalCode": {
                        "type": "string",
                        "description": "id dell'utente, che corrisponde al codice fiscale"
                    },
                    "payoffInstr": {
                        "type": "string",
                        "description": "identificativo dello strumento di pagamento per la riscossione del premio, per i conti tecnici verrà valorizzato con un placeholder (es. Conto Tecnico)"
                    },
                    "payoffInstrType": {
                        "type": "string",
                        "description": "tipologia di strumento di pagamento per la riscossione del premio"
                    },
                    "timestampTC": {
                        "type": "string",
                        "description": "timestamp dell'accettazione di T&C. FORMATO  ISO8601 yyyy-MM-ddTHH:mm:ss.SSSXXXXX",
                        "format": "date-time"
                    },
                    "technicalAccountHolder": {
                        "type": "string",
                        "description": "Ragione sociale dell’Issuer presso il quale è stato aperto il conto. Esempio: CONTO TECNICO srl"
                    },
                    "issuerCardId": {
                        "type": "string",
                        "description": "Identificativo univoco dello strumento di pagamento rilasciato dall'issuer"
                    }
                }
            },
            "CitizenRankingResourceArray": {
                "type": "array",
                "items": {
                    "$ref": "#/components/schemas/CitizenRankingResource"
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