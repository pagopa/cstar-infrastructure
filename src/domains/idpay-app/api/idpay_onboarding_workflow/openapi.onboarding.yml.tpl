openapi: 3.0.1
info:
  title: IDPAY Onboarding Workflow IO API
  description: IDPAY Onboarding Workflow IO
  version: '1.0'
servers:
  - url: https://api-io.dev.cstar.pagopa.it/idpay/onboarding
paths:
  /service/{serviceId}:
    get:
      tags:
        - onboarding
      summary: "ENG: Retrieves the initiative ID starting from the corresponding service ID - IT: Ritrova l'identificativo dell'iniziativa a partire dall'idetificativo del service"
      operationId: getInitiativeData
      parameters:
        - name: serviceId
          in: path
          description: "ENG: The service ID - IT: Identificativo del service"
          required: true
          schema:
            type: string
        - name: Accept-Language
          in: header
          description: "ENG: Language - IT: Lingua"
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
      responses:
        '200':
          description: Get successful
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/InitiativeDataDTO'
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/InitiativeErrorDTO'
              example:
                code: "INITIATIVE_INVALID_REQUEST"
                message: "Something went wrong handling the request"
        '401':
          description: Authentication failed
        '404':
          description: The requested initiative was not found
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

  /:
    put:
      tags:
        - onboarding
      summary: "ENG: Acceptance of Terms & Conditions - IT: Accettazione dei Termini e condizioni"
      operationId: onboardingCitizen
      parameters:
        - name: Accept-Language
          in: header
          description: "ENG: Language - IT: Lingua"
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
      requestBody:
        description: "ENG: Id of the initiative IT: Identificativo dell'iniziativa"
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OnboardingPutDTO'
      responses:
        '204':
          description: Acceptance successful
          content:
            application/json: {}
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_INVALID_REQUEST"
                message: "Something went wrong handling the request"
        '401':
          description: Authentication failed
        '403':
          description: This onboarding is forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_BUDGET_EXHAUSTED"
                message: "Budget exhausted for initiative [%s]"
        '404':
          description: The requested resource was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_INITIATIVE_NOT_FOUND"
                message: "Cannot find initiative [%s]"
        '429':
          description: Too many Requests
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_TOO_MANY_REQUESTS"
                message: "Too many requests"
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_GENERIC_ERROR"
                message: "An error occurred in the microservice admissibility"
  /initiative:
    put:
      tags:
        - onboarding
      summary: "ENG: Checks the initiative prerequisites - IT: Verifica i prerequisiti dell'iniziativa"
      operationId: checkPrerequisites
      parameters:
        - name: Accept-Language
          in: header
          description: "ENG: Language - IT: Lingua"
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
      requestBody:
        description: "ENG: Id of the initiative - IT: Identificatico dell'iniziativa"
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OnboardingPutDTO'
            example:
              initiativeId: string
      responses:
        '200':
          description: Check successful
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/RequiredCriteriaDTO'
        '202':
          description: Accepted - Request Taken Over
          content:
            application/json: { }
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_INVALID_REQUEST"
                message: "Something went wrong handling the request"
        '401':
          description: Authentication failed
        '403':
          description: This onboarding is forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_BUDGET_EXHAUSTED"
                message: "Budget exhausted for initiative [%s]"
        '404':
          description: The requested resource was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_INITIATIVE_NOT_FOUND"
                message: "Cannot find initiative [%s]"
        '429':
          description: Too many Requests
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_TOO_MANY_REQUESTS"
                message: "Too many requests"
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_GENERIC_ERROR"
                message: "An error occurred in the microservice admissibility"
  /consent:
    put:
      tags:
        - onboarding
      summary: "ENG: Saves the consensus of both PDND and self-declaration - IT: Salva i consensi di PDND e le autodichiarazioni"
      operationId: consentOnboarding
      parameters:
        - name: Accept-Language
          in: header
          description: "ENG: Language - IT: Lingua"
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
      requestBody:
        description: >-
          ENG: Unique identifier of the subscribed initiative, flag for PDND
          acceptation and the list of accepted self-declared criteria - IT: Identificativo univoco dell'iniziativa sottoscritta, flag per l'accettazione PDND e l'elenco dei criteri autodichiarati accettati
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ConsentPutDTO'
      responses:
        '202':
          description: Accepted - Request Taken Over
          content:
            application/json: {}
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_INVALID_REQUEST"
                message: "Something went wrong handling the request"
        '401':
          description: Authentication failed
        '403':
          description: This onboarding is forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_BUDGET_EXHAUSTED"
                message: "Budget exhausted for initiative [%s]"
        '404':
          description: The requested resource was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_INITIATIVE_NOT_FOUND"
                message: "Cannot find initiative [%s]"
        '429':
          description: Too many Requests
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_TOO_MANY_REQUESTS"
                message: "Too many requests"
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_GENERIC_ERROR"
                message: "An error occurred in the microservice admissibility"
  '/{initiativeId}/status':
    get:
      tags:
        - onboarding
      summary: "ENG: Returns the actual onboarding status along with the date on which that status changed and, if present, the date upon which the onboarding successfully went through - IT: Ritorna lo stato attuale dell'adesione insieme alla data in cui quello stato è cambiato e, se presente, la data in cui l'adesione è avvenuta con successo"
      operationId: onboardingStatus
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
          description: Check successful
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingStatusDTO'
        '400':
          description: Bad Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_INVALID_REQUEST"
                message: "Something went wrong handling the request"
        '401':
          description: Authentication failed
        '404':
          description: The requested resource was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_USER_NOT_ONBOARDED"
                message: "The current user is not onboarded on initiative [%s]"
        '429':
          description: Too many Requests
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_TOO_MANY_REQUESTS"
                message: "Too many requests"
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingErrorDTO'
              example:
                code: "ONBOARDING_GENERIC_ERROR"
                message: "An error occurred in the microservice admissibility"
