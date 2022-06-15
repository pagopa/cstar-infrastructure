{
    "openapi": "3.0.1",
    "info": {
        "title": "RTD Sender ADE ACK Files Download",
        "description": "API to download Sender ADE Ack Files",
        "version": "1.0"
    }, 
    "servers": [{
        "url": "${host}"
    }],
    "paths": {
        "/*": {
            "get": {
                "summary": "GET BlobURI",
                "operationId": "getBlob",
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