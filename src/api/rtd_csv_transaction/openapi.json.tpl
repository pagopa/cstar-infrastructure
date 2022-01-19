{
    "openapi": "3.0.1",
    "info": {
        "title": "RTD CSV Transaction API",
        "description": "API providing upload methods for CSV transaction files",
        "version": "1.0"
    },
    "servers": [{
        "url": "https://${host}/rtd/csv-transaction"
    }],
    "paths": {
        "/ade/sas": {
            "post": {
                "summary": "Creates a new SAS token",
                "description": "A new SAS token granting r/w permission on AdE client's container",
                "operationId": "createAdeSasToken",
                "parameters": [],
                "responses": {
                    "201": {
                        "description": "Created",
                        "content": {
                            "application/json": {
                                "schema": {
                                "$ref": "#/components/schemas/SasToken"
                                }
                            }
                        }
                    },
                    "401": {
                        "description": "Unauthorized"
                    },
                    "500": {
                        "description": "Internal Server Error"
                    }
                }
            }
        },
        "/cstar/sas": {
            "post": {
                "summary": "Creates a new SAS token",
                "description": "A new SAS token granting r/w permission on CSTAR client's container",
                "operationId": "createCstarSasToken",
                "parameters": [],
                "responses": {
                    "201": {
                        "description": "Created",
                        "content": {
                            "application/json": {
                                "schema": {
                                "$ref": "#/components/schemas/SasToken"
                                }
                            }
                        }
                    },
                    "401": {
                        "description": "Unauthorized"
                    },
                    "500": {
                        "description": "Internal Server Error"
                    }
                }
            }
        }
    },
    "components": {
        "schemas": {
            "SasToken": {
                "type": "object",
                "properties": {
                    "sas": {
                        "type": "string"
                    },
                    "authorizedContainer": {
                        "type": "string"
                    }
                },
                "additionalProperties": false
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