components:
  schemas:
    ConsentPutDTO:
      title: ConsentPutDTO
      type: object
      required:
        - initiativeId
        - pdndAccept
        - selfDeclarationList
      properties:
        initiativeId:
          type: string
          description: "ENG: Unique identifier of the subscribed initiative - IT: Identificativo univoco dell'iniziativa sottoscritta"
        pdndAccept:
          type: boolean
          description: "ENG: Flag for PDND acceptation - IT: Flag per l'accettazione PDND"
        selfDeclarationList:
          type: array
          items:
            $ref: "#/components/schemas/SelfConsentDTO"
          description: "ENG: The list of accepted self-declared criteria - IT: Lista dei criteri autodichiarati"
    SelfConsentDTO:
      oneOf:
        - $ref: '#/components/schemas/SelfConsentBoolDTO'
        - $ref: '#/components/schemas/SelfConsentMultiDTO'
        - $ref: '#/components/schemas/SelfConsentTextDTO'
    OnboardingPutDTO:
      title: OnboardingPutDTO
      type: object
      required:
        - initiativeId
      properties:
        initiativeId:
          type: string
          description: "ENG: Unique identifier of the subscribed initiative - IT: Identificativo univoco dell'iniziativa sottoscritta"
    OnboardingStatusDTO:
      title: OnboardingStatusDTO
      type: object
      required:
        - status
        - statusDate
      properties:
        status:
          enum:
            - ACCEPTED_TC
            - ON_EVALUATION
            - ONBOARDING_KO
            - ELIGIBLE_KO
            - ONBOARDING_OK
            - UNSUBSCRIBED
            - INVITED
            - DEMANDED
            - SUSPENDED
          type: string
          description: "ENG: Actual status of the citizen onboarding for an initiative - IT: Stato attuale del cittadino rispetto ad un'iniziativa"
        statusDate:
          type: string
          format: date-time
          description: "ENG: Date on which the status changed to the current one - IT: Data in cui lo stato è cambiato allo stato attuale"
        onboardingOkDate:
          type: string
          format: date-time
          description: "ENG: Date on which the onboarding successfully went through - IT: Data in cui l'adesione è avvenuta con successo"
    RequiredCriteriaDTO:
      type: object
      required:
        - pdndCriteria
        - selfDeclarationList
      properties:
        pdndCriteria:
          type: array
          items:
            $ref: '#/components/schemas/PDNDCriteriaDTO'
          description: "ENG: The list of checks made on the PDND platform - IT: Lista dei controlli effettutati dalla piattaforma PDND"
        selfDeclarationList:
          type: array
          items:
            $ref: "#/components/schemas/SelfDeclarationDTO"
          description: "ENG: The list of required self-declared criteria - IT: Lista dei criteri richiesti da autodichiarare"
    SelfDeclarationDTO:
      oneOf:
        - $ref: '#/components/schemas/SelfDeclarationBoolDTO'
        - $ref: '#/components/schemas/SelfDeclarationMultiDTO'
        - $ref: '#/components/schemas/SelfDeclarationTextDTO'
    PDNDCriteriaDTO:
      type: object
      required:
        - code
        - description
        - value
        - authority
      properties:
        code:
          type: string
          enum:
            - ISEE
            - BIRTHDATE
            - RESIDENCE
          description: "ENG: A code that identifies the type of criteria - IT: Codice che identifica il tipo di criterio"
        description:
          type: string
          description: "ENG: Description of the criteria - IT: Descrizione del criterio"
        value:
          type: string
          description: >-
            "ENG: The expected value for the criteria. It is used in conjunction with
            the operator to define a range or an equality over that criteria. - IT: Valore atteso dal criterio. E' usato insieme al campo operator per definire un insieme di valori o un'uguaglianza con un valore"
        value2:
          type: string
          description: >-
            "ENG: In situations where the operator expects two values (e.g BETWEEN)
            this field is populated - IT: Popolato quando il campo operator si aspetta due valori (e.g BETWEEN)"
        operator:
          type: string
          description: "ENG: Represents the relation between the criteria and the value field - IT: Rappresenta la relazione tra il criterio ed il campo value"
          enum:
            - EQ
            - NOT_EQ
            - LT
            - LE
            - GT
            - GE
            - BTW_CLOSED
            - BTW_OPEN
        authority:
          type: string
          description: "ENG: Authority to request PDND criteria value - IT: Autorità a cui richiedere il valore dei criteri PDND"
          enum:
            - INPS
            - AGID
    SelfDeclarationBoolDTO:
      type: object
      required:
        - _type
        - code
        - description
        - value
      properties:
        _type:
          type: string
          description: "ENG: Self-declaration boolean type - IT: Autodichiarazione di tipo boolean"
          enum:
            - boolean
        code:
          type: string
          description: "ENG: Self-declaration code - IT: Codice dell'autodichiarazione"
        description:
          type: string
          description: "ENG: Self-declaration description - IT: Descrizione dell'autodichiarazione"
        value:
          type: boolean
          description: "ENG: Indicates whether the self-declaration is accepted or not - IT: Indica se l'autodichiarazione è accettata o no"
    SelfDeclarationMultiDTO:
      type: object
      required:
        - _type
        - code
        - description
        - value
      properties:
        _type:
          type: string
          description: "ENG: Self-declaration value type - IT: Autodichiarazione di tipo multipli"
          enum:
            - multi
        code:
          type: string
          description: "ENG: Self-declaration code - IT: Codice dell'autodichiarazione"
        description:
          type: string
          description: "ENG: Self-declaration description - IT: Descrizione dell'autodichiarazione"
        value:
          type: array
          items:
            type: string
          description: "ENG: Indicates self-declaration values - IT: Indica i valori per l'autodichiarazione"
    SelfDeclarationTextDTO:
      type: object
      required:
        - _type
        - code
        - description
        - value
      properties:
        _type:
          type: string
          description: >-
            ENG: Self-declaration value type free text - IT: Autodichiarazione di tipo
            testo libero
          enum:
            - text
        code:
          type: string
          description: 'ENG: Self-declaration code - IT: Codice dell''autodichiarazione'
        description:
          type: string
          description: >-
            ENG: Self-declaration description - IT: Descrizione
            dell'autodichiarazione
        value:
          type: string
          description: >-
            ENG: Indicates self-declaration values - IT: Indica i valori per l'autodichiarazione
    SelfConsentBoolDTO:
      type: object
      required:
        - _type
        - code
        - accepted
      properties:
        _type:
          type: string
          enum:
            - boolean
          description: "ENG: Self-consent boolean type - IT: Auto consenso di tipo boolean"
        code:
          type: string
          description: "ENG: Self-consent code - IT: Codice dell'auto consenso"
        accepted:
          type: boolean
          description: "ENG: Indicates whether the self-consent is accepted or not - IT: Indica se l'auto consenso è accettato o no"
    SelfConsentMultiDTO:
      type: object
      required:
        - _type
        - code
        - value
      properties:
        _type:
          type: string
          enum:
            - multi
          description: "ENG: Self-consent value type - IT: Auto consenso di tipo multipli"
        code:
          type: string
          description: "ENG: Self-consent code - IT: Codice dell'auto consenso"
        value:
          type: string
          description: "ENG: Indicates self-consent values - IT: Indica i valori per gli auto consensi"
    SelfConsentTextDTO:
      type: object
      required:
        - _type
        - code
        - value
      properties:
        _type:
          type: string
          enum:
            - text
          description: 'ENG: Self-consent value type free text - IT: Auto consenso di tipo testo libero'
        code:
          type: string
          description: 'ENG: Self-consent code - IT: Codice dell''auto consenso'
        value:
          type: string
          description: >-
            ENG: Indicates self-consent values - IT: Indica i valori per gli
            auto consensi
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
    InitiativeDataDTO:
      type: object
      required:
        - initiativeId
        - initiativeName
        - description
        - organizationId
        - organizationName
        - tcLink
        - privacyLink
      properties:
        initiativeId:
          type: string
          description: "ENG: The initiative ID - IT: Identificativo dell'iniziativa"
        initiativeName:
          type: string
          description: "ENG: Initiative's name - IT: Nome dell'iniziativa"
        description:
          type: string
          description: "ENG: Initiative's description - IT: Descrizione dell'iniziativa"
        organizationId:
          type: string
          description: "ENG: Id of the organization that created the initiative - IT: Identificativo dell'organizzazione che ha creato l'iniziativa"
        organizationName:
          type: string
          description: "ENG: Name of the organization that created the initiative - IT: Nome dell'organizzazione che ha creato l'iniziativa"
        tcLink:
          type: string
          description: "ENG: URL that redirects to the terms and conditions - IT: URL che porta ai termini e condizioni"
        privacyLink:
          type: string
          description: "ENG: URL that redirects to the privacy policy - IT: URL che reindirizza all'informativa della privacy"
        logoURL:
          type: string
          description: "ENG: URL for the initiative's logo image - IT: URL del logo dell'iniziativa"
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
    OnboardingErrorDTO:
      type: object
      required:
        - code
        - message
      properties:
        code:
          type: string
          enum:
            - ONBOARDING_USER_UNSUBSCRIBED
            - ONBOARDING_PAGE_SIZE_NOT_ALLOWED
            - ONBOARDING_PDND_CONSENT_DENIED
            - ONBOARDING_SELF_DECLARATION_NOT_VALID
            - ONBOARDING_SUSPENSION_NOT_ALLOWED_FOR_USER_STATUS
            - ONBOARDING_READMISSION_NOT_ALLOWED_FOR_USER_STATUS
            - ONBOARDING_INVALID_REQUEST
            - ONBOARDING_USER_NOT_IN_WHITELIST
            - ONBOARDING_INITIATIVE_NOT_STARTED
            - ONBOARDING_INITIATIVE_ENDED
            - ONBOARDING_BUDGET_EXHAUSTED
            - ONBOARDING_INITIATIVE_STATUS_NOT_PUBLISHED
            - ONBOARDING_TECHNICAL_ERROR
            - ONBOARDING_UNSATISFIED_REQUIREMENTS
            - ONBOARDING_GENERIC_ERROR
            - ONBOARDING_USER_NOT_ONBOARDED
            - ONBOARDING_INITIATIVE_NOT_FOUND
            - ONBOARDING_TOO_MANY_REQUESTS
          description: >-
            "ENG: Error code:
            ONBOARDING_USER_UNSUBSCRIBED: The user has unsubscribed from initiative,
            ONBOARDING_PAGE_SIZE_NOT_ALLOWED: Page size not allowed,
            ONBOARDING_PDND_CONSENT_DENIED: The PDND consent was denied by the user for the initiative,
            ONBOARDING_SELF_DECLARATION_NOT_VALID: The self-declaration criteria are not
            valid for the initiative or those inserted by the user do not match those required by the initiative,
            ONBOARDING_SUSPENSION_NOT_ALLOWED_FOR_USER_STATUS: It is not possible to suspend
            the user on initiative,
            ONBOARDING_READMISSION_NOT_ALLOWED_FOR_USER_STATUS: It is not possible to readmit the user on initiative,
            ONBOARDING_INVALID_REQUEST: Something went wrong handling the request,
            ONBOARDING_USER_NOT_IN_WHITELIST: The current user is not allowed to participate to the initiative,
            ONBOARDING_INITIATIVE_NOT_STARTED: The initiative has not yet begun,
            ONBOARDING_INITIATIVE_ENDED: The initiative ended,
            ONBOARDING_BUDGET_EXHAUSTED: Budget exhausted for initiative,
            ONBOARDING_INITIATIVE_STATUS_NOT_PUBLISHED: The initiative is not active,
            ONBOARDING_TECHNICAL_ERROR: A technical error occurred during the onboarding process,
            ONBOARDING_UNSATISFIED_REQUIREMENTS: The user does not satisfy the requirements set for the initiative,
            ONBOARDING_GENERIC_ERROR: Application error,
            ONBOARDING_USER_NOT_ONBOARDED: The current user is not onboarded on initiative,
            ONBOARDING_INITIATIVE_NOT_FOUND: Cannot find initiative,
            ONBOARDING_TOO_MANY_REQUESTS: Too many requests
            - IT: Codice di errore:
            ONBOARDING_USER_UNSUBSCRIBED: L'utente si è disiscritto dall'iniziativa,
            ONBOARDING_PAGE_SIZE_NOT_ALLOWED: Dimensione pagina non permessa,
            ONBOARDING_PDND_CONSENT_DENIED: Il consenso PDND per l'iniziativa è stato negato dall'utente,
            ONBOARDING_SELF_DECLARATION_NOT_VALID: I criteri di autodichiarazione non sono
            validi per l'iniziativa o quelli inseriti dall'utente
            non corrispondono con quelli richiesti dall'iniziativa,
            ONBOARDING_SUSPENSION_NOT_ALLOWED_FOR_USER_STATUS: Non è possibile sospendere
            l'utente dall'iniziativa,
            ONBOARDING_READMISSION_NOT_ALLOWED_FOR_USER_STATUS: Non è possibile riammettere l'utente all'iniziativa,
            ONBOARDING_INVALID_REQUEST: Qualcosa è andato storto durante l'invio della richiesta,
            ONBOARDING_USER_NOT_IN_WHITELIST: L'utente corrente non ha il permesso di partecipare all'iniziativa,
            ONBOARDING_INITIATIVE_NOT_STARTED: L'iniziativa non è ancora partita,
            ONBOARDING_INITIATIVE_ENDED: L'iniziativa è terminata,
            ONBOARDING_BUDGET_EXHAUSTED: Il budget dell'iniziativa è esaurito,
            ONBOARDING_INITIATIVE_STATUS_NOT_PUBLISHED: L'iniziativa non è attiva,
            ONBOARDING_TECHNICAL_ERROR: Si è verificato un errore tecnico durante il processo di adesione,
            ONBOARDING_UNSATISFIED_REQUIREMENTS: L'utente non soddisfa i requisiti che sono stati richiesti per l'iniziativa,
            ONBOARDING_GENERIC_ERROR: Errore applicativo,
            ONBOARDING_USER_NOT_ONBOARDED: Utente non onboardato all'iniziativa,
            ONBOARDING_INITIATIVE_NOT_FOUND: Iniziativa non trovata,
            ONBOARDING_TOO_MANY_REQUESTS: Troppe richieste"
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
  - name: onboarding
    description: ''
