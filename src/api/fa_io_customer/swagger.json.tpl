{
    "swagger": "2.0",
    "info": {
        "title": "FA IO Customer Api",
        "version": "1.0"
    },
    "host": "${host}",
    "basePath": "/fa/io/customer",
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
        "/": {
            "get": {
                "description": "find",
                "operationId": "findUsingGET",
                "summary": "find",
                "tags": [
                    "FatturazioneAutomatica"
                ],
                "parameters": [
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
            "put": {
                "description": "enrollment",
                "operationId": "enrollmentUsingPUT",
                "summary": "enrollment",
                "tags": [
                    "FatturazioneAutomatica"
                ],
                "parameters": [
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
                        "name": "enrollmentCustomerDTOArray",
                        "in": "body",
                        "schema": {
                            "$ref": "#/definitions/EnrollmentCustomerDTOArray"
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
            },
            "delete": {
                "description": "delete",
                "operationId": "deleteUsingDELETE",
                "summary": "delete",
                "tags": [
                    "FatturazioneAutomatica"
                ],
                "parameters": [
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
                    "401": {
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
        "EnrollmentCustomerDTO": {
            "title": "EnrollmentCustomerDTO",
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
        "EnrollmentCustomerDTOArray": {
            "type": "array",
            "items": {
                "$ref": "#/definitions/EnrollmentCustomerDTO"
            },
            "example": [
                {
                    "vatNumber": "string",
                    "destinationCode": "string",
                    "pec": "string"
                }
            ]
        }
    },
    "tags": []
}