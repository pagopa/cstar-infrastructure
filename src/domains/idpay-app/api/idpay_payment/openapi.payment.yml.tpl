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
                $ref: '#/components/schemas/TransactionInProgress'
        '403':
          description: Transaction is associated to another user
        '404':
          description: Transaction does not exist
components:
  schemas:
    TransactionInProgress:
      type: object
      properties:
        id:
          type: string
        trxCode:
          type: string
        idTrxAcquirer:
          type: string
        acquirerCode:
          type: string
        trxDate:
          type: string
          format: date-time
        trxChargeDate:
          type: string
          format: date-time
        authDate:
          type: string
          format: date-time
        elaborationDateTime:
          type: string
          format: date-time
        operationType:
          type: string
        operationTypeTranscoded:
          type: string
          enum: [CHARGE, REFUND]
        idTrxIssuer:
          type: string
        amountCents:
          type: integer
          format: int64
        effectiveAmount:
          type: number
        amountCurrency:
          type: string
        mcc:
          type: string
        acquirerId:
          type: string
        merchantId:
          type: string
        senderCode:
          type: string
        merchantFiscalCode:
          type: string
        vat:
          type: string
        initiativeId:
          type: string
        reward:
          type: string
          items:
            $ref: "#/components/schemas/Reward"
        rejectionReasons:
          type: array
          items:
            type: string
          description: The list of rejection reasons
        userId:
          type: string
        status:
          type: string
          enum: [CREATED, IDENTIFIED, AUTHORIZED, REJECTED]
        callbackUrl:
          type: string
    Reward:
      type: object
      properties:
        initiativeId:
          type: string
        organizationId:
          type: string
        providedReward:
          type: number
        accruedReward:
          type: number
        capped:
          type: boolean
        dailyCapped:
          type: boolean
        monthlyCappedyearlyCappedweeklyCappedrefundcompleteRefund:
          type: boolean
        yearlyCappedweeklyCappedrefundcompleteRefund:
          type: boolean
        weeklyCappedrefundcompleteRefund:
          type: boolean
        refundcompleteRefund:
          type: boolean
        completeRefund:
          type: boolean
        counters:
          type: string
          items:
            $ref: "#/components/schemas/RewardCounters"
    RewardCounters:
      type: object
      properties:
        exhaustedBudget:
          type: boolean
        initiativeBudget:
          type: number
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
