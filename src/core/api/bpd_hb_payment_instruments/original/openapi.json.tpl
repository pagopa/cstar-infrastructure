{
    "openapi": "3.0.1",
    "info": {
        "title": "BPD HB Payment Instruments API",
        "version": ""
    },
    "servers": [{
        "url": "https://${host}/bpd/hb/payment-instruments"
    }],
    "paths": {
        "/{id}": {
            "delete": {
                "summary": "deletePaymentInstrumentHB",
                "description": "deletePaymentInstrumentHB",
                "operationId": "deldeletepaymentinstrumenthb",
                "parameters": [{
                    "name": "id",
                    "in": "path",
                    "description": "id dello strumento di pagamento, che corrisponde al PAN (Primary Account Number) del metodo di pagamento",
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
                    "in": "path",
                    "description": "id dello strumento di pagamento, che corrisponde all'hash del PAN (Primary Account Number) del metodo di pagamento",
                    "required": true,
                    "schema": {
                        "type": "string"
                    }
                }],
                "responses": {
                    "200": {
                        "description": ""
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
            }
        },
        "/card": {
            "put": {
                "summary": "enrollPaymentInstrumentHB",
                "description": "enrollPaymentInstrumentHB",
                "operationId": "putenrollpaymentinstrumenthb",
                "requestBody": {
                    "description": "request",
                    "content": {
                        "application/json": {
                            "schema": {
                                "$ref": "#/components/schemas/PaymentInstrumentDto"
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
                                "channel": "string"
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
                                    "$ref": "#/components/schemas/EnrollmentPaymentInstrumentResource"
                                },
                                "example": {
                                    "activationDate": "string"
                                }
                            }
                        }
                    },
                    "400": {
                        "description": ""
                    },
                    "401": {
                        "description": "",
                        "content": {
                            "application/json": {}
                        }
                    },
                    "403": {
                        "description": "",
                        "content": {
                            "application/json": {}
                        }
                    },
                    "409": {
                        "description": ""
                    },
                    "500": {
                        "description": "Internal MedaCustom Server Error"
                    }
                }
            }
        },
        "/bpay/{id}": {
            "put": {
                "summary": "enrollPaymentInstrumentHB BPay",
                "description": "enrollPaymentInstrumentHB BPay",
                "operationId": "putenrollpaymentinstrumenthbbpayid",
                "parameters": [{
                    "name": "id",
                    "in": "path",
                    "description": "id univoco dello strumento di pagamento, che corrisponde al valore cifrato della stringa “ABI+numero di cellulare”",
                    "required": true,
                    "schema": {
                        "type": "string"
                    }
                }],
                "requestBody": {
                    "description": "request",
                    "content": {
                        "application/json": {
                            "schema": {
                                "$ref": "#/components/schemas/PaymentInstrumentBPayBody"
                            },
                            "example": {
                                "fiscalCode": "string",
                                "channel": "string",
                                "groupCode": "string",
                                "instituteCode": "string",
                                "bank": "string",
                                "nameHolder": "string",
                                "surnameHolder": "string",
                                "phoneNumber": "string",
                                "serviceStatus": "ATT",
                                "infoPaymentInstrument": {
                                    "iban": "string",
                                    "flagPreferredPaymentPI": true,
                                    "flagPreferredIncomingPI": true
                                }
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
                                    "$ref": "#/components/schemas/EnrollmentPaymentInstrumentResource"
                                },
                                "example": {
                                    "activationDate": "string"
                                }
                            }
                        }
                    },
                    "400": {
                        "description": ""
                    },
                    "401": {
                        "description": "",
                        "content": {
                            "application/json": {}
                        }
                    },
                    "403": {
                        "description": "",
                        "content": {
                            "application/json": {}
                        }
                    },
                    "409": {
                        "description": ""
                    },
                    "500": {
                        "description": "Internal MedaCustom Server Error"
                    }
                }
            }
        },
        "/satispay/{id}": {
            "put": {
                "summary": "enrollPaymentInstrumentHB Satispay",
                "description": "enrollPaymentInstrumentHB Satispay",
                "operationId": "putenrollpaymentinstrumenthbsatispay",
                "parameters": [{
                    "name": "id",
                    "in": "path",
                    "description": "id univoco dello strumento di pagamento (ID Customer)",
                    "required": true,
                    "schema": {
                        "type": "string"
                    }
                }],
                "requestBody": {
                    "description": "request",
                    "content": {
                        "application/json": {
                            "schema": {
                                "$ref": "#/components/schemas/PaymentInstrumentSatispayBody"
                            },
                            "example": {
                                "fiscalCode": "string",
                                "channel": "string"
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
                                    "$ref": "#/components/schemas/EnrollmentPaymentInstrumentResource"
                                },
                                "example": {
                                    "activationDate": "string"
                                }
                            }
                        }
                    },
                    "401": {
                        "description": "",
                        "content": {
                            "application/json": {}
                        }
                    },
                    "403": {
                        "description": "",
                        "content": {
                            "application/json": {}
                        }
                    },
                    "500": {
                        "description": "Internal MedaCustom Server Error"
                    }
                }
            }
        },
        "/bpay": {
            "put": {
                "summary": "enrollPaymentInstrumentHB BPay",
                "description": "enrollPaymentInstrumentHB BancomatPay",
                "operationId": "putenrollpaymentinstrumenthbbpay",
                "responses": {
                    "200": {
                        "description": "OK"
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
                        "description": "Internal MedaCustom Server Error"
                    }
                }
            },
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
                        "description": ""
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
        },
        "/other": {
            "put": {
                "summary": "enrollPaymentInstrumentHB Other",
                "description": "enrollPaymentInstrumentHB Other",
                "operationId": "putenrollpaymentinstrumenthbother",
                "requestBody": {
                    "description": "request",
                    "content": {
                        "application/json": {
                            "schema": {
                                "$ref": "#/components/schemas/PaymentInstrumentOthersBody"
                            },
                            "example": {
                                "id": "string",
                                "fiscalCode": "string",
                                "channel": "string",
                                "description": "string",
                                "instrumentBrand": "string",
                                "additionalInfo": "string",
                                "additionalInfo2": "string"
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
                                    "$ref": "#/components/schemas/EnrollmentPaymentInstrumentResource"
                                },
                                "example": {
                                    "activationDate": "string"
                                }
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
                        "description": "Internal MedaCustom Server Error"
                    }
                }
            }
        }
    },
    "components": {
        "schemas": {
            "PaymentInstrumentResource": {
                "title": "PaymentInstrumentResource",
                "type": "object",
                "properties": {
                    "activationDate": {
                        "type": "string",
                        "format": "date-time"
                    },
                    "cancellationDate": {
                        "type": "string",
                        "format": "date-time"
                    },
                    "fiscalCode": {
                        "type": "string"
                    },
                    "hpan": {
                        "type": "string"
                    },
                    "status": {
                        "enum": ["ACTIVE", "INACTIVE"],
                        "type": "string"
                    }
                }
            },
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
            "PaymentInstrumentBPayBody": {
                "title": "PaymentInstrumentBPayBody",
                "type": "object",
                "properties": {
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
                }
            },
            "EnrollmentPaymentInstrumentResource-1": {
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
            "PaymentInstrumentResource-1": {
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
            "PaymentInstrumentBPayBody-1": {
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
                    "exprireMonth": {
                        "type": "string",
                        "description": "mese di scadenza dello strumento di pagamento"
                    },
                    "issuerAbiCode": {
                        "type": "string",
                        "description": "codice ABI della banca emittente carta"
                    },
                    "brand": {
                        "enum": ["VISA", "MASTERCARD", "MAESTRO", "VISA_ELECTRON", "AMEX", "PAGOBANCOMAT", "OTHER"],
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
                    "channel": "string"
                }
            },
            "PaymentInstrumentOthersBody": {
                "title": "PaymentInstrumentOthersBody",
                "type": "object",
                "properties": {
                    "id": {
                        "type": "string",
                        "description": "identificativo unico dello strumento di pagamento cifrato con una chiave pgp"
                    },
                    "fiscalCode": {
                        "type": "string",
                        "description": "codice fiscale dell’utente"
                    },
                    "channel": {
                        "type": "string",
                        "description": "canale che identifica l’Issuer in modo univoco sulla piattaforma BPD. Tale campo verrà valorizzato con una stringa fissa per ciascun Issuer"
                    },
                    "description": {
                        "type": "string",
                        "description": "identificativo dello strumento di pagamento noto all’utente contenente ulteriori dettagli che permettono di identificare in modo univoco lo strumento di pagamento"
                    },
                    "instrumentBrand": {
                        "type": "string",
                        "description": "valore fisso, concordato in fase di integrazione, identificativo della tipologia dello strumento di pagamento"
                    },
                    "additionalInfo": {
                        "type": "string",
                        "description": "informazione addizionale, a discrezione dell'issuer, utile all'utente per identificare lo strumento di pagamento"
                    },
                    "additionalInfo2": {
                        "type": "string",
                        "description": "ulteriore informazione addizionale, a discrezione dell'issuer, utile all'utente per identificare lo strumento di pagamento"
                    }
                },
                "example": {
                    "id": "string",
                    "fiscalCode": "string",
                    "channel": "string",
                    "description": "string",
                    "instrumentBrand": "string",
                    "additionalInfo": "string",
                    "additionalInfo2": "string"
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