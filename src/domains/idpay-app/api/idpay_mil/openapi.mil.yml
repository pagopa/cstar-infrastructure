openapi: 3.0.1
info:
  title: IDPAY MIL API
  description: IDPAY MIL
  version: '1.0.1'
servers:
  - url: https://api-io.dev.cstar.pagopa.it/idpay/payment/qr-code/merchant
paths:
  /initiatives:
    get:
      tags:
        - merchant-initiatives
      summary: Returns the list of initiatives of a specific merchant
      description: Returns the list of initiatives of a specific merchant
      operationId: getMerchantInitiativeList
      parameters:
        - name: x-merchant-id
          in: header
          schema:
            type: string
            example: merchant-id
          required: true
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/InitiativeDTO'
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '404':
          description: The merchant ID was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
  /:
    post:
      tags:
        - merchant-transactions
      summary: Create a transaction
      operationId: createTransaction
      parameters:
        - name: x-merchant-id
          in: header
          schema:
            type: string
            example: merchant-id
          required: true
        - name: x-acquirer-id
          in: header
          schema:
            type: string
            example: acquirer-id
          required: true
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
  /{transactionId}:
    delete:
      tags:
        - merchant-transactions
      summary: Delete a transaction
      operationId: deleteTransaction
      parameters:
        - name: x-merchant-id
          in: header
          schema:
            type: string
            example: merchant-id
          required: true
        - name: x-acquirer-id
          in: header
          schema:
            type: string
            example: acquirer-id
          required: true
        - name: transactionId
          in: path
          description: The transaction ID
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Ok
        '403':
          description: Merchant not allowed to operate on this transaction
        '404':
          description: Transaction does not exist
        '429':
          description: Too many Request
  /status/{transactionId}:
    get:
      tags:
        - merchant-transactions
      summary: Returns the detail of a transaction
      operationId: getStatusTransaction
      parameters:
        - name: x-merchant-id
          in: header
          description: Merchant ID
          required: true
          schema:
            type: string
        - name: x-acquirer-id
          in: header
          schema:
            type: string
            example: acquirer-id
          required: true
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
    InitiativeDTO:
      type: object
      properties:
        initiativeId:
          type: string
        initiativeName:
          type: string
        organizationName:
          type: string
        status:
          type: string
          enum:
            - PUBLISHED
            - CLOSED
        startDate:
          type: string
          format: date
        endDate:
          type: string
          format: date
        serviceId:
          type: string
        enabled:
          type: boolean
    TransactionCreationRequest:
      type: object
      required:
        - initiativeId
        - amountCents
        - idTrxAcquirer
      properties:
        initiativeId:
          type: string
        amountCents:
          type: integer
          format: int64
        mcc:
          type: string
        idTrxAcquirer:
          type: string
    TransactionResponse:
      type: object
      required:
        - id
        - trxCode
        - initiativeId
        - merchantId
        - idTrxAcquirer
        - trxDate
        - amountCents
        - amountCurrency
        - acquirerId
        - status
        - qrcodePngUrl
        - qrcodeTxtUrl
      properties:
        id:
          type: string
        trxCode:
          type: string
        initiativeId:
          type: string
        merchantId:
          type: string
        idTrxAcquirer:
          type: string
        trxDate:
          type: string
          format: date-time
        trxExpirationMinutes:
          type: number
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
          enum:
            - CREATED
            - IDENTIFIED
            - AUTHORIZED
            - REWARDED
            - REJECTED
        merchantFiscalCode:
          type: string
        vat:
          type: string
        splitPayment:
          type: boolean
        residualAmountCents:
          type: integer
          format: int64
        qrcodePngUrl:
          type: string
        qrcodeTxtUrl:
          type: string
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
