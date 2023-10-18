openapi: 3.0.1
info:
  title: IDPAY Payment QRCODE IO
  description: IDPAY Payment QRCODE IO
  version: '1.0'
servers:
  - url: https://api-io.dev.cstar.pagopa.it/idpay/payment/qr-code
paths:
  /{trxCode}/relate-user:
    put:
      tags:
        - payment
      summary: "ENG: Pre Authorize payment - IT: Preautorizzazione pagamento"
      operationId: putPreAuthPayment
      parameters:
        - name: trxCode
          in: path
          description: "ENG: The transaction's code - IT: Codice della transazione"
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
                $ref: '#/components/schemas/TransactionErrorDTO'
        '401':
          description: Token not validated correctly
        '403':
          description: Transaction is associated to another user, or transaction rejected
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
        '404':
          description: Transaction does not exist or is expired
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
        '429':
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
        '500':
          description: Generic error
          content:
           application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
  /{trxCode}/authorize:
    put:
      tags:
        - payment
      summary: "ENG: Authorize payment - IT: Autorizzazione pagamento"
      operationId: putAuthPayment
      parameters:
        - name: trxCode
          in: path
          description: "ENG: The transaction's code - IT: Codice della transazione"
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
                $ref: '#/components/schemas/TransactionErrorDTO'
        '401':
          description: Token not validated correctly
        '403':
          description: Transaction is associated to another user, or transaction rejected
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
        '404':
          description: Transaction does not exist or is expired
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
        '429':
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
        '500':
          description: Generic error
          content:
           application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
  /{trxCode}:
    delete:
      tags:
        - payment
      summary: "ENG: Cancel payment - IT: Cancellazione pagamento"
      operationId: deletePayment
      parameters:
        - name: trxCode
          in: path
          description: "ENG: The transaction's code - IT: Codice della transazione"
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
                $ref: '#/components/schemas/TransactionErrorDTO'
        '401':
          description: Token not validated correctly
        '403':
          description: Transaction is associated to another user, or transaction rejected
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
        '404':
          description: Transaction does not exist or is expired
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
        '429':
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
        '500':
          description: Generic error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
components:
  schemas:
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
          description: "ENG: Id of the payment - IT: Identificativo del pagamento"
        trxCode:
          type: string
          description: "ENG: Transaction code - IT: Codice della transazione"
        trxDate:
          type: string
          format: date-time
          description: "ENG: Transaction date - IT: Data della transazione"
        initiativeId:
          type: string
          description: "ENG: Id of the initiative - IT: Identificativo dell'iniziativa"
        initiativeName:
          type: string
          description: "ENG: Name of the initiative - IT: Nome della iniziativa"
        businessName:
          type: string
          description: "ENG: Business name - IT: Nome dell'esercente"
        status:
          type: string
          enum:
          - CREATED
          - IDENTIFIED
          - AUTHORIZED
          description: "ENG: Status of the payment [CREATED: Created, IDENTIFIED: User related, AUTHORIZED: authorized] - IT: Stato del pagamento [CREATED: Creato, IDENTIFIED: Utente associato, AUTHORIZED: autorizzato]"
        reward:
          type: integer
          format: int64
          description: "ENG: Reward - IT: Premio generato"
        amountCents:
          type: integer
          format: int64
          description: "ENG: Amount cents - IT: Importo in centessimi"
        residualBudget:
          type: number
          description: "ENG: Residual budget - IT: Budget residuo"
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
            - PAYMENT_USER_NOT_ONBOARDED
            - PAYMENT_USER_UNSUBSCRIBED
            - PAYMENT_INITIATIVE_NOT_FOUND
            - PAYMENT_INITIATIVE_INVALID_DATE
            - PAYMENT_INITIATIVE_NOT_DISCOUNT
          description: >-
            "ENG: Error code: PAYMENT_NOT_FOUND_EXPIRED: transaction not found
            or expired, PAYMENT_USER_NOT_VALID: user not valid,
            PAYMENT_STATUS_NOT_VALID: status not valid,
            PAYMENT_ALREADY_AUTHORIZED: transaction already authorized,
            PAYMENT_BUDGET_EXHAUSTED: budget exhausted,
            PAYMENT_GENERIC_REJECTED: generic rejected error,
            PAYMENT_TOO_MANY_REQUESTS: too many request, PAYMENT_GENERIC_ERROR:
            generic error, PAYMENT_USER_SUSPENDED: the user has been suspended
            on the initiative, PAYMENT_USER_NOT_ONBOARDED: the user has not been
            onboarded on the initiative, PAYMENT_USER_UNSUBSCRIBED: the user
            unsubscribed from the initiative, PAYMENT_INITIATIVE_NOT_FOUND: the
            initiative is not found, PAYMENT_INITIATIVE_INVALID_DATE: the user
            tried to create transaction outside initiative fruition period,
            PAYMENT_INITIATIVE_NOT_DISCOUNT: the initiative type is not discount
            - IT: Codice di errore PAYMENT_NOT_FOUND_EXPIRED: transazione non
            trovata oppure caducata, PAYMENT_USER_NOT_VALID:utente no valido,
            PAYMENT_STATUS_NOT_VALID: stato non valido,
            PAYMENT_ALREADY_AUTHORIZED: transazione già autorizzata,
            PAYMENT_BUDGET_EXHAUSTED: budget esaurito, PAYMENT_GENERIC_REJECTED:
            errore generico di rifiuto, PAYMENT_TOO_MANY_REQUESTS: troppe
            richieste, PAYMENT_GENERIC_ERROR: errore generico,
            PAYMENT_USER_SUSPENDED: l'utente è stato sospeso sull'iniziativa,
            PAYMENT_USER_NOT_ONBOARDED: l'utente non ha aderito all'iniziativa,
            PAYMENT_USER_UNSUBSCRIBED: l'utente ha effettuato il recesso
            dall'iniziativa, PAYMENT_INITIATIVE_NOT_FOUND: iniziativa non
            trovata, PAYMENT_INITIATIVE_INVALID_DATE: l'utente ha provato a
            creare una transazione al di fuori del periodo di fruizione,
            PAYMENT_INITIATIVE_NOT_DISCOUNT: iniziativa non a sconto"
          message:
          type: string
          description: "ENG: Error message- IT: Messaggio di errore"
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
