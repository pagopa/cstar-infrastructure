{
    "openapi": "3.0.1",
    "info": {
        "title": "pm-admin-panel",
        "description": "",
        "version": "1.0"
    },
    "servers": [{
        "url": "https://${host}/backoffice"
    }],
    "paths": {
        "/v1/external/walletv2": {
            "get": {
                "summary": "walletv2",
                "operationId": "walletv2",
                "responses": {
                    "200": {
                        "description": null
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