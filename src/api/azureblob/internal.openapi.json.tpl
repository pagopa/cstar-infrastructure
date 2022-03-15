{
    "openapi": "3.0.1",
    "info": {
        "title": "Blob Storage Internal",
        "description": "API for Internal Access to Blob Storage",
        "version": "1.0"
    },
    "servers": [{
        "url": "https://${host}/storage"
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
            },
            "post": {
                "summary": "POST BlobURI",
                "operationId": "postBlob",
                "responses": {
                    "200": {
                        "description": null
                    }
                }
            },
            "put": {
                "summary": "PUT BlobURI",
                "operationId": "putBlob",
                "responses": {
                    "200": {
                        "description": null
                    }
                }
            },
            "delete": {
                "summary": "DEL BlobURI",
                "operationId": "delBlob",
                "responses": {
                    "200": {
                        "description": null
                    }
                }
            },
            "head": {
                "summary": "HEAD BlobURI",
                "operationId": "headBlob",
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