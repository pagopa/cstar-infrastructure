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
          "type": "string",
          "example": "12345"
        },
        "acquirerId": {
          "format": "int64",
          "type": "integer",
          "example": 1
        },
        "amount": {
          "format": "int64",
          "type": "integer",
          "example": 10
        },
        "amountCurrency": {
          "type": "string",
          "example": "EUR"
        },
        "bin": {
          "format": "int64",
          "type": "integer",
          "example": 123456
        },
        "circuitType": {
          "type": "string",
          "example": "01"
        },
        "correlationId": {
          "format": "int64",
          "type": "integer",
          "example": 0
        },
        "enabled": {
          "type": "boolean",
          "example": true
        },
        "hpan": {
          "type": "string",
          "example": "r083u1r083i1jf83n1rc1nt9v3yn0t2ur39vt2mt028t08ty208t10t208ty240"
        },
        "idTrxAcquirer": {
          "format": "int64",
          "type": "integer",
          "example": 123154534314
        },
        "idTrxIssuer": {
          "format": "int64",
          "type": "integer",
          "example": 13435135134141
        },
        "insertDate": {
          "format": "date-time",
          "type": "string",
          "example": "2020-01-01T12:00:00+02:00"
        },
        "insertUser": {
          "type": "string",
          "example": "insertUser"
        },
        "mcc": {
          "type": "string",
          "example": "string"
        },
        "mccDescr": {
          "type": "string",
          "example": "string"
        },
        "merchantId": {
          "type": "string",
          "example": "2020_12345678910_0000001"
        },
        "operationType": {
          "type": "string",
          "example": "00"
        },
        "status": {
          "type": "string",
          "example": "enabled"
        },
        "terminalId": {
          "type": "string",
          "example": "123456"
        },
        "trxDate": {
          "format": "date-time",
          "type": "string",
          "example": "2019-12-31T12:00:00+02:00"
        },
        "updateDate": {
          "format": "date-time",
          "type": "string",
          "example": "2020-01-01T12:00:00+02:00"
        },
        "updateUser": {
          "type": "string",
          "example": "updateUser"
        }
      }
    },
    "RegisterTransaction": {
      "title": "RegisterTransaction",
      "type": "object",
      "properties": {
        "amount": {
          "format": "int64",
          "type": "integer",
          "example": 10
        },
        "bin": {
          "format": "int64",
          "type": "integer",
          "example": 123456
        },
        "acquirerId": {
          "format": "int64",
          "type": "integer",
          "example": 1
        },
        "idTrxIssuer": {
          "format": "int64",
          "type": "integer",
          "example": 13435135134141
        },
        "merchantId": {
          "type": "string",
          "example": "2020_12345678910_0000001"
        },
        "terminalId": {
          "type": "string",
          "example": "123456"
        },
        "trxDate": {
          "format": "date-time",
          "type": "string",
          "example": "2019-12-31T12:00:00+02:00"
        },
        "merchantVatNumber": {
          "type": "string",
          "example": "12345678910"
        },
        "pos_type": {
          "type": "string",
          "example": "ASSERVED_POS"
        },
        "contractId": {
          "type": "integer",
          "example": 1
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