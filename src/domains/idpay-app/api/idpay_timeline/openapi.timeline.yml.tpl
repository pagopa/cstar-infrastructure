openapi: 3.0.1
info:
  title: IDPAY Timeline IO API v2
  description: IDPAY Timeline IO
  version: '2.0'
servers:
  - url: https://api-io.dev.cstar.pagopa.it/idpay/timeline
paths:
  '/{initiativeId}':
    get:
      tags:
        - timeline
      summary: Returns the list of transactions and operations of an initiative of a citizen sorted by date (newest->oldest)
      operationId: getTimeline
      parameters:
        - name: Accept-Language
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: initiativeId
          in: path
          description: The initiative ID
          required: true
          schema:
            type: string
        - name: operationType
          in: query
          description: Operation type filter
          schema:
            type: string
        - name: page
          in: query
          description: The number of the page
          schema:
            type: integer
        - name: size
          in: query
          description: 'Number of items, default 3 - max 10'
          schema:
            type: integer
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TimelineDTO'
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
              example:
                code: 0
                message: string
        '404':
          description: The requested ID was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
              example:
                code: 0
                message: string
        '429':
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
              example:
                code: 0
                message: string
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
              example:
                code: 0
                message: string
  '/{initiativeId}/{operationId}':
    get:
      tags:
        - timeline
      summary: Returns the detail of a transaction
      operationId: getTimelineDetail
      parameters:
        - name: Accept-Language
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: initiativeId
          in: path
          description: The initiative ID
          required: true
          schema:
            type: string
        - name: operationId
          in: path
          description: The operation ID
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OperationDTO'
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
              example:
                code: 0
                message: string
        '404':
          description: The requested ID was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
              example:
                code: 0
                message: string
        '429':
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
              example:
                code: 0
                message: string
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
              example:
                code: 0
                message: string
components:
  schemas:
    OperationDTO:
      oneOf:
        - $ref: '#/components/schemas/TransactionDetailDTO'
        - $ref: '#/components/schemas/InstrumentOperationDTO'
        - $ref: '#/components/schemas/IbanOperationDTO'
        - $ref: '#/components/schemas/OnboardingOperationDTO'
        - $ref: '#/components/schemas/RefundOperationDTO'
    TimelineDTO:
      type: object
      required:
        - lastUpdate
        - operationList
      properties:
        lastUpdate:
          type: string
          description: date of the last update
          format: date-time
        operationList:
          type: array
          items:
            $ref: '#/components/schemas/OperationListDTO'
          description: the list of transactions and operations of an initiative of a citizen
    OperationListDTO:
      description: Complex type for items in the operation list
      oneOf:
        - $ref: '#/components/schemas/TransactionOperationDTO'
        - $ref: '#/components/schemas/InstrumentOperationDTO'
        - $ref: '#/components/schemas/RejectedInstrumentOperationDTO'
        - $ref: '#/components/schemas/IbanOperationDTO'
        - $ref: '#/components/schemas/OnboardingOperationDTO'
        - $ref: '#/components/schemas/RefundOperationDTO'
    RejectedInstrumentOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
        - brandLogo
        - maskedPan
        - channel
      properties:
        operationId:
          type: string
        operationType:
          enum:
            - REJECTED_ADD_INSTRUMENT
            - REJECTED_DELETE_INSTRUMENT
          type: string
        operationDate:
          type: string
          format: date-time
        brandLogo:
          type: string
        instrumentId:
          type: string
        maskedPan:
          type: string
        channel:
          type: string
    TransactionDetailDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
        - brandLogo
        - maskedPan
        - amount
        - accrued
        - circuitType
        - idTrxIssuer
        - idTrxAcquirer
      properties:
        operationId:
          type: string
        operationType:
          enum:
            - TRANSACTION
            - REVERSAL
          type: string
        brandLogo:
          type: string
        maskedPan:
          type: string
        amount:
          type: number
        accrued:
          type: number
        operationDate:
          type: string
          format: date-time
        circuitType:
          type: string
          description: '00-> Bancomat, 01->Visa, 02->Mastercard, 03->Amex, 04->JCB, 05->UnionPay, 06->Diners, 07->PostePay, 08->BancomatPay, 09->Satispay, 10->PrivateCircuit'
        idTrxIssuer:
          type: string
        idTrxAcquirer:
          type: string
    InstrumentOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
        - brandLogo
        - maskedPan
        - channel
      properties:
        operationId:
          type: string
        operationType:
          enum:
            - ADD_INSTRUMENT
            - DELETE_INSTRUMENT
          type: string
        operationDate:
          type: string
          format: date-time
        brandLogo:
          type: string
        maskedPan:
          type: string
        channel:
          type: string
    IbanOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
        - iban
        - channel
      properties:
        operationId:
          type: string
        operationType:
          enum:
            - ADD_IBAN
          type: string
        operationDate:
          type: string
          format: date-time
        iban:
          type: string
        channel:
          type: string
    OnboardingOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
      properties:
        operationId:
          type: string
        operationType:
          enum:
            - ONBOARDING
          type: string
        operationDate:
          type: string
          format: date-time
    RefundOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
        - amount
      properties:
        operationId:
          type: string
        operationType:
          enum:
            - PAID_REFUND
            - REJECTED_REFUND
          type: string
        operationDate:
          type: string
          format: date
        amount:
          type: number
    TransactionOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
        - brandLogo
        - maskedPan
        - amount
        - circuitType
      properties:
        operationId:
          type: string
        operationType:
          enum:
            - TRANSACTION
            - REVERSAL
          type: string
        operationDate:
          type: string
          format: date-time
        brandLogo:
          type: string
        maskedPan:
          type: string
        amount:
          type: number
        circuitType:
          type: string
          description: '00-> Bancomat, 01->Visa, 02->Mastercard, 03->Amex, 04->JCB, 05->UnionPay, 06->Diners, 07->PostePay, 08->BancomatPay, 09->Satispay, 10->PrivateCircuit'
    ErrorDTO:
      type: object
      required:
        - code
        - message
      properties:
        code:
          type: integer
          format: int32
        message:
          type: string
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
security:
  - bearerAuth: [ ]
tags:
  - name: timeline
    description: ''
