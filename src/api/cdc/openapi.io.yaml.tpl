openapi: 3.0.0
info:
  title: Carta della Cultutra REST APIs
  description: API to request Carta della Cultura
  version: 0.0.1
servers:
- url: ${host}

paths:
  /beneficiario/stato:
    get:
      summary: Lettura stato beneficiario per ogni anno
      operationId: getStatoBeneficiario
      responses:
        "200":
          description: Stato Beneficiario per Anno
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ListaStatoPerAnno'
        "404": 
          description: Risorsa non trovata
        "401":
          description: Utente non autorizzato
        "403": 
          description: Utente non loggato
        "500":
          description: Errore interno.
      # JWT Token (RSA+256)
      security:
        - BearerAuth: []

  /beneficiario/registrazione:
    post:
      tags:
      - /secured/utente
      summary: 'Richiesta Carta della Cultura da parte del beneficiario'
      operationId: registraBeneficiario
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/AnniRiferimento'
      responses:
        "200":
          description: Richiesta OK per almeno un anno
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ListaEsitoRichiestaPerAnno'
        "400":
          description: Validazioni non superate
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/RichiestaCartaErrata'
        "404": 
          description: Risorsa non esiste
        "401":
          description: Utente non autorizzato
        "403":
          description: Utente non loggato
        "500":
          description: Errore interno.
      # JWT Token (RSA+256)
      security:
        - BearerAuth: []
  

components:
  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
  schemas:
    StatoBeneficiario:
      type: string
      enum: 
        - ATTVABILE
        - INATTIVABILE 
        - ATTIVO # carta richiesta e risposta ok da INPS
        - VALUTAZIONE # carta richiesta ma non si conosce la risposta da INPS
        - INATTIVO # carta richiesta e risposta negativa da INPS
    EsitoRichiesta:
      type: string
      enum: 
        - INIZIATIVA_TERMINATA
        - ANNO_NON_AMMISSIBILE
        - CIT_REGISTRATO
        - OK
    Anno: 
      type: string 
      pattern: '^\\d{4}$'
      description: Anno a quattro cifre
      example: "2000"
    AnnoIsee:
      type: object
      required:
        - anno
      properties: 
        anno:
          $ref: '#/components/schemas/Anno'
        dataIsee:
          type: string
    RichiestaCartaErrataMotivo: #Il payload della POST non può essere processato
      type: string
      enum: 
        - NO_INPUT
        - ANNI_RIFERIMENTO_NON_FORNITI
        - LISTA_ANNI_VUOTA
        - FORMATO_ANNI_ERRATO
    RichiestaCartaErrata:
      type: object
      required:
        - annoRiferimento
        - status
      properties:
        type:
          type: string
        annoRiferimento:
          $ref: '#/components/schemas/Anno'
        title:
          type: string
        status:
          $ref: '#/components/schemas/RichiestaCartaErrataMotivo'
        detail:
          type: string
        instance:
          type: string
        errorCode:
          type: string
    StatoBeneficiarioPerAnno:
      type: object
      required:
        - statoBeneficiario
        - annoRiferimento
      properties:
        statoBeneficiario:
          $ref: '#/components/schemas/StatoBeneficiario'
        annoRiferimento:
          $ref: '#/components/schemas/Anno'
    EsitoRichiestaPerAnno:
      type: object
      required:
        - esitoRichiesta
        - annoRiferimento
      properties:
        esitoRichiesta:
          $ref: '#/components/schemas/EsitoRichiesta'
        annoRiferimento:
          $ref: '#/components/schemas/Anno'
    ListaStatoPerAnno:
      type: object
      required:
        - listaStatoPerAnno
      properties:
        listaStatoPerAnno:
          type: array
          items:
            $ref: '#/components/schemas/StatoBeneficiarioPerAnno'
    ListaEsitoRichiestaPerAnno:
      type: object
      required:
        - listaEsitoRichiestaPerAnno
      properties:
        listaEsitoRichiestaPerAnno:
          type: array
          items:
            $ref: '#/components/schemas/EsitoRichiestaPerAnno'
    AnniRiferimento:
      type: object
      required:
        - anniRif
      properties:
        anniRif:
          type: array
          items:
            $ref: '#/components/schemas/AnnoIsee'