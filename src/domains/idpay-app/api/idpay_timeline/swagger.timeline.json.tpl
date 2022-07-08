{
  "swagger": "2.0",
  "info": {
    "version": "1.0.0",
    "title": "IdPay - Timeline"
  },
  "host": "idpay",
  "tags": [
    {
      "name": "timeline",
      "description": ""
    }
  ],
  "schemes": [
    "https"
  ],
  "paths": {
    "/idpay/timeline/{initiativeId}": {
      "get": {
        "tags": [
          "timeline"
        ],
        "summary": "Returns the list of transactions and operations of an initiative of a citizen sorted by date (newest->oldest)",
        "description": "",
        "operationId": "getTimeline",
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json"
        ],
        "parameters": [
          {
            "name": "initiativeId",
            "in": "path",
            "description": "The initiative ID",
            "required": true,
            "type": "string"
          },
          {
            "name": "operationType",
            "in": "query",
            "type": "string",
            "description": "Operation type filter"
          },
          {
            "name": "page",
            "in": "query",
            "type": "integer",
            "description": "The number of the page"
          },
          {
            "name": "size",
            "in": "query",
            "type": "integer",
            "description": "Number of items, default 3 - max 10"
          }
        ],
        "responses": {
          "200": {
            "description": "Ok",
            "schema": {
              "$ref": "#/definitions/TimelineDTO"
            }
          },
          "401": {
            "description": "Authentication failed",
            "schema": {
              "$ref": "#/definitions/ErrorDTO"
            }
          },
          "404": {
            "description": "The requested ID was not found",
            "schema": {
              "$ref": "#/definitions/ErrorDTO"
            }
          },
          "429": {
            "description": "Too many Request",
            "schema": {
              "$ref": "#/definitions/ErrorDTO"
            }
          },
          "500": {
            "description": "Server ERROR",
            "schema": {
              "$ref": "#/definitions/ErrorDTO"
            }
          }
        },
        "security": [
          {
            "BearerAuthToken": []
          }
        ]
      }
    },
    "/idpay/timeline/{initiativeId}/{operationId}": {
      "get": {
        "tags": [
          "timeline"
        ],
        "summary": "Returns the detail of a transaction",
        "description": "",
        "operationId": "getTimelineDetail",
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json"
        ],
        "parameters": [
          {
            "name": "initiativeId",
            "in": "path",
            "description": "The initiative ID",
            "required": true,
            "type": "string"
          },
          {
            "name": "operationId",
            "in": "path",
            "description": "The operation ID",
            "required": true,
            "type": "string"
          }
        ],
        "responses": {
          "200": {
            "description": "Ok",
            "schema": {
              "$ref": "#/definitions/DetailOperationDTO"
            }
          },
          "401": {
            "description": "Authentication failed",
            "schema": {
              "$ref": "#/definitions/ErrorDTO"
            }
          },
          "404": {
            "description": "The requested ID was not found",
            "schema": {
              "$ref": "#/definitions/ErrorDTO"
            }
          },
          "429": {
            "description": "Too many Request",
            "schema": {
              "$ref": "#/definitions/ErrorDTO"
            }
          },
          "500": {
            "description": "Server ERROR",
            "schema": {
              "$ref": "#/definitions/ErrorDTO"
            }
          }
        },
        "security": [
          {
            "BearerAuthToken": []
          }
        ]
      }
    }
  },
  "securityDefinitions": {
    "BearerAuthToken": {
      "type": "apiKey",
      "name": "Authorization",
      "in": "header"
    }
  },
  "definitions": {
    "TimelineDTO": {
      "type": "object",
      "properties": {
        "lastUpdate": {
          "type": "string",
          "format": "date-time",
          "description": "date of the last update"
        },
        "operationList": {
          "type": "array",
          "description": "the list of transactions and operations of an initiative of a citizen",
          "items": {
            "$ref": "#/definitions/OperationDTO"
          }
        }
      }
    },
    "DetailOperationDTO": {
      "type": "object",
      "properties": {
        "operationId": {
          "type": "string"
        },
        "operationType": {
          "type": "string",
          "enum": [
            "PAID_REFUND",
            "TRANSACTION",
            "REVERSAL",
            "ADD_IBAN",
            "ADD_INSTRUMENT",
            "DELETE_INSTRUMENT",
            "ONBOARDING"
          ]
        },
        "hpan": {
          "type": "string"
        },
        "amount": {
          "type": "string"
        },
        "accrued": {
          "type": "string"
        },
        "operationDate": {
          "type": "string",
          "format": "date-time"
        },
        "circuitType": {
          "type": "string",
          "enum": [
            "00",
            "01",
            "02",
            "03",
            "04",
            "05",
            "06",
            "07",
            "08",
            "09",
            "10"
          ],
          "description": "00-> Bancomat, 01->Visa, 02->Mastercard, 03->Amex, 04->JCB, 05->UnionPay, 06->Diners, 07->PostePay, 08->BancomatPay, 09->Satispay, 10->PrivateCircuit"
        },
        "channel": {
          "type": "string"
        },
        "iban": {
          "type": "string"
        },
        "idTrxIssuer": {
          "type": "string"
        },
        "idTrxAcquirer": {
          "type": "string"
        }
      }
    },
    "OperationDTO": {
      "type": "object",
      "properties": {
        "operationId": {
          "type": "string"
        },
        "operationType": {
          "type": "string",
          "enum": [
            "PAID_REFUND",
            "TRANSACTION",
            "REVERSAL",
            "ADD_IBAN",
            "ADD_INSTRUMENT",
            "DELETE_INSTRUMENT",
            "ONBOARDING"
          ]
        },
        "hpan": {
          "type": "string"
        },
        "amount": {
          "type": "string"
        },
        "operationDate": {
          "type": "string",
          "format": "date-time"
        },
        "circuitType": {
          "type": "string",
          "enum": [
            "00",
            "01",
            "02",
            "03",
            "04",
            "05",
            "06",
            "07",
            "08",
            "09",
            "10"
          ],
          "description": "00-> Bancomat, 01->Visa, 02->Mastercard, 03->Amex, 04->JCB, 05->UnionPay, 06->Diners, 07->PostePay, 08->BancomatPay, 09->Satispay, 10->PrivateCircuit"
        },
        "channel": {
          "type": "string"
        },
        "iban": {
          "type": "string"
        }
      }
    },
    "ErrorDTO": {
      "type": "object",
      "properties": {
        "code": {
          "type": "integer",
          "format": "int32"
        },
        "message": {
          "type": "string"
        }
      }
    }
  }
}
