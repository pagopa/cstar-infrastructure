openapi: 3.0.1
info:
  title: IDPAY Payment API
  description: IDPAY Payment CIT
  version: '1.0'
servers:
  - url: https://api-io.dev.cstar.pagopa.it/idpay/payment
paths:
  /{transactionId}:
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
  /qrCode/{trxCode}/relate-user:
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
                $ref: '#/components/schemas/TransactionResponse'
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
  /qrCode/{trxCode}/authorize:
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
    AuthPaymentResponseDTO:
      type: object
      properties:
        id:
          type: string
        trxCode:
          type: string
        initiativeId:
          type: string
        status:
          type: string
        reward:
          type: number
        rejectionReasons:
          type: array
          items:
            type: string
          description: The list of rejection reasons
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
    Bearer:
      type: apiKey
      name: Authorization
      in: header
security:
  - Bearer: []
tags:
  - name: payment
    description: ''
