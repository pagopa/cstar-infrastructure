openapi: 3.0.1
info:
  title: IDPAY Payment API
  description: IDPAY Payment
  version: '1.0'
servers:
  - url: https://api-io.dev.cstar.pagopa.it/idpay/payment
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
