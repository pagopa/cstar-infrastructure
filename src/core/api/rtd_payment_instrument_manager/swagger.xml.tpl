{
    "swagger": "2.0",
    "info": {
        "title": "RTD Payment Instrument Manager API",
        "version": "1.0"
    },
    "host": "${host}",
    "basePath": "/rtd/payment-instrument-manager",
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
        "/salt": {
            "get": {
                "description": "Get Hash Salt",
                "operationId": "get-hash-salt",
                "summary": "Get Hash Salt",
                "produces": ["application/json"],
                "responses": {
                    "200": {
                        "description": "",
                        "schema": {
                            "$ref": "#/definitions/Salt"
                        },
                        "examples": {
                            "application/json": "SALT123"
                        }
                    }
                }
            }
        },
        "/hashed-pans": {
            "get": {
                "description": "Get Hashed PANs",
                "operationId": "get-hashed-pans",
                "summary": "Get Hashed PANs",
                "parameters": [
                    {
                        "in": "query",
                        "name": "filePart",
                        "required": false,
                        "type": "integer",
                        "description": "The number of hashed-pan page"
                    }
                ],
                "responses": {
                    "200": {
                        "description": "null"
                    }
                }
            }
        }
    },
    "definitions": {
        "Salt": {
            "type": "string"
        }
    },
    "tags": []
}