{
    "swagger": "2.0",
    "info": {
        "title": "BPD IO Payment Instrument API",
        "version": "1.0",
        "description": "Api and Models"
    },
    "host": "${host}",
    "basePath": "/bpd/io/payment-instruments",
    "schemes": ["https"],
    "paths": {
        "/{id}": {
            "get": {
                "description": "find",
                "operationId": "findUsingGET",
                "summary": "find",
                "tags": ["Bonus Pagamenti Digitali payment-instrument Controller"],
                "parameters": [{
                    "name": "id",
                    "in": "path",
                    "description": "id dello strumento di pagamento, che corrisponde all'hash del PAN (Primary Account Number) del metodo di pagamento",
                    "required": true,
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
                            "$ref": "#/definitions/PaymentInstrumentResource"
                        },
                        "examples": {
                            "application/json;charset=UTF-8": "{\r\n  \"Status\": \"ACTIVE\",\r\n  \"activationDate\": \"string\",\r\n  \"deactivationDate\": \"string\",\r\n  \"fiscalCode\": \"string\",\r\n  \"hpan\": \"string\"\r\n}"
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
                "description": "delete",
                "operationId": "deleteUsingDELETE",
                "summary": "delete",
                "tags": ["Bonus Pagamenti Digitali payment-instrument Controller"],
                "parameters": [{
                    "name": "id",
                    "in": "path",
                    "description": "id dello strumento di pagamento, che corrisponde all'hash del PAN (Primary Account Number) del metodo di pagamento",
                    "required": true,
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
            "put": {
                "description": "enrollmentPaymentInstrumentIO",
                "operationId": "enrollmentPaymentInstrumentIOUsingPUT",
                "summary": "enrollmentPaymentInstrumentIO",
                "tags": ["Bonus Pagamenti Digitali enrollment Controller"],
                "parameters": [{
                    "name": "id",
                    "in": "path",
                    "description": "id dello strumento di pagamento, che corrisponde all’hash del PAN (Primary Account Number) del metodo di pagamento",
                    "required": true,
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
                "produces": ["application/json"],
                "responses": {
                    "200": {
                        "description": "",
                        "schema": {
                            "$ref": "#/definitions/EnrollPaymentInstrumentResource"
                        },
                        "examples": {
                            "application/json": "{\r\n  \"activationDate\": \"string\"\r\n}"
                        }
                    },
                    "400": {
                        "description": "Bad Request"
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
        },
        "/number/": {
            "get": {
                "operationId": "paymentinstrumentsnumber",
                "summary": "paymentInstrumentsNumber",
                "tags": ["Bonus Pagamenti Digitali payment-instrument Controller"],
                "parameters": [{
                    "name": "channel",
                    "in": "query",
                    "description": "Canale che identifica univocamente l’issuer che invoca l’API sulla piattaforma. Valorizzato con il codice ABI dell’Issuer chiamante",
                    "type": "string"
                }],
                "produces": ["application/json"],
                "responses": {
                    "200": {
                        "description": "",
                        "schema": {
                            "$ref": "#/definitions/PaymentInstrumentNumberResourceArray"
                        }
                    },
                    "400": {
                        "description": ""
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
        "PaymentInstrumentDTO": {
            "title": "PaymentInstrumentDTO",
            "required": ["activationDate", "fiscalCode"],
            "type": "object",
            "properties": {
                "activationDate": {
                    "format": "date-time",
                    "description": "timestamp dell'attivazione dello strumento di pagamento. FORMATO  ISO8601 yyyy-MM-ddTHH:mm:ss.SSSXXXXX",
                    "type": "string"
                },
                "fiscalCode": {
                    "description": "id dell'utente, che corrisponde al codice fiscale",
                    "type": "string"
                }
            }
        },
        "PaymentInstrumentResource": {
            "title": "PaymentInstrumentResource",
            "required": ["Status", "activationDate", "deactivationDate", "fiscalCode", "hpan"],
            "type": "object",
            "properties": {
                "Status": {
                    "description": "stato dello strumento di pagamento. Può assumere i seguenti valori:ACTIVE,INACTIVE",
                    "enum": ["ACTIVE", "INACTIVE"],
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
                }
            }
        },
        "BpdPayment-instruments-id-HistoryActiveGet200-Response": {
            "type": "boolean"
        },
        "EnrollPaymentInstrumentDTO": {
            "title": "EnrollmentPaymentInstrumentDto",
            "type": "object",
            "properties": {
                "fiscalCode": {
                    "type": "string"
                }
            },
            "example": {
                "fiscalCode": "string"
            }
        },
        "EnrollPaymentInstrumentResource": {
            "title": "EnrollmentPaymentInstrumentResource",
            "type": "object",
            "properties": {
                "activationDate": {
                    "format": "date-time",
                    "description": "Timestamp dell’attivazione dello strumento di pagamento. FORMATO  ISO8601 yyyy-MM-ddTHH:mm:ss.SSSXXXXX",
                    "type": "string"
                }
            }
        },
        "PaymentInstrumentNumberResource": {
            "type": "object",
            "required": ["channel", "count"],
            "properties": {
                "channel": {
                    "type": "string",
                    "description": "Canale che identifica univocamente l’issuer che invoca l’API sulla piattaforma. Valorizzato con il codice ABI dell’Issuer chiamante"
                },
                "count": {
                    "type": "integer",
                    "format": "int64"
                }
            },
            "title": "PaymentInstrumentConverterResource"
        },
        "PaymentInstrumentNumberResourceArray": {
            "type": "array",
            "items": {
                "$ref": "#/components/schemas/PaymentInstrumentNumberResource"
            }
        }
    },
    "tags": [{
        "name": "Bonus Pagamenti Digitali payment-instrument Controller",
        "description": "Bpd Payment Instrument Controller Impl"
    }]
}