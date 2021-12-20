{
  "swagger": "2.0",
  "info": {
    "title": "FA EXT Merchant Api",
    "version": "1.0",
    "description": "Api and Models"
  },
  "host": "${host}",
  "basePath": "/fa/ext/merchant",
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
    "/provider": {
      "put": {
        "description": "onboardingMerchantByProvider",
        "operationId": "onboardingMerchantByProviderUsingPut",
        "summary": "onboardingMerchantByProvider",
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
    },
    "/other": {
      "put": {
        "description": "onboardingMerchantByOther",
        "operationId": "onboardingMerchantByOtherUsingPut",
        "summary": "onboardingMerchantByOther",
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
    },
    "/shop/{shopId}/contract/list": {
      "get": {
        "description": "contractListByShopId",
        "operationId": "contractListByShopIdUsingGet",
        "summary": "contractListByShopId",
        "tags": [
          "Fatturazione Automatica Merchant Controller"
        ],
        "parameters": [
          {
            "in": "path",
            "name": "shopId",
            "description": "Shop id",
            "type": "string",
            "required": true
          },
          {
            "in": "query",
            "name": "registerCode",
            "description": "Register code",
            "type": "string",
            "required": false
          }
        ],
        "produces": [
          "application/json;charset=UTF-8"
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/ContractResourceArray"
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
    },
    "/shop/{shopId}/contract/active": {
      "get": {
        "description": "activeContractByShopId",
        "operationId": "activeContractByShopIdUsingGet",
        "summary": "activeContractByShopId",
        "tags": [
          "Fatturazione Automatica Merchant Controller"
        ],
        "parameters": [
          {
            "in": "path",
            "name": "shopId",
            "description": "Shop id",
            "type": "string",
            "required": true
          },
          {
            "in": "query",
            "name": "registerCode",
            "description": "Register code",
            "type": "string",
            "required": false
          }
        ],
        "produces": [
          "application/json;charset=UTF-8"
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/ContractResource"
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
    },
    "ContractResourceArray": {
      "title": "ContractResourceArray",
      "type": "array",
      "items": {
        "$ref": "#/definitions/ContractResource"
      }
    },
    "ContractResource": {
      "title": "ContractResource",
      "type": "object",
      "properties": {
        "contractId": {
          "type": "integer"
        },
        "shopId": {
          "type": "string"
        },
        "providerId": {
          "type": "integer"
        },
        "activation": {
          "format": "date-time",
          "type": "string"
        },
        "deactivation": {
          "format": "date-time",
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
      "name": "Fatturazione Automatica Merchant Controller",
      "description": "Fa Merchant Controller Impl"
    }
  ]
}