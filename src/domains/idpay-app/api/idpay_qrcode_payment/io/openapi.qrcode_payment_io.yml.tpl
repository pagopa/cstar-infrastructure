openapi: 3.0.1
info:
  title: IDPAY Payment CIT API
  description: IDPAY Payment CIT
  version: '1.0'
servers:
  - url: https://api-io.dev.cstar.pagopa.it/idpay/payment/qr-code
paths:
  /transaction/{transactionId}:
    get:
      tags:
        - payment
      summary: Returns the detail of a transaction
      operationId: getTransaction
      parameters:
        - name: transactionId
          in: path
          description: The initiative ID
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SyncTrxStatus'
        '403':
          description: Transaction is associated to another user
        '404':
          description: Transaction does not exist
  /{trxCode}/relate-user:
    put:
      tags:
        - payment
      summary: Pre Authorize payment
      operationId: putPreAuthPayment
      parameters:
        - name: trxCode
          in: path
          description: The transaction's code
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AuthPaymentResponseDTO'
        '401':
          description: Token not validated correctly
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '403':
          description: Transaction is associated to another user, or user hasn't joined the initiative
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '404':
          description: Transaction does not exist
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
  /{trxCode}/authorize:
    put:
      tags:
        - payment
      summary: Authorize payment
      operationId: putAuthPayment
      parameters:
        - name: trxCode
          in: path
          description: The transaction's code
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AuthPaymentResponseDTO'
        '400':
          description: Transaction is not IDENTIFIED or AUTHORIZE
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '403':
          description: Transaction is associated to another user
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '404':
          description: Transaction does not exist
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '429':
          description: Too many Request
components:
  schemas:
    SyncTrxStatus:
      type: object
      required:
       - id
       - idTrxIssuer
       - trxCode
       - trxDate
       - authDate
       - operationType
       - amountCents
       - amountCurrency
       - mcc
       - acquirerId
       - merchantId
       - initiativeId
       - rewardCents
       - rejectionReasons
       - status
      properties:
        id:
          type: string
        idTrxIssuer:
          type: string
        trxCode:
          type: string
        trxDate:
          type: string
          format: date-time
        authDate:
          type: string
          format: date-time
        operationType:
          type: string
          enum: [CHARGE, REFUND]
        amountCents:
          type: integer
          format: int64
        amountCurrency:
          type: string
        mcc:
          type: string
        acquirerId:
          type: string
        merchantId:
          type: string
        initiativeId:
          type: string
        rewardCents:
          type: integer
          format: int64
        rejectionReasons:
          type: array
          items:
            type: string
          description: The list of rejection reasons
        status:
          type: string
          enum: [CREATED, IDENTIFIED, AUTHORIZED, REJECTED]
    AuthPaymentResponseDTO:
      type: object
      required:
       - id
       - trxCode
       - initiativeId
       - status
       - rejectionReasons
       - amountCents
       - splitPayment
      properties:
        id:
          type: string
        trxCode:
          type: string
        initiativeId:
          type: string
        status:
          type: string
          enum: [CREATED, IDENTIFIED, AUTHORIZED, REJECTED]
        reward:
          type: integer
          format: int64
        rejectionReasons:
          type: array
          items:
            type: string
          description: The list of rejection reasons
        amountCents:
          type: integer
          format: int64
        splitPayment:
          type: integer
          format: int64
    ErrorDTO:
      type: object
      required:
       - code
       - message
      properties:
        code:
          type: string
        message:
          type: string
  securitySchemes:
    Bearer:
      type: apiKey
      name: Authorization
      in: header
security:
  - Bearer: []
tags:
  - name: payment
    description: ''
