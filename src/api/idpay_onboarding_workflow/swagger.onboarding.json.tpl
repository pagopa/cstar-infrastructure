{
  "swagger": "2.0",
  "info": {
    "version": "1.0.0",
    "title": "IDPAY Onboarding Workflow API",
    "description": "IDPAY Onboarding Workflow"
  },
  "host": "idpay",
  "tags": [
    {
      "name": "onboarding",
      "description": ""
    }
  ],
  "schemes": [
    "https"
  ],
  "paths": {
    "/idpay/onboarding/citizen": {
      "put": {
        "tags": [
          "onboarding"
        ],
        "summary": "Acceptance of Terms & Conditions",
        "description": "",
        "operationId": "onboardingCitizen",
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json"
        ],
        "parameters": [
          {
            "in": "body",
            "name": "initiativeId",
            "description": "Id of the initiative",
            "required": true,
            "schema": {
              "$ref": "#/definitions/OnboardingPutDTO"
            }
          }
        ],
        "responses": {
          "204": {
            "description": "Acceptance successful"
          },
          "400": {
            "description": "Bad request",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
            }
          },
          "401": {
            "description": "Authentication failed",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
            }
          },
          "404": {
            "description": "The requested ID was not found",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
            }
          },
          "429": {
            "description": "Too many Request",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
            }
          },
          "500": {
            "description": "Server ERROR",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
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
    "/idpay/onboarding/initiative": {
      "put": {
        "tags": [
          "onboarding"
        ],
        "summary": "Check the initiative prerequisites",
        "description": "",
        "operationId": "checkPrerequisites2",
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json"
        ],
        "parameters": [
          {
            "in": "body",
            "name": "initiativeId",
            "description": "Id of the iniziative",
            "required": true,
            "schema": {
              "$ref": "#/definitions/OnboardingPutDTO"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Check successful",
            "schema": {
              "$ref": "#/definitions/RequiredCriteriaDTO"
            }
          },
          "202": {
            "description": "Accepted - Request Taken Over"
          },
          "400": {
            "description": "Bad request",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
            }
          },
          "401": {
            "description": "Authentication failed",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
            }
          },
          "403": {
            "description": "This enrolment is ended or suspended",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
            }
          },
          "404": {
            "description": "The requested ID was not found",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
            }
          },
          "429": {
            "description": "Too many Request",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
            }
          },
          "500": {
            "description": "Server ERROR",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
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
    "/idpay/onboarding/consent": {
      "put": {
        "tags": [
          "onboarding"
        ],
        "summary": "Save the consensus of both PDND and self-declaration",
        "description": "",
        "operationId": "consentOnboarding",
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
            "description": "Unique identifier of the subscribed initiative, flag for PDND acceptation and the list of accepted self-declared criteria",
            "required": true,
            "schema": {
              "$ref": "#/definitions/ConsentPutDTO"
            }
          }
        ],
        "responses": {
          "202": {
            "description": "Accepted - Request Taken Over"
          },
          "400": {
            "description": "Bad request",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
            }
          },
          "401": {
            "description": "Authentication failed",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
            }
          },
          "404": {
            "description": "The requested ID was not found",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
            }
          },
          "429": {
            "description": "Too many Request",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
            }
          },
          "500": {
            "description": "Server ERROR",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
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
    "/idpay/onboarding/{initiativeId}/status": {
      "get": {
        "tags": [
          "onboarding"
        ],
        "summary": "Returns the actual onboarding status",
        "description": "",
        "operationId": "onboardingStatus",
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
              "$ref": "#/definitions/OnboardingStatusDTO"
            }
          },
          "400": {
            "description": "Bad Request",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
            }
          },
          "401": {
            "description": "Authentication failed",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
            }
          },
          "404": {
            "description": "The requested ID was not found",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
            }
          },
          "500": {
            "description": "Server ERROR",
            "schema": {
              "$ref": "#/definitions/ErrorDto"
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
    "ConsentPutDTO": {
      "title": "ConsentPutDTO",
      "type": "object",
      "properties": {
        "initiativeId": {
          "type": "string",
          "description": "Unique identifier of the subscribed initiative"
        },
        "pdndAccept": {
          "type": "boolean",
          "description": "Flag for PDND acceptation"
        },
        "selfDeclarationList": {
          "type": "array",
          "description": "The list of accepted self-declared criteria",
          "items": {
            "$ref": "#/definitions/SelfConsentDTO"
          }
        }
      }
    },
    "OnboardingPutDTO": {
      "title": "OnboardingPutDTO",
      "type": "object",
      "properties": {
        "initiativeId": {
          "type": "string",
          "description": "Unique identifier of the subscribed initiative"
        }
      }
    },
    "OnboardingStatusDTO": {
      "title": "OnboardingStatusDTO",
      "type": "object",
      "properties": {
        "status": {
          "type": "string",
          "enum": [
            "ACCEPTED_TC",
            "ON_EVALUATION",
            "ONBOARDING_KO",
            "REGISTERED_ONLY_IBAN",
            "REGISTERED_ONLY_CC",
            "REGISTERED_REFUNDABLE"
          ],
          "description": "actual status of the citizen onboarding for an initiative"
        }
      }
    },
    "RequiredCriteriaDTO": {
      "type": "object",
      "required": [
        "listaStatoPerAnno"
      ],
      "properties": {
        "pdndCriteria": {
          "type": "array",
          "description": "The list of control made with PDND platform",
          "items": {
            "$ref": "#/definitions/PDNDCriteriaDTO"
          }
        },
        "selfDeclarationList": {
          "type": "array",
          "description": "The list of required self-declared criteria",
          "items": {
            "$ref": "#/definitions/SelfDeclarationDTO"
          }
        }
      }
    },
    "PDNDCriteriaDTO": {
      "type": "object",
      "properties": {
        "code": {
          "type": "string"
        },
        "description": {
          "type": "string"
        },
        "authority": {
          "type": "string"
        }
      }
    },
    "SelfDeclarationDTO": {
      "type": "object",
      "properties": {
        "code": {
          "type": "string"
        },
        "description": {
          "type": "string"
        }
      }
    },
    "SelfConsentDTO": {
      "type": "object",
      "properties": {
        "code": {
          "type": "string"
        },
        "accepted": {
          "type": "boolean"
        }
      }
    },
    "ErrorDto": {
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