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
  /initiative/{initiativeId}/merchants:
    get:
      tags:
        - merchant-list
      summary: Returns the merchants list
      description: "ENG: Returns the merchants list <br> IT: Lista degli esercenti"
      operationId: getMerchantList
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
                $ref: '#/components/schemas/MerchantListDTO'
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
  /{merchantId}/initiative/{initiativeId}:
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
        - name: merchantId
          in: path
          description: The merchant ID
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
    MerchantListDTO:
      type: object
      properties:
        content:
          type: array
          items:
            $ref: '#/components/schemas/MerchantDTO'
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
    MerchantDTO:
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
    ErrorDTO:
      type: object
      properties:
        code:
          type: string
        message:
          type: string
    MerchantDetailDTO:
      type: object
      properties:
        initiativeId:
          type: string
          description: "ENG: The ID of the initiative <br> IT: L'ID' dell'iniziativa"
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
  securitySchemes:
    Bearer:
      type: apiKey
      name: Authorization
      in: header
security:
  - Bearer: []
