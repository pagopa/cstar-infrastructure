openapi: 3.0.1
info:
  title: IDPAY Timeline Home Banking v1
  description: IDPAY Timeline Home Banking
  version: '1.0'
servers:
 - url: https://api-io.dev.cstar.pagopa.it/idpay/hb/timeline
paths:
  '/{initiativeId}':
    get:
      tags:
        - timeline
      summary: Returns the list of refunds of an initiative of a citizen sorted by date (newest->oldest)
      operationId: getTimelineRefund
      parameters:
        - name: Accept-Language
          in: header
          schema:
            type: string
            default: it-IT
          required: true
        - name: initiativeId
          in: path
          description: The initiative ID
          required: true
          schema:
            type: string
        - name: Fiscal-Code
          in: header
          description: The ID of the citizen
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TimelineDTO'
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
              example:
                code: 0
                message: "Parameter [size] must be less than or equal to 10"
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
            oneOf:
            - $ref: '#/components/schemas/RefundOperationDTO'
          description: the list of transactions and refunds of an initiative of a citizen
    RefundOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
        - amountCents
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
        amountCents:
          type: integer
          format: int64
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
