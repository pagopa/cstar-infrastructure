openapi: 3.0.1
info:
  title: IDPAY Onboarding Workflow IO API
  description: IDPAY Onboarding Workflow IO
  version: '1.0'
paths:
  /citizen:
    put:
      tags:
        - onboarding
      summary: Acceptance of Terms & Conditions
      operationId: onboardingCitizen
      requestBody:
        description: Id of the initiative
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OnboardingPutDTO'
            example:
              initiativeId: string
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
  /initiative:
    put:
      tags:
        - onboarding
      summary: Check the initiative prerequisites
      operationId: checkPrerequisites
      requestBody:
        description: Id of the iniziative
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
              example:
                pdndCriteria:
                  - code: string
                    description: string
                    authority: string
                selfDeclarationList:
                  - code: string
                    description: string
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
  /consent:
    put:
      tags:
        - onboarding
      summary: Save the consensus of both PDND and self-declaration
      operationId: consentOnboarding
      requestBody:
        description: 'Unique identifier of the subscribed initiative, flag for PDND acceptation and the list of accepted self-declared criteria'
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ConsentPutDTO'
            example:
              initiativeId: string
              pdndAccept: true
              selfDeclarationList:
                - code: string
                  accepted: true
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
  '/{initiativeId}/status':
    get:
      tags:
        - onboarding
      summary: Returns the actual onboarding status
      operationId: onboardingStatus
      parameters:
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
    ConsentPutDTO:
      title: ConsentPutDTO
      type: object
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
            $ref: '#/components/schemas/SelfConsentDTO'
          description: The list of accepted self-declared criteria
    OnboardingPutDTO:
      title: OnboardingPutDTO
      type: object
      properties:
        initiativeId:
          type: string
          description: Unique identifier of the subscribed initiative
    OnboardingStatusDTO:
      title: OnboardingStatusDTO
      type: object
      properties:
        status:
          enum:
            - ACCEPTED_TC
            - ON_EVALUATION
            - ONBOARDING_KO
            - ONBOARDING_OK
          type: string
          description: actual status of the citizen onboarding for an initiative
    RequiredCriteriaDTO:
      type: object
      properties:
        pdndCriteria:
          type: array
          items:
            $ref: '#/components/schemas/PDNDCriteriaDTO'
          description: The list of control made with PDND platform
        selfDeclarationList:
          type: array
          items:
            $ref: '#/components/schemas/SelfDeclarationDTO'
          description: The list of required self-declared criteria
    PDNDCriteriaDTO:
      type: object
      properties:
        code:
          type: string
        description:
          type: string
        authority:
          type: string
    SelfDeclarationDTO:
      type: object
      properties:
        code:
          type: string
        description:
          type: string
    SelfConsentDTO:
      type: object
      properties:
        code:
          type: string
        accepted:
          type: boolean
    ErrorDto:
      type: object
      properties:
        code:
          type: integer
          format: int32
        message:
          type: string
  securitySchemes:
    apiKeyHeader:
      type: apiKey
      name: Ocp-Apim-Subscription-Key
      in: header
    apiKeyQuery:
      type: apiKey
      name: subscription-key
      in: query
security:
  - apiKeyHeader: [ ]
  - apiKeyQuery: [ ]
tags:
  - name: onboarding
    description: ''
