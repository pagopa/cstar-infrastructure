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
          "type": "string",
          "example": "12345678910"
        },
        "companyName": {
          "type": "string",
          "example": "companyName"
        },
        "registerCode": {
          "type": "string",
          "example": "12345"
        },
        "registerAuth": {
          "type": "string",
          "example": "aaa123aaa123"
        },
        "shops": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/MerchantShop"
          }
        }
      }
    },
    "MerchantShop": {
      "title": "MerchantShop",
      "type": "object",
      "properties": {
        "callId": {
          "type": "integer",
          "example": 1
        },
        "companyName": {
          "type": "string",
          "example": "companyName"
        },
        "companyAddress": {
          "type": "string",
          "example": "via Roma 1"
        },
        "providerId": {
          "type": "integer",
          "example": 1
        },
        "contactName": {
          "type": "string",
          "example": "Mario"
        },
        "contactSurname": {
          "type": "string",
          "example": "Rossi"
        },
        "contactEmail": {
          "type": "string",
          "example": "email@email.it"
        },
        "contactTel1": {
          "type": "string",
          "example": "+3932012345612"
        }
      }
    },
    "MerchantResource": {
      "title": "MerchantResource",
      "type": "object",
      "properties": {
        "enabled": {
          "type": "boolean"
        },
        "timestampTC": {
          "format": "date-time",
          "type": "string"
        },
        "shops": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/MerchantShopResource"
          }
        }
      }
    },
    "MerchantShopResource": {
      "title": "MerchantShopResource",
      "type": "object",
      "properties": {
        "callId": {
          "type": "integer",
          "example": 1
        },
        "contractId": {
          "type": "integer",
          "example": 1
        },
        "shopId": {
          "type": "string",
          "example": "2020_12345678910_0000001"
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