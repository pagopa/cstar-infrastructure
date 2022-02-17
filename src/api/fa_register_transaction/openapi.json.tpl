{
  "swagger": "2.0",
  "info": {
    "title": "FA Register Transaction Api",
    "version": "1.0",
    "description": "Api and Models"
  },
  "host": "${host}",
  "basePath": "/fa/ext/transaction",
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
    "/pos/invoice/request": {
      "post": {
        "description": "createPosTransaction",
        "operationId": "createPosTransactionUsingPOST",
        "summary": "createPosTransaction",
        "tags": [
          "Fatturazione Automatica Transaction Controller"
        ],
        "parameters": [
          {
            "name": "posTransactionRequestDTO",
            "in": "body",
            "schema": {
              "$ref": "#/definitions/PosTransactionRequestDTO"
            }
          }
        ],
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json;charset=UTF-8"
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/PosTransactionResource"
            }
          },
          "201": {
            "description": "Created"
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
    "/pos/invoice/request/{id}": {
      "get": {
        "description": "getPosTransaction",
        "operationId": "getPosTransactionUsingGET",
        "summary": "getPosTransaction",
        "tags": [
          "Fatturazione Automatica Transaction Controller"
        ],
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "required": true,
            "type": "string"
          }
        ],
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json;charset=UTF-8"
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/PosTransactionRequestDTO"
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
    "/pos/invoice/request/{id}/customer": {
      "get": {
        "description": "getPosTransactionCustomer",
        "operationId": "getPosTransactionCustomerUsingGET",
        "summary": "getPosTransactionCustomer",
        "tags": [
          "Fatturazione Automatica Transaction Controller"
        ],
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "required": true,
            "type": "string"
          }
        ],
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json;charset=UTF-8"
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/PosTransactionRequestCustomerDTO"
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
    "PosTransactionRequestDTO": {
      "title": "PosTransactionRequestDTO",
      "required": [
        "acquirerId",
        "amount",
        "binCard",
        "customerParamDesc",
        "merchantId",
        "terminalId",
        "trxDate",
        "vatNumber",
        "contractId",
        "authCode"
      ],
      "type": "object",
      "properties": {
        "acquirerId": {
          "format": "int64",
          "description": "nel caso di transazione con carta rappresenta il valore omonimo veicolato nei tracciati dei circuiti internazionali",
          "type": "integer"
        },
        "amount": {
          "format": "int64",
          "description": "in centesimi di euro (es: 10 = 1000) ed in valore assoluto",
          "type": "integer"
        },
        "binCard": {
          "description": "codice Bin relativo allo strumento di pagamento",
          "type": "string"
        },
        "customerParamDesc": {
          "description": "parametro che identifica se il Compratore richiede la fattura tramite CF oppure P.IVA",
          "enum": [
            "FISCAL_CODE",
            "VAT_NUMBER"
          ],
          "type": "string"
        },
        "merchantId": {
          "format": "int64",
          "description": "Identificativo univoco del negozio fisico presso lAcquirer. serve ad identificare lesercente e la categoria merceologica",
          "type": "integer"
        },
        "terminalId": {
          "format": "int64",
          "description": "identificativo del terminale dell'esercente",
          "type": "integer"
        },
        "trxDate": {
          "format": "date-time",
          "description": "timestamp delloperazione di pagamento effettuata presso lesercente",
          "type": "string"
        },
        "vatNumber": {
          "description": "partita iva associata al merchant",
          "type": "string"
        },
        "contractId": {
          "description": "identificativo del legame tra registrante e shop",
          "type": "integer"
        },
        "authCode": {
          "description": "codice autorizzativo relativo la transazione",
          "type": "string"
        }
      },
      "example": {
        "acquirerId": 0,
        "amount": 0,
        "binCard": "string",
        "customerParamDesc": "FISCAL_CODE",
        "merchantId": 0,
        "terminalId": 0,
        "trxDate": "string",
        "vatNumber": "string",
        "contractId": 0,
        "authCode": "string"
      }
    },
    "PosTransactionResource": {
      "title": "PosTransactionResource",
      "required": [
        "invoiceRequestId"
      ],
      "type": "object",
      "properties": {
        "invoiceRequestId": {
          "description": "id richiesta staccato dalla piattaforma di Fatturazione Automatica",
          "type": "string"
        },
        "providerEndpoint": {
          "description": "puntamento al provider di fatturazione per l'invio dei dati necessari a finalizzare la fattura",
          "type": "string"
        }
      },
      "example": {
        "invoiceRequestId": "PAGOPA000000000000001"
      }
    },
    "PosTransactionRequestCustomerDTO": {
      "title": "PosTransactionRequestCustomerDTO",
      "required": [
        "customerId",
        "customerName"
      ],
      "type": "object",
      "properties": {
        "customerId": {
          "description": "id customer (PIVA o CF)",
          "type": "string"
        },
        "customerName": {
          "description": "dettagli relativi al customer legato alla fattura",
          "type": "string"
        },
        "SDICode": {
          "description": "codice SDI fornito dal customer per l'invio fattura",
          "type": "string"
        },
        "providerEndpoint": {
          "description": "puntamento al provider di fatturazione per l'invio dei dati necessari a finalizzare la fattura",
          "type": "string"
        }
      },
      "example": {
        "customerId": "AAABBB01C02D123E",
        "customerName": "Mario Rossi",
        "SDICode": "0000000",
        "providerEndpoint": "https:\\\\www.provider.fatturazione.com\\invio\\fattura"
      }
    }
  },
  "tags": [
    {
      "name": "Fatturazione Automatica Transaction Controller",
      "description": "Fa Transaction Controller Impl"
    }
  ]
}