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
      summary: "ENG: Returns list of Organizations for at least one initiative by each visible to the PagoPA operator - IT: Mostra una lista di enti con almeno un'iniziativa ciascuno visibili all'operatore PagoPA"
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
      summary: "ENG: Returns the list of initiatives names for a specific organization - IT: Mostra una lista di iniziative per uno specifico ente"
      description: "ENG: Returns the list of initiatives names for a specific organization - IT: Mostra una lista di iniziative per uno specifico ente"
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
      summary: "ENG: Return the number of onboarded users and the budget spent (accrued bonus) - IT: Mostra il numero di utenti onboardati ed il budget speso (bonus maturato)"
      operationId: initiativeStatistics
      parameters:
        - name: initiativeId
          in: path
          description: "ENG: The ID of the initiative - IT: L'ID dell'iniziativa"
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
      summary: "ENG: Returns the detail of an active initiative - IT: Mostra il dettaglio di un'iniziativa attiva"
      description: "ENG: Returns the detail of an active initiative - IT: Mostra il dettaglio di un'iniziativa attiva"
      operationId: getInitiativeDetail
      parameters:
        - name: initiativeId
          in: path
          description: "ENG: The ID of the initiative - IT: L'ID dell'iniziativa"
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
      summary: "ENG: Returns the detail of the IBAN associated to the initiative by the citizen - IT: Mostra il dettaglio dell'IBAN associato all'iniziativa dal cittadino"
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
          description: "ENG: The ID of the initiative - IT: L'ID dell'iniziativa"
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
      summary: "ENG: Returns the list of transactions and operations of a citizen on initiative sorted by date (newest->oldest) - IT: Mostra una lista di transazioni ed operazioni di un cittadino su un iniziativa ordinate per data"
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
          description: "ENG: The ID of the initiative - IT: L'ID dell'iniziativa"
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
      summary: "ENG: Returns the detail of a transaction - IT: Mostra il dettaglio di una transazione"
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
          description: "ENG: The ID of the initiative - IT: L'ID dell'iniziativa"
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
      summary: "ENG: Returns the wallet detail of a citizen on an active initiative - IT: Mostra il dettaglio del portafoglio del cittadino su un iniziativa attiva"
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
          description: "ENG: The ID of the initiative - IT: L'ID dell'iniziativa"
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
      summary: "ENG: Returns the list of payment instruments associated to the initiative by the citizen - IT: Lista degli strumenti di pagamento associati dal cittadino sull'iniziativa"
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
          description: "ENG: The ID of the initiative - IT: L'ID dell'iniziativa"
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
      summary: "ENG: Returns the onboardings status - IT: Mostra gli stati dell'onboarding"
      description: "ENG: Returns the onboardings status - IT: Mostra gli stati dell'onboarding"
      operationId: getOnboardingStatus
      parameters:
        - name: initiativeId
          in: path
          description: "ENG: The ID of the initiative - IT: L'ID dell'iniziativa"
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
          description: "ENG: The fiscal code - IT: Il codice fiscale"
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
      summary: "ENG: Returns the actual onboarding status - IT: Mostra lo stato attuale dell'onboarding"
      operationId: getBeneficiaryOnboardingStatus
      parameters:
        - name: Fiscal-Code
          in: header
          schema:
            type: string
          required: true
        - name: initiativeId
          in: path
          description: "ENG: The ID of the initiative - IT: L'ID dell'iniziativa"
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
      summary: "ENG: Return a pageable list of Citizen ranking status for a specific Intiative by using filters - IT: Mostra una lista paginata dello stato dei cittadini in graduatoria utilizzando dei filtri"
      description: "ENG: Return a pageable list of Citizen ranking status for a specific Intiative by using filters - IT: Mostra una lista paginata dello stato dei cittadini in graduatoria utilizzando dei filtri"
      operationId: getInitiativeOnboardingRankingStatusPaged
      parameters:
        - name: initiativeId
          in: path
          description: "ENG: The ID of the initiative - IT: L'ID dell'iniziativa"
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
          description: "ENG: The fiscal code - IT: Il codice fiscale"
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
      summary: "ENG: Return the requested filename containing the list of Citizen ranking status for a specific Intiative - IT: Restitusce un file contenente la lista degli stati dei cittadini in graduatoria per una specifica iniziativa"
      description: "ENG: Return the requested filename containing the list of Citizen ranking status for a specific Intiative - IT: Restitusce un file contenente la lista degli stati dei cittadini in graduatoria per una specifica iniziativa"
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
      summary: "ENG: Return a pageable list of reward exports notification for a specific Initiative by using filters - IT: Mostra una lista paginata di file di rimborsi per la specifica iniziativa usando dei filtri"
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
      summary: "ENG: Return a pageable list of reward imports notification for a specific Initiative by using filters - IT: Mostra una lista paginata di file di esiti su una specifica iniziativa utilizzando dei filtri"
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
      summary: "ENG: Return the requested filename - IT: Restituisce il file richiesto"
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
      summary: "ENG: Get dispositive file errors - IT: Mostra il file degli errori"
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
      summary: "ENG: Get the export summary data - IT: Mostra un resoconto del file di rimborso"
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
      summary: "ENG: Get the refunds list in pages - IT: Mostra la lista dei rimborsi paginata"
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
      summary: "ENG: Return the refund detail - IT: Mostra i dettagli del rimborso"
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
    InitiativeAdditionalDTO:
      type: object
      properties:
        serviceIO:
          type: boolean
          description: "ENG: Indicates that the initiative is on IO - IT: Indica che l'iniziativa viene erogata su IO"
        serviceId:
          type: string
          description: "ENG: The ID of the service - IT: L'ID del servizio"
        serviceName:
          type: string
          description: "ENG: The name of the service - IT: Il nome del servizio"
        serviceScope:
          enum:
            - LOCAL
            - NATIONAL
          type: string
          description: "ENG: The service scope of the initiative - IT: L'area di competenza dell'iniziativa"
        description:
          type: string
          description: "ENG: The description of the service - IT: La descrizione del servizio"
        privacyLink:
          type: string
          description: "ENG: Privacy policy link - IT: Link informativa privacy"
        tcLink:
          type: string
          description: "ENG: T&C clauses link - IT: Link termini e condizioni d'uso"
        channels:
          $ref: '#/components/schemas/ChannelArrayDTO'
        logoFileName:
          type: string
          description: "ENG: The file name of the logo - IT: Il nome file del logo"
        logoURL:
          type: string
          description: "ENG: The URL logo related to the initiative  - IT: L'URL del logo relativo all'iniziativa"
        logoUploadDate:
          type: string
          format: date-time
          description: "ENG: The date-time of logo's upload  - IT: Data-ora dell'inserimento del logo"
    InitiativeGeneralDTO:
      type: object
      properties:
        budget:
          type: number
          description: "ENG: The budget for the initiative - IT: Il budget per l'iniziativa"
        beneficiaryType:
          enum:
            - PF
            - PG
            - NF
          type: string
          description: "ENG: The type of beneficiary able on this initiative - IT: Il tipo di beneficiario abilitato per questa iniziativa"
        familyUnitComposition:
          enum:
            - INPS
            - ANPR
          type: string
          description: "ENG: Family unit composition provided by: INPS: Family unit composition on ISEE, ANPR: Registry family status,  - IT: Composizione del nucleo familiare fornita da: INPS: Nucleo familiare su ISEE, ANPR: Stato di famiglia anagrafica"
        beneficiaryKnown:
          type: boolean
          description: "ENG: Indicates if a list of fiscal code is uploaded or not - IT: Indica se verrà caricata una lista di codifi fiscali conosciuti oppure no"
        beneficiaryBudget:
          type: number
          description: "ENG: The budget for single beneficiary - IT: Budget per singolo beneficiario"
        startDate:
          type: string
          description: "ENG: Start date of the initiative - IT: Data di inizio dell'iniziativa"
          format: date
          example: '2022-01-30'
        endDate:
          type: string
          description: "ENG: End date of the initiative - IT: Data di fine dell'iniziativa"
          format: date
          example: '2022-01-30'
        rankingStartDate:
          type: string
          description: "ENG: Start date of the expenditure related to the initiative - IT: Data di inizio spesa relativa all'iniziativa"
          format: date
          example: '2022-01-30'
        rankingEndDate:
          type: string
          description: "ENG: End date of the expenditure related to the initiative - IT: Data di fine spesa relativa all'iniziativa"
          format: date
          example: '2022-01-30'
        rankingEnabled:
          type: boolean
          description: "ENG: Indicates if the initiative type is with ranking or not - IT: Indica se il tipo di iniziativa è con graduatoria oppure no"
        descriptionMap:
          $ref: '#/components/schemas/DescriptionMap'
    AutomatedCriteriaDTO:
      type: object
      properties:
        authority:
          type: string
          description: "ENG: The organization that provide the information - IT: L'ente che fornisce l'informazione"
        code:
          type: string
          description: "ENG: The code that identify the criteria - IT: Il codice che identifica il criterio"
        field:
          type: string
          description: "ENG: The field that determines onboarding (ex. ISEE) - IT: Il campo che determina l'onboarding (es.ISEE)"
        operator:
          type: string
          description: "ENG: Determines how to take the value: GT: Greater than value, LT: Less than value, EQ: Equal, NOT_EQ: Not equal, GE: Greater equal, LE: Less equal, BTW_OPEN: Between,  - IT: Determina in che modo considerare il valore: GT: Maggiore di value, LT: Minore di value, EQ: Uguale, NOT_EQ: Diverso, GE: Maggiore o uguale, LE: Minore o uguale, BTW_OPEN: Compreso tra"
        value:
          type: string
          description: "ENG: The field's value - IT: Il valore del campo che determina l'onboarding"
        orderDirection:
          type: string
          enum:
            - ASC
            - DESC
          description: "ENG: One of the possible order direction for the initiative criteria: ASC: Ascendent, DESC: Descendent,  - IT: Uno dei possibili ordinamenti dei criteri dell'iniziativa: ASC: Ascendente, DESC: Discendente"
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
          description: "ENG: The possibile ISEE types for the initiative criteria: ORDINARIO, MINORENNE, UNIVERSITARIO, SOCIOSANITARIO, DOTTORATO, RESIDENZIALE, CORRENTE,  - IT: Le possibili tipologie di ISEE per i criteri dell'iniziativa: ORDINARIO, MINORENNE, UNIVERSITARIO, SOCIOSANITARIO, DOTTORATO, RESIDENZIALE, CORRENTE"
    InitiativeDTO:
      type: object
      properties:
        initiativeId:
          type: string
          description: "ENG: The ID of the initiative - IT: L'ID dell'iniziativa"
        initiativeName:
          type: string
          description: "ENG: The name of the initiative - IT: Il nome dell'iniziativa"
        organizationId:
          type: string
          description: "ENG: The ID of the organization - IT: L'ID dell'ente"
        organizationName:
          type: string
          description: "ENG: The name of the organization - IT: Il nome dell'ente"
        creationDate:
          type: string
          format: date-time
          description: "ENG: The date of the initiative creation - IT: La data di creazione dell'iniziativa"
        updateDate:
          type: string
          format: date-time
          description: "ENG: The date of the initiative update - IT: La data di aggiornamento dell'iniziativa"
        status:
          type: string
          description: "ENG: One of the possible status of the initiative: DRAFT, IN_REVISION, APPROVED, PUBLISHED, CLOSED:,  - IT: Uno dei possibili stati in cui si trova l'iniziativa: DRAFT: In bozza, IN_REVISION: In revisione all'ente, APPROVED: Approvata dall'admin, PUBLISHED: Pubblicata dall'ente (in corso), CLOSED: Conclusa"
        autocertificationCheck:
          type: boolean
        beneficiaryRanking:
          type: boolean
          description: "ENG: The citizen position on ranking - IT: La posizione in graduatoria del cittadino"
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
          description: "ENG: One of the possible reward type of the initiative: REFUND, DISCOUNT,  - IT: Una delle possibili tipologie di iniziativa: REFUND: A rimborso, DISCOUNT: A sconto"
        rewardRule:
          $ref: '#/components/schemas/InitiativeRewardRuleDTO'
        trxRule:
          $ref: '#/components/schemas/InitiativeTrxConditionsDTO'
        refundRule:
          $ref: '#/components/schemas/InitiativeRefundRuleDTO'
        isLogoPresent:
          type: boolean
          description: "ENG: Indicates if the logo is present or not - IT: Indica se il logo è presente o meno"
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
          description: "ENG: The ID of the initiative - IT: L'ID dell'iniziativa"
        initiativeName:
          type: string
          description: "ENG: The name of the initiative - IT: Il nome dell'iniziativa"
        status:
          type: string
          description: "ENG: One of the possible status of the initiative: DRAFT, IN_REVISION, APPROVED, PUBLISHED, CLOSED:,  - IT: Uno dei possibili stati in cui si trova l'iniziativa: DRAFT: In bozza, IN_REVISION: In revisione all'ente, APPROVED: Approvata dall'admin, PUBLISHED: Pubblicata dall'ente (in corso), CLOSED: Conclusa"
        creationDate:
          type: string
          format: date-time
          description: "ENG: The date of the initiative creation - IT: La data di creazione dell'iniziativa"
        updateDate:
          type: string
          format: date-time
          description: "ENG: The date of the initiative update - IT: La data di aggiornamento dell'iniziativa"
        rankingEnabled:
          type: boolean
          description: "ENG: Indicates if the initiative type is with ranking or not - IT: Indica se il tipo di iniziativa è con graduatoria oppure no"
    OrganizationListDTO:
      type: array
      items:
        $ref: '#/components/schemas/OrganizationDTO'
    OrganizationDTO:
      type: object
      properties:
        organizationId:
          type: string
          description: "ENG: The ID of the organization - IT: L'ID dell'ente"
        organizationName:
          type: string
          description: "ENG: The name of the organization - IT: Il nome dell'ente"
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
          description: "ENG: One of the possible assistance contact type: web, email, mobile,  - IT: Una delle possibili tipologie di contatto per l'assistenza: web, email, mobile"
        contact:
          type: string
          description: "ENG: The assistance contact - IT: Il contatto di assistenza"
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
          description: "ENG: The api key of client id - IT: L'api key del client id"
        apiKeyClientAssertion:
          type: string
          description: "ENG: The api key of client assertion - IT: L'api key del client assertion"
    SelfCriteriaBoolDTO:
      type: object
      properties:
        _type:
          enum:
            - boolean
          type: string
          description: "ENG: The single choice - IT: Scelta singola"
        description:
          type: string
          description: "ENG: The description's criteria - IT: La descrizione dei criteri"
        value:
          type: boolean
          description: "ENG: A value always true - IT: Un valore sempre true"
        code:
          type: string
          description: "ENG: The index,as string, of citeria - IT: L'indice,come stringa, dei criteri"
    SelfCriteriaMultiDTO:
      title: SelfCriteriaMultiDTO
      type: object
      properties:
        _type:
          enum:
            - multi
          type: string
          description: "ENG: The multiple choice - IT: Scelta multipla"
        description:
          type: string
          description: "ENG: The description's criteria - IT: La descrizione dei criteri"
        value:
          type: array
          items:
            type: string
          example:
            - value1
            - value2
            - value3
          description: "ENG: The possible value condition - IT: Le possibili condizioni per aderire"
        code:
          type: string
          description: "ENG: The index,as string, of citeria - IT: L'indice,come stringa, dei criteri"
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
            description: "ENG: The day of the transaction: MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY,  - IT: Il giorno della transazione: LUNEDÍ, MARTEDÍ, MERCOLEDÍ, GIOVEDÍ, VENERDÍ, SABATO, DOMENICA"
        intervals:
          type: array
          items:
            $ref: '#/components/schemas/Interval'
    InitiativeRewardRuleDTO:
      required:
        - _type
        - rewardValueType
      type: object
      properties:
        _type:
          type: string
          description: "ENG: Return a default string: rewardValue - IT: Restituisce una stringa di default: rewardValue"
        rewardValueType:
          type: string
          enum:
            - PERCENTAGE
            - ABSOLUTE
          description: "ENG: One of the possible reward value type: PERCENTAGE: A percentage amount is rewarded, ABSOLUTE: An absolute amount is rewarded,  - IT: Una delle possibili regole per premiare l'importo: PERCENTAGE: Viene riconosciuta una percentuale, ABSOLUTE: Viene riconosciuto un importo fisso"
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
          description: "ENG: The start time (hours:minutes:seconds.nano) to do transactions - IT: L'orario di inizio (ore:minuti:secondi.nano) per eseguire le transazioni"
          example: '00:16:00.000'
        endTime:
          type: string
          description: "ENG: The end time (hours:minutes:seconds.nano) to do transactions - IT: L'orario di fine (ore:minuti:secondi.nano) per eseguire le transazioni"
          example: '02:00:00.000'
    MccFilterDTO:
      type: object
      properties:
        allowedList:
          type: boolean
          description: "ENG: Merchant category code filter exist or not - IT: Indica se il filtro sul codice categoria dell'esercente esiste o no"
        values:
          uniqueItems: true
          type: array
          items:
            type: string
            description: "ENG: The values of merchant category code - IT: I valori dei codici categoria dell'esercente"
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
          description: "ENG: The frequency to receive a reward - IT: La cadenza temporale per ricevere il premio"
        rewardLimit:
          type: number
          description: "ENG: The max value rewardable - IT: Il valore massimo premiabile"
    ThresholdDTO:
      type: object
      properties:
        from:
          type: number
          description: "ENG: Min spending threshold - IT: Soglia minima di spesa"
        fromIncluded:
          type: boolean
        to:
          type: number
          description: "ENG: Max spending threshold - IT: Soglia massima di spesa"
        toIncluded:
          type: boolean
    TrxCountDTO:
      type: object
      properties:
        from:
          type: integer
          format: int64
          description: "ENG: Min number of transaction to do - IT: Numero minimo di transazioni per poter ricevere il rimborso"
        fromIncluded:
          type: boolean
        to:
          type: integer
          format: int64
          description: "ENG: Max number of transaction rewardable - IT: Numero massimo di transazioni su cui verrà calcolata la percentuale di rimborso"
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
          description: "ENG: One of the possible accumulated type to do refund: BUDGET_EXHAUSTED, THRESHOLD_REACHED,  - IT: Una delle possibili tipologie di importo per erogare il rimborso: BUDGET_EXHAUSTED: Al raggiungimento dell'importo massimo, THRESHOLD_REACHED: Al raggiungimento di un certo importo"
        refundThreshold:
          type: number
          description: "ENG: The threshold to reach - IT: La soglia da raggiungere"
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
          description: "ENG: The frequency to do refund. The possible value is one of these: CLOSED, DAILY, WEEKLY, MONTHLY, QUARTERLY,  - IT: La cadenza temporale per erogare il rimborso. Il valore possibile è uno di questi: CLOSED: Ad iniziativa conclusa, DAILY: Ogni giorno, WEEKLY: Ogni settimana, MONTHLY: Ogni mese, QUARTERLY: Ogni tre mesi"
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
          description: "ENG: The number of the page - IT: Il numero della pagina"
        pageSize:
          type: integer
          format: int32
          description: "ENG: The element size for page - IT: Il numero di elementi per pagina"
        totalElements:
          type: integer
          format: int32
          description: "ENG: The total number of the elements - IT: Il numero totale degli elementi"
        totalPages:
          type: integer
          format: int32
          description: "ENG: The total number of the pages - IT: Il numero totale delle pagine"
    StatusOnboardingDTOS:
      type: object
      properties:
        beneficiary:
          type: string
          description: "ENG: The name of beneficiary - IT: Il nome del beneficiario"
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
          description: "ENG: The onboarding's status of beneficiary - IT: Lo stato dell'onboarding del beneficiario"
        updateStatusDate:
          type: string
          format: date-time
          description: "ENG: The date-time of the status update - IT: La data-ora dell'aggiornamento dello stato"
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
          description: "ENG: The number of the page - IT: Il numero della pagina"
        pageSize:
          type: integer
          format: int32
          description: "ENG: The element size for page - IT: Il numero di elementi per pagina"
        totalElements:
          type: integer
          format: int32
          description: "ENG: The total number of the elements - IT: Il numero totale degli elementi"
        totalPages:
          type: integer
          format: int32
          description: "ENG: The total number of the pages - IT: Il numero totale delle pagine"
        rankingStatus:
          type: string
          description: "ENG: The ranking status - IT: Lo stato della graduatoria"
        rankingPublishedTimestamp:
          type: string
          format: date-time
          description: "ENG: The date-time of the ranking pubblication - IT: La data-ora della pubblicazione della graduatoria"
        rankingGeneratedTimestamp:
          type: string
          format: date-time
          description: "ENG: The date-time of the ranking generation - IT: La data-ora della generazione della graduatoria"
        totalEligibleOk:
          type: integer
          format: int64
          description: "ENG: The number of citizen eligible and included in the ranking - IT: Il numero di cittadini che soddisfano i requisiti e rientrano nella graduatoria"
        totalEligibleKo:
          type: integer
          format: int64
          description: "ENG: The number of citizen eligible but not included in the ranking - IT: Il numero di cittadini che soddisfano i requisiti ma non rientrano nella graduatoria"
        totalOnboardingKo:
          type: integer
          format: int64
          description: "ENG: The number of citizen not eligible for the ranking - IT: Il numero di cittadini che non soddisfano i requisiti"
        rankingFilePath:
          type: string
          description: "ENG: The file path where the ranking is stored - IT: Il path del file dove si trova la graduatoria"
    OnboardingRankingsDTO:
      type: object
      properties:
        beneficiary:
          type: string
          description: "ENG: The citizen - IT: Il cittadino"
        criteriaConsensusTimestamp:
          type: string
          format: date-time
          description: "ENG: The date-time of acceptance criteria - IT: La data-ora di accettazione dei criteri"
        rankingValue:
          type: integer
          format: int64
          description: "ENG: The value that determines the ranking position - IT: Il valore che determina la posizione in graduatoria"
        ranking:
          type: integer
          format: int64
          description: "ENG: The ranking position - IT: La posizione in graduatoria"
        beneficiaryRankingStatus:
          type: string
          description: "ENG: One of the possible beneficiary ranking status: ELIGIBLE_OK: Citizen eligible and included in the ranking, ELIGIBLE_KO: Citizen eligible but not included in the ranking, ONBOARDING_KO: Citizen not eligible for the ranking,  IT: Uno dei possibili stati del cittadino in graduatoria: ELIGIBLE_OK: Cittadini che soddisfano i requisiti e rientrano nella graduatoria, ELIGIBLE_KO: Cittadini che soddisfano i requisiti ma non rientrano nella graduatoria, ONBOARDING_KO: Cittadini che non soddisfano i requisiti"
    RefundAdditionalInfoDTO:
      required:
        - identificationCode
      type: object
      properties:
        identificationCode:
          type: string
          description: "ENG: The identification code - IT: Il codice identificativo"
    InitiativeStatisticsDTO:
      type: object
      properties:
        lastUpdatedDateTime:
          type: string
          format: date-time
          description: "ENG: The last date-time of statistics update - IT: L'ultima data-ora dell'aggiornamento delle statistiche"
        onboardedCitizenCount:
          type: integer
          format: int32
          description: "ENG: The counter of onboarded citizen - IT: Il contatore dei cittadini onboardati"
        accruedRewards:
          type: string
          description: "ENG: The total budget spent (accrued bonus) - IT: Il budget totale speso (bonus maturato)"
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
          description: "ENG: The total number of the elements - IT: Il numero totale degli elementi"
        totalPages:
          type: integer
          format: int32
          description: "ENG: The total number of the pages - IT: Il numero totale delle pagine"
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
          description: "ENG: The total number of the elements - IT: Il numero totale degli elementi"
        totalPages:
          type: integer
          format: int32
          description: "ENG: The total number of the pages - IT: Il numero totale delle pagine"
    DescriptionMap:
      type: object
      description: "ENG: Description of the initiative rules - IT: Descrizione aggiuntiva delle regole dell'iniziativa"
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
          description: "ENG: Date-time of the file's upload - IT: Data-ora di caricamento del file"
        filePath:
          type: string
          description: "ENG: The file path - IT: Il file path"
        id:
          type: string
          description: "ENG: The ID of the export file - IT: L'ID del file di rimborsi"
        initiativeId:
          type: string
          description: "ENG: The ID of the initiative - IT: L'ID dell'iniziativa"
        initiativeName:
          type: string
          description: "ENG: The name of the initiative - IT: Il nome dell'iniziativa"
        notificationDate:
          type: string
          format: date
          description: "ENG: The date oh the notification - IT: La data di notifica"
        organizationId:
          type: string
          description: "ENG: The ID of the organization - IT: L'ID dell'ente"
        percentageResulted:
          type: string
          description: "ENG: The percentage of rewardsResulted compared to rewardNotified, expressed as an integer in cents  - IT: La percentuale del numero dei rimborsi che hanno un esito comparato con quelli notificati, espressa in centesimi"
        percentageResultedOk:
          type: string
          description: "ENG: The percentage of rewardsResultedOk compared to rewardNotified, expressed as an integer in cents  - IT: La percentuale del numero dei rimborsi che hanno un esito positivo comparato con quelli notificati, espressa in centesimi"
        percentageResults:
          type: string
          description: "ENG: The percentage of rewardsResultsCents compared to rewardsExportedCents - IT: La percentuale del totale dei rimborsi con esito positivo in centesimi comparata con il totale dei rimborsi notificati"
        rewardsExported:
          type: string
          description: "ENG: Total of notified rewards in euro - IT: Il totale dei rimborsi notificati in euro"
        rewardsNotified:
          type: integer
          format: int64
          description: "ENG: Number of notified rewards - IT: Il numero di rimborsi notificati"
        rewardsResulted:
          type: integer
          format: int64
          description: "ENG: The number of outcome's rewards - IT: Il numero di rimborsi con un esito"
        rewardsResultedOk:
          type: integer
          format: int64
          description: "ENG: The number of successfull rewards - IT: Il numero di rimborsi con esito positivo"
        rewardsResults:
          type: string
          description: "ENG: Total successful rewards in euro - IT: Il totale dei rimborsi con esito positivo in euro"
        status:
          type: string
          description: "ENG: The status of the export file - IT: Lo stato del file dei rimborsi"
    RewardImportsDTO:
      title: RewardImportsDTO
      type: object
      properties:
        contentLength:
          type: integer
          format: int32
          description: "ENG: ContentLenght of the file's upload event - IT: ContentLength dell’evento di caricamento del file"
        eTag:
          type: string
          description: "ENG: Etag of the file's upload event - IT: Etag dell’evento di caricamento del file"
        elabDate:
          type: string
          format: date-time
          description: "ENG: The date-time of the file elaboration - IT: La data-ora dell'elaborazione del file"
        errorsSize:
          type: integer
          format: int32
          description: "ENG: The size of the error list during the file's elaboration - IT: La grandezza della lista di errori di elaborazione del file"
        exportIds:
          type: array
          items:
            type: string
            description: "ENG: The export files list that the import file refers - IT: La lista di file di rimborsi a cui il file di esiti fa riferimento"
        feedbackDate:
          type: string
          format: date-time
          description: "ENG: Date-time of the file's upload - IT: Data-ora di caricamento del file"
        filePath:
          type: string
          description: "ENG: The file path - IT: Il file path"
        initiativeId:
          type: string
          description: "ENG: The ID of the initiative - IT: L'ID dell'iniziativa"
        organizationId:
          type: string
          description: "ENG: The ID of the organization - IT: L'ID dell'ente"
        percentageResulted:
          type: string
          description: "ENG: The percentage of rewardsResulted compared to rewardNotified. - IT: La percentuale del numero dei rimborsi che hanno un esito comparato con quelli notificati."
        percentageResultedOk:
          type: string
          description: "ENG: The number of successfull rewards - IT: Il numero di rimborsi con esito positivo"
        percentageResultedOkElab:
          type: string
          description: "ENG: The number of successfull and correctly processed rewards compared to the correctly processed rewards, expressed as an integer in cents  - IT: Percentuale del numero di feedback ricevuti con esito positivo e processati correttamente rispetto al totale di feedback processati correttamente, espresso come un intero in centesimi"
        rewardsResulted:
          type: integer
          format: int64
          description: "ENG: The number of outcome's rewards - IT: Il numero di rimborsi con un esito"
        rewardsResultedError:
          type: integer
          format: int64
          description: "ENG: The number of outcome's rewards with an error - IT: Numero di record del file il cui processamento ha comportato un errore"
        rewardsResultedOk:
          type: integer
          format: int64
          description: "ENG: The number of successfull rewards - IT: Il numero di rimborsi con esito positivo"
        rewardsResultedOkError:
          type: integer
          format: int64
          description: "ENG: The number of successfull rewards with an error - IT: Numero di mandate con esito positivo andate in errore"
        status:
          type: string
          enum:
            - COMPLETE
            - ERROR
            - IN_PROGRESS
            - WARN
          description: "ENG: One of the possible status: IN PROGRESS, WARN: If the elaboration of at least one of the record is an error, ERROR, COMPLETE,  - IT: Uno dei possibili stati: IN PROGRESS: Se in fase di elaborazione, WARN: Se l’elaborazione di almeno un record si è risolta con un errore, ERROR: Se l’intero file non è stato elaborato a causa di un errore, COMPLETE: Se l’elaborazione è stata completata con successo"
        url:
          type: string
          description: "ENG: Url of the file in the blob - IT: Url verso il file nel blob"
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
          description: "ENG: IBAN of the citizen - IT: IBAN del cittadino"
        checkIbanStatus:
          type: string
          description: "ENG: Check of the IBAN status- IT: Check dello stato dell'IBAN"
        holderBank:
          type: string
          description: "ENG: The name of the holder bank - IT: Il nome della banca titolare"
        description:
          type: string
          description: "ENG: The account description - IT: La descrizione del conto"
        channel:
          type: string
          description: "ENG: Is the operation's channel: ISSUER: third parties channel, APP_IO,  - IT: È il canale da cui proviene l'operazione: ISSUER: canale di terze parti, APP_IO"
        checkIbanResponseDate:
          type: string
          format: date-time
          description: "ENG: The date-time of check iban - IT: La data-ora del check iban"
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
          description: "ENG: The Id of the initiative - IT: L'ID dell'iniziativa"
        initiativeName:
          type: string
          description: "ENG: The name of the initiative - IT: Il nome dell'iniziativa"
        status:
          enum:
            - NOT_REFUNDABLE_ONLY_IBAN
            - NOT_REFUNDABLE_ONLY_INSTRUMENT
            - REFUNDABLE
            - NOT_REFUNDABLE
            - UNSUBSCRIBED
            - SUSPENDED
          type: string
          description: "ENG: Actual status of the citizen wallet for an initiative:-NOT_REFUNDABLE: the beneficiary has neither IBAN nor Payment Instrument associated to the initiative, NOT_REFUNDABLE_ONLY_IBAN: the beneficiary has an IBAN, but no Payment Instrument associated to the initiative, NOT_REFUNDABLE_ONLY_INSTRUMENT: the beneficiary has at least one Payment Instrument, but no IBAN associated to the initiative, REFUNDABLE: the beneficiary has both IBAN and Payment Instrument associated to the initiative, SUSPENDED: the beneficiary has been suspended from the initiative, UNSUBSCRIBED: the beneficiary is unsubribed from the initiative,  - IT: Stato attuale del portafoglio di un cittadino su una iniziativa:-NOT_REFUNDABLE: Il beneficiario non ha IBAN né Strumenti di Pagamento associati all’iniziativa, NOT_REFUNDABLE_ONLY_IBAN: Il beneficiario ha un IBAN, ma non ha alcuno Strumento di Pagamento associato all’iniziativa, NOT_REFUNDABLE_ONLY_INSTRUMENT: Il beneficiario ha almeno uno Strumento di Pagamento, ma non ha alcun IBAN associato all’iniziativa, REFUNDABLE: Il beneficiario ha sia un IBAN che almeno uno Strumento di Pagamento associato all’iniziativa, SUSPENDED: il beneficiario è stato sospeso dall'iniziativa, UNSUBSCRIBED: il beneficiario ha fatto il recesso dall'iniziativa"
        endDate:
          type: string
          format: date
          description: "ENG: End date of the initiative - IT: Data del termine dell’iniziativa"
        amount:
          type: number
          description: "ENG: Available balance: the maximum benefit net of all accrued benefits - IT: Saldo disponibile, ovvero il BENEFICIO/CAP MASSIMO previsto per quella iniziativa al netto di eventuali BENEFICI MATURATI"
        accrued:
          type: number
          description: "ENG: Accrued benefits - IT: Benefici maturati"
        refunded:
          type: number
          description: "ENG: Refunded benefits - IT: Beneficio rimborsato"
        lastCounterUpdate:
          type: string
          format: date-time
          description: "ENG: Last date of update of accrued/refunded benefits - IT: Ultima data dell’aggiornamento dei benefici maturati/rimborsati"
        iban:
          type: string
          description: "ENG: IBAN associated to the initiative - IT: IBAN associato all'iniziativa"
        nInstr:
          type: integer
          format: int32
          description: "ENG: Number of Payment Instruments associated to the initiative - IT: Numero di strumenti di pagamento associati all'iniziativa"
    InstrumentListDTO:
      type: object
      required:
        - instrumentList
      properties:
        instrumentList:
          type: array
          items:
            $ref: '#/components/schemas/InstrumentDTO'
          description: "ENG: The list of payment instruments associated to the initiative by the citizen - IT: Lista degli strumenti di pagamento associati dal cittadino sull'iniziativa"
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
          description: "ENG: Wallet's ID provided by the Payment manager - IT: Wallet ID provveduto dal Payment manager"
        instrumentId:
          type: string
          description: "ENG: Payment instrument ID - IT: ID dello strumento di pagamento"
        maskedPan:
          type: string
          description: "ENG: Masked Pan of the payment instrument - IT: Numero Pan della carta oscurato"
        channel:
          type: string
          description: "ENG: Is the operation's channel: ISSUER: third parties channel, APP_IO,  - IT: È il canale da cui proviene l'operazione: ISSUER: canale di terze parti, APP_IO"
        brandLogo:
          type: string
          description: "ENG: The logo card's brand as mastercard, visa, etc. - IT: Il logo del brand della carta: mastercard, visa, ecc."
        status:
          enum:
            - ACTIVE
            - PENDING_ENROLLMENT_REQUEST
            - PENDING_DEACTIVATION_REQUEST
          type: string
          description: "ENG: One of the possible status of the instrument: ACTIVE: active instrument, PENDING_ENROLLMENT_REQUEST: the instrument enrollment request is in pending, PENDING_DEACTIVATION_REQUEST: the instrument deactivation request is in pending,  - IT: Uno dei possibili stati dello strumento di pagamento: ACTIVE: strumento di pagamento attivo , PENDING_ENROLLMENT_REQUEST: L'aggiunta dello strumento di pagamento è in attesa, PENDING_DEACTIVATION_REQUEST: La disattivazione dello strumento di pagamento è in attesa"
        activationDate:
          type: string
          format: date-time
          description: "ENG: The instrument activation date - IT: La data di attivazione dello strumento di pagamento"
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
          description: "ENG: The date of the last update - IT: La data dell'ultimo aggiornamento"
          format: date-time
        operationList:
          type: array
          items:
            $ref: '#/components/schemas/OperationListDTO'
          description: "ENG: The list of transactions and operations of citizen on initiative - IT: La lista delle transazioni ed operazioni di un cittadino su un iniziativa"
        pageNo:
          type: integer
          format: int32
          description: "ENG: The number of the page - IT: Il numero della pagina"
        pageSize:
          type: integer
          format: int32
          description: "ENG: The element size for page - IT: Il numero di elementi per pagina"
        totalElements:
          type: integer
          format: int32
          description: "ENG: The total number of the elements - IT: Il numero totale degli elementi"
        totalPages:
          type: integer
          format: int32
          description: "ENG: The total number of the pages - IT: Il numero totale delle pagine"
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
          description: "ENG: The ID of the operation - IT: L'ID dell'operazione"
        operationType:
          enum:
            - REJECTED_ADD_INSTRUMENT
            - REJECTED_DELETE_INSTRUMENT
          type: string
          description: "ENG: Indicates one of the possible operation type: REJECTED_ADD_INSTRUMENT, REJECTED_DELETE_INSTRUMENT,  - IT: Indica uno dei possibili tipi di operazione: REJECTED_ADD_INSTRUMENT: Aggiunta dello strumento rifiutata, REJECTED_DELETE_INSTRUMENT: Cancellazione dello strumento rifiutata"
        operationDate:
          type: string
          format: date-time
          description: "ENG: The date-time of the operation - IT: La data-ora dell'operazione"
        brandLogo:
          type: string
          description: "ENG: The logo card's brand as mastercard, visa, etc. - IT: Il logo del brand della carta: mastercard, visa, ecc."
        instrumentId:
          type: string
          description: "ENG: Payment instrument ID - IT: ID dello strumento di pagamento"
        maskedPan:
          type: string
          description: "ENG: Masked Pan of the payment instrument - IT: Numero Pan della carta oscurato"
        channel:
          type: string
          description: "ENG: Is the operation's channel: ISSUER: third parties channel, APP_IO,  - IT: È il canale da cui proviene l'operazione: ISSUER: canale di terze parti, APP_IO"
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
          description: "ENG: The ID of the operation - IT: L'ID dell'operazione"
        operationType:
          enum:
            - TRANSACTION
            - REVERSAL
          type: string
          description: "ENG: Indicates one of the possible operation type: TRANSACTION, REVERSAL,  - IT: Indica uno dei possibili tipi di operazione: TRANSACTION: Transazione, REVERSAL: Storno"
        brandLogo:
          type: string
          description: "ENG: The logo card's brand as mastercard, visa, etc. - IT: Il logo del brand della carta: mastercard, visa, ecc."
        maskedPan:
          type: string
          description: "ENG: Masked Pan of the payment instrument - IT: Numero Pan della carta oscurato"
        amount:
          type: number
          description: "ENG: The amount of transaction - IT: Il totale della transazione"
        accrued:
          type: number
          description: "ENG: Accrued benefits - IT: Benefici maturati"
        operationDate:
          type: string
          format: date-time
          description: "ENG: The date-time of the operation - IT: La data-ora dell'operazione"
        brand:
          type: string
          description: "ENG: 00-> Bancomat, 01->Visa, 02->Mastercard, 03->Amex, 04->JCB, 05->UnionPay, 06->Diners, 07->PostePay, 08->BancomatPay, 09->Satispay, 10->PrivateCircuit - IT: 00-> Bancomat, 01->Visa, 02->Mastercard, 03->Amex, 04->JCB, 05->UnionPay, 06->Diners, 07->PostePay, 08->BancomatPay, 09->Satispay, 10->PrivateCircuit"
        idTrxIssuer:
          type: string
          description: "ENG: - IT:"
        idTrxAcquirer:
          type: string
          description: "ENG: - IT:"
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
          description: "ENG: The ID of the operation - IT: L'ID dell'operazione"
        operationType:
          enum:
            - ADD_INSTRUMENT
            - DELETE_INSTRUMENT
          type: string
          description: "ENG: One of the possible operation type: ADD_INSTRUMENT, DELETE_INSTRUMENT,  - IT: Uno dei possibili tipi di operazione: ADD_INSTRUMENT, DELETE_INSTRUMENT"
        operationDate:
          type: string
          format: date-time
          description: "ENG: The date-time of the operation - IT: La data-ora dell'operazione"
        brandLogo:
          type: string
          description: "ENG: The logo card's brand as mastercard, visa, etc. - IT: Il logo del brand della carta: mastercard, visa, ecc."
        maskedPan:
          type: string
          description: "ENG: Masked Pan of the payment instrument - IT: Numero Pan della carta oscurato"
        channel:
          type: string
          description: "ENG: Is the operation's channel: ISSUER: third parties channel, APP_IO,  - IT: È il canale da cui proviene l'operazione: ISSUER: canale di terze parti, APP_IO"
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
          description: "ENG: The ID of the operation - IT: L'ID dell'operazione"
        operationType:
          enum:
            - ADD_IBAN
          type: string
          description: "ENG: One of the possible operation type: ADD_IBAN,  - IT: Uno dei possibili tipi di operazione: ADD_IBAN"
        operationDate:
          type: string
          format: date-time
          description: "ENG: The date-time of the operation - IT: La data-ora dell'operazione"
        iban:
          type: string
          description: "ENG: IBAN of the citizen - IT: IBAN del cittadino"
        channel:
          type: string
          description: "ENG: Is the operation's channel: ISSUER: third parties channel, APP_IO,  - IT: È il canale da cui proviene l'operazione: ISSUER: canale di terze parti, APP_IO"
    OnboardingOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
      properties:
        operationId:
          type: string
          description: "ENG: The ID of the operation - IT: L'ID dell'operazione"
        operationType:
          enum:
            - ONBOARDING
          type: string
          description: "ENG: One of the possible operation type: ONBOARDING,  - IT: Uno dei possibili tipi di operazione: ONBOARDING"
        operationDate:
          type: string
          format: date-time
          description: "ENG: The date-time of the operation - IT: La data-ora dell'operazione"
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
          description: "ENG: The ID of the operation - IT: L'ID dell'operazione"
        eventId:
          type: string
          description: "ENG: The ID of the event - IT: L'ID dell'evento"
        operationType:
          enum:
            - PAID_REFUND
            - REJECTED_REFUND
          type: string
          description: "ENG: One of the possible operation type: PAID_REFUND, REJECTED_REFUND,  - IT: Uno dei possibili tipi di operazione: PAID_REFUND: Rimborso pagato, REJECTED_REFUND: Rimborso rifiutato"
        operationDate:
          type: string
          format: date
          description: "ENG: The date-time of the operation - IT: La data-ora dell'operazione"
        amount:
          type: number
          description: "ENG: The amount of the refund - IT: Il totale del rimborso"
        accrued:
          type: number
          description: "ENG: Accrued benefits - IT: Benefici maturati"
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
          description: "ENG: The ID of the operation - IT: L'ID dell'operazione"
        operationType:
          enum:
            - TRANSACTION
            - REVERSAL
          type: string
          description: "ENG: Indicates one of the possible operation type: TRANSACTION, REVERSAL,  - IT: Indica uno dei possibili tipi di operazione: TRANSACTION: Transazione, REVERSAL: Storno"
        operationDate:
          type: string
          format: date-time
          description: "ENG: The date-time of the operation - IT: La data-ora dell'operazione"
        brandLogo:
          type: string
          description: "ENG: The logo card's brand as mastercard, visa, etc. - IT: Il logo del brand della carta: mastercard, visa, ecc."
        maskedPan:
          type: string
          description: "ENG: Masked Pan of the payment instrument - IT: Numero Pan della carta oscurato"
        amount:
          type: number
          description: "ENG: The amount of transaction - IT: Il totale della transazione"
        accrued:
          type: number
          description: "ENG: Accrued benefits - IT: Benefici maturati"
        circuitType:
          type: string
          description: "ENG: 00-> Bancomat, 01->Visa, 02->Mastercard, 03->Amex, 04->JCB, 05->UnionPay, 06->Diners, 07->PostePay, 08->BancomatPay, 09->Satispay, 10->PrivateCircuit - IT: 00-> Bancomat, 01->Visa, 02->Mastercard, 03->Amex, 04->JCB, 05->UnionPay, 06->Diners, 07->PostePay, 08->BancomatPay, 09->Satispay, 10->PrivateCircuit"
    SuspendOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
      properties:
        operationId:
          type: string
          description: "ENG: The ID of the operation - IT: L'ID dell'operazione"
        operationType:
          enum:
            - SUSPENDED
          type: string
          description: "ENG: Indicates one of the possible operation type: SUSPENDED,  - IT: Indica uno dei possibili tipi di operazione: SUSPENDED"
        operationDate:
          type: string
          format: date-time
          description: "ENG: The date-time of the operation - IT: La data-ora dell'operazione"
    ReadmittedOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
      properties:
        operationId:
          type: string
          description: "ENG: The ID of the operation - IT: L'ID dell'operazione"
        operationType:
          enum:
            - READMITTED
          type: string
          description: "ENG: Indicates one of the possible operation type: READMITTED - IT: Indica uno dei possibili tipi di operazione: READMITTED"
        operationDate:
          type: string
          format: date-time
          description: "ENG: The date-time of the operation - IT: La data-ora dell'operazione"
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
          description: "ENG: The creation date of the refund file - IT: La data di creazione del file dei rimborsi"
        totalAmount:
          type: number
          description: "ENG: The total of rewards present in the file - IT: Il totale dei premi presenti nel file"
        totalRefundedAmount:
          type: number
          description: "ENG: The total of the rewards refunded present in the file - IT: Il totale dei premi rimborsati presenti nel file"
        totalRefunds:
          type: integer
          format: int64
          description: "ENG: The number of total refunds - IT: Il numero totale dei rimborsi presenti"
        successPercentage:
          type: string
          description: "ENG: The success percentage of the refunds - IT: La percentuale di successo dei rimborsi"
        status:
          type: string
          description: "ENG: One of the possible status: EXPORTED, PARTIAL, COMPLETE - IT: Uno dei possibili stati: EXPORTED: Al momento della creazione del file, PARTIAL: Se non si hanno tutti gli esiti, COMPLETE: Se tutte le richieste sono state ricevute"
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
          description: "ENG: The number of the page - IT: Il numero della pagina"
        pageSize:
          type: integer
          format: int32
          description: "ENG: The element size for page - IT: Il numero di elementi per pagina"
        totalElements:
          type: integer
          format: int32
          description: "ENG: The total number of the elements - IT: Il numero totale degli elementi"
        totalPages:
          type: integer
          format: int32
          description: "ENG: The total number of the pages - IT: Il numero totale delle pagine"
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
          description: "ENG: The actual status for the onboarding's citizen. The possible status is one of these: INVITED, ACCEPTED_TC, DEMANDED, ON_EVALUATION, ONBOARDING_KO, ELIGIBLE_KO, ONBOARDING_OK, ELIGIBLE, INACTIVE, UNSUBSCRIBED, SUSPENDED,  - IT: Lo stato attuale dell'onboarding in cui si trova il cittadino. Lo stato può essere uno di questi: INVITED, ACCEPTED_TC, DEMANDED, ON_EVALUATION, ONBOARDING_KO, ELIGIBLE_KO, ONBOARDING_OK, ELIGIBLE, INACTIVE, UNSUBSCRIBED, SUSPENDED"
    ExportDetailDTO:
      type: object
      properties:
        iban:
          type: string
          description: "ENG: IBAN of the citizen - IT: IBAN del cittadino"
        amount:
          type: number
          description: "ENG: The amount of refund - IT: Il totale del rimborso"
        status:
          type: string
          description: "ENG: One of the possible status: RECOVERED, EXPORTED, COMPLETED_OK, COMPLETED_KO - IT: Uno dei possibili stati: RECOVERED: Se in precedenza era un completed_ko ma è stato recuperato, EXPORTED: Se correttamente esportato nel csv da affidare all’ente, COMPLETED_OK: Se si è avuto riscontro positivo, COMPLETED_KO: Se si è avuto riscontro negativo, eventuali dettagli nel campo rejection_reason"
        eventId:
          type: string
          description: "ENG: The ID of the event - IT: L'ID dell'evento"
    RefundDetailDTO:
      type: object
      properties:
        fiscalCode:
          type: string
          description: "ENG: The fiscal code of the citizen - IT: Il codice fiscale del cittadino"
        iban:
          type: string
          description: "ENG: IBAN of the citizen - IT: IBAN del cittadino"
        amount:
          type: number
          description: "ENG: The amount of refund - IT: Il totale del rimborso"
        startDate:
          type: string
          format: date
          description: "ENG: The start date of the refund's reference period - IT: La data di inizio del periodo di riferimento del rimborso"
        endDate:
          type: string
          format: date
          description: "ENG: The end date of the refund's reference period - IT: La data di fine del periodo di riferimento del rimborso"
        status:
          type: string
          description: "ENG: One of the possible status: RECOVERED, EXPORTED, COMPLETED_OK, COMPLETED_KO - IT: Uno dei possibili stati: RECOVERED: Se in precedenza era un completed_ko ma è stato recuperato, EXPORTED: Se correttamente esportato nel csv da affidare all’ente, COMPLETED_OK: Se si è avuto riscontro positivo, COMPLETED_KO: Se si è avuto riscontro negativo, eventuali dettagli nel campo rejection_reason"
        refundType:
          type: string
          description: "ENG: One of the possible type: ORDINARY, REMEDIAL - IT: Una delle possibili tipologie: ORDINARY, REMEDIAL: Quando un ordinary va ko e viene recuperato"
        cro:
          type: string
          description: "ENG: CRO = Codice di Riferimento dell'Operazione - IT: CRO = Codice di Riferimento dell'Operazione"
        transferDate:
          type: string
          format: date
          description: "ENG: The date of refund's sending by the organization - IT: La data di invio del rimborso da parte dell'ente"
        userNotificationDate:
          type: string
          format: date
          description: "ENG: The date of the notification to user - IT: La data di notifica all'utente"
  securitySchemes:
    Bearer:
      type: apiKey
      name: Authorization
      in: header
security:
  - Bearer: []
