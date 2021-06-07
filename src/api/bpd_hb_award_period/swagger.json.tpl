{
    "swagger": "2.0",
    "info": {
        "title": "BPD HB Award Period API",
        "version": "1.0",
        "description": "Api and Models"
    },
    "host": "${host}",
    "basePath": "/bpd/hb/award-periods",
    "schemes": ["https"],
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
    "security": [{
        "apiKeyHeader": []
    }, {
        "apiKeyQuery": []
    }],
    "paths": {
        "/": {
            "get": {
                "description": "findAll",
                "operationId": "findAll",
                "summary": "findAll",
                "parameters": [{
                    "name": "x-request-id",
                    "in": "header",
                    "description": "x-request-id",
                    "required": true,
                    "type": "string"
                }],
                "produces": ["application/json"],
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "$ref": "#/definitions/AwardPeriodResourceArray"
                        }
                    },
                    "401": {
                        "description": "Unauthorized"
                    },
                    "500": {
                        "description": ""
                    }
                }
            }
        },
        "/cache": {
            "get": {
                "operationId": "testcache",
                "summary": "testcache",
                "responses": {
                    "200": {
                        "description": ""
                    }
                }
            }
        }
    },
    "definitions": {
        "AwardPeriodResource": {
            "title": "AwardPeriodResource",
            "required": ["awardPeriodId", "cashbackPercentage", "endDate", "gracePeriod", "maxAmount", "maxPeriodCashback", "maxTransactionCashback", "maxTransactionEvaluated", "minPosition", "minTransactionNumber", "startDate", "status"],
            "type": "object",
            "properties": {
                "awardPeriodId": {
                    "format": "int64",
                    "description": "Identificativo univoco del periodo di premiazione",
                    "type": "integer"
                },
                "cashbackPercentage": {
                    "format": "int64",
                    "description": "Percentuale applicata al cashback",
                    "type": "integer"
                },
                "endDate": {
                    "format": "date",
                    "description": "Data di fine periodo premiazione. FORMATO ISO8601 yyyy-MM-dd",
                    "type": "string"
                },
                "gracePeriod": {
                    "format": "int64",
                    "description": "Periodo di tolleranza",
                    "type": "integer"
                },
                "maxAmount": {
                    "format": "int64",
                    "description": "Importo massimo erogabile nel periodo",
                    "type": "integer"
                },
                "maxPeriodCashback": {
                    "format": "int64",
                    "description": "Cashback massimo accumulabile per l'intero periodo",
                    "type": "integer"
                },
                "maxTransactionCashback": {
                    "format": "int64",
                    "description": "Cashback massimo accumulabile per singola transazione",
                    "type": "integer"
                },
                "maxTransactionEvaluated": {
                    "format": "int64",
                    "description": "Valore massimo trattato sulla transazione",
                    "type": "integer"
                },
                "minPosition": {
                    "format": "int64",
                    "description": "Posizione minima per rientrare nel rimborso speciale",
                    "type": "integer"
                },
                "minTransactionNumber": {
                    "format": "int64",
                    "description": "Numero minimo di transazioni per accedere al cashback",
                    "type": "integer"
                },
                "startDate": {
                    "format": "date",
                    "description": "Data di inizio periodo premiazione. FORMATO ISO8601 yyyy-MM-dd",
                    "type": "string"
                },
                "status": {
                    "description": "Stato del periodo (ACTIVE- INACTIVE- CLOSED)",
                    "type": "string"
                }
            },
            "example": {
                "awardPeriodId": 0,
                "cashbackPercentage": 0,
                "endDate": "string",
                "gracePeriod": 0,
                "maxAmount": 0,
                "maxPeriodCashback": 0,
                "maxTransactionCashback": 0,
                "maxTransactionEvaluated": 0,
                "minPosition": 0,
                "minTransactionNumber": 0,
                "startDate": "string",
                "status": "string"
            }
        },
        "AwardPeriodResourceArray": {
            "type": "array",
            "items": {
                "$ref": "#/components/schemas/AwardPeriodResource"
            }
        }
    },
    "tags": []
}