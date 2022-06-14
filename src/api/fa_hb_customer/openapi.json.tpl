{
    "swagger": "2.0",
    "info": {
        "title": "FA HB Customer API",
        "version": "1.0"
    },
    "host": "${host}",
    "basePath": "/fa/hb/customer",
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
                        "name": "x-request-id",
                        "in": "header",
                        "description": "UUID for request identification",
                        "type": "string"
                    },
                    {
                        "name": "id",
                        "in": "header",
                        "description": "UUID for request identification",
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
                            "$ref": "#/definitions/CustomerResource"
                        },
                        "examples": {
                            "application/json": {
                                "fiscalCode": "string",
                                "status": "string",
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
            },
            "delete": {
                "description": "delete",
                "operationId": "deleteUsingDELETE",
                "summary": "delete",
                "parameters": [
                    {
                        "name": "id",
                        "in": "header",
                        "description": "id univoco che corrisponde al codice fiscale dell'utente",
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
                    "409": {
                        "description": ""
                    },
                    "500": {
                        "description": ""
                    }
                }
            },
            "put": {
                "description": "enrollmentUsingPUT",
                "operationId": "enrollmentUsingPUT",
                "summary": "enrollmentUsingPUT",
                "parameters": [
                    {
                        "name": "enrollmentCustomerDTO",
                        "in": "body",
                        "schema": {
                            "$ref": "#/definitions/EnrollmentCustomerVatNumberDTO"
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
                            "$ref": "#/definitions/CustomerResource"
                        },
                        "examples": {
                            "application/json": {
                                "fiscalCode": "string",
                                "status": "string",
                                "activationDate": "string"
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
        }
    },
    "definitions": {
        "CustomerResource": {
            "type": "object",
            "properties": {
                "fiscalCode": {
                    "type": "string"
                },
                "status": {
                    "type": "string"
                },
                "activationDate": {
                    "type": "string"
                },
                "deactivationDate": {
                    "type": "string"
                },
                "vatNumberList": {
                    "type": "array",
                    "items": {
                        "type": "string"
                    }
                }
            },
            "example": {
                "fiscalCode": "string",
                "status": "string",
                "activationDate": "string",
                "deactivationDate": "string",
                "vatNumberList": [
                    "string"
                ]
            }
        },
        "EnrollmentCustomerVatNumberDTO": {
            "title": "EnrollmentCustomerVatNumberDTO",
            "required": [
                "vatNumber"
            ],
            "type": "object",
            "properties": {
                "vatNumber": {
                    "type": "string"
                },
                "destinationCode": {
                    "type": "string"
                },
                "pec": {
                    "type": "string"
                }
            },
            "example": {
                "vatNumber": "string",
                "destinationCode": "string",
                "pec": "string"
            }
        },
        "EnrollmentCustomerDTO": {
            "title": "CitizenDTO",
            "required": [
                "id"
            ],
            "type": "object",
            "properties": {
                "id": {
                    "description": "id dell'utente, che corrisponde al codice fiscale",
                    "type": "string"
                },
                "vatNumbers": {
                    "type": "array",
                    "items": {
                        "$ref": "#/definitions/EnrollmentCustomerVatNumberDTO"
                    }
                }
            },
            "example": {
                "id": "string",
                "vatNumbers": [
                    {
                        "vatNumber": "string",
                        "destinationCode": "string",
                        "pec": "string"
                    }
                ]
            }
        }
    },
    "tags": []
}