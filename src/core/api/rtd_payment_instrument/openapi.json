{
    "openapi": "3.0.1",
    "info": {
        "title": "RTD Payment Instrument API",
        "description": "",
        "version": "1.0"
    },
    "servers": [{
        "url": "https://${host}/rtd/payment-instruments"
    }],
    "paths": {
        "/{hpan}": {
            "delete": {
                "summary": "delete",
                "description": "delete",
                "operationId": "delete",
                "parameters": [{
                    "name": "hpan",
                    "in": "path",
                    "required": true,
                    "schema": {
                        "type": ""
                    }
                }, {
                    "name": "fiscalCode",
                    "in": "query",
                    "description": "Fiscal code to be used in PI deletion",
                    "schema": {
                        "type": ""
                    }
                }, {
                    "name": "cancellationDate",
                    "in": "query",
                    "description": "Date to be used as deactivation date",
                    "schema": {
                        "type": ""
                    }
                }],
                "responses": {
                    "200": {
                        "description": "null"
                    }
                }
            }
        }
    },
    "components": {
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