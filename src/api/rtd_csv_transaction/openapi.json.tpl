{
    "openapi": "3.0.1",
    "info": {
        "title": "RTD CSV Transaction API",
        "description": "API providing upload methods for csv transaction files",
        "version": "1.0"
    },
    "servers": [{
        "url": "https://${host}/rtd/csv-transaction"
    }],
    "paths": {
        "/ade": {
            "post": {
                "summary": "Creates a new SAS token",
                "description": "A new SAS token granting r/w permission on ade container",
                "operationId": "createAdeSasToken",
                "parameters": [],
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