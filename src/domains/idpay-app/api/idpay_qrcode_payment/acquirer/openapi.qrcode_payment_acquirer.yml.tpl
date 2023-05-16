openapi: 3.0.1
info:
  title: IDPAY Payment Merchant API
  description: IDPAY Payment Merchant
  version: '1.0'
servers:
  - url: https://api-io.dev.cstar.pagopa.it/idpay/payment/qr-code/merchant
paths:
  /:
    post:
      tags:
        - payment
      summary: Merchant create transaction
      operationId: createTransaction
      parameters:
        - name: x-merchant-id
          in: header
          description: Merchant ID
          required: true
          schema:
            type: string
      requestBody:
        description: General information about Transaction
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/TransactionCreationRequest'
      responses:
        '201':
          description: Created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionResponse'
        '404':
          description: Transaction not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
  /{transactionId}/confirm:
    put:
      tags:
        - payment
      summary: Merchant confirms the payment and the event is notified to IDPay
      operationId: confirmPaymentQRCode
      parameters:
        - name: transactionId
          in: path
          description: Transaction ID
          required: true
          schema:
            type: string
        - name: x-merchant-id
          in: header
          description: Merchant ID
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionResponse'
        '400':
          description: Transaction is not AUTHORIZED
        '403':
          description: Merchant not allowed to operate on this transaction
        '404':
          description: Transaction does not exist
        '429':
          description: Too many Request
        '500':
          description: Server ERROR
  /status/{transactionId}:
    get:
      tags:
        - payment
      summary: Returns the detail of a transaction
      operationId: getStatusTransaction
      parameters:
        - name: transactionId
          in: path
          description: The initiative ID
          required: true
          schema:
            type: string
        - name: x-merchant-id
          in: header
          description: Merchant ID
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
components:
  schemas:
    TransactionCreationRequest:
      type: object
      required:
        - merchantFiscalCode
        - vat
        - idTrxIssuer
        - initiativeId
        - trxDate
        - amountCents
        - mcc
      properties:
        initiativeId:
          type: string
        merchantFiscalCode:
          type: string
        vat:
          type: string
        idTrxIssuer:
          type: string
        trxDate:
          type: string
          format: date-time
        amountCents:
          type: integer
          format: int64
        mcc:
          type: string
    TransactionResponse:
      type: object
      required:
       - id
       - trxCode
       - initiativeId
       - merchantId
       - idTrxIssuer
       - idTrxAcquire
       - trxDate
       - amountCents
       - amountCurrency
       - mcc
       - acquirerId
       - status
      properties:
        id:
          type: string
        trxCode:
          type: string
        initiativeId:
          type: string
        merchantId:
          type: string
        idTrxIssuer:
          type: string
        idTrxAcquire:
          type: string
        trxDate:
          type: string
          format: date-time
        amountCents:
          type: integer
          format: int64
        amountCurrency:
          type: string
        mcc:
          type: string
        acquirerId:
          type: string
        status:
          type: string
          enum: [CREATED, IDENTIFIED, AUTHORIZED, REWARDED, REJECTED]
        merchantFiscalCode:
          type: string
        vat:
          type: string
        splitPayment:
          type: boolean
        residualAmountCents:
          type: integer
          format: int64
    SyncTrxStatus:
      type: object
      required:
       - id
       - idTrxIssuer
       - trxCode
       - trxDate
       - operationType
       - amountCents
       - amountCurrency
       - mcc
       - acquirerId
       - merchantId
       - initiativeId
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
          enum: [CREATED, IDENTIFIED, AUTHORIZED, REWARDED, REJECTED]
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
    ApiKeyAuth:
      type: apiKey
      in: header
      name: Ocp-Apim-Subscription-Key
      description: The API key can be obtained through the developer portal
security:
  - ApiKeyAuth: [ ]
tags:
  - name: payment
    description: ''
