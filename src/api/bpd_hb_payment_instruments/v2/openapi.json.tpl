{
    "openapi": "3.0.1",
    "info": {
        "title": "BPD HB Payment Instruments API",
        "description": "",
        "version": "v2"
    },
    "servers": [{
        "url": "https://${host}/bpd/hb/payment-instruments/v2"
    }],
    "paths": {
        "/": {
            "delete": {
                "summary": "deletePaymentInstrumentHB",
                "description": "deletePaymentInstrumentHB",
                "operationId": "deldeletepaymentinstrumenthb",
                "parameters": [{
                    "name": "id",
                    "in": "header",
                    "description": "id dello strumento di pagamento, che corrisponde al PAN (Primary Account Number) cifrato pgp del metodo di pagamento",
                    "required": true,
                    "schema": {
                        "type": "string"
                    }
                }],
                "responses": {
                    "204": {
                        "description": "No Content"
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
            "get": {
                "summary": "statusPaymentInstrumentHB",
                "description": "statusPaymentInstrumentHB",
                "operationId": "getstatuspaymentinstrumenthb",
                "parameters": [{
                    "name": "id",
                    "in": "header",
                    "description": "id dello strumento di pagamento, che corrisponde al PAN (Primary Account Number) cifrato pgp del metodo di pagamento",
                    "required": true,
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
                                    "$ref": "#/components/schemas/PaymentInstrumentResource"
                                },
                                "example": {
                                    "activationDate": "string",
                                    "deactivationDate": "string",
                                    "fiscalCode": "string",
                                    "hpan": "string",
                                    "Status": "ACTIVE"
                                }
                            }
                        }
                    },
                    "401": {
                        "description": "Unauthorized"
                    },
                    "403": {
                        "description": "Forbidden"
                    },
                    "500": {
                        "description": ""
                    }
                }
            },
            "patch": {
                "summary": "patchPaymentInstrument",
                "description": "patchPaymentInstrument",
                "operationId": "patchpatchpaymentinstrument",
                "requestBody": {
                    "content": {
                        "application/json": {
                            "schema": {
                                "$ref": "#/components/schemas/PatchPaymentInstrumentDto"
                            },
                            "example": {
                                "id": "string",
                                "fiscalCode": "string",
                                "tokenPanList": ["string"],
                                "PAR": "string"
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
                                    "$ref": "#/components/schemas/EnrollmentPaymentInstrumentResource"
                                },
                                "example": {
                                    "activationDate": "string"
                                }
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
        },
        "/bpay": {
            "get": {
                "summary": "BPay statusPaymentInstrumentHB",
                "description": "BPay statusPaymentInstrumentHB",
                "operationId": "getbpaystatuspaymentinstrumenthb",
                "parameters": [{
                    "name": "id",
                    "in": "query",
                    "description": "id dello strumento che corrisponde a ABI+Numero cifrato",
                    "required": true,
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
                                    "$ref": "#/components/schemas/PaymentInstrumentResource"
                                },
                                "example": {
                                    "activationDate": "string",
                                    "deactivationDate": "string",
                                    "fiscalCode": "string",
                                    "hpan": "string",
                                    "Status": "ACTIVE"
                                }
                            }
                        }
                    },
                    "401": {
                        "description": "Unauthorized"
                    },
                    "403": {
                        "description": "Forbidden"
                    },
                    "500": {
                        "description": ""
                    }
                }
            },
            "delete": {
                "summary": "BPay deletePaymentInstrumentHB",
                "description": "BPay deletePaymentInstrumentHB",
                "operationId": "delbpaydeletepaymentinstrumenthb",
                "parameters": [{
                    "name": "id",
                    "in": "query",
                    "description": "id dello strumento che corrisponde a ABI+Numero cifrati",
                    "required": true,
                    "schema": {
                        "type": "string"
                    }
                }],
                "responses": {
                    "204": {
                        "description": "No Content"
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
            }
        }
    },
    "components": {
        "schemas": {
            "EnrollmentPaymentInstrumentResource": {
                "title": "EnrollmentPaymentInstrumentResource",
                "type": "object",
                "properties": {
                    "activationDate": {
                        "type": "string",
                        "description": "Timestamp dell’attivazione dello strumento di pagamento. FORMATO  ISO8601 yyyy-MM-ddTHH:mm:ss.SSSXXXXX",
                        "format": "date-time"
                    }
                }
            },
            "PaymentInstrumentSatispayBody": {
                "title": "PaymentInstrumentSatispayBody",
                "type": "object",
                "properties": {
                    "fiscalCode": {
                        "type": "string"
                    },
                    "channel": {
                        "type": "string"
                    }
                }
            },
            "PaymentInstrumentResource": {
                "title": "PaymentInstrumentResource",
                "type": "object",
                "properties": {
                    "activationDate": {
                        "type": "string",
                        "format": "date-time"
                    },
                    "deactivationDate": {
                        "type": "string",
                        "format": "date-time"
                    },
                    "fiscalCode": {
                        "type": "string"
                    },
                    "hpan": {
                        "type": "string"
                    },
                    "Status": {
                        "enum": ["ACTIVE", "INACTIVE"],
                        "type": "string"
                    }
                }
            },
            "PaymentInstrumentBPayBody": {
                "title": "PaymentInstrumentBPayBody",
                "type": "object",
                "properties": {
                    "id": {
                        "type": "string",
                        "description": "id dello strumento di pagamento, che corrisponde a ABI+Cellulare cifrati"
                    },
                    "fiscalCode": {
                        "type": "string",
                        "description": "id dell’utente, che corrisponde al codice fiscale"
                    },
                    "channel": {
                        "type": "string",
                        "description": "canale che identifica univocamente l'issuer sulla piattaforma"
                    },
                    "groupCode": {
                        "type": "string",
                        "description": "Codice ABI del gruppo a cui appartiene la banca indicata nel campo InstituteCode"
                    },
                    "instituteCode": {
                        "type": "string",
                        "description": "Codice ABI dell’istituto dell’utente"
                    },
                    "bank": {
                        "type": "string",
                        "description": "nome della Banca issuer"
                    },
                    "nameHolder": {
                        "type": "string",
                        "description": "Nome offuscato del titolare conto"
                    },
                    "surnameHolder": {
                        "type": "string",
                        "description": "Cognome offuscato del titolare conto"
                    },
                    "phoneNumber": {
                        "type": "string",
                        "description": "Numero di cellulare del titolare conto offuscato"
                    },
                    "cryptedPhoneNumber": {
                        "type": "string",
                        "description": "Numero di cellulare del titolare conto criptato"
                    },
                    "serviceStatus": {
                        "enum": ["ATT", "DIS", "SOSP", "SAT_GG", "SAT_MM", "SAT_NO", "NFC_IN_COR", "NFC_ESTINTO", "ATTPND", "DISPND"],
                        "type": "string",
                        "description": "stato del servizio"
                    },
                    "infoPaymentInstrument": {
                        "type": "object",
                        "properties": {
                            "iban": {
                                "type": "string",
                                "description": "iban offuscato"
                            },
                            "flagPreferredPaymentPI": {
                                "type": "boolean",
                                "description": "Se valorizzato a true indica che lo strumento a cui è associato è stato impostato come strumento di default per i pagamenti in uscita"
                            },
                            "flagPreferredIncomingPI": {
                                "type": "boolean",
                                "description": "Se valorizzato a true indica che lo strumento a cui è associato è stato impostato come strumento di default per i pagamenti in entrata"
                            }
                        }
                    }
                },
                "example": {
                    "id": "string",
                    "fiscalCode": "string",
                    "channel": "string",
                    "groupCode": "string",
                    "instituteCode": "string",
                    "bank": "string",
                    "nameHolder": "string",
                    "surnameHolder": "string",
                    "phoneNumber": "string",
                    "cryptedPhoneNumber": "string",
                    "serviceStatus": "string",
                    "infoPaymentInstrument": {
                        "iban": "string",
                        "flagPreferredPaymentPI": false,
                        "flagPreferredIncomingPI": false
                    }
                }
            },
            "PatchPaymentInstrumentDto": {
                "title": "PatchPaymentInstrumentDto",
                "type": "object",
                "properties": {
                    "id": {
                        "type": "string",
                        "description": "id dello strumento di pagamento, che corrisponde al PAN (Personal Account Number) cifrato pgp"
                    },
                    "fiscalCode": {
                        "type": "string",
                        "description": "id dell'utente, che corrisponde al codice fiscale"
                    },
                    "tokenPanList": {
                        "type": "array",
                        "items": {
                            "type": "string"
                        },
                        "description": "elenco dei PAN tokenizzati collegati alla scheda fisica"
                    },
                    "PAR": {
                        "type": "string",
                        "description": "corrisponde al Payment Account Reference"
                    }
                }
            },
            "PaymentInstrumentDto": {
                "title": "PaymentInstrumentDto",
                "type": "object",
                "properties": {
                    "id": {
                        "type": "string",
                        "description": "id dello strumento di pagamento, che corrisponde al PAN (Personal Account Number) cifrato pgp"
                    },
                    "fiscalCode": {
                        "type": "string",
                        "description": "id dell'utente, che corrisponde al codice fiscale"
                    },
                    "expireYear": {
                        "type": "integer",
                        "description": "anno di scadenza dello strumento di pagamento"
                    },
                    "expireMonth": {
                        "type": "string",
                        "description": "mese di scadenza dello strumento di pagamento"
                    },
                    "issuerAbiCode": {
                        "type": "string",
                        "description": "codice ABI della banca emittente carta"
                    },
                    "brand": {
                        "enum": ["VISA", "MASTERCARD", "MAESTRO", "VISA_ELECTRON", "AMEX", "OTHER", "PAGOBANCOMAT"],
                        "type": "string",
                        "description": "tipo circuito (es. Visa, Mastercard)"
                    },
                    "holder": {
                        "type": "string",
                        "description": "titolare carta (nome e cognome)"
                    },
                    "type": {
                        "enum": ["PP", "DEB", "CRD"],
                        "type": "string",
                        "description": "tipologia carta (es. PP, DEB, CRD)"
                    },
                    "channel": {
                        "type": "string",
                        "description": "canale che identifica univocamente l'issuer sulla piattaforma"
                    },
                    "tokenPanList": {
                        "type": "array",
                        "items": {
                            "type": "string"
                        },
                        "description": "elenco dei PAN tokenizzati collegati alla scheda fisica"
                    },
                    "PAR": {
                        "type": "string",
                        "description": "corrisponde al Payment Account Reference"
                    }
                },
                "example": {
                    "id": "string",
                    "fiscalCode": "string",
                    "expireYear": 0,
                    "expireMonth": "string",
                    "issuerAbiCode": "string",
                    "brand": "string",
                    "holder": "string",
                    "type": "string",
                    "channel": "string",
                    "tokenPanList": ["string"],
                    "PAR": "string"
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