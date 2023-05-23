openapi: 3.0.1
info:
  title: IDPAY Assistance API
  description: API for assistance
  version: '1.0'
servers:
  - url: https://api-io.dev.cstar.pagopa.it/idpay/assistance
paths:
  '/organizations':
    get:
      tags:
        - organizations
      summary: Returns list of Organizations for at least one initiative by each visible to the PagoPA operator
      operationId: getListOfOrganization
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrganizationListDTO'
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
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
  /summary:
    get:
      tags:
        - initiative
      summary: Returns the list of initiatives names for a specific organization
      description: Returns the list of initiatives names for a specific organization
      operationId: getInitativeSummary
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/InitiativeSummaryArrayDTO'
        '401':
          description: Authentication failed
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

  /{initiativeId}/statistics:
    get:
      tags:
        - initiative
      summary: Return of onboard users and the budget spent (accrued bonus)
      operationId: initiativeStatistics
      parameters:
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
                $ref: '#/components/schemas/InitiativeStatisticsDTO'
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
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
  /{initiativeId}:
    get:
      tags:
        - initiative
      summary: Returns the detail of an active initiative
      description: Returns the detail of an active initiative
      operationId: getInitiativeDetail
      parameters:
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
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
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
  '/{initiativeId}/beneficiary/{iban}':
    get:
      tags:
        - beneficiary
      summary: Returns the detail of the IBAN associated to the initiative by the citizen
      operationId: getIban
      parameters:
        - name: Fiscal-Code
          in: header
          schema:
            type: string
            example: Fiscal-Code
          required: true
        - name: iban
          in: path
          description: The citizen iban
          required: true
          schema:
            type: string
        - name: initiativeId
          in: path
          description: The initiative id
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/IbanDTO'
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
  '/{initiativeId}/beneficiary/timeline':
    get:
      tags:
        - beneficiary
      summary: Returns the list of transactions and operations of an initiative of a citizen sorted by date (newest->oldest)
      operationId: getTimeline
      parameters:
        - name: Fiscal-Code
          in: header
          schema:
            type: string
            example: Fiscal-Code
          required: true
        - name: initiativeId
          in: path
          description: The initiative ID
          required: true
          schema:
            type: string
        - name: operationType
          in: query
          description: Operation type filter
          schema:
            type: string
        - name: dateFrom
          in: query
          description: Start date
          required: false
          schema:
            type: string
            format: date-time
        - name: dateTo
          in: query
          description: End date
          required: false
          schema:
            type: string
            format: date-time
        - name: page
          in: query
          description: The number of the page
          schema:
            type: integer
        - name: size
          in: query
          description: 'Number of items, default 3 - max 10'
          schema:
            type: integer
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TimelineDTO'
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
  '/{initiativeId}/beneficiary/timeline/{operationId}':
    get:
      tags:
        - beneficiary
      summary: Returns the detail of a transaction
      operationId: getTimelineDetail
      parameters:
        - name: Fiscal-Code
          in: header
          schema:
            type: string
            example: Fiscal-Code
          required: true
        - name: initiativeId
          in: path
          description: The initiative ID
          required: true
          schema:
            type: string
        - name: operationId
          in: path
          description: The operation ID
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OperationDTO'
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
  '/{initiativeId}/beneficiary/wallet':
    get:
      tags:
        - beneficiary
      summary: Returns the detail of an active initiative of a citizen
      operationId: getWalletDetail
      parameters:
        - name: Fiscal-Code
          in: header
          schema:
            type: string
            example: Fiscal-Code
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
                $ref: '#/components/schemas/WalletDTO'
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
  '/{initiativeId}/beneficiary/instruments':
    get:
      tags:
        - beneficiary
      summary: Returns the list of payment instruments associated to the initiative by the citizen
      operationId: getInstrumentList
      parameters:
        - name: Fiscal-Code
          in: header
          schema:
            type: string
            example: Fiscal-Code
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

  /{initiativeId}/onboardings:
    get:
      tags:
        - initiative-onboarding
      summary: Returns the onboardings status
      description: Returns the onboardings status
      operationId: getOnboardingStatus
      parameters:
        - name: initiativeId
          in: path
          description: The initiative ID
          required: true
          schema:
            type: string
        - name: page
          in: query
          required: false
          schema:
            type: integer
            format: int32
        - name: size
          in: query
          required: false
          schema:
            type: integer
            format: int32
        - name: sort
          in: query
          required: false
          schema:
            type: string
        - name: beneficiary
          in: query
          description: Fiscale code
          required: false
          schema:
            type: string
        - name: dateFrom
          in: query
          description: Start date
          required: false
          schema:
            type: string
        - name: dateTo
          in: query
          description: End date
          required: false
          schema:
            type: string
        - name: state
          in: query
          description: onboarding state
          required: false
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OnboardingDTO'
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
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
  /{initiativeId}/onboarding/status:
    get:
      tags:
        - initiative-onboarding
      summary: Returns the actual onboarding status
      operationId: getBeneficiaryOnboardingStatus
      parameters:
        - name: Fiscal-Code
          in: header
          schema:
            type: string
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
  /{initiativeId}/ranking/exports:
    get:
      tags:
        - initiative-onboarding
      summary: Return a pageable list of Citizen ranking status for a specific Intiative by using filters
      description: Return a pageable list of Citizen ranking status for a specific Intiative by using filters
      operationId: getInitiativeOnboardingRankingStatusPaged
      parameters:
        - name: initiativeId
          in: path
          description: The initiative ID
          required: true
          schema:
            type: string
        - name: page
          in: query
          required: false
          schema:
            type: integer
            format: int32
        - name: size
          in: query
          required: false
          schema:
            type: integer
            format: int32
        - name: sort
          in: query
          required: false
          schema:
            type: string
        - name: beneficiary
          in: query
          description: Fiscale code
          required: false
          schema:
            type: string
        - name: state
          in: query
          description: onboarding state
          required: false
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PageOnboardingRankingsDTO'
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
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
  /{initiativeId}/ranking/exports/{filename}:
    get:
      tags:
        - initiative-onboarding
      summary: Return the requested filename containing the list of Citizen ranking status for a specific Intiative
      description: Return the requested filename containing the list of Citizen ranking status for a specific Intiative
      operationId: getRankingFileDownload
      parameters:
        - name: initiativeId
          in: path
          description: initiativeId
          required: true
          style: simple
          schema:
            type: string
        - name: filename
          in: path
          description: filename
          required: true
          style: simple
          schema:
            type: string
      responses:
        '201':
          description: Created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SasToken'
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '403':
          description: Forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
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

  /{initiativeId}/reward/exports:
    get:
      tags:
        - initiative-reward
      summary: Return a pageable list of reward exports notification for a specific Initiative by using filters
      operationId: getRewardNotificationExportsPaged
      parameters:
        - name: initiativeId
          in: path
          description: initiativeId
          required: true
          style: simple
          schema:
            type: string
        - name: page
          in: query
          required: false
          style: form
          schema:
            type: integer
            format: int32
        - name: size
          in: query
          required: false
          style: form
          schema:
            type: integer
            format: int32
        - name: sort
          in: query
          required: false
          style: form
          schema:
            type: string
        - name: status
          in: query
          required: false
          style: form
          schema:
            type: string
        - name: notificationDateFrom
          in: query
          required: false
          style: form
          schema:
            type: string
            format: date
        - name: notificationDateTo
          in: query
          required: false
          style: form
          schema:
            type: string
            format: date
      responses:
        '200':
          description: OK
          content:
            '*/*':
              schema:
                $ref: '#/components/schemas/PageRewardExportsDTO'
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '403':
          description: Forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
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
  /{initiativeId}/reward/imports:
    get:
      tags:
        - initiative-reward
      summary: Return a pageable list of reward imports notification for a specific Initiative by using filters
      operationId: getRewardNotificationImportsPaged
      parameters:
        - name: initiativeId
          in: path
          description: initiativeId
          required: true
          style: simple
          schema:
            type: string
        - name: page
          in: query
          required: false
          style: form
          schema:
            type: integer
            format: int32
        - name: size
          in: query
          required: false
          style: form
          schema:
            type: integer
            format: int32
        - name: sort
          in: query
          required: false
          style: form
          schema:
            type: string
        - name: status
          in: query
          required: false
          style: form
          schema:
            type: string
        - name: elabDateFrom
          in: query
          required: false
          style: form
          schema:
            type: string
            format: date-time
        - name: elabDateTo
          in: query
          required: false
          style: form
          schema:
            type: string
            format: date-time
      responses:
        '200':
          description: OK
          content:
            '*/*':
              schema:
                $ref: '#/components/schemas/PageRewardImportsDTO'
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '403':
          description: Forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '404':
          description: The requested ID was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '409':
          description: Conflict
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

  /{initiativeId}/reward/exports/{filename}:
    get:
      tags:
        - initiative-reward
      summary: Return the requested filename
      operationId: getRewardFileDownload
      parameters:
        - name: initiativeId
          in: path
          description: initiativeId
          required: true
          style: simple
          schema:
            type: string
        - name: filename
          in: path
          description: filename
          required: true
          style: simple
          schema:
            type: string
      responses:
        '201':
          description: Created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SasToken'
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '403':
          description: Forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
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

  /{initiativeId}/reward/import/{filename}/errors:
    get:
      tags:
        - initiative-reward
      summary: Get dispositive file errors
      operationId: getDispFileErrors
      parameters:
        - name: initiativeId
          in: path
          description: initiativeId
          required: true
          style: simple
          schema:
            type: string
        - name: filename
          in: path
          description: filename
          required: true
          style: simple
          schema:
            type: string
      responses:
        '200':
          description: OK
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CsvDTO'
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '403':
          description: Forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
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
  /{initiativeId}/reward/exports/{exportId}/summary:
    get:
      tags:
        - initiative-reward
      summary: get the export summary data
      operationId: getExportSummary
      parameters:
        - name: initiativeId
          in: path
          description: initiativeId
          required: true
          style: simple
          schema:
            type: string
        - name: exportId
          in: path
          description: exportId
          required: true
          style: simple
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                '$ref': '#/components/schemas/ExportSummaryDTO'
              example:
                createDate: 2018-10-13
                status: EXPORTED
                successPercentage: '20'
                totalAmount: 100
                totalRefundedAmount: 10
                totalRefunds: 20
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '403':
          description: Forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
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
  /{initiativeId}/reward/exports/{exportId}/refunds:
    get:
      tags:
        - initiative-reward
      summary: get the refunds list in pages
      operationId: getExportRefundsListPaged
      parameters:
        - name: initiativeId
          in: path
          description: initiativeId
          required: true
          style: simple
          schema:
            type: string
        - name: exportId
          in: path
          description: exportId
          required: true
          style: simple
          schema:
            type: string
        - name: page
          in: query
          required: false
          schema:
            type: integer
            format: int32
        - name: size
          in: query
          required: false
          schema:
            type: integer
            format: int32
        - name: sort
          in: query
          required: false
          schema:
            type: string
        - name: cro
          in: query
          required: false
          schema:
            type: string
        - name: status
          in: query
          required: false
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                '$ref': '#/components/schemas/ExportListDTO'
              example:
                content:
                  - id: '1234'
                    iban: IT60X0542811101000000123456
                    amount: 10
                    status: COMPLETED_OK
                  - id: '5678'
                    iban: IT60X0542811101000000123456
                    amount: 10
                    status: COMPLETED_OK
                  - id: '9101'
                    iban: IT60X0542811101000000123456
                    amount: 10
                    status: COMPLETED_OK
                  - id: '1121'
                    iban: IT60X0542811101000000123456
                    amount: 10
                    status: COMPLETED_OK
                  - id: '3141'
                    iban: IT60X0542811101000000123456
                    amount: 10
                    status: COMPLETED_KO
                  - id: '5161'
                    iban: IT60X0542811101000000123456
                    amount: 10
                    status: COMPLETED_KO
                  - id: '7181'
                    iban: IT60X0542811101000000123456
                    amount: 10
                    status: COMPLETED_KO
                  - id: '9200'
                    iban: IT60X0542811101000000123456
                    amount: 10
                    status: EXPORTED
                  - id: '1222'
                    iban: IT60X0542811101000000123456
                    amount: 10
                    status: EXPORTED
                  - id: '3242'
                    iban: IT60X0542811101000000123456
                    amount: 10
                    status: EXPORTED
                pageNo: 0
                pageSize: 10
                totalElements: 10
                totalPages: 1
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '403':
          description: Forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
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
  /{initiativeId}/reward/exports/event/{eventId}:
    get:
      tags:
        - initiative-reward
      summary: get the refund detail
      operationId: getRefundDetail
      parameters:
        - name: initiativeId
          in: path
          description: initiativeId
          required: true
          style: simple
          schema:
            type: string
        - name: eventId
          in: path
          description: eventId
          required: true
          style: simple
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                '$ref': '#/components/schemas/RefundDetailDTO'
              example:
                amount: 10
                endDate: 2022-10-15
                fiscalCode: RSSMRA94C31F205K
                iban: IT60X0542811101000000123456
                userNotificationDate: 2022-12-13
                refundType: ORDINARY
                transferDate: 2022-12-13
                startDate: 2022-10-14
                status: COMPLETED_OK
                cro: '12345678901'
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '401':
          description: Authentication failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '403':
          description: Forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
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
components:
  schemas:
    SasToken:
      type: object
      properties:
        sas:
          type: string
    PortalToken:
      type: object
      properties:
        token:
          type: string
    InitiativeAdditionalDTO:
      type: object
      properties:
        serviceIO:
          type: boolean
        serviceId:
          type: string
        serviceName:
          type: string
        serviceScope:
          enum:
            - LOCAL
            - NATIONAL
          type: string
        description:
          type: string
        privacyLink:
          type: string
        tcLink:
          type: string
        channels:
          $ref: '#/components/schemas/ChannelArrayDTO'
        logoFileName:
          type: string
        logoURL:
          type: string
        logoUploadDate:
          type: string
          format: date-time
    InitiativeGeneralDTO:
      type: object
      properties:
        budget:
          type: number
        beneficiaryType:
          enum:
            - PF
            - PG
            - NF
          type: string
        familyUnitComposition:
          enum:
            - INPS
            - ANPR
          type: string
        beneficiaryKnown:
          type: boolean
        beneficiaryBudget:
          type: number
        startDate:
          type: string
          description: Start date
          format: date
          example: '2022-01-30'
        endDate:
          type: string
          description: Start date
          format: date
          example: '2022-01-30'
        rankingStartDate:
          type: string
          description: Start date
          format: date
          example: '2022-01-30'
        rankingEndDate:
          type: string
          description: Start date
          format: date
          example: '2022-01-30'
        rankingEnabled:
          type: boolean
        descriptionMap:
          $ref: '#/components/schemas/DescriptionMap'
    AutomatedCriteriaDTO:
      type: object
      properties:
        authority:
          type: string
        code:
          type: string
        field:
          type: string
        operator:
          type: string
        value:
          type: string
        orderDirection:
          type: string
          enum:
            - ASC
            - DESC
        iseeTypes:
          type: array
          items:
            type: string
            enum:
              - ORDINARIO
              - MINORENNE
              - UNIVERSITARIO
              - SOCIOSANITARIO
              - DOTTORATO
              - RESIDENZIALE
              - CORRENTE
          example:
            [
              'ORDINARIO',
              'MINORENNE',
              'UNIVERSITARIO',
              'SOCIOSANITARIO',
              'DOTTORATO',
              'RESIDENZIALE',
              'CORRENTE',
            ]
    InitiativeDTO:
      type: object
      properties:
        initiativeId:
          type: string
        initiativeName:
          type: string
        organizationId:
          type: string
        organizationName:
          type: string
        creationDate:
          type: string
          description: Creation Date
          format: date-time
        updateDate:
          type: string
          description: Update Date
          format: date-time
        status:
          type: string
        autocertificationCheck:
          type: boolean
        beneficiaryRanking:
          type: boolean
        general:
          $ref: '#/components/schemas/InitiativeGeneralDTO'
        additionalInfo:
          $ref: '#/components/schemas/InitiativeAdditionalDTO'
        beneficiaryRule:
          $ref: '#/components/schemas/InitiativeBeneficiaryRuleDTO'
        initiativeRewardType:
          type: string
          enum:
            - DISCOUNT
            - REFUND
        rewardRule:
          $ref: '#/components/schemas/InitiativeRewardRuleDTO'
        trxRule:
          $ref: '#/components/schemas/InitiativeTrxConditionsDTO'
        refundRule:
          $ref: '#/components/schemas/InitiativeRefundRuleDTO'
        isLogoPresent:
          type: boolean
    DescriptionLanguageMap:
      type: object
      properties:
        language:
          type: string
        description:
          type: string
      items:
        $ref: '#/components/schemas/DescriptionLanguageMap'
    InitiativeSummaryArrayDTO:
      type: array
      items:
        $ref: '#/components/schemas/InitiativeSummaryDTO'
    InitiativeSummaryDTO:
      type: object
      properties:
        initiativeId:
          type: string
        initiativeName:
          type: string
        status:
          type: string
        creationDate:
          type: string
          format: date-time
        updateDate:
          type: string
          format: date-time
        rankingEnabled:
          type: boolean
    OrganizationListDTO:
      type: array
      items:
        $ref: '#/components/schemas/OrganizationDTO'
    OrganizationDTO:
      type: object
      properties:
        organizationId:
          type: string
        organizationName:
          type: string
    ChannelArrayDTO:
      type: array
      items:
        $ref: '#/components/schemas/ChannelDTO'
    ChannelDTO:
      type: object
      properties:
        type:
          enum:
            - web
            - email
            - mobile
          type: string
        contact:
          type: string
    ErrorDTO:
      type: object
      properties:
        code:
          type: string
        message:
          type: string
    AnyOfInitiativeBeneficiaryRuleDTOSelfDeclarationCriteriaItems:
      type: object
      anyOf:
        - $ref: '#/components/schemas/SelfCriteriaBoolDTO'
        - $ref: '#/components/schemas/SelfCriteriaMultiDTO'
      description: List of possible criteria
    InitiativeBeneficiaryRuleDTO:
      type: object
      properties:
        selfDeclarationCriteria:
          type: array
          items:
            $ref: '#/components/schemas/AnyOfInitiativeBeneficiaryRuleDTOSelfDeclarationCriteriaItems'
        automatedCriteria:
          type: array
          items:
            $ref: '#/components/schemas/AutomatedCriteriaDTO'
        apiKeyClientId:
          type: string
        apiKeyClientAssertion:
          type: string
    SelfCriteriaBoolDTO:
      type: object
      properties:
        _type:
          enum:
            - boolean
          type: string
        description:
          type: string
        value:
          type: boolean
        code:
          type: string
    SelfCriteriaMultiDTO:
      title: SelfCriteriaMultiDTO
      type: object
      properties:
        _type:
          enum:
            - multi
          type: string
        description:
          type: string
        value:
          type: array
          items:
            type: string
          example:
            - value1
            - value2
            - value3
        code:
          type: string
    ConfigBeneficiaryRuleArrayDTO:
      type: array
      items:
        $ref: '#/components/schemas/ConfigBeneficiaryRuleDTO'
    ConfigBeneficiaryRuleDTO:
      title: ConfigBeneficiaryRuleDTO
      type: object
      properties:
        code:
          type: string
        authority:
          type: string
        field:
          type: string
        operator:
          type: string
        checked:
          type: boolean
    ConfigTrxRuleArrayDTO:
      type: array
      items:
        $ref: '#/components/schemas/ConfigTrxRuleDTO'
    ConfigTrxRuleDTO:
      title: ConfigTrxRuleDTO
      type: object
      properties:
        code:
          type: string
        description:
          type: string
        enabled:
          type: boolean
        checked:
          type: boolean
    ConfigMccArrayDTO:
      type: array
      items:
        $ref: '#/components/schemas/ConfigMccDTO'
    ConfigMccDTO:
      title: ConfigMccDTO
      type: object
      properties:
        code:
          type: string
        description:
          type: string
    DayConfig:
      type: object
      properties:
        daysOfWeek:
          uniqueItems: true
          type: array
          items:
            type: string
            enum:
              - MONDAY
              - TUESDAY
              - WEDNESDAY
              - THURSDAY
              - FRIDAY
              - SATURDAY
              - SUNDAY
        intervals:
          type: array
          items:
            $ref: '#/components/schemas/Interval'
    InitiativeRewardAndTrxRulesDTO:
      required:
        - initiativeRewardType
        - rewardRule
      type: object
      properties:
        initiativeRewardType:
          type: string
          enum:
            - REFUND
            - DISCOUNT
        rewardRule:
          oneOf:
            - $ref: '#/components/schemas/RewardGroupsDTO'
            - $ref: '#/components/schemas/RewardValueDTO'
        trxRule:
          $ref: '#/components/schemas/InitiativeTrxConditionsDTO'
    InitiativeRewardRuleDTO:
      required:
        - _type
        - rewardValueType
      type: object
      properties:
        _type:
          type: string
        rewardValueType:
          type: string
          enum:
            - PERCENTAGE
            - ABSOLUTE
      discriminator:
        propertyName: _type
    InitiativeTrxConditionsDTO:
      type: object
      properties:
        daysOfWeek:
          type: array
          properties:
            empty:
              type: boolean
          items:
            $ref: '#/components/schemas/DayConfig'
        threshold:
          $ref: '#/components/schemas/ThresholdDTO'
        mccFilter:
          $ref: '#/components/schemas/MccFilterDTO'
        trxCount:
          $ref: '#/components/schemas/TrxCountDTO'
        rewardLimits:
          type: array
          items:
            $ref: '#/components/schemas/RewardLimitsDTO'
    Interval:
      type: object
      properties:
        startTime:
          type: string
          description: 'hours:minutes:seconds.nano'
          example: '00:16:00.000'
        endTime:
          type: string
          description: 'hours:minutes:seconds.nano'
          example: '02:00:00.000'
    MccFilterDTO:
      type: object
      properties:
        allowedList:
          type: boolean
        values:
          uniqueItems: true
          type: array
          items:
            type: string
    LogoDTO:
      type: object
      properties:
        logoFileName:
          type: string
          example: 'logo-name.png'
        logoURL:
          type: string
          example: 'https://localhost:8080/logo/initiative/logo.png'
        logoUploadDate:
          type: string
          description: date-time
          example: '2022-11-18T17:16:08.8820821'
    RewardGroupDTO:
      type: object
      properties:
        from:
          type: number
        to:
          type: number
        rewardValue:
          maximum: 100
          minimum: 0
          type: number
    RewardGroupsDTO:
      type: object
      allOf:
        - $ref: '#/components/schemas/InitiativeRewardRuleDTO'
        - type: object
          properties:
            rewardGroups:
              type: array
              items:
                $ref: '#/components/schemas/RewardGroupDTO'
    RewardLimitsDTO:
      type: object
      properties:
        frequency:
          type: string
          enum:
            - DAILY
            - WEEKLY
            - MONTHLY
            - YEARLY
        rewardLimit:
          type: number
    RewardValueDTO:
      type: object
      allOf:
        - $ref: '#/components/schemas/InitiativeRewardRuleDTO'
        - type: object
          properties:
            rewardValue:
              maximum: 100
              minimum: 0
              type: number
    ThresholdDTO:
      type: object
      properties:
        from:
          type: number
        fromIncluded:
          type: boolean
        to:
          type: number
        toIncluded:
          type: boolean
    TrxCountDTO:
      type: object
      properties:
        from:
          type: integer
          format: int64
        fromIncluded:
          type: boolean
        to:
          type: integer
          format: int64
        toIncluded:
          type: boolean
    InitiativeRefundRuleDTO:
      type: object
      properties:
        accumulatedAmount:
          $ref: '#/components/schemas/AccumulatedAmountDTO'
        timeParameter:
          $ref: '#/components/schemas/TimeParameterDTO'
        additionalInfo:
          $ref: '#/components/schemas/RefundAdditionalInfoDTO'
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
    OnboardingDTO:
      type: object
      properties:
        content:
          type: array
          items:
            $ref: '#/components/schemas/StatusOnboardingDTOS'
        pageNo:
          type: integer
          format: int32
        pageSize:
          type: integer
          format: int32
        totalElements:
          type: integer
          format: int32
        totalPages:
          type: integer
          format: int32
    StatusOnboardingDTOS:
      type: object
      properties:
        beneficiary:
          type: string
        beneficiaryState:
          type: string
          enum:
            - INVITED
            - ACCEPTED_TC
            - DEMANDED
            - ON_EVALUATION
            - ONBOARDING_KO
            - ELIGIBLE_KO
            - ONBOARDING_OK
            - ELIGIBLE
            - INACTIVE
            - UNSUBSCRIBED
            - SUSPENDED
        updateStatusDate:
          type: string
          format: date-time
    PageOnboardingRankingsDTO:
      type: object
      properties:
        content:
          type: array
          items:
            $ref: '#/components/schemas/OnboardingRankingsDTO'
        pageNumber:
          type: integer
          format: int32
        pageSize:
          type: integer
          format: int32
        totalElements:
          type: integer
          format: int32
        totalPages:
          type: integer
          format: int32
        rankingStatus:
          type: string
        rankingPublishedTimestamp:
          type: string
          format: date-time
        rankingGeneratedTimestamp:
          type: string
          format: date-time
        totalEligibleOk:
          type: integer
          format: int64
        totalEligibleKo:
          type: integer
          format: int64
        totalOnboardingKo:
          type: integer
          format: int64
        rankingFilePath:
          type: string
    OnboardingRankingsDTO:
      type: object
      properties:
        beneficiary:
          type: string
        criteriaConsensusTimestamp:
          type: string
          format: date-time
        rankingValue:
          type: integer
          format: int64
        ranking:
          type: integer
          format: int64
        beneficiaryRankingStatus:
          type: string
    RefundAdditionalInfoDTO:
      required:
        - identificationCode
      type: object
      properties:
        identificationCode:
          type: string
    InitiativeStatisticsDTO:
      type: object
      properties:
        lastUpdatedDateTime:
          type: string
          format: date-time
        onboardedCitizenCount:
          type: integer
          format: int32
        accruedRewards:
          type: string
    PageRewardExportsDTO:
      title: PageRewardExportsDTO
      type: object
      properties:
        content:
          type: array
          items:
            $ref: '#/components/schemas/RewardExportsDTO'
        totalElements:
          type: integer
          format: int64
        totalPages:
          type: integer
          format: int32
    PageRewardImportsDTO:
      title: PageRewardImportsDTO
      type: object
      properties:
        content:
          type: array
          items:
            '$ref': '#/components/schemas/RewardImportsDTO'
        totalElements:
          type: integer
          format: int64
        totalPages:
          type: integer
          format: int32
    DescriptionMap:
      type: object
      additionalProperties:
        type: string
      example:
        it: Ciao!
        en: Hello!
        fr: Salut!
    RewardExportsDTO:
      title: RewardExportsDTO
      required:
        [
          'id',
          'organizationId',
          'initiativeId',
          'initiativeName',
          'filePath',
          'status',
          'notificationDate',
          'percentageResulted',
          'percentageResults',
          'rewardsExported',
          'rewardsNotified',
          'rewardsResulted',
          'rewardsResultedOk',
          'rewardsResults',
        ]
      type: object
      properties:
        feedbackDate:
          type: string
          format: date-time
        filePath:
          type: string
        id:
          type: string
        initiativeId:
          type: string
        initiativeName:
          type: string
        notificationDate:
          type: string
          format: date
        organizationId:
          type: string
        percentageResulted:
          type: string
        percentageResultedOk:
          type: string
        percentageResults:
          type: string
        rewardsExported:
          type: string
        rewardsNotified:
          type: integer
          format: int64
        rewardsResulted:
          type: integer
          format: int64
        rewardsResultedOk:
          type: integer
          format: int64
        rewardsResults:
          type: string
        status:
          type: string
    RewardImportsDTO:
      title: RewardImportsDTO
      type: object
      properties:
        contentLength:
          type: integer
          format: int32
        eTag:
          type: string
        elabDate:
          type: string
          format: date-time
        errorsSize:
          type: integer
          format: int32
        exportIds:
          type: array
          items:
            type: string
        feedbackDate:
          type: string
          format: date-time
        filePath:
          type: string
        initiativeId:
          type: string
        organizationId:
          type: string
        percentageResulted:
          type: string
        percentageResultedOk:
          type: string
        percentageResultedOkElab:
          type: string
        rewardsResulted:
          type: integer
          format: int64
        rewardsResultedError:
          type: integer
          format: int64
        rewardsResultedOk:
          type: integer
          format: int64
        rewardsResultedOkError:
          type: integer
          format: int64
        status:
          type: string
          enum:
            - COMPLETE
            - ERROR
            - IN_PROGRESS
            - WARN
        url:
          type: string
    IbanDTO:
      type: object
      required:
        - iban
        - checkIbanStatus
        - description
        - channel
        - checkIbanResponseDate
      properties:
        iban:
          type: string
        checkIbanStatus:
          type: string
        holderBank:
          type: string
        description:
          type: string
        channel:
          type: string
        checkIbanResponseDate:
          type: string
          format: date-time
    WalletDTO:
      type: object
      required:
        - initiativeId
        - status
        - endDate
        - nInstr
      properties:
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
        lastCounterUpdate:
          type: string
          format: date-time
        iban:
          type: string
        nInstr:
          type: integer
          format: int32
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
        - status
        - activationDate
        - channel
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
        activationDate:
          type: string
          format: date-time
    OperationDTO:
      oneOf:
        - $ref: '#/components/schemas/TransactionDetailDTO'
        - $ref: '#/components/schemas/InstrumentOperationDTO'
        - $ref: '#/components/schemas/IbanOperationDTO'
        - $ref: '#/components/schemas/OnboardingOperationDTO'
        - $ref: '#/components/schemas/RefundOperationDTO'
        - $ref: '#/components/schemas/SuspendOperationDTO'
        - $ref: '#/components/schemas/ReadmittedOperationDTO'
    TimelineDTO:
      type: object
      required:
        - operationList
      properties:
        lastUpdate:
          type: string
          description: date of the last update
          format: date-time
        operationList:
          type: array
          items:
            $ref: '#/components/schemas/OperationListDTO'
          description: the list of transactions and operations of an initiative of a citizen
        pageNo:
          type: integer
          format: int32
        pageSize:
          type: integer
          format: int32
        totalElements:
          type: integer
          format: int32
        totalPages:
          type: integer
          format: int32
    OperationListDTO:
      description: Complex type for items in the operation list
      oneOf:
        - $ref: '#/components/schemas/TransactionOperationDTO'
        - $ref: '#/components/schemas/InstrumentOperationDTO'
        - $ref: '#/components/schemas/RejectedInstrumentOperationDTO'
        - $ref: '#/components/schemas/IbanOperationDTO'
        - $ref: '#/components/schemas/OnboardingOperationDTO'
        - $ref: '#/components/schemas/RefundOperationDTO'
        - $ref: '#/components/schemas/SuspendOperationDTO'
        - $ref: '#/components/schemas/ReadmittedOperationDTO'
    RejectedInstrumentOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
        - brandLogo
        - maskedPan
        - channel
      properties:
        operationId:
          type: string
        operationType:
          enum:
            - REJECTED_ADD_INSTRUMENT
            - REJECTED_DELETE_INSTRUMENT
          type: string
        operationDate:
          type: string
          format: date-time
        brandLogo:
          type: string
        instrumentId:
          type: string
        maskedPan:
          type: string
        channel:
          type: string
    TransactionDetailDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
        - brandLogo
        - maskedPan
        - amount
        - accrued
        - brand
        - idTrxIssuer
        - idTrxAcquirer
      properties:
        operationId:
          type: string
        operationType:
          enum:
            - TRANSACTION
            - REVERSAL
          type: string
        brandLogo:
          type: string
        maskedPan:
          type: string
        amount:
          type: number
        accrued:
          type: number
        operationDate:
          type: string
          format: date-time
        brand:
          type: string
          description: '00-> Bancomat, 01->Visa, 02->Mastercard, 03->Amex, 04->JCB, 05->UnionPay, 06->Diners, 07->PostePay, 08->BancomatPay, 09->Satispay, 10->PrivateCircuit'
        idTrxIssuer:
          type: string
        idTrxAcquirer:
          type: string
    InstrumentOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
        - brandLogo
        - maskedPan
        - channel
      properties:
        operationId:
          type: string
        operationType:
          enum:
            - ADD_INSTRUMENT
            - DELETE_INSTRUMENT
          type: string
        operationDate:
          type: string
          format: date-time
        brandLogo:
          type: string
        maskedPan:
          type: string
        channel:
          type: string
    IbanOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
        - iban
        - channel
      properties:
        operationId:
          type: string
        operationType:
          enum:
            - ADD_IBAN
          type: string
        operationDate:
          type: string
          format: date-time
        iban:
          type: string
        channel:
          type: string
    OnboardingOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
      properties:
        operationId:
          type: string
        operationType:
          enum:
            - ONBOARDING
          type: string
        operationDate:
          type: string
          format: date-time
    RefundOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - eventId
        - operationDate
        - amount
      properties:
        operationId:
          type: string
        eventId:
          type: string
        operationType:
          enum:
            - PAID_REFUND
            - REJECTED_REFUND
          type: string
        operationDate:
          type: string
          format: date
        amount:
          type: number
        accrued:
          type: number
    TransactionOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
        - brandLogo
        - maskedPan
        - amount
        - circuitType
      properties:
        operationId:
          type: string
        operationType:
          enum:
            - TRANSACTION
            - REVERSAL
          type: string
        operationDate:
          type: string
          format: date-time
        brandLogo:
          type: string
        maskedPan:
          type: string
        amount:
          type: number
        accrued:
          type: number
        circuitType:
          type: string
          description: '00-> Bancomat, 01->Visa, 02->Mastercard, 03->Amex, 04->JCB, 05->UnionPay, 06->Diners, 07->PostePay, 08->BancomatPay, 09->Satispay, 10->PrivateCircuit'
    SuspendOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
      properties:
        operationId:
          type: string
        operationType:
          enum:
            - SUSPENDED
          type: string
        operationDate:
          type: string
          format: date-time
    ReadmittedOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
      properties:
        operationId:
          type: string
        operationType:
          enum:
            - READMITTED
          type: string
        operationDate:
          type: string
          format: date-time
    CsvDTO:
      title: CsvDTO
      type: object
      properties:
        data:
          type: string
    ExportSummaryDTO:
      title: ExportSummaryDTO
      type: object
      properties:
        createDate:
          type: string
          format: date
        totalAmount:
          type: number
        totalRefundedAmount:
          type: number
        totalRefunds:
          type: integer
          format: int64
        successPercentage:
          type: string
        status:
          type: string
    ExportListDTO:
      type: object
      properties:
        content:
          type: array
          items:
            $ref: '#/components/schemas/ExportDetailDTO'
        pageNo:
          type: integer
          format: int32
        pageSize:
          type: integer
          format: int32
        totalElements:
          type: integer
          format: int32
        totalPages:
          type: integer
          format: int32
    OnboardingStatusDTO:
      title: OnboardingStatusDTO
      type: object
      required:
        - status
      properties:
        status:
          enum:
            - INVITED
            - ACCEPTED_TC
            - DEMANDED
            - ON_EVALUATION
            - ONBOARDING_KO
            - ELIGIBLE_KO
            - ONBOARDING_OK
            - ELIGIBLE
            - INACTIVE
            - UNSUBSCRIBED
            - SUSPENDED
          type: string
          description: actual status of the citizen onboarding for an initiative
    ExportDetailDTO:
      type: object
      properties:
        iban:
          type: string
        amount:
          type: number
        status:
          type: string
        eventId:
          type: string
    RefundDetailDTO:
      type: object
      properties:
        fiscalCode:
          type: string
        iban:
          type: string
        amount:
          type: number
        startDate:
          type: string
          format: date
        endDate:
          type: string
          format: date
        status:
          type: string
        refundType:
          type: string
        cro:
          type: string
        transferDate:
          type: string
          format: date
        userNotificationDate:
          type: string
          format: date
    FamilyUnitCompositionDTO:
      type: object
      required:
        - usersList
      properties:
        usersList:
          type: array
          items:
            $ref: '#/components/schemas/OnboardingDetailDTO'
          description: The list of family unit composition details
    OnboardingDetailDTO:
      type: object
      required:
        - code
        - message
        - details
      properties:
        fiscalCode:
          type: string
        familyId:
          type: string
        onboardingDate:
          type: string
          format: date
        status:
          enum:
            - INVITED
            - ACCEPTED_TC
            - DEMANDED
            - ON_EVALUATION
            - ONBOARDING_KO
            - ELIGIBLE_KO
            - ONBOARDING_OK
            - ELIGIBLE
            - INACTIVE
            - UNSUBSCRIBED
            - SUSPENDED
          type: string
  securitySchemes:
    Bearer:
      type: apiKey
      name: Authorization
      in: header
security:
  - Bearer: []
tags:
  - name: initiative
    description: ''
