openapi: 3.0.1
info:
  title: IDPAY Welfare Portal Merchant API
  description: IDPAY Welfare Portal Merchant
  version: '1.0'
servers:
  - url: https://api-io.dev.cstar.pagopa.it/idpay/merchant
paths:
  /initiative/{initiativeId}/upload:
    put:
      tags:
        - merchant-upload
      summary: Upload CSV file containing a list of merchants
      description: "ENG: Upload CSV file containing a list of merchants <br> IT: Caricamento del file CSV conentente una lista di esercenti"
      operationId: uploadMerchantList
      parameters:
      - name: initiativeId
        in: path
        description: The initiative ID
        required: true
        schema:
          type: string
      requestBody:
        content:
          multipart/form-data:
            schema:
              required:
              - file
              type: object
              properties:
                file:
                  type: string
                  format: binary
      responses:
        "200":
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MerchantUpdateDTO'
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
        '409':
          description: Conflict
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorDTO'
        '422':
          description: Unprocessable Entity
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
        - merchant-onboarding
      summary: Returns the merchants list
      description: "ENG: Returns the merchants list <br> IT: Lista degli esercenti"
      operationId: getMerchantsOnboardingList
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
        - name: fiscalCode
          in: query
          description: Fiscal Code
          required: false
          schema:
            type: string
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MerchantOnboardingDTO'
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
  /initiatives:
    get:
      summary: Returns the list of initiatives of a specific merchant
      description: Returns the list of initiatives of a specific merchant
      operationId: getMerchantInitiativeList
      parameters:
        - name: merchantId
          in: header
          schema:
            type: string
          required: true
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
components:
  schemas:
    MerchantUpdateDTO:
      type: object
      properties:
        status:
          type: string
          description: "ENG: Upload file status <br>IT: Stato di caricamento del file"
        errorRow:
          type: integer
          format: int32
          description: "ENG: Row where an error occurs during file uploading <br>IT: Riga alla quale c'è stato un errore durante il caricamento del file"
        errorKey:
          type: string
          description: "ENG: Error Key: <ul><li>merchant.invalid.file.format: file format not valid</li><li>merchant.invalid.file.empty: empty file</li><li>merchant.invalid.file.size: file size exceeds limit</li><li>merchant.invalid.file.vat.wrong: VAT Number or fiscal code not valid</li><li>merchant.invalid.file.iban.wrong: IBAN not valid</li></ul><br>IT: Chiave di errore: <ul><li>merchant.invalid.file.format: formato del file non valido</li><li>merchant.invalid.file.empty: file vuoto</li><li>merchant.invalid.file.size: la dimensione del file supera il limite consentito</li><li>merchant.invalid.file.vat.wrong: partita IVA o CF non valido</li><li>merchant.invalid.file.iban.wrong: IBAN non valido</li></ul>"
        elabTimeStamp:
          type: string
          format: date-time
          description: "ENG: Time and date of file elaboration <br>IT: Data e ora dell'elaborazione del file"
    MerchantOnboardingDTO:
      type: object
      properties:
        content:
          type: array
          items:
            $ref: '#/components/schemas/MerchantOnboardingStatusDTO'
        pageNo:
          type: integer
          format: int32
          description: "ENG: The number of the page <br> IT: Il numero della pagina"
        pageSize:
          type: integer
          format: int32
          description: "ENG: The element size for page <br> IT: Il numero di elementi per pagina"
        totalElements:
          type: integer
          format: int32
          description: "ENG: The total number of the elements <br> IT: Il numero totale degli elementi"
        totalPages:
          type: integer
          format: int32
          description: "ENG: The total number of the pages <br> IT: Il numero totale delle pagine"
    MerchantOnboardingStatusDTO:
      type: object
      properties:
        merchantId:
          type: string
          description: "ENG: The ID of the merchant <br> IT: L'ID' dell'esercente"
        businessName:
          type: string
          description: "ENG: The name of the merchant <br> IT: La ragione sociale dell'esercente"
        fiscalCode:
          type: string
          description: "ENG: The fiscal code/vat number of the merchant <br> IT: Il codice fiscale/partita iva dell'esercente"
        merchantStatus:
          type: string
          enum:
            - UPLOADED
          description: "ENG: One of the possible merchant onboarding status: <ul><li>UPLOADED:This is the initial status after the csv upload</li></ul>IT: Uno dei possibili stati dell'onboarding da parte dell'esercente: <ul><li>UPLOADED:Questo è lo stato iniziale dopo il caricamento del file csv</li></ul>"
        updateStatusDate:
          type: string
          format: date-time
          description: "ENG: Time and date of the last status update <br> IT: La data ed ora dell'ultimo aggiornamento dello stato"
    InitiativeDTO:
      type: object
      properties:
        initiativeId:
          type: string
        initiativeName:
          type: string
        merchantStatus:
          type: string
        creationDate:
          type: string
          format: date-time
        updateDate:
          type: string
          format: date-time
        enabled:
          type: boolean
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
