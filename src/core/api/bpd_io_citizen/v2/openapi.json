{
    "openapi": "3.0.1",
    "info": {
        "title": "BPD IO Citizen API",
        "description": "Api and Models",
        "version": "v2"
    },
    "servers": [{
        "url": "https://${host}/bpd/io/citizen/v2"
    }],
    "paths": {
        "/": {
            "get": {
                "tags": ["Bonus Pagamenti Digitali Citizen Controller"],
                "summary": "find",
                "description": "find",
                "operationId": "findUsingGET",
                "parameters": [{
                    "name": "Authorization",
                    "in": "header",
                    "description": "Bearer Auth Token",
                    "required": true,
                    "schema": {
                        "type": "string"
                    }
                }, {
                    "name": "x-request-id",
                    "in": "header",
                    "description": "UUID for request identification",
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
                                    "enabled": false,
                                    "fiscalCode": "string",
                                    "payoffInstr": "string",
                                    "payoffInstrType": "string",
                                    "timestampTC": "string",
                                    "optInStatus": "DENIED"
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
            "delete": {
                "tags": ["Bonus Pagamenti Digitali Citizen Controller"],
                "summary": "delete",
                "description": "delete",
                "operationId": "deleteUsingDELETE",
                "parameters": [{
                    "name": "Authorization",
                    "in": "header",
                    "description": "Bearer Auth Token",
                    "required": true,
                    "schema": {
                        "type": "string"
                    }
                }, {
                    "name": "x-request-id",
                    "in": "header",
                    "description": "UUID for request identification",
                    "schema": {
                        "type": "string"
                    }
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
                "tags": ["Bonus Pagamenti Digitali Citizen Controller"],
                "summary": "updatePaymentMethod",
                "description": "updatePaymentMethod",
                "operationId": "updatePaymentMethodUsingPATCH",
                "parameters": [{
                    "name": "Authorization",
                    "in": "header",
                    "description": "Bearer Auth Token",
                    "required": true,
                    "schema": {
                        "type": "string"
                    }
                }, {
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
                                "accountHolderCF": "string",
                                "accountHolderName": "string",
                                "accountHolderSurname": "string",
                                "payoffInstr": "string",
                                "payoffInstrType": "string"
                            }
                        }
                    }
                },
                "responses": {
                    "200": {
                        "description": "",
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
                "tags": ["Bonus Pagamenti Digitali enrollment Controller"],
                "summary": "enrollCitizenIO",
                "description": "enrollCitizenIO",
                "operationId": "enrollment",
                "parameters": [{
                    "name": "Authorization",
                    "in": "header",
                    "description": "Bearer Auth Token",
                    "required": true,
                    "schema": {
                        "type": "string"
                    }
                }, {
                    "name": "x-request-id",
                    "in": "header",
                    "description": "UUID for request identification",
                    "schema": {
                        "type": "string"
                    }
                }],
                "requestBody": {
                    "description": "Citizen",
                    "required": false,
                    "content": {
                        "application/json": {
                            "schema": {
                                "$ref": "#/components/schemas/CitizenPutDTO"
                            },
                            "example": {
                                "optInStatus": "DENIED"
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
                                    "enabled": false,
                                    "fiscalCode": "string",
                                    "payoffInstr": "string",
                                    "payoffInstrType": "string",
                                    "timestampTC": "string",
                                    "optInStatus": "DENIED"
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
            }
        },
        "/ranking": {
            "get": {
                "tags": ["Bonus Pagamenti Digitali Citizen Controller"],
                "summary": "findRanking",
                "description": "findRanking",
                "operationId": "findRankingUsingGET",
                "parameters": [{
                    "name": "awardPeriodId",
                    "in": "query",
                    "schema": {
                        "type": "string"
                    }
                }, {
                    "name": "Authorization",
                    "in": "header",
                    "description": "Bearer Auth Token",
                    "required": true,
                    "schema": {
                        "type": "string"
                    }
                }, {
                    "name": "x-request-id",
                    "in": "header",
                    "description": "UUID for request identification",
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
                                    "$ref": "#/components/schemas/CitizenRankingMilestoneResourceArray"
                                },
                                "example": [{
                                    "awardPeriodId": 0,
                                    "maxTransactionNumber": 0,
                                    "milestoneResource": {
                                        "cashbackNorm": "string",
                                        "idTrxMinTransactionNumber": "string",
                                        "idTrxPivot": "string",
                                        "maxCashback": "string",
                                        "totalCashback": "string"
                                    },
                                    "minTransactionNumber": 0,
                                    "ranking": 0,
                                    "totalParticipants": 0,
                                    "transactionNumber": 0
                                }]
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
        "/ranking/milestone": {
            "get": {
                "tags": ["Bonus Pagamenti Digitali Citizen Controller"],
                "summary": "findRankingMilestone",
                "description": "findRankingMilestone",
                "operationId": "findRankingMilestoneUsingGET",
                "parameters": [{
                    "name": "awardPeriodId",
                    "in": "query",
                    "description": "identificativo univoco del periodo di premiazione",
                    "required": true,
                    "schema": {
                        "type": "integer"
                    }
                }, {
                    "name": "Authorization",
                    "in": "header",
                    "description": "Bearer Auth Token",
                    "required": true,
                    "schema": {
                        "type": "string"
                    }
                }, {
                    "name": "x-request-id",
                    "in": "header",
                    "description": "UUID for request identification",
                    "schema": {
                        "type": "string"
                    }
                }],
                "responses": {
                    "200": {
                        "description": "",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/CitizenRankingMilestoneResourceArray"
                                },
                                "example": [{
                                    "awardPeriodId": 0,
                                    "maxTransactionNumber": 0,
                                    "milestoneResource": {
                                        "cashbackNorm": "string",
                                        "idTrxMinTransactionNumber": "string",
                                        "idTrxPivot": "string",
                                        "maxCashback": "string",
                                        "totalCashback": "string"
                                    },
                                    "minTransactionNumber": 0,
                                    "ranking": 0,
                                    "totalParticipants": 0,
                                    "transactionNumber": 0
                                }]
                            }
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
    "components": {
        "schemas": {
            "CitizenPutDTO": {
                "title": "CitizenPutDTO",
                "type": "object",
                "properties": {
                    "optInStatus": {
                       "enum": ["NOREQ","ACCEPTED","DENIED"],
                       "type": "string",
                       "description": "stato della richiesta utente di Opt-In per il mantenimento delle carte in AppIO"
                    }
                }
            },
            "CitizenPatchDTO": {
                "title": "CitizenPatchDTO",
                "required": ["accountHolderCF", "accountHolderName", "accountHolderSurname", "payoffInstr", "payoffInstrType"],
                "type": "object",
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
                        "enum": ["IBAN"],
                        "type": "string",
                        "description": "tipologia di strumento di pagamento per la riscossione del premio"
                    }
                },
                "example": {
                    "accountHolderCF": "string",
                    "accountHolderName": "string",
                    "accountHolderSurname": "string",
                    "payoffInstr": "string",
                    "payoffInstrType": "string"
                }
            },
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
                },
                "example": {
                    "totalParticipants": "0.0",
                    "ranking": "0.0"
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
                        "type": "integer",
                        "description": "Numero delle transazioni effettuate dall'utente",
                        "format": "int64"
                    }
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
                        "description": "identificativo dello strumento di pagamento per la riscossione del premi"
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
                    "technicalAccount": {
                        "type": "string",
                        "description": "Label fissa tramite la quale si verifica la presenza di un conto tecnico. Quando tale campo sarà valorizzato, il Client dovrà mascherare l’IBAN inviato nel campo payoffInstr"
                    },
                    "technicalAccountHolder": {
                        "type": "string",
                        "description": "Ragione sociale dell’Issuer presso il quale è stato aperto il conto. Esempio: CONTO TECNICO srl"
                    },
                    "issuerCardId": {
                        "type": "string",
                        "description": "Identificativo univoco dello strumento di pagamento rilasciato dall'issuer"
                    },
                    "optInStatus": {
                        "enum": ["NOREQ","ACCEPTED","DENIED"],
                        "type": "string",
                        "description": "stato della richiesta utente di Opt-In per il mantenimento delle carte in AppIO"
                    }
                },
                "example": {
                    "enabled": false,
                    "fiscalCode": "string",
                    "payoffInstr": "string",
                    "payoffInstrType": "string",
                    "timestampTC": "string",
                    "optInStatus": "DENIED"
                }
            },
            "CitizenRankingMilestoneResourceArray": {
                "type": "array",
                "items": {
                    "$ref": "#/components/schemas/CitizenRankingMilestoneResource"
                },
                "example": [{
                    "awardPeriodId": 0,
                    "maxTransactionNumber": 0,
                    "milestoneResource": {
                        "cashbackNorm": "string",
                        "idTrxMinTransactionNumber": "string",
                        "idTrxPivot": "string",
                        "maxCashback": "string",
                        "totalCashback": "string"
                    },
                    "minTransactionNumber": 0,
                    "ranking": 0,
                    "totalParticipants": 0,
                    "transactionNumber": 0
                }]
            },
            "CitizenRankingResourceArray": {
                "type": "array",
                "items": {
                    "$ref": "#/components/schemas/CitizenRankingResource"
                },
                "example": [{
                    "totalParticipants": 0,
                    "ranking": 0,
                    "maxTransactionNumber": 0,
                    "minTransactionNumber": 0,
                    "transactionNumber": 0,
                    "awardPeriodId": 0
                }]
            },
            "CitizenRankingMilestoneResource": {
                "title": "CitizenRankingMilestoneResource",
                "required": ["awardPeriodId", "maxTransactionNumber", "minTransactionNumber", "ranking", "totalParticipants", "transactionNumber"],
                "type": "object",
                "properties": {
                    "awardPeriodId": {
                        "type": "integer",
                        "description": "identificativo univoco del periodo di premiazione",
                        "format": "int64"
                    },
                    "maxTransactionNumber": {
                        "type": "integer",
                        "description": "Numero massimo di transazioni effettuate dagli utenti che rientrano nel •rimborso speciale•",
                        "format": "int64"
                    },
                    "milestoneResource": {
                        "$ref": "#/components/schemas/MilestoneResource"
                    },
                    "minTransactionNumber": {
                        "type": "integer",
                        "description": "Numero minimo di transazioni effettuate dagli utenti che rientrano nel •rimborso speciale•",
                        "format": "int64"
                    },
                    "ranking": {
                        "type": "integer",
                        "description": "posizione della graduatoria riferita al periodo di premiazione corrente",
                        "format": "int64"
                    },
                    "totalParticipants": {
                        "type": "integer",
                        "description": "numero totale di partecipanti al Bonus Pagamenti Digitali",
                        "format": "int64"
                    },
                    "transactionNumber": {
                        "type": "integer",
                        "description": "Numero di transazioni effettuate dall•utente",
                        "format": "int64"
                    }
                },
                "example": {
                    "awardPeriodId": "0.0",
                    "maxTransactionNumber": "0.0",
                    "milestoneResource": {
                        "cashbackNorm": "string",
                        "idTrxMinTransactionNumber": "string",
                        "idTrxPivot": "string",
                        "maxCashback": "string",
                        "totalCashback": "string"
                    },
                    "minTransactionNumber": "0.0",
                    "ranking": "0.0",
                    "totalParticipants": "0.0",
                    "transactionNumber": "0.0"
                }
            },
            "MilestoneResource": {
                "title": "MilestoneResource",
                "type": "object",
                "properties": {
                    "cashbackNorm": {
                        "type": "number"
                    },
                    "idTrxMinTransactionNumber": {
                        "type": "string"
                    },
                    "idTrxPivot": {
                        "type": "string"
                    },
                    "maxCashback": {
                        "type": "number"
                    },
                    "totalCashback": {
                        "type": "number"
                    }
                },
                "example": {
                    "cashbackNorm": "string",
                    "idTrxMinTransactionNumber": "string",
                    "idTrxPivot": "string",
                    "maxCashback": "string",
                    "totalCashback": "string"
                }
            }
        }
    },
    "tags": [{
        "name": "Bonus Pagamenti Digitali Citizen Controller",
        "description": "Bpd Citizen Controller Impl"
    }]
}