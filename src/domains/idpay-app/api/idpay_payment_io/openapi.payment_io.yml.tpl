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
                code: PAYMENT_INVALID_REQUEST
                message: Required initiativeId is not present
        '403':
          description: User not onboarded
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: PAYMENT_USER_NOT_ONBOARDED
                message: User not onboarded
        '404':
          description: Transaction not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: PAYMENT_NOT_FOUND_OR_EXPIRED
                message: 'Cannot find transaction with trxCode [trxCode]'
        '429':
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: PAYMENT_TOO_MANY_REQUESTS
                message: 'Too many requests'
        '500':
          description: Generic error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionErrorDTO'
              example:
                code: PAYMENT_GENERIC_ERROR
                message: 'application error (connection microservice error)'
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
            PAYMENT_TRANSACTION_VERSION_PENDING: The transaction
            version is actually locked, - IT: Codice di errore:
            PAYMENT_NOT_FOUND_OR_EXPIRED: transazione non trovata oppure
            scaduta, PAYMENT_TRANSACTION_EXPIRED: transazione
            scaduta, PAYMENT_INITIATIVE_NOT_FOUND: iniziativa non trovata,
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
            PAYMENT_TRANSACTION_VERSION_PENDING: La versione del
            contatore è attualmente bloccata"
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
        - initiativeName
        - trxDate
        - trxExpirationSeconds
        - residualBudgetCents
        - status
      properties:
        id:
          type: string
          description: 'ENG: Id of the payment - IT: Identificativo del pagamento'
        trxCode:
          type: string
          description: 'ENG: Transaction code - IT: Codice della transazione'
        initiativeId:
          type: string
          description: 'ENG: Id of the initiative - IT: Identificativo dell''iniziativa'
        initiativeName:
          type: string
          description: 'ENG: Name of the initiative - IT: Nome dell''iniziativa'
        trxDate:
          type: string
          format: date-time
          description: 'ENG: Transaction date - IT: Data della transazione'
        trxExpirationSeconds:
          type: number
          description: "ENG: Expiration time of the transaction, in seconds - IT: Scadenza della transazione, in secondi"
        residualBudgetCents:
          type: integer
          format: int64
          description: 'ENG: Residual budget in cents - IT: Budget residuo in centesimi'
        status:
          type: string
          enum:
            - CREATED
          description: >-
            ENG: Status of the payment [CREATED: Created] - IT: Stato del pagamento [CREATED:
            Creato]
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
