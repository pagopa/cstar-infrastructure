openapi: 3.0.1
info:
  title: IDPAY Onboarding Workflow Issuer API v1
  description: IDPAY Onboarding Workflow issuer
  version: '1.0'
servers:
 - url: https://api-io.dev.cstar.pagopa.it/idpay/hb/onboarding
paths:
  /initiative:
    get:
      tags:
        - onboarding
      summary: Retrieves a list of active initiatives with whitelist
      operationId: onboardingInitiativeList
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
                $ref: '#/components/schemas/InitiativeListDTO'
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
    put:
      tags:
        - onboarding
      summary: Check the initiative prerequisites
      operationId: checkPrerequisites
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
      requestBody:
        description: Id of the iniziative
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OnboardingPutDTO'
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
  /:
    put:
      tags:
        - onboarding
      summary: Acceptance of Terms & Conditions
      operationId: onboardingCitizen
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
      requestBody:
        description: Id of the initiative
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OnboardingPutDTO'
      responses:
        '204':
          description: Acceptance successful
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
  /{initiativeId}/status:
    get:
      tags:
        - onboarding
      summary: Returns the actual onboarding status
      operationId: onboardingStatus
      parameters:
        - name: Accept-Language
          in: header
          schema:
            type: string
            example: it-IT
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
    OnboardingPutDTO:
      title: OnboardingPutDTO
      type: object
      required:
       - initiativeId
      properties:
        initiativeId:
          type: string
          description: Unique identifier of the subscribed initiative
    InitiativeListDTO:
      type: object
      required:
        - initiativeList
      properties:
        initiativeList:
          type: array
          items:
            $ref: '#/components/schemas/InitiativeDto'
          description: The list of active iniziatives with whitelist
    InitiativeDto:
      type: object
      required:
        - initiativeId
        - description
      properties:
        initiativeId:
          type: string
          description: Unique identifier of the subscribed initiative
        initiativeName:
          type: string
          description: Name of the subscribed initiative
        organizationName:
          type: string
          description: Organization name of a initiative
        descriptionMap:
          type: array
          items:
            $ref: '#/components/schemas/descriptionMapDto'
          example:
                it: it
        startDate:
          type: string
          description: Start of period of spending funds in an initiative
        endDate:
          type: string
          description: End of period of spending funds in an initiative
        rankingEnabled:
          type: boolean
          description: Flag of period of participation/adhesion in an initiative
        rankingStartDate:
          type: string
          description: Start of period of participation/adhesion in an initiative
        rankingEndDate:
          type: string
          description: End of period of participation/adhesion in an initiative
        beneficiaryKnown:
          type: boolean
          description: Flag that indicates the presence of a whitelist
        status:
          type: string
          description: Status of the subscribed initiative
        tcLink:
          type: string
        privacyLink:
          type: string
          description: Privacy link of the subscribed initiative
        logoUrl:
          type: string
          description: The url of the logo of the subscribed initiative
    descriptionMapDto:
      title: O
      type: object
      required:
       - type
       - contact
      properties:
        it:
          type: string
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
          description: The list of control made with PDND platform
        selfDeclarationList:
          type: array
          items:
            $ref: "#/components/schemas/SelfDeclarationDTO"
          description: The list of required self-declared criteria
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
        description:
          type: string
        value:
          type: string
          description: The expected value for the criteria. It is used in conjunction with the operator to define a range or an equality over that criteria.
        value2:
          type: string
          description: In situations where the operator expects two values (e.g BETWEEN) this field is populated
        operator:
          type: string
          description: Represents the relation between the criteria and the value field
        authority:
          type: string
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
          enum:
            - boolean
        code:
          type: string
        description:
          type: string
        value:
          type: boolean
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
          enum:
            - multi
        code:
          type: string
        description:
          type: string
        value:
          type: array
          items:
            type: string
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
          type: array
          items:
            type: string
          description: >-
            ENG: Indicates self-declaration values - IT: Indica i valori per
            l'autodichiarazione
    ErrorDto:
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
    InitiativeErrorDTO:
      type: object
      properties:
        code:
          type: string
          enum:
            - INITIATIVE_INVALID_REQUEST
            - INITIATIVE_NOT_FOUND
            - INITIATIVE_TOO_MANY_REQUESTS
            - INITIATIVE_GENERIC_ERROR
          description: >-
           "ENG: Error code:
            INITIATIVE_INVALID_REQUEST: Something went wrong handling the request,
            INITIATIVE_NOT_FOUND: Initiative not found,
            INITIATIVE_TOO_MANY_REQUESTS: Too many requests,
            INITIATIVE_GENERIC_ERROR: Application error,
            - IT: Codice di errore:
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
    ApiKeyAuth:
      type: apiKey
      in: header
      name: Ocp-Apim-Subscription-Key
      description: The API key can be obtained through the developer portal
security:
  - ApiKeyAuth: [ ]
tags:
  - name: onboarding
    description: ''
