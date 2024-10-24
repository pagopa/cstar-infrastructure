{
    "swagger": "2.0",
    "info": {
        "title": "BPD IO Citizen API",
        "version": "",
        "description": "Api and Models"
    },
    "host": "${host}",
    "basePath": "/bpd/io/citizen",
    "schemes": ["https"],
    "paths": {
        "/": {
            "get": {
                "description": "find",
                "operationId": "findUsingGET",
                "summary": "find",
                "tags": ["Bonus Pagamenti Digitali Citizen Controller"],
                "parameters": [{
                    "name": "Authorization",
                    "in": "header",
                    "description": "Bearer Auth Token",
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
            "delete": {
                "description": "delete",
                "operationId": "deleteUsingDELETE",
                "summary": "delete",
                "tags": ["Bonus Pagamenti Digitali Citizen Controller"],
                "parameters": [{
                    "name": "Authorization",
                    "in": "header",
                    "description": "Bearer Auth Token",
                    "required": true,
                    "type": "string"
                }, {
                    "name": "x-request-id",
                    "in": "header",
                    "description": "UUID for request identification",
                    "type": "string"
                }],
                "responses": {
                    "204": {
                        "description": "No Content"
                    },
                    "401": {
                        "description": "Unauthorized"
                    }
                }
            },
            "patch": {
                "description": "updatePaymentMethod",
                "operationId": "updatePaymentMethodUsingPATCH",
                "summary": "updatePaymentMethod",
                "tags": ["Bonus Pagamenti Digitali Citizen Controller"],
                "parameters": [{
                    "name": "Authorization",
                    "in": "header",
                    "description": "Bearer Auth Token",
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
                        "description": "",
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
                "description": "enrollCitizenIO",
                "operationId": "enrollment",
                "summary": "enrollCitizenIO",
                "tags": ["Bonus Pagamenti Digitali enrollment Controller"],
                "parameters": [{
                    "name": "Authorization",
                    "in": "header",
                    "description": "Bearer Auth Token",
                    "required": true,
                    "type": "string"
                }, {
                    "name": "x-request-id",
                    "in": "header",
                    "description": "UUID for request identification",
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
            }
        },
        "/ranking": {
            "get": {
                "description": "findRanking",
                "operationId": "findRankingUsingGET",
                "summary": "findRanking",
                "tags": ["Bonus Pagamenti Digitali Citizen Controller"],
                "parameters": [{
                    "name": "awardPeriodId",
                    "in": "query",
                    "type": "string"
                }, {
                    "name": "Authorization",
                    "in": "header",
                    "description": "Bearer Auth Token",
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
                            "$ref": "#/definitions/CitizenRankingResource"
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
            },
            "example": {
                "enabled": false,
                "fiscalCode": "string",
                "payoffInstr": "string",
                "payoffInstrType": "string",
                "timestampTC": "string"
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
            },
            "example": {
                "totalParticipants": 0,
                "ranking": 0
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
            "example": {
                "accountHolderCF": "string",
                "accountHolderName": "string",
                "accountHolderSurname": "string",
                "payoffInstr": "string",
                "payoffInstrType": "string"
            }
        }
    },
    "tags": [{
        "name": "Bonus Pagamenti Digitali Citizen Controller",
        "description": "Bpd Citizen Controller Impl"
    }]
}