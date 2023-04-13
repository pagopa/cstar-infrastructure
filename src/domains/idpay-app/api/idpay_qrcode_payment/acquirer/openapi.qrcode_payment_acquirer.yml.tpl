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
components:
  schemas:
    TransactionCreationRequest:
      type: object
      properties:
        initiativeId:
          type: string
        senderCode:
          type: string
        merchantFiscalCode:
          type: string
        vat:
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
        acquirerCode:
          type: string
        acquirerId:
          type: string
        callbackUrl:
          type: string
    TransactionResponse:
      type: object
      properties:
        id:
          type: string
        trxCode:
          type: string
        initiativeId:
          type: string
        senderCode:
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
        acquirerCode:
          type: string
        acquirerId:
          type: string
        status:
          type: string
          enum: [CREATED, IDENTIFIED, AUTHORIZED, REJECTED]
    Severity:
      type: string
      enum: [error, warning]
    ErrorDTO:
      type: object
      properties:
        severity:
          type: string
          items:
            $ref: "#/components/schemas/Severity"
        title:
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
