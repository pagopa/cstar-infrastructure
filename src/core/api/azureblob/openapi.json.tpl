{
    "openapi": "3.0.1",
    "info": {
        "title": "azureblob",
        "description": "",
        "version": "1.0"
    },
    "servers": [{
        "url": "https://${host}/pagopastorage"
    }],
    "paths": {
        "/*": {
            "get": {
                "summary": "getblob",
                "operationId": "getblob",
                "responses": {
                    "200": {
                        "description": null
                    }
                }
            },
            "post": {
                "summary": "postblob",
                "operationId": "postblob",
                "responses": {
                    "200": {
                        "description": null
                    }
                }
            },
            "put": {
                "summary": "putblob",
                "operationId": "putblob",
                "responses": {
                    "200": {
                        "description": null
                    },
                     "400": {
                         "description": "Content-Length is 0"
                     },
                     "413": {
                         "description": "Content-Length exceeds ${pgp-put-limit-bytes}"
                     }
                }
            },
            "delete": {
                "summary": "delblob",
                "operationId": "delblob",
                "responses": {
                    "200": {
                        "description": null
                    }
                }
            },
            "head": {
                "summary": "headblob",
                "operationId": "headblob",
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
