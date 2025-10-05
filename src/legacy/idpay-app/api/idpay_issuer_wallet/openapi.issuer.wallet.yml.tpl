openapi: 3.0.1
info:
  title: IDPAY Wallet Issuer API v1
  description: IDPAY Wallet Issuer
  version: '1.0'
servers:
 - url: https://api-io.dev.cstar.pagopa.it/idpay/hb/wallet
paths:
  /{initiativeId}:
    get:
      tags:
        - wallet
      summary: Returns the detail of an active initiative of a citizen
      operationId: getWalletDetail
      parameters:
        - name: Accept-Language
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: Fiscal-Code
          in: header
          description: The ID of the citizen
          required: true
          schema:
            type: string
        - name: initiativeId
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
                      $ref: '#/components/schemas/InitiativeDTO'
              '401':
                description: Authentication failed
              '404':
                description: The requested resource was not found
                content:
                  application/json:
                    schema:
                      $ref: '#/components/schemas/WalletErrorDTO'
                    example:
                      code: "WALLET_USER_NOT_ONBOARDED"
                      message: "User not onboarded on this initiative"
              '429':
                description: Too many Request
                content:
                  application/json:
                    schema:
                      $ref: '#/components/schemas/WalletErrorDTO'
                    example:
                      code: "WALLET_TOO_MANY_REQUESTS"
                      message: "Too many requests"
              '500':
                description: Server ERROR
                content:
                  application/json:
                    schema:
                      $ref: '#/components/schemas/WalletErrorDTO'
                    example:
                      code: "WALLET_GENERIC_ERROR"
                      message: "Application error"
  /{initiativeId}/iban:
    put:
      tags:
        - wallet
      summary: Association of an IBAN to an initiative
      operationId: enrollIban
      parameters:
        - name: Accept-Language
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: Fiscal-Code
          in: header
          description: The ID of the citizen
          required: true
          schema:
            type: string
        - name: initiativeId
          in: path
          description: The initiative ID
          required: true
          schema:
            type: string
      requestBody:
        description: 'Unique identifier of the subscribed initiative, IBAN of the citizen'
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/IbanPutDTO'
      responses:
              '200':
                description: Enrollment OK
                content:
                  application/json: { }
              '400':
                description: Bad request
                content:
                  application/json:
                    schema:
                      $ref: '#/components/schemas/WalletErrorDTO'
                    example:
                      code: "WALLET_INVALID_REQUEST"
                      message: "Something went wrong handling the request"
              '401':
                description: Authentication failed
              '403':
                description: Forbidden
                content:
                  application/json:
                    schema:
                      $ref: '#/components/schemas/WalletErrorDTO'
                    example:
                      code: "WALLET_ENROLL_IBAN_NOT_ALLOWED_FOR_DISCOUNT_INITIATIVE"
                      message: "It is not possible enroll
                  an iban for a discount type initiative"
              '429':
                description: Too many Request
                content:
                  application/json:
                    schema:
                      $ref: '#/components/schemas/WalletErrorDTO'
                    example:
                      code: "WALLET_TOO_MANY_REQUESTS"
                      message: "Too many requests"
              '500':
                description: Server ERROR
                content:
                  application/json:
                    schema:
                      $ref: '#/components/schemas/WalletErrorDTO'
                    example:
                      code: "WALLET_GENERIC_ERROR"
                      message: "Application error"
  /{initiativeId}/instruments:
    put:
      tags:
        - wallet
      summary: Association of a payment instrument to an initiative
      operationId: enrollInstrument
      parameters:
        - name: Accept-Language
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: Fiscal-Code
          in: header
          description: The ID of the citizen
          required: true
          schema:
            type: string
        - name: initiativeId
          in: path
          description: The initiative ID
          required: true
          schema:
            type: string
      responses:
              '200':
                description: Enrollment OK
                content:
                  application/json: {}
              '400':
                description: Bad request
                content:
                  application/json:
                    schema:
                      $ref: '#/components/schemas/WalletErrorDTO'
                    example:
                      code: "WALLET_INVALID_REQUEST"
                      message: "Something went wrong handling the request"
              '401':
                description: Authentication failed
              '403':
                description: Forbidden
                content:
                  application/json:
                    schema:
                      $ref: '#/components/schemas/WalletErrorDTO'
                    example:
                      code: "WALLET_INSTRUMENT_ALREADY_ASSOCIATED"
                      message: "Payment Instrument is already associated to another user"
              '404':
                description: The requested resource was not found
                content:
                  application/json:
                    schema:
                      $ref: '#/components/schemas/WalletErrorDTO'
                    example:
                      code: "WALLET_INSTRUMENT_NOT_FOUND"
                      message: "The selected payment instrument has not been found for the current user"
              '429':
                description: Too many Request
                content:
                  application/json:
                    schema:
                      $ref: '#/components/schemas/WalletErrorDTO'
                    example:
                      code: "WALLET_TOO_MANY_REQUESTS"
                      message: "Too many requests"
              '500':
                description: Server ERROR
                content:
                  application/json:
                    schema:
                      $ref: '#/components/schemas/WalletErrorDTO'
                    example:
                      code: "WALLET_GENERIC_ERROR"
                      message: "An error occurred in the microservice payment instrument"
    get:
      tags:
        - wallet
      summary: Returns the list of payment instruments associated to the initiative by the citizen
      operationId: getInstrumentList
      parameters:
        - name: Accept-Language
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: Fiscal-Code
          in: header
          description: The ID of the citizen
          required: true
          schema:
            type: string
        - name: initiativeId
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
                $ref: '#/components/schemas/InstrumentListDTO'
        '401':
          description: Authentication failed
        '429':
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PaymentInstrumentErrorDTO'
              example:
                code: "PAYMENT_INSTRUMENT_TOO_MANY_REQUESTS"
                message: "Too many requests"
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PaymentInstrumentErrorDTO'
              example:
                code: "PAYMENT_INSTRUMENT_GENERIC_ERROR"
                message: "Something gone wrong while send RTD instrument notify"
  /{initiativeId}/status:
    get:
      tags:
        - wallet
      summary: Returns the actual wallet status
      operationId: getWalletStatus
      parameters:
        - name: Accept-Language
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: Fiscal-Code
          in: header
          description: The ID of the citizen
          required: true
          schema:
            type: string
        - name: initiativeId
          in: path
          description: The initiative ID
          required: true
          schema:
            type: string
      responses:
              '200':
                description: Check successful
                content:
                  application/json:
                    schema:
                      $ref: '#/components/schemas/WalletStatusDTO'
                    example:
                      status: NOT_REFUNDABLE_ONLY_IBAN
              '400':
                description: Bad request
                content:
                  application/json:
                    schema:
                      $ref: '#/components/schemas/WalletErrorDTO'
                    example:
                      code: "WALLET_INVALID_REQUEST"
                      message: "Something went wrong handling the request"
              '401':
                description: Authentication failed
              '404':
                description: The requested resource was not found
                content:
                  application/json:
                    schema:
                      $ref: '#/components/schemas/WalletErrorDTO'
                    example:
                      code: "WALLET_USER_NOT_ONBOARDED"
                      message: "User not onboarded on this initiative"
              '429':
                description: Too many Request
                content:
                  application/json:
                    schema:
                      $ref: '#/components/schemas/WalletErrorDTO'
                    example:
                      code: "WALLET_TOO_MANY_REQUESTS"
                      message: "Too many requests"
              '500':
                description: Server ERROR
                content:
                  application/json:
                    schema:
                      $ref: '#/components/schemas/WalletErrorDTO'
                    example:
                        code: "WALLET_GENERIC_ERROR"
                        message: "Application error"
