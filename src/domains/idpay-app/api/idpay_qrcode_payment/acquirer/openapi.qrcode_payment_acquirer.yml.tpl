openapi: 3.0.1
info:
  title: IDPAY QR-Code Payment API
  description: IDPAY QR-Code Payment CIT
  version: '1.0'
servers:
  - url: https://api-io.dev.cstar.pagopa.it/idpay/payment/qr-code
paths:
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
