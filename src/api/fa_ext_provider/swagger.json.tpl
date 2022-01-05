{
  "swagger": "2.0",
  "info": {
    "title": "FA EXT Provider Api",
    "version": "1.0",
    "description": "Api and Models"
  },
  "host": "${host}",
  "basePath": "/fa/ext/provider",
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
    {
      "apiKeyHeader": []
    },
    {
      "apiKeyQuery": []
    }
  ],
  "paths": {
    "/list": {
      "get": {
        "description": "providerListUsingGET",
        "operationId": "providerListUsingGET",
        "summary": "providerListUsingGET",
        "tags": [
          "Fatturazione Automatica Provider Controller"
        ],
        "produces": [
          "application/json;charset=UTF-8"
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
               "$ref": "#/definitions/ProviderResource"
            }
          },
          "401": {
            "description": "Unauthorized"
          },
          "403": {
            "description": "Forbidden"
          },
          "404": {
            "description": "Not Found"
          }
        }
      }
    }
  },
  "definitions": {
    "ProviderResource":{
        "title": "ProviderResource",
        "type": "array",
        "items": {
            "$ref": "#/definitions/ProviderItem"
        }
    },
    "ProviderItem": {
      "title": "ProviderItem",
      "type": "object",
      "properties": {
        "providerId": {
          "type": "integer"
        },
        "providerDesc": {
          "type": "string"
        },
        "enabled": {
          "type": "boolean"
        }
      }
    }
  },
  "tags": [
    {
      "name": "Fatturazione Automatica Provider Controller",
      "description": "Fa Provider Controller Impl"
    }
  ]
}