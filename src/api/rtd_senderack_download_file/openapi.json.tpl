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
        "/{fileName}": {
            "get": {
                "summary": "GET BlobURI",
                "operationId": "getBlob",
                "responses": {
                    "200": {
                        "description": "Ok"
                    }
                },
                "parameters": [{
                    "name": "fileName",
                    "in": "path",
                    "description": "Name of the file to be downloaded from PagoPA",
                    "required": true,
                    "schema": {
                        "type": "string"
                    }
                }]
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