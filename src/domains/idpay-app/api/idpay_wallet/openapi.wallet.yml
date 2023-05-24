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
      summary: Returns the list of active initiatives of a citizen
      operationId: getWallet
      parameters:
        - name: Accept-Language
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
              example:
                initiativeList:
                  - initiativeId: string
                    initiativeName: string
                    status: NOT_REFUNDABLE_ONLY_IBAN
                    endDate: string
                    amount: 0.01
                    accrued: 0.01
                    refunded: 0.01
                    iban: string
                    nInstr: 0
                    initiativeRewardType: REFUND
                    logoURL: string
                    organizationName: string
        '401':
          description: Authentication failed
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
  '/{initiativeId}/detail':
    get:
      tags:
        - wallet
      summary: Returns the detail of an initiative
      operationId: getInitiativeBeneficiaryDetail
      parameters:
        - name: initiativeId
          in: path
          description: The initiative ID
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
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/InitiativeDetailDTO'
        '404':
          description: The requested ID was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '429':
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
  '/{initiativeId}':
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
              example:
                familyId: string
                initiativeId: string
                initiativeName: string
                status: NOT_REFUNDABLE_ONLY_IBAN
                endDate: string
                amount: 0.01
                accrued: 0.01
                refunded: 0.01
                iban: string
                nInstr: 0
                initiativeRewardType: REFUND
                logoURL: string
                organizationName: string
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
          description: Forbidden
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
  /{initiativeId}/instruments/{idWallet}:
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
        - name: initiativeId
          in: path
          description: The initiative ID
          required: true
          schema:
            type: string
        - name: idWallet
          in: path
          description: A unique id that identifies a payment method
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
          description: Forbidden
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
  /{initiativeId}/instruments:
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

  /{initiativeId}/instruments/{instrumentId}:
    delete:
      tags:
        - wallet
      summary: Delete a payment instrument from an initiative
      operationId: deleteInstrument
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
        - name: instrumentId
          in: path
          description: A unique id, internally detached, which identifies a payment method
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Delete OK
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
          description: Forbidden
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

  /{initiativeId}/unsubscribe:
    delete:
      tags:
        - wallet
      summary: Unsubscribe to an initiative
      operationId: unsubscribe
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
        '204':
          description: Unsubscribe OK
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
          description: Forbidden
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
  '/instrument/{idWallet}/initiatives':
    get:
      tags:
        - wallet
      summary: Returns the initiatives list associated to a payment instrument
      operationId: getInitiativesWithInstrument
      parameters:
        - name: Accept-Language
          in: header
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: idWallet
          in: path
          description: The ID Wallet
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
            - SUSPENDED
          type: string
          description: actual status of the citizen wallet for an initiative
    WalletDTO:
      type: object
      required:
        - initiativeList
      properties:
        initiativeList:
          type: array
          items:
            $ref: '#/components/schemas/InitiativeDTO'
          description: The list of active initiatives of a citizen
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
        brand:
          type: string
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
        familyId:
          type: string
        initiativeId:
          type: string
        initiativeName:
          type: string
        status:
          enum:
            - NOT_REFUNDABLE_ONLY_IBAN
            - NOT_REFUNDABLE_ONLY_INSTRUMENT
            - REFUNDABLE
            - NOT_REFUNDABLE
            - UNSUBSCRIBED
            - SUSPENDED
          type: string
        endDate:
          type: string
          format: date
        amount:
          type: number
        accrued:
          type: number
        refunded:
          type: number
        iban:
          type: string
        nInstr:
          type: integer
          format: int32
        initiativeRewardType:
          enum:
            - DISCOUNT
            - REFUND
          type: string
        logoURL:
          type: string
        organizationName:
          type: string
        nTrx:
          type: integer
          format: int64
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
        maskedPan:
          type: string
        brand:
          type: string
        initiativeList:
          type: array
          items:
            $ref: '#/components/schemas/InitiativesStatusDTO'
          description: The list of the payment instrument status with respect to the initiative
    InitiativesStatusDTO:
      type: object
      required:
        - initiativeId
        - initiativeName
        - status
      properties:
        initiativeId:
          type: string
        initiativeName:
          type: string
        idInstrument:
          type: string
        status:
          type: string
          enum:
            - ACTIVE
            - INACTIVE
            - PENDING_ENROLLMENT_REQUEST
            - PENDING_DEACTIVATION_REQUEST
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
    InitiativeDetailDTO:
      type: object
      properties:
        initiativeName:
          type: string
        status:
          type: string
        description:
          type: string
        ruleDescription:
          type: string
        endDate:
          type: string
          format: date
        rankingStartDate:
          type: string
          format: date
        rankingEndDate:
          type: string
          format: date
        rewardRule:
          $ref: '#/components/schemas/RewardValueDTO'
        refundRule:
          $ref: '#/components/schemas/InitiativeRefundRuleDTO'
        privacyLink:
          type: string
        tcLink:
          type: string
        logoURL:
          type: string
        updateDate:
          type: string
          format: date-time
        serviceId:
          type: string
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
        refundThreshold:
          type: number
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
        rewardValue:
          type: number
    RefundAdditionalInfoDTO:
      required:
        - identificationCode
      type: object
      properties:
        identificationCode:
          type: string
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
security:
  - bearerAuth: [ ]
tags:
  - name: wallet
    description: ''
