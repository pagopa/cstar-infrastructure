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
                $ref: '#/components/schemas/ErrorDto'
              example:
                code: 0
                message: string
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDto'
              example:
                code: 0
                message: string
        '404':
          description: The requested ID was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDto'
              example:
                code: 0
                message: string
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDto'
              example:
                code: 0
                message: string
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
                $ref: '#/components/schemas/ErrorDto'
              example:
                code: 0
                message: string
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDto'
              example:
                code: 0
                message: string
        '403':
          description: This enrolment is ended or suspended
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDto'
              example:
                code: 0
                message: string
        '404':
          description: The requested ID was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDto'
              example:
                code: 0
                message: string
        '429':
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDto'
              example:
                code: 0
                message: string
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDto'
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
                $ref: '#/components/schemas/ErrorDto'
              example:
                code: 0
                message: string
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDto'
              example:
                code: 0
                message: string
        '404':
          description: The requested ID was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDto'
              example:
                code: 0
                message: string
        '429':
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDto'
              example:
                code: 0
                message: string
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDto'
              example:
                code: 0
                message: string
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
              example:
                status: ACCEPTED_TC
        '400':
          description: Bad Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDto'
              example:
                code: 0
                message: string
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDto'
              example:
                code: 0
                message: string
        '404':
          description: The requested ID was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDto'
              example:
                code: 0
                message: string
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDto'
              example:
                code: 0
                message: string
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
      properties:
        status:
          enum:
            - ACCEPTED_TC
            - ON_EVALUATION
            - ONBOARDING_KO
            - ONBOARDING_OK
            - UNSUBSCRIBED
            - ELIGIBLE_KO
            - INVITED
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
