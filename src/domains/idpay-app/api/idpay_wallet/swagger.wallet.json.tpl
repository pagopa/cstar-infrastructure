{
  "swagger": "2.0",
  "info": {
    "version": "1.0.0",
    "title": "IdPay - Wallet"
  },
  "host": "idpay",
  "tags": [
    {
      "name": "wallet",
      "description": ""
    }
  ],
  "schemes": [
    "https"
  ],
  "paths": {
    "/": {
      "get": {
        "tags": [
          "wallet"
        ],
        "summary": "Returns the list of active initiatives of a citizen",
        "description": "",
        "operationId": "getWallet",
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json"
        ],
        "responses": {
          "200": {
            "description": "Ok",
            "schema": {
              "$ref": "#/definitions/WalletDTO"
            }
          },
          "401": {
            "description": "Authentication failed",
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
    "/{initiativeId}": {
      "get": {
        "tags": [
          "wallet"
        ],
        "summary": "Returns the detail of an active initiative of a citizen",
        "description": "",
        "operationId": "getWalletDetail",
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
          }
        ],
        "responses": {
          "200": {
            "description": "Ok",
            "schema": {
              "$ref": "#/definitions/InitiativeDTO"
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
    "/iban": {
      "put": {
        "tags": [
          "wallet"
        ],
        "summary": "Association of an IBAN to an initiative",
        "description": "",
        "operationId": "enrollIban",
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json"
        ],
        "parameters": [
          {
            "in": "body",
            "name": "body",
            "description": "Unique identifier of the subscribed initiative, IBAN of the citizen",
            "required": true,
            "schema": {
              "$ref": "#/definitions/IbanPutDTO"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Enrollment OK"
          },
          "400": {
            "description": "Bad request",
            "schema": {
              "$ref": "#/definitions/ErrorDTO"
            }
          },
          "401": {
            "description": "Authentication failed",
            "schema": {
              "$ref": "#/definitions/ErrorDTO"
            }
          },
          "403": {
            "description": "Forbidden",
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
    "/iban/{initiativeId}": {
      "get": {
        "tags": [
          "wallet"
        ],
        "summary": "Returns the detail of the IBAN associated to the initiative by the citizen",
        "description": "",
        "operationId": "getIbanDetail",
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
          }
        ],
        "responses": {
          "200": {
            "description": "Ok",
            "schema": {
              "$ref": "#/definitions/IbanDTO"
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
    "/instrument": {
      "put": {
        "tags": [
          "wallet"
        ],
        "summary": "Association of a payment instrument to an initiative",
        "description": "",
        "operationId": "enrollInstrument",
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json"
        ],
        "parameters": [
          {
            "in": "body",
            "name": "body",
            "description": "Unique identifier of the subscribed initiative, instrument HPAN",
            "required": true,
            "schema": {
              "$ref": "#/definitions/InstrumentPutDTO"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Enrollment OK"
          },
          "400": {
            "description": "Bad request",
            "schema": {
              "$ref": "#/definitions/ErrorDTO"
            }
          },
          "401": {
            "description": "Authentication failed",
            "schema": {
              "$ref": "#/definitions/ErrorDTO"
            }
          },
          "403": {
            "description": "Forbidden",
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
      },
      "delete": {
        "tags": [
          "wallet"
        ],
        "summary": "Delete a payment instrument from an initiative",
        "description": "",
        "operationId": "deleteInstrument",
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json"
        ],
        "parameters": [
          {
            "in": "body",
            "name": "body",
            "description": "Unique identifier of the subscribed initiative, instrument HPAN",
            "required": true,
            "schema": {
              "$ref": "#/definitions/InstrumentPutDTO"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Enrollment OK"
          },
          "400": {
            "description": "Bad request",
            "schema": {
              "$ref": "#/definitions/ErrorDTO"
            }
          },
          "401": {
            "description": "Authentication failed",
            "schema": {
              "$ref": "#/definitions/ErrorDTO"
            }
          },
          "403": {
            "description": "Forbidden",
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
    "/instrument/{initiativeId}": {
      "get": {
        "tags": [
          "wallet"
        ],
        "summary": "Returns the list of payment instruments associated to the initiative by the citizen",
        "description": "",
        "operationId": "getInstrumentList",
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
          }
        ],
        "responses": {
          "200": {
            "description": "Ok",
            "schema": {
              "$ref": "#/definitions/InstrumentListDTO"
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
    "/{initiativeId}/status": {
      "get": {
        "tags": [
          "wallet"
        ],
        "summary": "Returns the actual wallet status",
        "description": "",
        "operationId": "getWalletStatus",
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
          }
        ],
        "responses": {
          "200": {
            "description": "Check successful",
            "schema": {
              "$ref": "#/definitions/WalletStatusDTO"
            }
          },
          "400": {
            "description": "Bad Request",
            "schema": {
              "$ref": "#/definitions/ErrorDTO"
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
    "IbanPutDTO": {
      "title": "IbanPutDTO",
      "type": "object",
      "properties": {
        "initiativeId": {
          "type": "string",
          "description": "Unique identifier of the subscribed initiative"
        },
        "iban": {
          "type": "string",
          "description": "IBAN of the citizen"
        },
        "description": {
          "type": "string",
          "description": "further information about the iban"
        }
      }
    },
    "InstrumentPutDTO": {
      "title": "InstrumentPutDTO",
      "type": "object",
      "properties": {
        "initiativeId": {
          "type": "string",
          "description": "Unique identifier of the subscribed initiative"
        },
        "hpan": {
          "type": "string",
          "description": "Payment instrument of the citizen"
        }
      }
    },
    "WalletStatusDTO": {
      "title": "WalletStatusDTO",
      "type": "object",
      "properties": {
        "status": {
          "type": "string",
          "enum": [
            "NOT_REFUNDABLE_ONLY_IBAN",
            "NOT_REFUNDABLE_ONLY_INSTRUMENT",
            "REFUNDABLE",
            "NOT_REFUNDABLE"
          ],
          "description": "actual status of the citizen wallet for an initiative"
        }
      }
    },
    "WalletDTO": {
      "type": "object",
      "properties": {
        "initiativeList": {
          "type": "array",
          "description": "The list of active initiatives of a citizen",
          "items": {
            "$ref": "#/definitions/InitiativeDTO"
          }
        }
      }
    },
    "InstrumentListDTO": {
      "type": "object",
      "properties": {
        "instrumentList": {
          "type": "array",
          "description": "The list of payment instruments associated to the initiative by the citizen",
          "items": {
            "$ref": "#/definitions/InstrumentDTO"
          }
        }
      }
    },
    "InstrumentDTO": {
      "title": "InstrumentDTO",
      "type": "object",
      "properties": {
        "hpan": {
          "type": "string",
          "description": "Payment instrument id"
        },
        "channel": {
          "type": "string"
        }
      }
    },
    "IbanDTO": {
      "type": "object",
      "properties": {
        "iban": {
          "type": "string"
        },
        "description": {
          "type": "string"
        },
        "holderBank": {
          "type": "string"
        },
        "channel": {
          "type": "string"
        }
      }
    },
    "InitiativeDTO": {
      "type": "object",
      "properties": {
        "initiativeId": {
          "type": "string"
        },
        "initiativeName": {
          "type": "string"
        },
        "status": {
          "type": "string",
          "enum": [
            "NOT_REFUNDABLE_ONLY_IBAN",
            "NOT_REFUNDABLE_ONLY_INSTRUMENT",
            "REFUNDABLE",
            "NOT_REFUNDABLE"
          ]
        },
        "endDate": {
          "type": "string",
          "format": "date"
        },
        "available": {
          "type": "string"
        },
        "accrued": {
          "type": "string"
        },
        "refunded": {
          "type": "string"
        },
        "iban": {
          "type": "string"
        },
        "nInstr": {
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
