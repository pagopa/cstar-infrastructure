{
    "swagger": "2.0",
    "info": {
        "title": "FA HB Payment Instruments API",
        "version": "1.0"
    },
    "host": "${host}",
    "basePath": "/fa/hb/payment-instruments",
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
        "/": {
            "get": {
                "description": "find",
                "operationId": "findUsingGET",
                "summary": "find",
                "parameters": [
                    {
                        "name": "id",
                        "in": "header",
                        "description": "id dello strumento di pagamento, che corrisponde al PAN (Primary Account Number) cifrato pgp del metodo di pagamento",
                        "required": true,
                        "type": "string"
                    },
                    {
                        "name": "fiscalCode",
                        "in": "header",
                        "description": "codice fiscale dell'utente",
                        "required": true,
                        "type": "string"
                    }
                ],
                "produces": [
                    "application/json"
                ],
                "responses": {
                    "200": {
                        "description": "",
                        "schema": {
                            "$ref": "#/definitions/PaymentInstrumentResource"
                        },
                        "examples": {
                            "application/json": {
                                "activationDate": "string",
                                "deactivationDate": "string",
                                "fiscalCode": "string",
                                "hpan": "string",
                                "Status": "string"
                            }
                        }
                    },
                    "401": {
                        "description": ""
                    },
                    "403": {
                        "description": ""
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
                "parameters": [
                    {
                        "name": "id",
                        "in": "header",
                        "description": "id dello strumento di pagamento, che corrisponde al PAN (Primary Account Number) cifrato pgp del metodo di pagamento",
                        "required": true,
                        "type": "string"
                    }
                ],
                "responses": {
                    "204": {
                        "description": ""
                    },
                    "400": {
                        "description": ""
                    },
                    "401": {
                        "description": ""
                    },
                    "500": {
                        "description": ""
                    }
                }
            },
            "patch": {
                "description": "patch",
                "operationId": "patchUsingPATCH",
                "summary": "patch",
                "parameters": [
                    {
                        "name": "patchPaymentInstrumentDto",
                        "in": "body",
                        "schema": {
                            "$ref": "#/definitions/PatchPaymentInstrumentDto"
                        }
                    }
                ],
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "responses": {
                    "200": {
                        "description": "",
                        "schema": {
                            "$ref": "#/definitions/EnrollmentPaymentInstrumentResource"
                        },
                        "examples": {
                            "application/json": {
                                "activationDate": "string"
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
                "description": "find BPay",
                "operationId": "findUsingGETBpay",
                "summary": "find BPay",
                "parameters": [
                    {
                        "name": "id",
                        "in": "query",
                        "description": "id dello strumento che corrisponde a ABI+Numero cifrato",
                        "required": true,
                        "type": "string"
                    }
                ],
                "produces": [
                    "application/json"
                ],
                "responses": {
                    "200": {
                        "description": "",
                        "schema": {
                            "$ref": "#/definitions/PaymentInstrumentResource"
                        },
                        "examples": {
                            "application/json": {
                                "activationDate": "string",
                                "deactivationDate": "string",
                                "fiscalCode": "string",
                                "hpan": "string",
                                "Status": "string"
                            }
                        }
                    },
                    "401": {
                        "description": ""
                    },
                    "403": {
                        "description": ""
                    },
                    "500": {
                        "description": ""
                    }
                }
            },
            "delete": {
                "description": "delete BPay",
                "operationId": "deleteUsingDELETEBpay",
                "summary": "delete BPay",
                "parameters": [
                    {
                        "name": "id",
                        "in": "query",
                        "description": "id dello strumento che corrisponde a ABI+Numero cifrato",
                        "required": true,
                        "type": "string"
                    }
                ],
                "responses": {
                    "204": {
                        "description": ""
                    },
                    "400": {
                        "description": ""
                    },
                    "401": {
                        "description": ""
                    },
                    "500": {
                        "description": ""
                    }
                }
            },
            "put": {
                "description": "enrollment BPay",
                "operationId": "enrollmentUsingPUTBpay",
                "summary": "enrollment BPay",
                "parameters": [
                    {
                        "name": "paymentInstrumentBPayBody",
                        "in": "body",
                        "schema": {
                            "$ref": "#/definitions/PaymentInstrumentBPayBody"
                        }
                    }
                ],
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "responses": {
                    "200": {
                        "description": "",
                        "schema": {
                            "$ref": "#/definitions/EnrollmentPaymentInstrumentResource"
                        },
                        "examples": {
                            "application/json": {
                                "activationDate": "string"
                            }
                        }
                    },
                    "400": {
                        "description": ""
                    },
                    "401": {
                        "description": ""
                    },
                    "403": {
                        "description": ""
                    },
                    "409": {
                        "description": ""
                    },
                    "500": {
                        "description": "OK"
                    }
                }
            }
        },
        "/card": {
            "put": {
                "description": "enrollment Card",
                "operationId": "enrollmentUsingPUTCard",
                "summary": "enrollment Card",
                "parameters": [
                    {
                        "name": "paymentInstrumentDto",
                        "in": "body",
                        "schema": {
                            "$ref": "#/definitions/PaymentInstrumentDto"
                        }
                    }
                ],
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "responses": {
                    "200": {
                        "description": "",
                        "schema": {
                            "$ref": "#/definitions/EnrollmentPaymentInstrumentResource"
                        },
                        "examples": {
                            "application/json": {
                                "activationDate": "string"
                            }
                        }
                    },
                    "400": {
                        "description": ""
                    },
                    "401": {
                        "description": ""
                    },
                    "403": {
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
        "/other": {
            "put": {
                "description": "enrollment Other",
                "operationId": "enrollmentUsingPUTOther",
                "summary": "enrollment Other",
                "parameters": [
                    {
                        "name": "paymentInstrumentOthersBody",
                        "in": "body",
                        "schema": {
                            "$ref": "#/definitions/PaymentInstrumentOthersBody"
                        }
                    }
                ],
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "responses": {
                    "200": {
                        "description": "",
                        "schema": {
                            "$ref": "#/definitions/EnrollmentPaymentInstrumentResource"
                        },
                        "examples": {
                            "application/json": {
                                "activationDate": "string"
                            }
                        }
                    },
                    "400": {
                        "description": ""
                    },
                    "401": {
                        "description": ""
                    },
                    "403": {
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
        "/satispay/{id}": {
            "put": {
                "description": "enrollment Satispay",
                "operationId": "enrollmentUsingPUTSatispay",
                "summary": "enrollment Satispay",
                "parameters": [
                    {
                        "name": "id",
                        "in": "path",
                        "description": "id univoco dello strumento di pagamento (ID Customer)",
                        "required": true,
                        "type": "string"
                    },
                    {
                        "name": "paymentInstrumentSatispayBody",
                        "in": "body",
                        "schema": {
                            "$ref": "#/definitions/PaymentInstrumentSatispayBody"
                        }
                    }
                ],
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "responses": {
                    "200": {
                        "description": "",
                        "schema": {
                            "$ref": "#/definitions/EnrollmentPaymentInstrumentResource"
                        },
                        "examples": {
                            "application/json": {
                                "activationDate": "string"
                            }
                        }
                    },
                    "401": {
                        "description": ""
                    },
                    "403": {
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
        "PatchPaymentInstrumentDto": {
            "title": "PatchPaymentInstrumentDto",
            "type": "object",
            "properties": {
                "id": {
                    "description": "id dello strumento di pagamento, che corrisponde al PAN (Personal Account Number) cifrato pgp",
                    "type": "string"
                },
                "fiscalCode": {
                    "description": "id dell'utente, che corrisponde al codice fiscale",
                    "type": "string"
                },
                "tokenPanList": {
                    "description": "elenco dei PAN tokenizzati collegati alla scheda fisica",
                    "type": "array",
                    "items": {
                        "type": "string"
                    }
                },
                "PAR": {
                    "description": "corrisponde al Payment Account Reference",
                    "type": "string"
                }
            },
            "example": {
                "id": "string",
                "fiscalCode": "string",
                "tokenPanList": [
                    "string"
                ],
                "PAR": "string"
            }
        },
        "PaymentInstrumentResource": {
            "title": "PaymentInstrumentResource",
            "required": [
                "status",
                "activationDate",
                "fiscalCode",
                "hpan"
            ],
            "type": "object",
            "properties": {
                "status": {
                    "description": "stato dello strumento di pagamento. Può assumere i seguenti valori:ACTIVE,INACTIVE",
                    "enum": [
                        "ACTIVE",
                        "INACTIVE"
                    ],
                    "type": "string"
                },
                "activationDate": {
                    "format": "date-time",
                    "description": "timestamp dell'attivazione dello strumento di pagamento. FORMATO  ISO8601 yyyy-MM-ddTHH:mm:ss.SSSXXXXX",
                    "type": "string"
                },
                "deactivationDate": {
                    "format": "date-time",
                    "description": "timestamp della disattivazione dello strumento di pagamento. FORMATO  ISO8601 yyyy-MM-ddTHH:mm:ss.SSSXXXXX",
                    "type": "string"
                },
                "fiscalCode": {
                    "description": "id dell'utente, che corrisponde al codice fiscale",
                    "type": "string"
                },
                "hpan": {
                    "description": "id dello strumento di pagamento, che corrisponde all'hash del PAN (Primary Account Number) del metodo di pagamento",
                    "type": "string"
                },
                "vatNumber": {
                    "description": "p.iva dell'utente legata allo strumento di pagamento",
                    "type": "string"
                }
            },
            "example": {
                "status": "string",
                "activationDate": "string",
                "deactivationDate": "string",
                "fiscalCode": "string",
                "hpan": "string",
                "vatNumber": "string"
            }
        },
        "PaymentInstrumentOthersBody": {
            "title": "PaymentInstrumentOthersBody",
            "type": "object",
            "properties": {
                "id": {
                    "description": "identificativo unico dello strumento di pagamento cifrato con una chiave pgp",
                    "type": "string"
                },
                "fiscalCode": {
                    "description": "codice fiscale dell’utente",
                    "type": "string"
                },
                "channel": {
                    "description": "canale che identifica l’Issuer in modo univoco sulla piattaforma BPD. Tale campo verrà valorizzato con una stringa fissa per ciascun Issuer",
                    "type": "string"
                },
                "description": {
                    "description": "identificativo dello strumento di pagamento noto all’utente contenente ulteriori dettagli che permettono di identificare in modo univoco lo strumento di pagamento",
                    "type": "string"
                },
                "instrumentBrand": {
                    "description": "valore fisso, concordato in fase di integrazione, identificativo della tipologia dello strumento di pagamento",
                    "type": "string"
                },
                "additionalInfo": {
                    "description": "informazione addizionale, a discrezione dell'issuer, utile all'utente per identificare lo strumento di pagamento",
                    "type": "string"
                },
                "additionalInfo2": {
                    "description": "ulteriore informazione addizionale, a discrezione dell'issuer, utile all'utente per identificare lo strumento di pagamento",
                    "type": "string"
                },
                "vatNumber": {
                    "description": "p.iva dell'utente legata allo strumento di pagamento",
                    "type": "string"
                }
            },
            "example": {
                "id": "string",
                "fiscalCode": "string",
                "channel": "string",
                "description": "string",
                "instrumentBrand": "string",
                "additionalInfo": "string",
                "additionalInfo2": "string",
                "vatNumber": "string"
            }
        },
        "PaymentInstrumentDto": {
            "title": "PaymentInstrumentDto",
            "type": "object",
            "properties": {
                "id": {
                    "description": "id dello strumento di pagamento, che corrisponde al PAN (Personal Account Number) cifrato pgp",
                    "type": "string"
                },
                "fiscalCode": {
                    "description": "id dell'utente, che corrisponde al codice fiscale",
                    "type": "string"
                },
                "expireYear": {
                    "description": "anno di scadenza dello strumento di pagamento",
                    "type": "integer"
                },
                "expireMonth": {
                    "description": "mese di scadenza dello strumento di pagamento",
                    "type": "string"
                },
                "issuerAbiCode": {
                    "description": "codice ABI della banca emittente carta",
                    "type": "string"
                },
                "brand": {
                    "description": "tipo circuito (es. Visa, Mastercard)",
                    "enum": [
                        "VISA",
                        "MASTERCARD",
                        "MAESTRO",
                        "VISA_ELECTRON",
                        "AMEX",
                        "PAGOBANCOMAT",
                        "OTHER"
                    ],
                    "type": "string"
                },
                "holder": {
                    "description": "titolare carta (nome e cognome)",
                    "type": "string"
                },
                "type": {
                    "description": "tipologia carta (es. PP, DEB, CRD)",
                    "enum": [
                        "PP",
                        "DEB",
                        "CRD"
                    ],
                    "type": "string"
                },
                "channel": {
                    "description": "canale che identifica univocamente l'issuer sulla piattaforma",
                    "type": "string"
                },
                "vatNumber": {
                    "description": "p.iva dell'utente legata allo strumento di pagamento",
                    "type": "string"
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
                "vatNumber": "string"
            }
        },
        "PaymentInstrumentBPayBody": {
            "title": "PaymentInstrumentBPayBody",
            "type": "object",
            "properties": {
                "id": {
                    "description": "id dello strumento di pagamento, che corrisponde a ABI+Cellulare cifrati",
                    "type": "string"
                },
                "fiscalCode": {
                    "description": "id dell’utente, che corrisponde al codice fiscale",
                    "type": "string"
                },
                "channel": {
                    "description": "canale che identifica univocamente l'issuer sulla piattaforma",
                    "type": "string"
                },
                "groupCode": {
                    "description": "Codice ABI del gruppo a cui appartiene la banca indicata nel campo InstituteCode",
                    "type": "string"
                },
                "instituteCode": {
                    "description": "Codice ABI dell’istituto dell’utente",
                    "type": "string"
                },
                "bank": {
                    "description": "nome della Banca issuer",
                    "type": "string"
                },
                "nameHolder": {
                    "description": "Nome offuscato del titolare conto",
                    "type": "string"
                },
                "surnameHolder": {
                    "description": "Cognome offuscato del titolare conto",
                    "type": "string"
                },
                "phoneNumber": {
                    "description": "Numero di cellulare del titolare conto offuscato",
                    "type": "string"
                },
                "cryptedPhoneNumber": {
                    "description": "Numero di cellulare del titolare conto criptato",
                    "type": "string"
                },
                "serviceStatus": {
                    "description": "stato del servizio",
                    "enum": [
                        "ATT",
                        "DIS",
                        "SOSP",
                        "SAT_GG",
                        "SAT_MM",
                        "SAT_NO",
                        "NFC_IN_COR",
                        "NFC_ESTINTO",
                        "ATTPND",
                        "DISPND"
                    ],
                    "type": "string"
                },
                "infoPaymentInstrument": {
                    "type": "object",
                    "properties": {
                        "iban": {
                            "description": "iban offuscato",
                            "type": "string"
                        },
                        "flagPreferredPaymentPI": {
                            "description": "Se valorizzato a true indica che lo strumento a cui è associato è stato impostato come strumento di default per i pagamenti in uscita",
                            "type": "boolean"
                        },
                        "flagPreferredIncomingPI": {
                            "description": "Se valorizzato a true indica che lo strumento a cui è associato è stato impostato come strumento di default per i pagamenti in entrata",
                            "type": "boolean"
                        }
                    }
                },
                "vatNumber": {
                    "description": "p.iva dell'utente legata allo strumento di pagamento",
                    "type": "string"
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
                },
                "vatNumber": "string"
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
                },
                "vatNumber": {
                    "description": "p.iva dell'utente legata allo strumento di pagamento",
                    "type": "string"
                }
            },
            "example": {
                "fiscalCode": "string",
                "channel": "string",
                "vatNumber": "string"
            }
        },
        "EnrollmentPaymentInstrumentResource": {
            "title": "EnrollmentPaymentInstrumentResource",
            "type": "object",
            "properties": {
                "activationDate": {
                    "format": "date-time",
                    "description": "Timestamp dell’attivazione dello strumento di pagamento. FORMATO  ISO8601 yyyy-MM-ddTHH:mm:ss.SSSXXXXX",
                    "type": "string"
                }
            },
            "example": {
                "vatNumber": "string"
            }
        }
    },
    "tags": []
}