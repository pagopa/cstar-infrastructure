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
        '400':
          description: Transaction is not CREATED or IDENTIFIED
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '401':
          description: Token not validated correctly
        '403':
          description: Transaction is associated to another user, or transaction rejected
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '404':
          description: Transaction does not exist or is expired
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
          description: Generic error
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
        '401':
          description: Token not validated correctly
        '403':
          description: Transaction is associated to another user, or transaction rejected
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '404':
          description: Transaction does not exist or is expired
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
          description: Generic error
          content:
           application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
  /{trxCode}:
    delete:
      tags:
        - payment
      summary: Cancel payment
      operationId: deletePayment
      parameters:
        - name: trxCode
          in: path
          description: The transaction's code
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Cancel Ok
        '400':
          description: Transaction is not IDENTIFIED
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '401':
          description: Token not validated correctly
        '403':
          description: Transaction is associated to another user, or transaction rejected
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '404':
          description: Transaction does not exist or is expired
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
          description: Generic error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
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
          enum:
            - CHARGE
            - REFUND
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
          enum:
          - CREATED
          - IDENTIFIED
          - AUTHORIZED
          - REJECTED
    AuthPaymentResponseDTO:
      type: object
      required:
       - id
       - trxCode
       - initiativeId
       - status
       - amountCents
      properties:
        id:
          type: string
        trxCode:
          type: string
        trxDate:
          type: string
          format: date-time
        initiativeId:
          type: string
        initiativeName:
          type: string
        businessName:
          type: string
        status:
          type: string
          enum:
          - CREATED
          - IDENTIFIED
          - AUTHORIZED
        reward:
          type: integer
          format: int64
        amountCents:
          type: integer
          format: int64
        residualBudget:
          type: number
    ErrorDTO:
      type: object
      required:
       - code
       - message
      properties:
        code:
          type: string
          enum:
          - PAYMENT_NOT_FOUND_EXPIRED
          - PAYMENT_USER_NOT_VALID
          - PAYMENT_STATUS_NOT_VALID
          - PAYMENT_BUDGET_EXHAUSTED
          - PAYMENT_GENERIC_REJECTED
          - PAYMENT_TOO_MANY_REQUESTS
          - PAYMENT_GENERIC_ERROR
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
