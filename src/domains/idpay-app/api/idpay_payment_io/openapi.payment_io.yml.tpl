openapi: 3.0.1
info:
  title: IDPAY Payment IO
  description: IDPAY Payment IO
  version: '1.0'
servers:
  - url: https://api-io.dev.cstar.pagopa.it/idpay/payment
paths:
  /bar-code:
    post:
      tags:
        - payment
      summary: Create a transaction
      operationId: createBarCodeTransaction
      requestBody:
        description: 'ENG: Id of the iniziative - IT: Identificativo dell''iniziativa'
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/TransactionBarCodeRequest'
            example:
              initiativeId: string
      responses:
        '201':
          description: Created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionBarCodeResponse'
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: "PAYMENT_REQUEST_NOT_VALID"
                message: "Required initiativeId is not present"
        '404':
          description: Transaction not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: "PAYMENT_NOT_FOUND_EXPIRED"
                message: "Cannot find transaction with trxCode [trxCode]"
components:
  schemas:
    TransactionErrorDTO:
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
            - PAYMENT_ALREADY_AUTHORIZED
            - PAYMENT_BUDGET_EXHAUSTED
            - PAYMENT_GENERIC_REJECTED
            - PAYMENT_TOO_MANY_REQUESTS
            - PAYMENT_GENERIC_ERROR
            - PAYMENT_USER_SUSPENDED
          description: >-
            "ENG: Error code: PAYMENT_NOT_FOUND_EXPIRED: transaction not found
            or expired, PAYMENT_USER_NOT_VALID: user not valid,
            PAYMENT_STATUS_NOT_VALID: status not valid,
            PAYMENT_ALREADY_AUTHORIZED: transaction already authorized,
            PAYMENT_BUDGET_EXHAUSTED: budget exhausted,
            PAYMENT_GENERIC_REJECTED: generic rejected error,
            PAYMENT_TOO_MANY_REQUESTS: too many request, PAYMENT_GENERIC_ERROR:
            generic error, PAYMENT_USER_SUSPENDED: the user has been suspended
            on the initiative - IT: Codice di errore PAYMENT_NOT_FOUND_EXPIRED:
            transazione non trovata oppure caducata, PAYMENT_USER_NOT_VALID:
            utente no valido, PAYMENT_STATUS_NOT_VALID: stato non valido,
            PAYMENT_ALREADY_AUTHORIZED: transazione già autorizzata,
            PAYMENT_BUDGET_EXHAUSTED: budget esaurito, PAYMENT_GENERIC_REJECTED:
            errore generico di rifiuto, PAYMENT_TOO_MANY_REQUESTS: troppe
            richieste, PAYMENT_GENERIC_ERROR: errore generico,
            PAYMENT_USER_SUSPENDED: l'utente è stato sospeso sull'iniziativa"
        message:
          type: string
          description: 'ENG: Error message- IT: Messaggio di errore'
    TransactionBarCodeRequest:
      type: object
      required:
        - initiativeId
      properties:
        initiativeId:
          type: string
          description: 'ENG: Initiative ID - IT: Identificativo dell''iniziativa'
    TransactionBarCodeResponse:
      type: object
      required:
        - id
        - trxCode
        - initiativeId
        - trxDate
        - status
      properties:
        id:
          type: string
        trxCode:
          type: string
        initiativeId:
          type: string
        trxDate:
          type: string
          format: date-time
        trxExpirationMinutes:
          type: number
        status:
          type: string
          enum:
            - CREATED
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
