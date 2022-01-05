{
  "swagger": "2.0",
  "info": {
    "title": "FA IO Merchant Api",
    "version": "1.0",
    "description": "Api and Models"
  },
  "host": "${host}",
  "basePath": "/fa/io/merchant",
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
    "/": {
      "put": {
        "description": "onboardingMerchantByIO",
        "operationId": "onboardingMerchantByIOUsingPut",
        "summary": "onboardingMerchantByIO",
        "tags": [
          "Fatturazione Automatica Merchant Controller"
        ],
        "parameters": [
          {
            "in": "body",
            "name": "Merchant",
            "description": "Merchant body",
            "schema": {
              "$ref": "#/definitions/Merchant"
            }
          }
        ],
        "produces": [
          "application/json;charset=UTF-8"
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
                "$ref": "#/definitions/MerchantResource"
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
    "Merchant": {
      "title": "Merchant",
      "type": "object",
      "properties": {
        "vatNumber": {
          "type": "string"
        },
        "fiscalCode": {
          "type": "string"
        },
        "companyName": {
          "type": "string"
        },
        "companyAddress": {
          "type": "string"
        },
        "providerId": {
          "format": "int64",
          "type": "integer"
        },
        "merchantIdList": {
          "type": "array",
          "items": {
            "type": "string"
          }
        }
      }
    },
    "MerchantResource": {
        "title": "MerchantResource",
        "type": "object",
        "properties": {
            "vatNumber": {
                "type": "string"
            },
            "fiscalCode": {
                "type": "string"
            },
            "timestampTC": {
                "format": "date-time",
                "type": "string"
            }
        }
    }
  },
  "tags": [
    {
      "name": "Fatturazione Automatica Merchant Controller",
      "description": "Fa Merchant Controller Impl"
    }
  ]
}