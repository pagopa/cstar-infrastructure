{
    "swagger": "2.0",
    "info": {
        "title": "FA IO Payment Instrument API",
        "version": "1.0"
    },
    "host": "${host}",
    "basePath": "/fa/io/payment-instruments",
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
        {},
        {
            "apiKeyHeader": []
        },
        {
            "apiKeyQuery": []
        }
    ],
    "paths": {
        "/{id}": {
            "get": {
                "description": "find",
                "operationId": "findUsingGET",
                "summary": "find",
                "parameters": [
                    {
                        "name": "id",
                        "in": "path",
                        "description": "id dello strumento di pagamento, che corrisponde all'hash del PAN (Primary Account Number) del metodo di pagamento",
                        "required": true,
                        "type": "string"
                    },
                    {
                        "name": "Authorization",
                        "in": "header",
                        "description": "Bearer Auth Token",
                        "required": true,
                        "type": "string"
                    },
                    {
                        "name": "x-request-id",
                        "in": "header",
                        "description": "UUID for request identification",
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
                                "status": "string",
                                "activationDate": "string",
                                "deactivationDate": "string",
                                "fiscalCode": "string",
                                "hpan": "string",
                                "vatNumber": "string"
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
                        "in": "path",
                        "description": "id dello strumento di pagamento, che corrisponde all'hash del PAN (Primary Account Number) del metodo di pagamento",
                        "required": true,
                        "type": "string"
                    },
                    {
                        "name": "Authorization",
                        "in": "header",
                        "description": "Bearer Auth Token",
                        "required": true,
                        "type": "string"
                    },
                    {
                        "name": "x-request-id",
                        "in": "header",
                        "description": "UUID for request identification",
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
                "description": "enrollment",
                "operationId": "enrollmentUsingPUT",
                "summary": "enrollment",
                "parameters": [
                    {
                        "name": "id",
                        "in": "path",
                        "description": "id dello strumento di pagamento, che corrisponde all’hash del PAN (Primary Account Number) del metodo di pagamento",
                        "required": true,
                        "type": "string"
                    },
                    {
                        "name": "Authorization",
                        "in": "header",
                        "description": "Bearer Auth Token",
                        "required": true,
                        "type": "string"
                    },
                    {
                        "name": "x-request-id",
                        "in": "header",
                        "description": "UUID for request identification",
                        "type": "string"
                    },
                    {
                        "name": "enrollmentPaymentInstrumentDTO",
                        "in": "body",
                        "schema": {
                            "$ref": "#/definitions/EnrollmentPaymentInstrumentDTO"
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
                            "$ref": "#/definitions/EnrollPaymentInstrumentResource"
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
        "EnrollPaymentInstrumentResource": {
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
                "activationDate": "string"
            }
        },
        "EnrollmentPaymentInstrumentDTO": {
            "type": "object",
            "properties": {
                "vatNumber": {
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