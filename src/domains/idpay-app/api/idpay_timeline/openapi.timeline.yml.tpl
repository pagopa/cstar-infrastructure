openapi: 3.0.1
info:
  title: IDPAY Timeline IO API
  description: IDPAY Timeline IO
  version: '1.0'
paths:
  '/{initiativeId}':
    get:
      tags:
        - timeline
      summary: Returns the list of transactions and operations of an initiative of a citizen sorted by date (newest->oldest)
      operationId: getTimeline
      parameters:
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
              example:
                lastUpdate: string
                operationList:
                  - operationId: string
                    operationType: PAID_REFUND
                    hpan: string
                    amount: string
                    operationDate: string
                    circuitType: '00'
                    channel: string
                    iban: string
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
                $ref: '#/components/schemas/DetailOperationDTO'
              example:
                operationId: string
                operationType: PAID_REFUND
                hpan: string
                amount: string
                accrued: string
                operationDate: string
                circuitType: '00'
                channel: string
                iban: string
                idTrxIssuer: string
                idTrxAcquirer: string
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
    TimelineDTO:
      type: object
      properties:
        lastUpdate:
          type: string
          description: date of the last update
          format: date-time
        operationList:
          type: array
          items:
            $ref: '#/components/schemas/OperationDTO'
          description: the list of transactions and operations of an initiative of a citizen
    DetailOperationDTO:
      type: object
      properties:
        operationId:
          type: string
        operationType:
          enum:
            - PAID_REFUND
            - TRANSACTION
            - REVERSAL
            - ADD_IBAN
            - ADD_INSTRUMENT
            - DELETE_INSTRUMENT
            - ONBOARDING
          type: string
        hpan:
          type: string
        amount:
          type: string
        accrued:
          type: string
        operationDate:
          type: string
          format: date-time
        circuitType:
          enum:
            - '00'
            - '01'
            - '02'
            - '03'
            - '04'
            - '05'
            - '06'
            - '07'
            - '08'
            - '09'
            - '10'
          type: string
          description: '00-> Bancomat, 01->Visa, 02->Mastercard, 03->Amex, 04->JCB, 05->UnionPay, 06->Diners, 07->PostePay, 08->BancomatPay, 09->Satispay, 10->PrivateCircuit'
        channel:
          type: string
        iban:
          type: string
        idTrxIssuer:
          type: string
        idTrxAcquirer:
          type: string
    OperationDTO:
      type: object
      properties:
        operationId:
          type: string
        operationType:
          enum:
            - PAID_REFUND
            - TRANSACTION
            - REVERSAL
            - ADD_IBAN
            - ADD_INSTRUMENT
            - DELETE_INSTRUMENT
            - ONBOARDING
          type: string
        hpan:
          type: string
        amount:
          type: string
        operationDate:
          type: string
          format: date-time
        circuitType:
          enum:
            - '00'
            - '01'
            - '02'
            - '03'
            - '04'
            - '05'
            - '06'
            - '07'
            - '08'
            - '09'
            - '10'
          type: string
          description: '00-> Bancomat, 01->Visa, 02->Mastercard, 03->Amex, 04->JCB, 05->UnionPay, 06->Diners, 07->PostePay, 08->BancomatPay, 09->Satispay, 10->PrivateCircuit'
        channel:
          type: string
        iban:
          type: string
    ErrorDTO:
      type: object
      properties:
        code:
          type: integer
          format: int32
        message:
          type: string
  securitySchemes:
    apiKeyHeader:
      type: apiKey
      name: Ocp-Apim-Subscription-Key
      in: header
    apiKeyQuery:
      type: apiKey
      name: subscription-key
      in: query
security:
  - apiKeyHeader: [ ]
  - apiKeyQuery: [ ]
tags:
  - name: timeline
    description: ''
