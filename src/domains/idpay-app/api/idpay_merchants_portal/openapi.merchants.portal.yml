openapi: 3.0.1
info:
  title: IDPAY Welfare Portal Merchant API
  description: IDPAY Welfare Portal Merchant
  version: '1.0.1'
servers:
  - url: https://api-io.dev.cstar.pagopa.it/idpay/merchant/portal
paths:
  /initiatives:
    get:
      tags:
        - merchant-initiatives
      summary: Returns the list of initiatives of a specific merchant
      description: Returns the list of initiatives of a specific merchant
      operationId: getMerchantInitiativeList
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                type: array
                items:
                  allOf:
                    - $ref: '#/components/schemas/InitiativeDTO'
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '404':
          description: The merchant ID was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
  /initiatives/{initiativeId}/statistics:
    get:
      tags:
        - merchant-initiative-statistics
      summary: Returns the merchant statistics on the initiative
      description: Returns the merchant statistics on the initiative
      operationId: getMerchantInitiativeStatistics
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
                $ref: '#/components/schemas/MerchantStatisticsDTO'
        '400':
          description: Bad Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '404':
          description: The requested ID was Not Found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
  /transactions:
    post:
      tags:
        - merchant-transactions
      summary: Merchant create transaction
      operationId: createTransaction
      requestBody:
        description: General information about Transaction
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/TransactionCreationRequest'
      responses:
        '201':
          description: Created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionResponse'
        '404':
          description: Transaction not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
  /transactions/{transactionId}:
    delete:
      tags:
        - merchant-transactions
      summary: Merchant delete transaction
      operationId: deleteTransaction
      parameters:
        - name: transactionId
          in: path
          description: The transaction ID
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Ok
        '403':
          description: Merchant not allowed to operate on this transaction
        '404':
          description: Transaction does not exist
        '429':
          description: Too many Request
  /initiatives/{initiativeId}/transactions:
    get:
      tags:
        - merchant-transactions
      summary: Returns the list of in progress transactions associated to a merchant
      description: "ENG: Returns the list of in progress transactions associated to a merchant <br> IT: Ritorna la lista delle transazioni in corso associate ad un esercente"
      operationId: getMerchantTransactions
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
        - name: fiscalCode
          in: query
          description: Fiscal Code
          required: false
          schema:
            type: string
        - name: status
          in: query
          description: Transaction status
          required: false
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MerchantTransactionsListDTO'
        '401':
          description: Autentication failed
        '404':
          description: Merchant not found
        '429':
          description: Too many requests
        '500':
          description: Server error
  /transactions/{transactionId}/confirm:
    put:
      tags:
        - merchant-transactions
      summary: Merchant confirms the payment and the event is notified to IDPay
      operationId: confirmPaymentQRCode
      parameters:
        - name: transactionId
          in: path
          description: Transaction ID
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionResponse'
        '400':
          description: Transaction is not AUTHORIZED
        '403':
          description: Merchant not allowed to operate on this transaction
        '404':
          description: Transaction does not exist
        '429':
          description: Too many Request
        '500':
          description: Server ERROR
  /initiatives/{initiativeId}:
    get:
      tags:
        - merchant-detail
      summary: Returns the merchants detail on initiative
      description: "ENG: Returns the merchant detail on initiative <br> IT: Dettaglio dell' esercente sull'iniziativa"
      operationId: getMerchantDetail
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
                $ref: '#/components/schemas/MerchantDetailDTO'
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
components:
  schemas:
    InitiativeDTO:
      type: object
      properties:
        initiativeId:
          type: string
        initiativeName:
          type: string
        organizationName:
          type: string
        status:
          type: string
          enum:
            - PUBLISHED
            - CLOSED
        startDate:
          type: string
          format: date
        endDate:
          type: string
          format: date
        serviceId:
          type: string
        enabled:
          type: boolean
    MerchantStatisticsDTO:
      type: object
      properties:
        amount:
          type: number
        accrued:
          type: number
        refunded:
          type: number
    MerchantTransactionsListDTO:
      type: object
      required:
        - content
        - pageNo
        - pageSize
        - totalElements
        - totalPages
      properties:
        content:
          type: array
          items:
            $ref: '#/components/schemas/MerchantTransactionDTO'
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
    MerchantTransactionDTO:
      type: object
      required:
        - trxCode
        - trxId
        - effectiveAmount
        - status
      properties:
        trxCode:
          type: string
        trxId:
          type: string
        fiscalCode:
          type: string
        effectiveAmount:
          type: number
        trxDate:
          type: string
          format: date-time
        trxExpirationMinutes:
          type: number
        updateDate:
          type: string
          format: date-time
        status:
          type: string
          enum:
            - CREATED
            - IDENTIFIED
            - AUTHORIZED
            - REJECTED
    MerchantDetailDTO:
      type: object
      properties:
        initiativeId:
          type: string
          description: "ENG: The ID of the initiative <br> IT: L'ID' dell'iniziativa"
        initiativeName:
          type: string
          description: "ENG: The name of the initiative <br> IT: Il nome dell'iniziativa"
        businessName:
          type: string
          description: "ENG: The name of the merchant <br> IT: La ragione sociale dell'esercente"
        legalOfficeAddress:
          type: string
          description: "ENG: The address of the legal office <br> IT: L'indirizzo della sede legale"
        legalOfficeMunicipality:
          type: string
          description: "ENG: The municipality of the legal office <br> IT: Il comune della sede legale"
        legalOfficeProvince:
          type: string
          description: "ENG: The province of the legal office <br> IT: La provincia della sede legale"
        legalOfficeZipCode:
          type: string
          description: "ENG: The zipcode of the legal office <br> IT: Il CAP della sede legale"
        certifiedEmail:
          type: string
          description: "ENG: The certified email address of the merchant <br> IT: L'indirizzo email PEC dell' esercente"
        fiscalCode:
          type: string
          description: "ENG: The fiscal code/vat number of the merchant <br> IT: Il codice fiscale/partita iva dell'esercente"
        vatNumber:
          type: string
          description: "ENG: The vat number of the merchant <br> IT: La partita iva dell'esercente"
        status:
          type: string
          enum:
            - UPLOADED
          description: "ENG: One of the possible merchant onboarding status: <ul><li>UPLOADED:This is the initial status after the csv upload</li></ul>IT: Uno dei possibili stati dell'onboarding da parte dell'esercente: <ul><li>UPLOADED:Questo è lo stato iniziale dopo il caricamento del file csv</li></ul>"
        iban:
          type: string
          description: "ENG: The iban of the merchant <br> IT: L'iban dell'esercente"
        creationDate:
          type: string
          format: date-time
          description: "ENG: Time and date of the initiative creation <br> IT: La data ed ora della creazione dell'iniziativa"
        updateDate:
          type: string
          format: date-time
          description: "ENG: Time and date of the last status update <br> IT: La data ed ora dell'ultimo aggiornamento dello stato"
    TransactionCreationRequest:
      type: object
      required:
        - idTrxIssuer
        - initiativeId
        - trxDate
        - amountCents
      properties:
        initiativeId:
          type: string
        idTrxIssuer:
          type: string
        trxDate:
          type: string
          format: date-time
        amountCents:
          type: integer
          format: int64
        mcc:
          type: string
    TransactionResponse:
      type: object
      required:
        - id
        - trxCode
        - initiativeId
        - merchantId
        - idTrxIssuer
        - idTrxAcquirer
        - trxDate
        - amountCents
        - amountCurrency
        - mcc
        - acquirerId
        - status
      properties:
        id:
          type: string
        trxCode:
          type: string
        initiativeId:
          type: string
        merchantId:
          type: string
        idTrxIssuer:
          type: string
        idTrxAcquirer:
          type: string
        trxDate:
          type: string
          format: date-time
        trxExpirationMinutes:
          type: number
        amountCents:
          type: integer
          format: int64
        amountCurrency:
          type: string
        mcc:
          type: string
        acquirerId:
          type: string
        status:
          type: string
          enum:
            - CREATED
            - IDENTIFIED
            - AUTHORIZED
            - REWARDED
            - REJECTED
        merchantFiscalCode:
          type: string
        vat:
          type: string
        splitPayment:
          type: boolean
        residualAmountCents:
          type: integer
          format: int64
    ErrorDTO:
      type: object
      properties:
        code:
          type: string
        message:
          type: string
  securitySchemes:
    Bearer:
      type: apiKey
      name: Authorization
      in: header
security:
  - Bearer: []
