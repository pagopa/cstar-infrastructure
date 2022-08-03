openapi: 3.0.1
info:
  title: IDPAY Iban IO API
  description: IDPAY IBAN IO
  version: '1.0'
servers:
 - url: https://api-io.dev.cstar.pagopa.it/idpay/iban
paths:
  '/{iban}':
    get:
      tags:
        - iban
      summary: Returns the detail of the IBAN associated to the initiative by the citizen
      operationId: getIban
      parameters:
        - name: iban
          in: path
          description: The citizen iban
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/IbanDTO'
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
  '/':
    get:
      tags:
        - wallet
      summary: Returns the list of iban associated to the citizen
      operationId: getIbanList
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/IbanListDTO'
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
    IbanDTO:
      type: object
      properties:
        iban:
          type: string
        checkIbanStatus:
          type: string
        holderBank:
          type: string
        description:
          type: string
        channel:
          type: string
        bicCode:
          type: string
        queueDate:
          type: string
        checkIbanResponseDate:
          type: string
          format: date-time
    IbanListDTO:
      type: object
      properties:
        ibanList:
          type: array
          items:
            $ref: '#/components/schemas/IbanDTO'
          description: The list of iban of a citizen
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
  - name: iban
    description: ''
