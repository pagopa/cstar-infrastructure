{
    "swagger": "2.0",
    "info": {
        "title": "BPD HB Citizen API",
        "version": "",
        "description": "Api and Models"
    },
    "host": "${host}",
    "basePath": "/bpd/hb/citizens",
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
        "/{id}": {
            "get": {
                "description": "find",
                "operationId": "find",
                "summary": "find",
                "parameters": [{
                    "name": "id",
                    "in": "path",
                    "description": "id dell’utente, che corrisponde al codice fiscale",
                    "required": true,
                    "type": "string"
                }, {
                    "name": "x-request-id",
                    "in": "header",
                    "description": "UUID for request identification",
                    "type": "string"
                }],
                "produces": ["application/json;charset=UTF-8"],
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "$ref": "#/definitions/CitizenResource"
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
                "description": "updatePaymentMethod",
                "operationId": "updatePaymentMethod",
                "summary": "updatePaymentMethod",
                "parameters": [{
                    "name": "id",
                    "in": "path",
                    "description": "id dell’utente, che corrisponde al codice fiscale",
                    "required": true,
                    "type": "string"
                }, {
                    "name": "x-request-id",
                    "in": "header",
                    "description": "UUID for request identification",
                    "type": "string"
                }, {
                    "name": "citizenPatchDTO",
                    "in": "body",
                    "schema": {
                        "$ref": "#/definitions/CitizenPatchDTO"
                    },
                    "description": "citizen"
                }],
                "consumes": ["application/json"],
                "produces": ["application/json"],
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "$ref": "#/definitions/CitizenPatchResource"
                        }
                    },
                    "400": {
                        "description": ""
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
                "description": "enrollmentCitizenHB",
                "operationId": "enrollmentCitizenHB",
                "summary": "enrollmentCitizenHB",
                "parameters": [{
                    "name": "id",
                    "in": "path",
                    "description": "id dell'utente, che corrisponde al codice fiscale",
                    "required": true,
                    "type": "string"
                }],
                "produces": ["application/json"],
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "$ref": "#/definitions/CitizenResource"
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
                "operationId": "delete",
                "summary": "delete",
                "parameters": [{
                    "name": "id",
                    "in": "path",
                    "description": "id univoco che corrisponde al codice fiscale dell'utente",
                    "required": true,
                    "type": "string"
                }, {
                    "name": "citizenDeleteResource",
                    "in": "body",
                    "schema": {
                        "$ref": "#/definitions/CitizenDeleteResource"
                    }
                }],
                "consumes": ["application/json"],
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
        "/{id}/ranking": {
            "get": {
                "operationId": "findranking",
                "summary": "findRanking",
                "tags": ["Bonus Pagamenti Digitali Citizen Controller"],
                "parameters": [{
                    "name": "id",
                    "in": "path",
                    "description": "codice fiscale del cittadino",
                    "required": true,
                    "type": "string"
                }, {
                    "name": "awardPeriodId",
                    "in": "query",
                    "description": "identificativo univoco del periodo di premiazione",
                    "type": "integer"
                }, {
                    "name": "x-request-id",
                    "in": "header",
                    "description": "UUID for request identification",
                    "type": "string"
                }],
                "produces": ["application/json;charset=UTF-8"],
                "responses": {
                    "200": {
                        "description": "",
                        "schema": {
                            "$ref": "#/definitions/CitizenRankingResourceArray"
                        }
                    },
                    "401": {
                        "description": ""
                    },
                    "404": {
                        "description": ""
                    },
                    "500": {
                        "description": ""
                    }
                }
            }
        }
    },
    "definitions": {
        "CitizenDTO": {
            "title": "CitizenDTO",
            "required": ["timestampTC"],
            "type": "object",
            "properties": {
                "timestampTC": {
                    "format": "date-time",
                    "description": "timestamp dell'accettazione di T&C. FORMATO  ISO8601 yyyy-MM-ddTHH:mm:ss.SSSXXXXX",
                    "type": "string"
                }
            }
        },
        "CitizenResource": {
            "title": "CitizenResource",
            "required": ["enabled", "fiscalCode", "payoffInstr", "payoffInstrType", "timestampTC"],
            "type": "object",
            "properties": {
                "enabled": {
                    "description": "stato dell'abilitazione al servizio da parte del citizen",
                    "type": "boolean"
                },
                "fiscalCode": {
                    "description": "id dell'utente, che corrisponde al codice fiscale",
                    "type": "string"
                },
                "payoffInstr": {
                    "description": "identificativo dello strumento di pagamento per la riscossione del premio",
                    "type": "string"
                },
                "payoffInstrType": {
                    "description": "tipologia di strumento di pagamento per la riscossione del premio",
                    "type": "string"
                },
                "timestampTC": {
                    "format": "date-time",
                    "description": "timestamp dell'accettazione di T&C. FORMATO  ISO8601 yyyy-MM-ddTHH:mm:ss.SSSXXXXX",
                    "type": "string"
                }
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
        "CitizenPatchResource": {
            "type": "object",
            "required": ["validationStatus"],
            "properties": {
                "validationStatus": {
                    "type": "string",
                    "description": "Stato di validazione a seguito della chiamata al servizio di checkIban."
                }
            },
            "title": "CitizenPatchResource"
        },
        "CitizenPatchDTO": {
            "type": "object",
            "required": ["accountHolderCF", "accountHolderName", "accountHolderSurname", "payoffInstr", "payoffInstrType"],
            "properties": {
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
                    "type": "string",
                    "description": "tipologia di strumento di pagamento per la riscossione del premio",
                    "enum": ["IBAN"]
                }
            },
            "title": "CitizenPatchDTO",
            "example": "{\r\n  \"payoffInstr\": \"string\",\r\n  \"payoffInstrType\": \"string\"\r\n}"
        },
        "CitizenDeleteResource": {
            "type": "object",
            "required": ["channel"],
            "properties": {
                "channel": {
                    "type": "string",
                    "description": "Canale che identifica univocamente l’issuer che invoca l’API sulla piattaforma. Valorizzato con il codice ABI dell’Issuer chiamante"
                }
            },
            "title": "CitizenDeleteResource"
        },
        "CitizenRankingResourceArray": {
            "type": "array",
            "items": {
                "$ref": "#/components/schemas/CitizenRankingResource"
            }
        }
    },
    "tags": []
}