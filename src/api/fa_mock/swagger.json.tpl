{
  "swagger": "2.0",
  "info": {
    "title": "FA Mock Api",
    "version": "1.0",
    "description": "Api and Models"
  },
  "host": "${host}",
  "basePath": "/fa/mock",
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
    "/transaction/rtd/send": {
      "post": {
        "description": "sendAcquirerTransaction",
        "operationId": "sendAcquirerTransactionUsingPOST",
        "summary": "sendAcquirerTransaction",
        "tags": [
          "Fatturazione Automatica Mock Controller"
        ],
        "parameters": [
          {
            "in": "body",
            "name": "AcquirerTransaction",
            "description": "AcquirerTransaction",
            "schema": {
              "$ref": "#/definitions/Transaction"
            }
          }
        ],
        "produces": [
          "application/json;charset=UTF-8"
        ],
        "responses": {
          "200": {
            "description": "OK"
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
    "/cash/register/pos/transaction/sender": {
      "post": {
        "description": "sendRegisterTransaction",
        "operationId": "sendRegisterTransactionUsingPOST",
        "summary": "sendRegisterTransaction",
        "tags": [
          "Fatturazione Automatica Mock Controller"
        ],
        "parameters": [
          {
            "name": "hpan",
            "in": "query",
            "description": "id dello strumento di pagamento, che corrisponde all'hash del PAN (Primary Account Number) del metodo di pagamento",
            "required": false,
            "type": "string"
          },
          {
            "in": "body",
            "name": "RegisterTransaction",
            "description": "RegisterTransaction",
            "schema": {
              "$ref": "#/definitions/RegisterTransaction"
            }
          }
        ],
        "produces": [
          "application/json;charset=UTF-8"
        ],
        "responses": {
          "200": {
            "description": "OK"
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
    "/transaction/status": {
      "post": {
        "description": "searchAcquirerTransactionError",
        "operationId": "searchAcquirerTransactionErrorUsingPOST",
        "summary": "searchAcquirerTransactionError",
        "tags": [
          "Fatturazione Automatica Mock Controller"
        ],
        "parameters": [
          {
            "in": "body",
            "name": "searchAcquirerTransactionError",
            "description": "searchAcquirerTransactionError",
            "schema": {
              "$ref": "#/definitions/Transaction"
            }
          }
        ],
        "produces": [
          "application/json;charset=UTF-8"
        ],
        "responses": {
          "200": {
            "description": "OK"
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
    "Transaction": {
      "title": "Transaction",
      "type": "object",
      "properties": {
        "acquirerCode": {
          "type": "string"
        },
        "acquirerId": {
          "format": "int64",
          "type": "integer"
        },
        "amount": {
          "format": "int64",
          "type": "integer"
        },
        "amountCurrency": {
          "type": "string"
        },
        "bin": {
          "format": "int64",
          "type": "integer"
        },
        "circuitType": {
          "type": "string"
        },
        "correlationId": {
          "format": "int64",
          "type": "integer"
        },
        "enabled": {
          "type": "boolean"
        },
        "hpan": {
          "type": "string"
        },
        "idTrxAcquirer": {
          "format": "int64",
          "type": "integer"
        },
        "idTrxIssuer": {
          "format": "int64",
          "type": "integer"
        },
        "insertDate": {
          "format": "date-time",
          "type": "string"
        },
        "insertUser": {
          "type": "string"
        },
        "mcc": {
          "type": "string"
        },
        "mccDescr": {
          "type": "string"
        },
        "merchantId": {
          "format": "int64",
          "type": "integer"
        },
        "operationType": {
          "type": "string"
        },
        "status": {
          "type": "string"
        },
        "terminalId": {
          "type": "string"
        },
        "trxDate": {
          "format": "date-time",
          "type": "string"
        },
        "updateDate": {
          "format": "date-time",
          "type": "string"
        },
        "updateUser": {
          "type": "string"
        }
      }
    },
    "RegisterTransaction": {
      "title": "RegisterTransaction",
      "type": "object",
      "properties": {
        "amount": {
          "format": "int64",
          "type": "integer"
        },
        "bin": {
          "format": "int64",
          "type": "integer"
        },
        "acquirerId": {
          "format": "int64",
          "type": "integer"
        },
        "idTrxIssuer": {
          "format": "int64",
          "type": "integer"
        },
        "merchantId": {
          "format": "int64",
          "type": "integer"
        },
        "terminalId": {
          "type": "string"
        },
        "trxDate": {
          "format": "date-time",
          "type": "string"
        },
        "merchantVatNumber": {
          "type": "string"
        },
        "pos_type": {
          "type": "string"
        }
      }
    }
  },
  "tags": [
    {
      "name": "Fatturazione Automatica Mock Controller",
      "description": "Fa Mock Controller Impl"
    }
  ]
}