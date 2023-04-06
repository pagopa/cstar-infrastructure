openapi: 3.0.1
info:
  title: IDPAY Payment Merchant API
  description: IDPAY Payment Merchant
  version: '1.0'
servers:
  - url: https://api-io.dev.cstar.pagopa.it/idpay/payment
paths:
  '/qr-code/{initiativeId}/{trxCode}/confirm':
    put:
      tags:
        - payment
      summary: Merchant confirms the payment and the event is notified to IDPay
      operationId: confirmPaymentQRCode
      parameters:
        - name: initiativeId
          in: path
          description: The initiative ID
          required: true
          schema:
            type: string
        - name: trxCode
          in: path
          description: Transaction's temporary code
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PaymentDTO'
        '400':
          description: Transaction is not REWARDED
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
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
components:
  schemas:
    PaymentDTO:
      type: object
      properties:
        id:
          type: string
        trxCode:
          type: string
        initiativeId:
          type: string
        merchantId:
          type: string
        senderCode:
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
        amount:
          type: string
        amountCurrency:
          type: string
        mcc:
          type: string
        acquirerCode:
          type: string
        acquirerId:
          type: string
        idTrxAcquirer:
          type: string
    ErrorDTO:
      type: object
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
