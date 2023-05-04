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
      summary: Retrieves the initiative ID and related information starting from the corresponding service ID
      operationId: getInitiativeData
      parameters:
        - name: serviceId
          in: path
          description: The service ID
          required: true
          schema:
            type: string
        - name: Accept-Language
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
                $ref: '#/components/schemas/InitiativeDataDTO'
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
              example:
                code: 0
                message: string
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
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
              example:
                code: 0
                message: string

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
                $ref: '#/components/schemas/ErrorDTO'
              example:
                code: 0
                message: string
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
              example:
                code: 0
                message: string
        '403':
          description: This onboarding is forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PrerequisitesErrorDTO'
              example:
                code: 0
                message: string
                details: GENERIC_ERROR
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
  /initiative:
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
      requestBody:
        description: Id of the iniziative
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
                $ref: '#/components/schemas/ErrorDTO'
              example:
                code: 0
                message: string
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
              example:
                code: 0
                message: string
        '403':
          description: This onboarding is forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PrerequisitesErrorDTO'
              example:
                code: 0
                message: string
                details: GENERIC_ERROR
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
  /consent:
    put:
      tags:
        - onboarding
      summary: Save the consensus of both PDND and self-declaration
      operationId: consentOnboarding
      parameters:
        - name: Accept-Language
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
      requestBody:
        description: 'Unique identifier of the subscribed initiative, flag for PDND acceptation and the list of accepted self-declared criteria'
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ConsentPutDTO'
      responses:
        '202':
          description: Accepted - Request Taken Over
          content:
            application/json: { }
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
              example:
                code: 0
                message: string
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
              example:
                code: 0
                message: string
        '403':
          description: This onboarding is forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PrerequisitesErrorDTO'
              example:
                code: 0
                message: string
                details: GENERIC_ERROR
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
  '/{initiativeId}/status':
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
      responses:
        '200':
          description: Check successful
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingStatusDTO'
              example:
                status: ACCEPTED_TC
        '400':
          description: Bad Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
              example:
                code: 0
                message: string
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
          description: Unique identifier of the subscribed initiative
        pdndAccept:
          type: boolean
          description: Flag for PDND acceptation
        selfDeclarationList:
          type: array
          items:
            $ref: "#/components/schemas/SelfConsentDTO"
          description: The list of accepted self-declared criteria
    SelfConsentDTO:
      oneOf:
        - $ref: '#/components/schemas/SelfConsentBoolDTO'
        - $ref: '#/components/schemas/SelfConsentMultiDTO'
    OnboardingPutDTO:
      title: OnboardingPutDTO
      type: object
      required:
        - initiativeId
      properties:
        initiativeId:
          type: string
          description: Unique identifier of the subscribed initiative
    OnboardingStatusDTO:
      title: OnboardingStatusDTO
      type: object
      required:
        - status
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
            - ELIGIBLE
            - SUSPENDED
          type: string
          description: actual status of the citizen onboarding for an initiative
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
        description:
          type: string
        value:
          type: string
          description: >-
            The expected value for the criteria. It is used in conjunction with
            the operator to define a range or an equality over that criteria.
        value2:
          type: string
          description: >-
            In situations where the operator expects two values (e.g BETWEEN)
            this field is populated
        operator:
          type: string
          description: Represents the relation between the criteria and the value field
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
        code:
          type: string
        accepted:
          type: boolean
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
        code:
          type: string
        value:
          type: string
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
    PrerequisitesErrorDTO:
      type: object
      required:
        - code
        - message
        - details
      properties:
        code:
          type: integer
          format: int32
        message:
          type: string
        details:
          type: string
          enum:
            - INITIATIVE_NOT_STARTED
            - INITIATIVE_END
            - BUDGET_TERMINATED
            - INITIATIVE_SUSPENDED
            - GENERIC_ERROR
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
        initiativeName:
          type: string
        description:
          type: string
        organizationId:
          type: string
        organizationName:
          type: string
        tcLink:
          type: string
        privacyLink:
          type: string
        logoURL:
          type: string
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
security:
  - bearerAuth: [ ]
tags:
  - name: onboarding
    description: ''