components:
  schemas:
    IbanPutDTO:
      title: IbanPutDTO
      type: object
      required:
        - iban
        - description
      properties:
        iban:
          type: string
          description: IBAN of the citizen
        description:
          type: string
          description: further information about the iban
    WalletStatusDTO:
      title: WalletStatusDTO
      type: object
      required:
        - status
      properties:
        status:
          enum:
            - NOT_REFUNDABLE_ONLY_IBAN
            - NOT_REFUNDABLE_ONLY_INSTRUMENT
            - REFUNDABLE
            - NOT_REFUNDABLE
            - UNSUBSCRIBED
          type: string
          description: actual status of the citizen wallet for an initiative
    InstrumentListDTO:
      type: object
      required:
        - instrumentList
      properties:
        instrumentList:
          type: array
          items:
            $ref: '#/components/schemas/InstrumentDTO'
          description: The list of payment instruments associated to the initiative by the citizen
    InstrumentDTO:
      title: InstrumentDTO
      type: object
      required:
        - instrumentId
      properties:
        idWallet:
          type: string
          description: Wallet's id provided by the Payment manager
        instrumentId:
          type: string
          description: Payment instrument id
        maskedPan:
          type: string
          description: Masked Pan
        channel:
          type: string
        brandLogo:
          type: string
          description: Card's brand as mastercard, visa, ecc.
        status:
          enum:
            - ACTIVE
            - PENDING_ENROLLMENT_REQUEST
            - PENDING_DEACTIVATION_REQUEST
          type: string
          description: The status of the instrument
    InitiativeDTO:
      type: object
      required:
        - initiativeId
        - status
        - endDate
        - nInstr
      properties:
        amountCents:
          type: integer
          format: int64
        accruedCents:
          type: integer
          format: int64
        refundedCents:
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
    WalletErrorDTO:
      type: object
      required:
        - code
        - message
      properties:
        code:
          type: string
          enum:
            - WALLET_USER_UNSUBSCRIBED
            - WALLET_ENROLL_INSTRUMENT_NOT_ALLOWED_FOR_DISCOUNT_INITIATIVE
            - WALLET_ENROLL_IBAN_NOT_ALLOWED_FOR_DISCOUNT_INITIATIVE
            - WALLET_ENROLL_INSTRUMENT_NOT_ALLOWED_FOR_REFUND_INITIATIVE
            - WALLET_INITIATIVE_ENDED
            - WALLET_USER_NOT_ONBOARDED
            - WALLET_IBAN_NOT_ITALIAN
            - WALLET_INSTRUMENT_ALREADY_ASSOCIATED
            - WALLET_INSTRUMENT_DELETE_NOT_ALLOWED
            - WALLET_INSTRUMENT_IDPAYCODE_NOT_FOUND
            - WALLET_SUSPENSION_NOT_ALLOWED_FOR_USER_STATUS
            - WALLET_READMISSION_NOT_ALLOWED_FOR_USER_STATUS
            - WALLET_INSTRUMENT_NOT_FOUND
            - WALLET_GENERIC_ERROR
            - WALLET_INVALID_REQUEST
            - WALLET_TOO_MANY_REQUESTS
          description: >-
            "ENG: Error code:
            WALLET_USER_UNSUBSCRIBED: The user has unsubscribed from initiative,
            WALLET_ENROLL_INSTRUMENT_NOT_ALLOWED_FOR_DISCOUNT_INITIATIVE: It is not possible to
            enroll a payment instrument for a discount initiative,
            WALLET_ENROLL_IBAN_NOT_ALLOWED_FOR_DISCOUNT_INITIATIVE: It is not possible enroll
            an iban for a discount type initiative,
            WALLET_ENROLL_INSTRUMENT_NOT_ALLOWED_FOR_REFUND_INITIATIVE: It is not possible to enroll
            a IDPayCode for a refund type initiative,
            WALLET_INITIATIVE_ENDED: The operation is not allowed because the initiative has already ended,
            WALLET_USER_NOT_ONBOARDED: User not onboarded on this initiative,
            WALLET_IBAN_NOT_ITALIAN: Iban is not italian,
            WALLET_INSTRUMENT_ALREADY_ASSOCIATED: Payment Instrument is already associated to another user,
            WALLET_INSTRUMENT_DELETE_NOT_ALLOWED: It's not possible to delete an instrument of AppIO payment types,
            WALLET_INSTRUMENT_IDPAYCODE_NOT_FOUND: idpayCode is not found for the current user,
            WALLET_SUSPENSION_NOT_ALLOWED_FOR_USER_STATUS: It is not possible to suspend the
            user on initiative,
            WALLET_READMISSION_NOT_ALLOWED_FOR_USER_STATUS: It is not possible to readmit
            the user on initiative,
            WALLET_INSTRUMENT_NOT_FOUND: The selected payment instrument has not been found for the current user,
            WALLET_GENERIC_ERROR: Application error,
            WALLET_INVALID_REQUEST: Something went wrong handling the request,
            WALLET_TOO_MANY_REQUESTS: Too many requests on the ms
            - IT: Codice di errore:
            WALLET_USER_UNSUBSCRIBED: L'utente si è disiscritto dall'iniziativa,
            WALLET_ENROLL_INSTRUMENT_NOT_ALLOWED_FOR_DISCOUNT_INITIATIVE: Non è possibile associare
            uno strumento di pagamento per un'iniziativa di tipo a sconto,
            WALLET_ENROLL_IBAN_NOT_ALLOWED_FOR_DISCOUNT_INITIATIVE: Non è possibile associare un iban per un'iniziativa di tipo a sconto,
            WALLET_ENROLL_INSTRUMENT_NOT_ALLOWED_FOR_REFUND_INITIATIVE: Non è possibile associare un
            IDPayCode per una iniziativa di tipo a rimborso,
            WALLET_INITIATIVE_ENDED: L'operazione non è consentita perché l'iniziativa è scaduta,
            WALLET_USER_NOT_ONBOARDED: Utente non onboardato all'inziativa,
            WALLET_IBAN_NOT_ITALIAN: L'Iban non è italiano,
            WALLET_INSTRUMENT_ALREADY_ASSOCIATED: Lo strumento di pagamento è già associato
            ad un altro utente,
            WALLET_INSTRUMENT_DELETE_NOT_ALLOWED: Non è possibile eliminare uno strumento di tipo AppIO,
            WALLET_INSTRUMENT_IDPAYCODE_NOT_FOUND: L'idpayCode non è stato trovato per l'utente corrente,
            WALLET_SUSPENSION_NOT_ALLOWED_FOR_USER_STATUS: Non è possibile sospendere l'utente dall'iniziativa,
            WALLET_READMISSION_NOT_ALLOWED_FOR_USER_STATUS: Non è possibile riammettere
            l'utente all'iniziativa,
            WALLET_INSTRUMENT_NOT_FOUND: Lo strumento di pagamento selezionato non è stato trovato per l'utente corrente,
            WALLET_GENERIC_ERROR: Errore generico,
            WALLET_INVALID_REQUEST: Qualcosa è andato storto durante l'invio della richiesta,
            WALLET_TOO_MANY_REQUESTS: Troppe richieste"
        message:
          type: string
          description: 'ENG: Error message- IT: Messaggio di errore'
    PaymentInstrumentErrorDTO:
      type: object
      required:
        - code
        - message
      properties:
        code:
          type: string
          enum:
            - PAYMENT_INSTRUMENT_PIN_LENGTH_NOT_VALID
            - PAYMENT_INSTRUMENT_INVALID_REQUEST
            - PAYMENT_INSTRUMENT_ALREADY_ASSOCIATED
            - PAYMENT_INSTRUMENT_DELETE_NOT_ALLOWED
            - PAYMENT_INSTRUMENT_ENCRYPTION_ERROR
            - PAYMENT_INSTRUMENT_DECRYPTION_ERROR
            - PAYMENT_INSTRUMENT_ENROLL_NOT_ALLOWED_FOR_REFUND_INITIATIVE
            - PAYMENT_INSTRUMENT_INITIATIVE_ENDED
            - PAYMENT_INSTRUMENT_USER_UNSUBSCRIBED
            - PAYMENT_INSTRUMENT_NOT_FOUND
            - PAYMENT_INSTRUMENT_IDPAYCODE_NOT_FOUND
            - PAYMENT_INSTRUMENT_USER_NOT_ONBOARDED
            - PAYMENT_INSTRUMENT_TOO_MANY_REQUESTS
            - PAYMENT_INSTRUMENT_GENERIC_ERROR
          description: >-
            "ENG: Error code:
            PAYMENT_INSTRUMENT_PIN_LENGTH_NOT_VALID: Pin length is not valid,
            PAYMENT_INSTRUMENT_INVALID_REQUEST: Something went wrong handling the request,
            PAYMENT_INSTRUMENT_ALREADY_ASSOCIATED: Payment Instrument is already associated to another user,
            PAYMENT_INSTRUMENT_DELETE_NOT_ALLOWED: It's not possible to delete an instrument of AppIO payment types,
            PAYMENT_INSTRUMENT_ENCRYPTION_ERROR: Something went wrong creating SHA256 digest,
            PAYMENT_INSTRUMENT_DECRYPTION_ERROR: Something gone wrong while extracting datablock from pinblock,
            PAYMENT_INSTRUMENT_ENROLL_NOT_ALLOWED_FOR_REFUND_INITIATIVE: It is not possible to enroll a idpayCode for a refund type initiative,
            PAYMENT_INSTRUMENT_INITIATIVE_ENDED: The operation is not allowed because the initiative has already ended,
            PAYMENT_INSTRUMENT_USER_UNSUBSCRIBED: The user has unsubscribed from initiative,
            PAYMENT_INSTRUMENT_NOT_FOUND: The selected payment instrument has not been found for the current user,
            PAYMENT_INSTRUMENT_IDPAYCODE_NOT_FOUND: idpayCode is not found for the current user,
            PAYMENT_INSTRUMENT_USER_NOT_ONBOARDED: The current user is not onboarded on initiative,
            PAYMENT_INSTRUMENT_TOO_MANY_REQUESTS: Too many requests,
            PAYMENT_INSTRUMENT_GENERIC_ERROR Application error:
            - IT: Codice di errore:
            PAYMENT_INSTRUMENT_PIN_LENGTH_NOT_VALID: Lunghezza del pin non valida,
            PAYMENT_INSTRUMENT_INVALID_REQUEST: Qualcosa è andato storto durante l'invio della richiesta,
            PAYMENT_INSTRUMENT_ALREADY_ASSOCIATED: Lo strumento di pagamento è già associato ad un altro utente,
            PAYMENT_INSTRUMENT_DELETE_NOT_ALLOWED: Non è possibile eliminare uno strumento di pagamento di tipo AppIO,
            PAYMENT_INSTRUMENT_ENCRYPTION_ERROR: Qualcosa è andato storto durante la creazione del digest SHA256,
            PAYMENT_INSTRUMENT_DECRYPTION_ERROR: Qualcosa è andato storto durante l'estrazione del datablock dal pinblock,
            PAYMENT_INSTRUMENT_ENROLL_NOT_ALLOWED_FOR_REFUND_INITIATIVE: Non è possibile enrollare un idpayCode per un'iniziativa di tipo a rimborso,
            PAYMENT_INSTRUMENT_INITIATIVE_ENDED: L'operazione non è consentita perché l'iniziativa è scaduta,
            PAYMENT_INSTRUMENT_USER_UNSUBSCRIBED: L'utente si è disiscritto dall'iniziativa,
            PAYMENT_INSTRUMENT_NOT_FOUND:  Lo strumento di pagamento selezionato non è stato trovato per l'utente corrente,
            PAYMENT_INSTRUMENT_IDPAYCODE_NOT_FOUND: L'idpayCode non è stato trovato per l'utente corrente,
            PAYMENT_INSTRUMENT_USER_NOT_ONBOARDED: L'utente corrente non è onboardato all'iniziativa,
            PAYMENT_INSTRUMENT_TOO_MANY_REQUESTS: Troppe richieste,
            PAYMENT_INSTRUMENT_GENERIC_ERROR: Errore generico"
        message:
          type: string
          description: 'ENG: Error message- IT: Messaggio di errore'
  securitySchemes:
    ApiKeyAuth:
      type: apiKey
      in: header
      name: Ocp-Apim-Subscription-Key
      description: The API key can be obtained through the developer portal
security:
  - ApiKeyAuth: [ ]
tags:
  - name: wallet
    description: ''
