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
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: 'PAYMENT_INVALID_REQUEST'
                message: 'Required trxCode is not present'
        '401':
          description: Token not validated correctly
        '403':
          description: Forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: 'PAYMENT_USER_UNSUBSCRIBED'
                message: 'The user has unsubscribed from initiative'
        '404':
          description: Transaction does not exist or is expired
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: 'PAYMENT_NOT_FOUND_OR_EXPIRED'
                message: 'transaction not found or expired'
        '429':
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: 'PAYMENT_TOO_MANY_REQUESTS'
                message: 'Too many requests'
        '500':
          description: Generic error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: 'PAYMENT_GENERIC_ERROR'
                message: 'application error (connection microservice error)'
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
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: 'PAYMENT_INVALID_REQUEST'
                message: 'Required trxCode is not present'
        '401':
          description: Token not validated correctly
        '403':
          description: Forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: 'PAYMENT_ALREADY_ASSIGNED'
                message: 'transaction already assigned'
        '404':
          description: Transaction does not exist or is expired
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: 'PAYMENT_NOT_FOUND_OR_EXPIRED'
                message: 'transaction not found or expired'
        '429':
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: 'PAYMENT_TOO_MANY_REQUESTS'
                message: 'Too many requests'
        '500':
          description: Generic error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: 'PAYMENT_GENERIC_ERROR'
                message: 'application error (connection microservice error)'
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
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: 'PAYMENT_UNRELATE_NOT_ALLOWED_FOR_TRX_STATUS'
                message: 'unrelate transaction not allowed due to status'
        '401':
          description: Token not validated correctly
        '403':
          description: Forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: 'PAYMENT_ALREADY_ASSIGNED'
                message: 'transaction already assigned'
        '404':
          description: Transaction does not exist or is expired
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: 'PAYMENT_NOT_FOUND_OR_EXPIRED'
                message: 'transaction not found or expired'
        '429':
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: 'PAYMENT_TOO_MANY_REQUESTS'
                message: 'Too many requests'
        '500':
          description: Generic error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: 'PAYMENT_GENERIC_ERROR'
                message: 'application error (connection microservice error)'
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
          - AUTHORIZATION_REQUESTED
          - AUTHORIZED
          description: "ENG: Status of the payment [CREATED: Created, IDENTIFIED: User related, AUTHORIZATION_REQUESTED: Authorization Requested, AUTHORIZED: authorized] - IT: Stato del pagamento [CREATED: Creato, IDENTIFIED: Utente associato, AUTHORIZATION_REQUESTED: autorizzazione richiesta, AUTHORIZED: autorizzato]"
        rewardCents:
          type: integer
          format: int64
          description: "ENG: Reward - IT: Premio generato"
        amountCents:
          type: integer
          format: int64
          description: "ENG: Amount cents - IT: Importo in centessimi"
        residualBudgetCents:
          type: integer
          format: int64
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
            - PAYMENT_NOT_FOUND_OR_EXPIRED
            - PAYMENT_TRANSACTION_EXPIRED
            - PAYMENT_INITIATIVE_NOT_FOUND
            - PAYMENT_INITIATIVE_INVALID_DATE
            - PAYMENT_INITIATIVE_NOT_DISCOUNT
            - PAYMENT_ALREADY_AUTHORIZED
            - PAYMENT_ALREADY_CANCELLED
            - PAYMENT_BUDGET_EXHAUSTED
            - PAYMENT_GENERIC_REJECTED
            - PAYMENT_TOO_MANY_REQUESTS
            - PAYMENT_GENERIC_ERROR
            - PAYMENT_USER_SUSPENDED
            - PAYMENT_USER_NOT_ONBOARDED
            - PAYMENT_USER_UNSUBSCRIBED
            - PAYMENT_ALREADY_ASSIGNED
            - PAYMENT_NOT_ALLOWED_FOR_TRX_STATUS
            - PAYMENT_NOT_ALLOWED_MISMATCHED_MERCHANT
            - PAYMENT_USER_NOT_ASSOCIATED
            - PAYMENT_DELETE_NOT_ALLOWED_FOR_TRX_STATUS
            - PAYMENT_UNRELATE_NOT_ALLOWED_FOR_TRX_STATUS
            - PAYMENT_AMOUNT_NOT_VALID
            - PAYMENT_MERCHANT_NOT_ONBOARDED
            - PAYMENT_INVALID_REQUEST
            - PAYMENT_TRANSACTION_VERSION_PENDING
          description: >-
            "ENG: Error code: PAYMENT_NOT_FOUND_OR_EXPIRED: transaction not
            found or expired, PAYMENT_TRANSACTION_EXPIRED: transaction expired,
            PAYMENT_INITIATIVE_NOT_FOUND: initiative not found,
            PAYMENT_INITIATIVE_INVALID_DATE: initiative invalid date,
            PAYMENT_INITIATIVE_NOT_DISCOUNT: initiative is not of discount type,
            PAYMENT_ALREADY_AUTHORIZED: transaction already authorized,
            PAYMENT_ALREADY_CANCELLED: transaction already cancelled,
            PAYMENT_BUDGET_EXHAUSTED: budget exhausted,
            PAYMENT_GENERIC_REJECTED: generic rejected error (transaction
            rejected), PAYMENT_TOO_MANY_REQUESTS: too many request, retry,
            PAYMENT_GENERIC_ERROR: application error (connection microservice
            error), PAYMENT_USER_SUSPENDED: the user has been suspended on the
            initiative, PAYMENT_USER_NOT_ONBOARDED: user not onboarded,
            PAYMENT_USER_UNSUBSCRIBED: user unsubscribed,
            PAYMENT_ALREADY_ASSIGNED:  transaction already assigned,
            PAYMENT_NOT_ALLOWED_FOR_TRX_STATUS: operation on transaction not
            allowed due to status, PAYMENT_NOT_ALLOWED_MISMATCHED_MERCHANT:
            operation on transaction not allowed due to merchant mismatched,
            PAYMENT_USER_NOT_ASSOCIATED: user not associated to the transaction,
            PAYMENT_DELETE_NOT_ALLOWED_FOR_TRX_STATUS: cancellation of
            transaction not allowed due to status,
            PAYMENT_UNRELATE_NOT_ALLOWED_FOR_TRX_STATUS: unrelate transaction
            not allowed due to status, PAYMENT_AMOUNT_NOT_VALID: amount of
            transaction not valid, PAYMENT_MERCHANT_NOT_ONBOARDED: the merchant
            is not onboarded, PAYMENT_INVALID_REQUEST: request validation error,
            PAYMENT_TRANSACTION_VERSION_PENDING: The transaction version is
            actually locked, - IT: Codice di errore:
            PAYMENT_NOT_FOUND_OR_EXPIRED: transazione non trovata oppure scaduta,
            PAYMENT_TRANSACTION_EXPIRED: transazione scaduta,
            PAYMENT_INITIATIVE_NOT_FOUND: iniziativa non trovata,
            PAYMENT_INITIATIVE_INVALID_DATE: iniziativa con data invalida,
            PAYMENT_INITIATIVE_NOT_DISCOUNT: iniziativa non è di tipo a sconto,
            PAYMENT_ALREADY_AUTHORIZED: transazione già autorizzata,
            PAYMENT_ALREADY_CANCELLED: transazione già cancellata,
            PAYMENT_BUDGET_EXHAUSTED: budget esaurito, PAYMENT_GENERIC_REJECTED:
            errore generico, transazione rigettata, PAYMENT_TOO_MANY_REQUESTS:
            troppe richieste, riprovare, PAYMENT_GENERIC_ERROR: errore generico
            (errore nella connessione ad un microservizio),
            PAYMENT_USER_SUSPENDED: l'utente è stato sospeso dall'iniziativa,
            PAYMENT_USER_NOT_ONBOARDED: utente non onboardato all'iniziativa,
            PAYMENT_USER_UNSUBSCRIBED: utente disiscritto dall'iniziativa,
            PAYMENT_ALREADY_ASSIGNED:  transazione già assegnata,
            PAYMENT_NOT_ALLOWED_FOR_TRX_STATUS: transazione non consentita a
            causa dello stato della transazione,
            PAYMENT_NOT_ALLOWED_MISMATCHED_MERCHANT: transazione non consentita
            a causa della mancata corrispondenza del merchant,
            PAYMENT_USER_NOT_ASSOCIATED: utente non associato alla transazione,
            PAYMENT_DELETE_NOT_ALLOWED_FOR_TRX_STATUS: annullamento della
            transazione non consentito a causa dello stato della transazione,
            PAYMENT_UNRELATE_NOT_ALLOWED_FOR_TRX_STATUS: disassociazione non
            consentita a causa dello stato della transazione,
            PAYMENT_AMOUNT_NOT_VALID: importo nella transazione non valido,
            PAYMENT_MERCHANT_NOT_ONBOARDED: il merchant non è onboardato,
            PAYMENT_INVALID_REQUEST: errore di validazione della richiesta,
            PAYMENT_TRANSACTION_VERSION_PENDING: La versione del contatore è
            attualmente bloccata"
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
