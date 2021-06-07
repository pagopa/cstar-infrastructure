{
    "swagger": "2.0",
    "info": {
        "title": "BPD TC API",
        "version": "1.0",
        "description": "Api and Models"
    },
    "host": "${host}",
    "basePath": "/bpd/tc",
    "schemes": ["https"],
    "paths": {
        "/html": {
            "get": {
                "description": "getTermsAndConditions",
                "operationId": "getTermsAndConditionsUsingGET",
                "summary": "getTermsAndConditionsHTML",
                "tags": ["Bonus Pagamenti Digitali File Storage Controller"],
                "produces": ["application/pdf"],
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "$ref": "#/definitions/InputStreamResource"
                        }
                    },
                    "404": {
                        "description": "Not Found"
                    },
                    "500": {
                        "description": ""
                    }
                }
            }
        },
        "/pdf": {
            "get": {
                "description": "getTermsAndConditions",
                "operationId": "getTermsAndConditionsPDF",
                "summary": "getTermsAndConditionsPDF",
                "produces": ["application/pdf"],
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "$ref": "#/definitions/InputStreamResource"
                        }
                    },
                    "404": {
                        "description": "Not Found"
                    },
                    "500": {
                        "description": ""
                    }
                }
            }
        }
    },
    "definitions": {
        "InputStream": {
            "title": "InputStream",
            "type": "object"
        },
        "InputStreamResource": {
            "title": "InputStreamResource",
            "type": "object",
            "properties": {
                "description": {
                    "type": "string"
                },
                "inputStream": {
                    "$ref": "#/definitions/InputStream"
                },
                "read": {
                    "type": "boolean"
                }
            }
        }
    },
    "tags": [{
        "name": "Bonus Pagamenti Digitali File Storage Controller",
        "description": "Bpd File Storage Controller Impl"
    }]
}