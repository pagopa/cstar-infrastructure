openapi: 3.0.1
info:
  title: IDPAY Wallet IO API v2
  description: IDPAY Wallet IO
  version: '2.0'
servers:
  - url: https://api-io.dev.cstar.pagopa.it/idpay/wallet
paths:
  /:
    get:
      tags:
        - wallet
      summary: "ENG: Returns the list of active initiatives of a citizen - IT: Ritorna la lista di iniziative attive di un cittadino"
      operationId: getWallet
      parameters:
        - name: Accept-Language
          description: "ENG: Language - IT: Lingua"
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/WalletDTO'
        '401':
          description: Authentication failed
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
  '/{initiativeId}/detail':
    get:
      tags:
        - wallet
      summary: "ENG: Returns the detail of an initiative - IT: Ritorna i dettagli dell'iniziativa"
      operationId: getInitiativeBeneficiaryDetail
      parameters:
        - name: initiativeId
          in: path
          description: "ENG: The initiative ID - IT: Identificativo dell'iniziativa"
          required: true
          schema:
            type: string
        - name: Accept-Language
          description: "ENG: Language - IT: Lingua"
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/InitiativeDetailDTO'
        '401':
          description: Authentication failed
        '404':
          description: The requested inititative was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/InitiativeErrorDTO'
              example:
                code: "INITIATIVE_NOT_FOUND"
                message: "Initiative not found"
        '429':
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/InitiativeErrorDTO'
              example:
                  code: "INITIATIVE_TOO_MANY_REQUESTS"
                  message: "Too many requests"
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/InitiativeErrorDTO'
              example:
                code: "INITIATIVE_GENERIC_ERROR"
                message: "Application error"
  '/{initiativeId}':
    get:
      tags:
        - wallet
      summary: "ENG: Returns the detail of an active initiative of a citizen - IT: Ritorna i dettagli di una iniziativa di un cittadino"
      operationId: getWalletDetail
      parameters:
        - name: Accept-Language
          description: "ENG: Language - IT: Lingua"
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: initiativeId
          in: path
          description: "ENG: The initiative ID - IT: Identificativo dell'iniziativa"
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
      summary: "ENG: Association of an IBAN to an initiative - IT: Associa un IBAN ad un'iniziativa"
      operationId: enrollIban
      parameters:
        - name: Accept-Language
          description: "ENG: Language - IT: Lingua"
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: initiativeId
          in: path
          description: "ENG: The initiative ID - IT: Identificativo dell'iniziativa"
          required: true
          schema:
            type: string
      requestBody:
        description: "ENG: Unique identifier of the subscribed initiative, IBAN of the citizen - IT: Identificativo dell'iniziativa sottoscritta, IBAN del cittadino"
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/IbanPutDTO'
            example:
              iban: string
              description: string
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
  /{initiativeId}/instruments/{idWallet}:
    put:
      tags:
        - wallet
      summary: "ENG: Association of a payment instrument to an initiative - IT: Associa uno strumento di pagamento ad un'iniziativa"
      operationId: enrollInstrument
      parameters:
        - name: Accept-Language
          description: "ENG: Language - IT: Lingua"
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: initiativeId
          in: path
          description: "ENG: The initiative ID - IT: Identificativo dell'iniziativa"
          required: true
          schema:
            type: string
        - name: idWallet
          in: path
          description: "ENG: A unique id that identifies a payment method - IT: Identificativo univoco del metodo di pagamento"
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
  /{initiativeId}/instruments:
    get:
      tags:
        - wallet
      summary: "ENG: Returns the list of payment instruments associated to the initiative by the citizen - IT: Ritorna la lista di istrumenti di pagamenti associati ad un'iniziativa del cittadino"
      operationId: getInstrumentList
      parameters:
        - name: Accept-Language
          in: header
          description: "ENG: Language - IT: Lingua"
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: initiativeId
          in: path
          description: "ENG: The initiative ID - IT: Identificativo dell'iniziativa"
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

  /{initiativeId}/instruments/{instrumentId}:
    delete:
      tags:
        - wallet
      summary: "ENG: Delete a payment instrument from an initiative - IT: Cancella uno strumento di pagamento di un'iniziativa"
      operationId: deleteInstrument
      parameters:
        - name: Accept-Language
          description: "ENG: Language - IT: Lingua"
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: initiativeId
          in: path
          description: "ENG: The initiative ID - IT: Identificatico dell'iniziativa"
          required: true
          schema:
            type: string
        - name: instrumentId
          in: path
          description: "ENG: A unique id, internally detached, which identifies a payment method - IT: Identificativo univoco, che identifica il metodo di pagamento"
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Delete OK
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
                code: "WALLET_INSTRUMENT_DELETE_NOT_ALLOWED"
                message: "It's not possible to delete an instrument of AppIO payment types"
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

  /{initiativeId}/unsubscribe:
    delete:
      tags:
        - wallet
      summary: "ENG: Unsubscribe to an initiative - IT: Disiscrizione ad un'iniziativa"
      operationId: unsubscribe
      parameters:
        - name: Accept-Language
          description: "ENG: Language - IT: Lingua"
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: initiativeId
          in: path
          description: "ENG: The initiative ID - IT: Identificativo dell'iniziativa"
          required: true
          schema:
            type: string
      responses:
        '204':
          description: Unsubscribe OK
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
                message: "An error occurred in the microservice onboarding"

  '/{initiativeId}/status':
    get:
      tags:
        - wallet
      summary: "ENG: Returns the actual wallet status - IT: Ritorna lo status attuale del wallet"
      operationId: getWalletStatus
      parameters:
        - name: Accept-Language
          description: "ENG: Language - IT: Lingua"
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: initiativeId
          in: path
          description: "ENG: The initiative ID - IT: Identificativo dell'iniziativa"
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

  '/instrument/{idWallet}/initiatives':
    get:
      tags:
        - wallet
      summary: "ENG: Returns the initiatives list associated to a payment instrument - IT: Ritorna la lista di iniziative associate ad uno strumento di pagamento"
      operationId: getInitiativesWithInstrument
      parameters:
        - name: Accept-Language
          description: "ENG: Language - IT: Lingua"
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: idWallet
          in: path
          description: "ENG: The ID Wallet - IT: Identificativo wallet"
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/InitiativesWithInstrumentDTO'
        '401':
          description: Authentication failed
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

  '/code/status':
    get:
      tags:
        - wallet
      summary: 'ENG: Check if the idpay code already exists - IT: Verifica se è già stato generato il codice idpay'
      operationId: getIdpayCodeStatus
      responses:
        '200':
          description: Check successful
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CheckEnrollmentDTO'
        '401':
          description: Authentication failed
        '429':
          description: Too many requests
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
                message: "An error occurred in the microservice payment instrument"
  '/code/generate':
    post:
      tags:
        - wallet
      summary: 'ENG: Generate idpay code, if initativeId is not present new code will be generated,- IT: Generato il codice per idpay, se l''initiativeId non è presente verrà generato un nuovo codice'
      operationId: generateCode
      requestBody:
        description: 'ENG: Id of the iniziative - IT: Identificativo dell''iniziativa'
        required: false
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/GenerateCodeReqDTO'
            example:
              initiativeId: string
      responses:
        '200':
          description: Check successful
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenerateCodeRespDTO'
        '401':
          description: Authentication failed
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PaymentInstrumentErrorDTO'
              example:
                code: "PAYMENT_INSTRUMENT_PIN_LENGTH_NOT_VALID"
                message: "Pin length is not valid"
        '403':
          description: Forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PaymentInstrumentErrorDTO'
              example:
                code: "PAYMENT_INSTRUMENT_ENROLL_NOT_ALLOWED_FOR_REFUND_INITIATIVE"
                message: "It is not possible to enroll a idpayCode for a refund type initiative"
        '404':
          description: The requested resource was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PaymentInstrumentErrorDTO'
              example:
                code: "PAYMENT_INSTRUMENT_USER_NOT_ONBOARDED"
                message: "The current user is not onboarded on initiative"
        '429':
          description: Too many requests
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PaymentInstrumentErrorDTO'
              example:
                code: "PAYMENT_INSTRUMENT_TOO_MANY_REQUESTS"
                message: "Too many requests on the ms  Payment Instrument"
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PaymentInstrumentErrorDTO'
              example:
                code: "PAYMENT_INSTRUMENT_GENERIC_ERROR"
                message: "An error occurred in the microservice wallet"
  '/{initiativeId}/code/instruments':
    put:
      tags:
        - wallet
      summary: 'ENG: Association of a payment instrument to an initiative - IT: Associa uno strumento di pagamento ad una iniziativa'
      operationId: enrollInstrumentCode
      parameters:
        - name: Accept-Language
          description: 'ENG: Language - IT: Lingua'
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: initiativeId
          in: path
          description: 'ENG: The initiative ID - IT: Identificativo dell''iniziativa'
          required: true
          schema:
            type: string
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
        '404':
          description: The requested resource was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/WalletErrorDTO'
              example:
                code: "WALLET_INSTRUMENT_IDPAYCODE_NOT_FOUND"
                message: "idpayCode is not found for the current user"
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
components:
  schemas:
    CheckEnrollmentDTO:
      type: object
      properties:
        isIdPayCodeEnabled:
          type: boolean
    GenerateCodeReqDTO:
      title: GenerateCodeDTO
      type: object
      properties:
        initiativeId:
          type: string
          description: >-
            ENG: Unique identifier of the subscribed initiative - IT:
            Identificativo univoco dell'iniziativa sottoscritta
    GenerateCodeRespDTO:
      type: object
      properties:
        idpayCode:
          type: string
          description: 'ENG: Numeric code - IT: codice numerico'
    IbanPutDTO:
      title: IbanPutDTO
      type: object
      required:
        - iban
        - description
      properties:
        iban:
          type: string
          description: "ENG: IBAN of the citizen - IT: IBAN del cittadino"
        description:
          type: string
          description: "ENG: Further information about the iban - IT: Ulteriori informazioni sull'iban"
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
            - SUSPENDED
          type: string
          description: "ENG: Actual status of the citizen wallet for an initiative - IT: Stato attuale del portafoglio di un cittadino per un'iniziativa"
    WalletDTO:
      type: object
      required:
        - initiativeList
      properties:
        initiativeList:
          type: array
          items:
            $ref: '#/components/schemas/InitiativeDTO'
          description: "ENG: The list of active initiatives of a citizen - IT: Lista delle iniziative attive di un cittadino"
    InstrumentListDTO:
      type: object
      required:
        - instrumentList
      properties:
        instrumentList:
          type: array
          items:
            $ref: '#/components/schemas/InstrumentDTO'
          description: >-
            "ENG: The list of payment instruments associated to the initiative by the
            citizen - IT: Lista degli strumenti di pagamenti di un cittadino associati ad una iniziativa"
    InstrumentDTO:
      title: InstrumentDTO
      type: object
      required:
        - instrumentId
        - instrumentType
      properties:
        idWallet:
          type: string
          description: "ENG: Wallet's id provided by the Payment manager - IT: Identificativo del portafoglio fornito dal gestore di pagamenti"
        instrumentId:
          type: string
          description: "ENG: Payment instrument id - IT: Identificativo dello strumento di pagamento"
        maskedPan:
          type: string
          description: "ENG: Masked Pan - IT: Masked Pan"
        channel:
          type: string
          description: "ENG: Channel - IT: Canale di richiesta"
        brandLogo:
          type: string
          description: "ENG: Card's brand logo URL - IT: URL del logo del marchio della carta"
        brand:
          type: string
          description: "ENG: Card's brand as mastercard, visa, ecc. - IT: Marchio della carta come mastercard, visa, ecc..."
        status:
          enum:
            - ACTIVE
            - PENDING_ENROLLMENT_REQUEST
            - PENDING_DEACTIVATION_REQUEST
          type: string
          description: "ENG: The status of the instrument - IT: Stato dello strumento"
        instrumentType:
          type: string
          enum:
            - CARD
            - APP_IO_PAYMENT
            - IDPAYCODE
        activationDate:
          type: string
          format: date-time
          description: "ENG: Activation date of the instrument - IT: Data di attivazione dello strumento"
    InitiativeDTO:
      type: object
      required:
        - initiativeId
        - status
        - endDate
        - nInstr
      properties:
        familyId:
          type: string
          description: "ENG: Id of the family unit - IT: Identificativo del nucleo familiare"
        initiativeId:
          type: string
          description: "ENG: Id initiative - IT: Identificativo dell'iniziativa"
        initiativeName:
          type: string
          description: "ENG: Name of the initiative - IT: Nome dell'iniziativa"
        status:
          enum:
            - NOT_REFUNDABLE_ONLY_IBAN
            - NOT_REFUNDABLE_ONLY_INSTRUMENT
            - REFUNDABLE
            - NOT_REFUNDABLE
            - UNSUBSCRIBED
            - SUSPENDED
          type: string
          description: "ENG: The status of the initiative - IT: Stato dell'iniziativa"
        endDate:
          type: string
          format: date
          description: "ENG: End date for the time window in which it is possible to use the initiative's rewards - IT: Data che indica la fine del periodo di fruizione dell'iniziativa"
        amountCents:
          type: integer
          format: int64
          description: "ENG: Initiative total amount - IT: Importo totale dell'iniziativa"
        accruedCents:
          type: integer
          format: int64
          description: "ENG: Initiative accrued amount IT: Importo accumulato dell'iniziativa"
        refundedCents:
          type: integer
          format: int64
          description: "ENG: Refunded amount of the initiative - IT: Importo rimborsato dell'iniziativa"
        lastCounterUpdate:
          type: string
          format: date-time
          description: "ENG: Date of the last update of the counters - IT: Data dell'ultimo aggiornamento dei contatori"
        iban:
          type: string
          description: "ENG: IBAN - IT: IBAN"
        nInstr:
          type: integer
          format: int32
          description: "ENG: Number of instruments - IT: Numero di strumenti"
        initiativeRewardType:
          enum:
            - DISCOUNT
            - REFUND
            - EXPENSE
          type: string
          description: "ENG: Reward type of the initiative - IT: Tipologia di premio dell'iniziativa"
        logoURL:
          type: string
          description: "ENG: Url of the logo - IT: Url del logo"
        organizationName:
          type: string
          description: "ENG: Organization name - IT: Nome dell'organizzazione"
        nTrx:
          type: integer
          format: int64
          description: "ENG:Number of transaction - IT: Numero di transazione"
        webViewUrl:
          type: string
          description: 'ENG: webViewUrl - IT: Url della webView'
        serviceId:
          type: string
          description: 'ENG: The service ID - IT: Identificativo del service'
    InitiativesWithInstrumentDTO:
      type: object
      required:
        - idWallet
        - maskedPan
        - brand
        - initiativeList
      properties:
        idWallet:
          type: string
          description: "ENG: Id of the wallet - IT: Identificativo del portafoglio"
        maskedPan:
          type: string
          description: "ENG: Masked Pan - IT: Masked Pan"
        brand:
          type: string
          description: "ENG: Card's brand as mastercard, visa, ecc. - IT: Marchio della carta come mastercard, visa, ecc..."
        initiativeList:
          type: array
          items:
            $ref: '#/components/schemas/InitiativesStatusDTO'
          description: "ENG: The list of the initiatives status related to a payment instrument - IT: Lista degli stati delle iniziative associate ad un instrumento di pagamento"
    InitiativesStatusDTO:
      type: object
      required:
        - initiativeId
        - initiativeName
        - status
      properties:
        initiativeId:
          type: string
          description: "ENG: Initiative ID - IT: Identificativo dell'iniziativa"
        initiativeName:
          type: string
          description: "ENG: Name of the initiative - IT: Nome dell'iniziativa"
        idInstrument:
          type: string
          description: "ENG: Instrument ID - IT: Identificativo dello strumento"
        status:
          type: string
          enum:
            - ACTIVE
            - INACTIVE
            - PENDING_ENROLLMENT_REQUEST
            - PENDING_DEACTIVATION_REQUEST
          description: "ENG: Status of the initiative [ACTIVE: Active, INACTIVE: Inactive, PENDING_ENROLLMENT_REQUEST: Richiesta di adesione in attesa, PENDING_DEACTIVATION_REQUEST: Pending deactivation request] - IT: Stato dell'iniziativa [ACTIVE: Iniziativa attiva, INACTIVE: Iniziativa inactive, PENDING_ENROLLMENT_REQUEST: Pending enrollment request, PENDING_DEACTIVATION_REQUEST: Richiesta di disattivazione in attesa]"
    ErrorDTO:
      type: object
      required:
        - code
        - message
      properties:
        code:
          type: integer
          format: int32
          description: "ENG: Error code - IT: Codice di errore"
        message:
          type: string
          description: "ENG: Error message - IT: Messaggio di errore"
    InitiativeDetailDTO:
      type: object
      properties:
        initiativeName:
          type: string
          description: "ENG: Name of the initiative - IT: Nome dell'iniziativa"
        status:
          type: string
          description: "ENG: Status of the initiative - IT: Stato dell'iniziativa"
        description:
          type: string
          description: "ENG: Description of the initiative - IT: Descrizione dell'iniziativa"
        ruleDescription:
          type: string
          description: "ENG: Description of the rules - IT: Descrizione delle regole"
        onboardingStartDate:
          type: string
          format: date
          description: "ENG: Start date for the initiative's onboarding time window - IT: Data di inizio della finestra temporale in cui si può aderire all'iniziativa"
        onboardingEndDate:
          type: string
          format: date
          description: "ENG: End date for the initiative's onboarding time window - IT: Data di fine della finestra temporale in cui si può aderire all'iniziativa"
        fruitionStartDate:
          type: string
          format: date
          description: "ENG: Start date of the time window in which it is possible to use the initiative's rewards - IT: Data di inizio della finestra temporale in cui si usufruire dei premi dell'iniziativa"
        fruitionEndDate:
          type: string
          format: date
          description: "ENG: End date of the time window in which it is possible to use the initiative's rewards - IT: Data di fine della finestra temporale in cui si usufruire dei premi dell'iniziativa"
        rewardRule:
          $ref: '#/components/schemas/RewardValueDTO'
        refundRule:
          $ref: '#/components/schemas/InitiativeRefundRuleDTO'
        privacyLink:
          type: string
          description: "ENG: URL that redirects to the privacy policy - IT: URL che reindirizza all informativa della privacy"
        tcLink:
          type: string
          description: "ENG: URL that redirects to the terms and conditions - IT: URL che porta ai termini e condizioni"
        logoURL:
          type: string
          description: "ENG: Url of the logo - IT: Url del logo"
        updateDate:
          type: string
          format: date-time
          description: "ENG: Update date - IT: Data di aggiornamento dell'iniziativa"
        serviceId:
          type: string
          description: "ENG: The service ID - IT: Identificativo del service"
    InitiativeRefundRuleDTO:
      type: object
      properties:
        accumulatedAmount:
          $ref: '#/components/schemas/AccumulatedAmountDTO'
        timeParameter:
          $ref: '#/components/schemas/TimeParameterDTO'
    AccumulatedAmountDTO:
      required:
        - accumulatedType
      type: object
      properties:
        accumulatedType:
          type: string
          enum:
            - BUDGET_EXHAUSTED
            - THRESHOLD_REACHED
          description: "ENG: Accumulated type [BUDGET_EXHAUSTED: budget exhausted, THRESHOLD_REACHED: threshold reached] - IT: Tipologia di accumulazione [BUDGET_EXHAUSTED: Budget esaurito, THRESHOLD_REACHED: Soglia raggiunta]"
        refundThreshold:
          type: number
          description: "ENG: Refund threshold - IT: Soglia di rimborso"
    TimeParameterDTO:
      required:
        - timeType
      type: object
      properties:
        timeType:
          type: string
          enum:
            - CLOSED
            - DAILY
            - WEEKLY
            - MONTHLY
            - QUARTERLY
          description: "ENG: Time type [CLOSED: At the end of the initiative, DAILY: Daily, WEEKLY: Weekly, MONTHLY: Monthly, QUARTERLY: Quarterly] - IT: Tipologia di tesmpistiche di rimborso [CLOSED: Alla chiusura dell'iniziativa, DAILY: Giornaliero, WEEKLY: Settimanale, MONTHLY: Mensile, QUARTERLY: Trimestrale]"
    RewardValueDTO:
      required:
        - rewardValueType
        - rewardValue
      type: object
      properties:
        rewardValueType:
          type: string
          enum:
            - PERCENTAGE
            - ABSOLUTE
          description: "ENG: Reward value type [PERCENTAGE: Percentage, ABSOLUTE: Absolute]- IT: Tipologia di premio [PERCENTAGE: Percentuale, ABSOLUTE: Assoluto]"
        rewardValue:
          type: number
          description: "ENG: Reward value - IT: Valore di reward"
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
    InitiativeErrorDTO:
      type: object
      properties:
        code:
          type: string
          enum:
            - INITIATIVE_INVALID_LOCALE_FORMAT
            - INITIATIVE_INVALID_REQUEST
            - INITIATIVE_NOT_FOUND
            - INITIATIVE_TOO_MANY_REQUESTS
            - INITIATIVE_GENERIC_ERROR
          description: >-
           "ENG: Error code:
            INITIATIVE_INVALID_LOCALE_FORMAT: Initiative not found due to invalid locale format,
            INITIATIVE_INVALID_REQUEST: Something went wrong handling the request,
            INITIATIVE_NOT_FOUND: Initiative not found,
            INITIATIVE_TOO_MANY_REQUESTS: Too many requests,
            INITIATIVE_GENERIC_ERROR: Application error,
            - IT: Codice di errore:
            INITIATIVE_INVALID_LOCALE_FORMAT: Iniziativa non trovata a causa di format locale non valido,
            INITIATIVE_INVALID_REQUEST: Qualcosa è andato storto durante l'invio della richiesta,
            INITIATIVE_NOT_FOUND: Iniziativa non trovata,
            INITIATIVE_TOO_MANY_REQUESTS: Troppe richieste,
            INITIATIVE_GENERIC_ERROR: Errore generico"
        message:
          type: string
          description: "ENG: Error message - IT: Messaggio di errore"
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
    bearerAuth:
      type: http
      scheme: bearer
security:
  - bearerAuth: [ ]
tags:
  - name: wallet
    description: ''
