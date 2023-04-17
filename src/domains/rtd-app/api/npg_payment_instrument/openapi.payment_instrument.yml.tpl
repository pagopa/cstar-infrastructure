openapi: 3.0.3
info:
  title: Payment Instrument - OpenAPI 3.0
  description: |-
    Payment Instrument APIs 
  termsOfService: http://pagopa.it/terms/
  contact:
    email: apiteam@swagger.io
  license:
    name: Apache 2.0
    url: http://www.apache.org/licenses/LICENSE-2.0.html
  version: 1.0.0
externalDocs:
  description: Find out more about Swagger
  url: http://swagger.io
servers:
  - url: https://localhost:8080
tags:
  - name: PaymentInstrument
paths:
  /paymentGatewayOperationNotify:
    post:
      tags:
        - PaymentInstrument
      summary: Called by payment gateway to notify an operation result
      description: Called by payment gateway to notify an operation result
      operationId: paymentGatewayOperationNotify
      requestBody:
        description: Operation result body
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OperationResultRequest'
        required: true
      responses:
        '200':
          description: Successful operation    
        '400':
          description: Bad Request
    
components:
  schemas:
    OperationResultRequest:
      type: object
      properties:
        eventId:
          type: string
          format: uuid
          example: "74839f8e-28c4-4c5e-9af6-befecb12c657"
        eventTime:
          type: string
          example: "2023-03-23 14:24:39.421"
        securityToken:
          type: string
          example: "48f051537591413283e6b0c20d01c804"
        operation:
          $ref: '#/components/schemas/OperationSchema' 
    OperationSchema:
      type: object
      properties:
        orderId:
          type: string
        operationId:
          type: string
        channel:
          type: string
          example: ECOMMERCER
        operationType:
          type: string
          enum: [ "AUTHORIZED", "DECLINED" ]
        operationTime:
          type: string
          example: "2023-03-23 14:24:39.421"
        paymentMethod:
          type: string
          enum: ["CARD", "APM"]
        paymentCircuit:
          type: string
          enum: ["VISA", "MASTERCARD", "PAYPAL"]
        paymentInstrumentInfo:
          type: string
          example: "***0906"
        paymentEndToEndId:
          type: string
          example: "242440"
        cancelledOperationId:
          type: string
        operationAmount:
          type: string
          example: "100"
          description: "Cents"
        operationCurrency:
          type: string
          example: "EUR"
        additionalData:
          $ref: '#/components/schemas/OperationAdditionalDataSchema'
    
    OperationAdditionalDataSchema:
      description: Can be null for APM payment methods
      oneOf:
        - $ref: '#/components/schemas/OperationAdditionalCardDataSchema'
        - type: string
          example: null
      
    
    OperationAdditionalCardDataSchema:
      type: object
      description: Additional data related to data card. Only some information is reported here.
      properties:
        maskedPan:
          type: string
          example: "434994******0906"
        cardType:
          type: string
          example: "VISA"
        cardId:
          type: string
          example: "79e199c6bfb632f58ee2e6810aa39f7abcabc11ce66360d602ca61408171e230"
