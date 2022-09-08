openapi: 3.0.0
info:
  title: Carta della Cultutra REST APIs
  description: API to request Carta della Cultura
  version: 0.0.1
servers:
  - url: ${host}

tags:
  - name: Fase 2

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

  /carte/:
    get:
      tags:
        - Fase 2
      summary: "Liste delle carte della cultura per il beneficiario"
      operationId: getCards
      responses:
        "200":
          description: Liste delle carte, vuota se non ha carte attive
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/CartaDellaCultura'
        "401":
          description: Utente non autorizzaato
        "403":
          description: Utente non loggato
        "500":
          description: Errore interno
      security:
        - BearerAuth: []

  /carte/{annoCarta}:
    get:
      tags:
        - Fase 2
      summary: "Dettaglio della carta specificata"
      parameters: &idcard_path_param
        - in: path
          name: annoCarta
          required: true
          schema:
            $ref: '#/components/schemas/AnnoCarta'
          description: "Anno della Carta della Cultura"
      responses:
        "200":
          description: "Dettaglio carta della cultura"
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CartaDellaCultura'
        "401":
          description: Utente non autorizzaato
        "403":
          description: Utente non loggato
        "404":
          description: Carta non trovata
        "500":
          description: Errore interno
      security:
        - BearerAuth: []

  #    delete:
  #      tags:
  #        - Fase 2
  #      summary: "Cancella l'iscrizione per la carta della cultura specificata."
  #      operationId: revokeCard
  #      parameters:
  #        *idcard_path_param
  #      responses:
  #        "200":
  #          description: Cancellazione effettuata con successo
  #        "401":
  #          description: Utente non autorizzaato
  #        "403":
  #          description: Utente non loggato
  #        "404":
  #          description: Carta non trovata
  #        "500":
  #          description: Errore interno
  #      security:
  #        - BearerAuth: []

  /carte/{annoCarta}/buoni:
    get:
      tags:
        - Fase 2
      summary: |
        Ritorna la lista di buoni creati con la carta specificata.
        Supporta la paginazione basata su chiave (key-based) utilizzando come chiave l'id del prossimo buono da ottenere.
      operationId: getVouchersOfCard
      parameters:
        - in: path
          name: annoCarta
          required: true
          schema:
            $ref: '#/components/schemas/AnnoCarta'
          description: "Anno della Carta della Cultura"
        - in: query
          name: since_id
          required: false
          schema:
            $ref: '#/components/schemas/IdBuono'
          description: Id del buono da cui partire per creare la pagina
        - in: query
          name: limit
          required: false
          description: "Dimensione della pagina. Il valore massimo consentito è 10."
          example: 3
          schema:
            type: integer
            minimum: 1
            maximum: 10
      responses:
        "200":
          description: Lista dei voucher generati dalla carta specificata
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/BuonoPagina'
        "404":
          description: Carta della cultura non trovata
        "401":
          description: Utente non autorizzaato
        "403":
          description: Utente non loggato
        "500":
          description: Errore interno
      security:
        - BearerAuth: []

    post:
      tags:
        - Fase 2
      summary: "Genera un nuovo buono a partire dalla carta specificata"
      operationId: generateVoucher
      parameters:
        - in: path
          name: annoCarta
          required: true
          schema:
            $ref: '#/components/schemas/AnnoCarta'
      requestBody:
        description:  |
          È necessario specificare il valore del buono e una lista di carte da cui generare il buono. La liste di carte può essere rappresentata dagli anni di riferimento delle carte o dagli id specifici delle carte.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CrezioneBuono'

      responses:
        "200":
          description: Buono generato
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/BuonoDettaglio'
        "400":
          description: Richiesta malformata.
        "401":
          description: Utente non autorizzaato
        "403":
          description: Utente non loggato
        "422":
          description: Saldo disponibile insufficiente
        "500":
          description: Errore interno
      security:
        - BearerAuth: []

  /buoni/{codiceBuono}:
    get:
      tags:
        - Fase 2
      summary: "Dettaglio di un buono specifico"
      parameters:
        - in: path
          name: codiceBuono
          description: "Codice del buono"
          required: true
          schema:
            $ref: '#/components/schemas/IdBuono'
      responses:
        "200":
          description: |
            Dettaglio del buono. L'esercente su cui è stato speso il buono, non è valorizzato se lo stato è DISPONIBILE, analogamente la dataSpesa.
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/BuonoDettaglio'
        "404":
          description: Buono non trovato
        "401":
          description: Utente non autorizzaato
        "403":
          description: Utente non loggato
        "500":
          description: Errore interno
      security:
        - BearerAuth: []

    delete:
      tags:
        - Fase 2
      summary: "Revoca un buono"
      parameters:
        - in: path
          name: codiceBuono
          description: "Codice del buono"
          required: true
          schema:
            $ref: '#/components/schemas/IdBuono'
      responses:
        "200":
          description: "Buono revocato con successo"
        "404":
          description: Buono non trovato
        "401":
          description: Utente non autorizzaato
        "403":
          description: Utente non loggato
        "500":
          description: Errore interno
      security:
        - BearerAuth: []
  
  /esercenti/:
    get:
      tags:
        - Fase 2
      summary: |
        Ritorna la lista degli esercenti in base ai filtri.
          - se la tipologia è FISICO il comune è obbligatorio
      parameters:
        - in: query
          name: tipo
          required: true
          schema:
            $ref: '#/components/schemas/TipoEsercente'
          description: "La tipologia di esercente da usare come filtro"
        - in: query
          name: since_id
          required: false
          schema:
            $ref: '#/components/schemas/Id'
          description: Id dell'esercente da cui creare la pagina
        - in: query
          name: nome
          required: false
          description: "Nome dell'esercente da ricercare"
          schema:
            type: string
            example: "La feltrinelli"
        - in: query
          name: comune
          required: false
          description: "Nome del comune su cui cercare"
          schema:
            type: string
            example: "Roma"
        - in: query
          name: limit
          required: false
          description: "Dimensione della pagina. Il valore massimo consentito è 20."
          example: 3
          schema:
            type: integer
            minimum: 1
            maximum: 20
      responses:
        "200":
          description: 'Ritorna la lista degli esercenti con riferimento alla pagina successiva.'
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/EsercentiPage'
        "400":
          description: Richiesta malformata. E.g. tipo di negozio errato o mancante nei query params.
        "401":
          description: Utente non autorizzaato
        "403":
          description: Utente non loggato
        "500":
          description: Errore interno
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
        - ATTIVABILE
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
        - INPUT_SUPERIORE_AL_CONSENTITO
    RichiestaCartaErrata:
      type: object
      required:
        - status
      properties:
        type:
          type: string
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

    StatoBuono:
      type: string
      enum:
        - DISPONIBILE
        - SPESO
        - CANCELLATO
      description: "Lo stato del buono. DISPONIBILE quando il buono è stato generato ma non ancora speso, altrimenti diventa SPESO."

    Buono:
      type: object
      properties:
        codice: &voucher_id
          $ref: '#/components/schemas/IdBuono'
        valore: &voucher_value
          type: number
          example: 33.0
          description: "Valore del buono in euro"
        stato: &voucher_status
          $ref: '#/components/schemas/StatoBuono'
        dataCreazione: &voucher_creation_date
          description: "Data creazione del buono in formato ISO 8601"
          $ref: '#/components/schemas/DateISO8601'


    BuonoDettaglio:
      type: object
      properties:
        valore: *voucher_value
        stato: *voucher_status
        dataCreazione: *voucher_creation_date
        dataSpesa:
          description: "Data spesa del buono in formato ISO 8601"
          $ref: '#/components/schemas/DateISO8601'
        codice: *voucher_id
        annoCarta:
          $ref: '#/components/schemas/AnnoCarta'
        esercente:
          $ref: '#/components/schemas/EsercenteBuono'
        qrCode:
          $ref: '#/components/schemas/QRCode'
        barCode:
          $ref: '#/components/schemas/BarCode'

    BuonoPagina:
      type: object
      properties:
        buoni:
          type: array
          items:
            $ref: '#/components/schemas/Buono'
        prossimo:
          $ref: '#/components/schemas/IdBuono'

    CartaDellaCultura:
      type: object
      properties:
        annoRiferimento:
          $ref: '#/components/schemas/Anno'
        scadenza:
          $ref: '#/components/schemas/DateISO8601'
        saldoDisponibile:
          type: number
          description: "Saldo disponibile per la creazioni di buoni"
          example: 100.0
        saldoPrenotato:
          type: number
          example: 53.4
          description: |
            Saldo prenotato dalla creazione di buoni. I buoni non ancora spesi (DISPONIBILE) contribuiscono al saldoPrenotato. In particolare la somma dei buoni disponibili rappresentano il saldo prenotato.
        beneficiari:
          type: array
          items:
            $ref: '#/components/schemas/Beneficiario'

    CrezioneBuono:
      type: object
      properties:
        valore:
          type: number
          example: 33
          description: "Valore dell'importo del buono da generare"
      required:
        - carte
        - valore

    Id:
      type: string
      format: uuid
      example: 403ca3e4-cd96-4f9b-847e-71bf221bfc0b


    TipoEsercente:
      type: string
      enum:
        - FISICO
        - ONLINE
    EsercenteBuono:
      type: object
      properties:
        id:
          $ref: '#/components/schemas/Id'
        nome:
          type: string
          example: "La Feltrinelli"
        tipo:
          $ref: '#/components/schemas/TipoEsercente'

    Esercente:
      type: object
      properties:
        id:
          $ref: '#/components/schemas/Id'
        nome:
          type: string
          example: "La Feltrinelli"
        tipo:
          $ref: '#/components/schemas/TipoEsercente'
        indirizzo:
          type: string
          example: "Viale Regina Margherita, 12, 00121, Roma"
        website:
          type: string
          example: "www.amazon.it"

    Beneficiario:
      type: object
      properties:
        nome:
          type: string
          example: "Mario"
        cognome:
          type: string
          example: "Rossi"
        codiceFiscale:
          type: string
          example: "RSSMRA80D42A123U"

    IdBuono:
      type: integer
      example: 123456789

    AnnoCarta:
      $ref: '#/components/schemas/Anno'

    EsercentiPage:
      type: object
      properties:
        esercenti:
          type: array
          items:
            $ref: '#/components/schemas/Esercente'
        prossimo:
          $ref: '#/components/schemas/Id'

    DateISO8601:
      type: string
      format: date-time
      example: "2022-06-22T11:19:45.000Z"

    QRCode: &qr_code
      description: Immagine del qrcode codificata in base64
      type: object
      properties:
        mime_type:
          description: Formato dell'immagine codificata
          type: string
          enum:
            - image/png
          example:
            image/png
        content:
          description: Rappresentazione base64 dell'immagine
          type: string
          example: >-
            PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyMyAyMyI+PHBhdGggZmlsbD0iYmxhY2siIGQ9Ik0xIDFoN3Y3aC03ek05IDFoMXYxaC0xek0xMSAxaDJ2MWgtMXYxaC0ydi0xaDF6TTE1IDFoN3Y3aC03ek0yIDJ2NWg1di01ek0xNiAydjVoNXYtNXpNMyAzaDN2M2gtM3pNOSAzaDF2MWgtMXpNMTIgM2gxdjJoMXY0aC0xdi0yaC0xdjNoLTF2MWgxdi0xaDF2MWgxdjFoLTF2MWgydi0xaDF2MmgtNHYtMmgtMXYxaC0xdi0yaC0xdi0xaDF2LTFoMXYtMmgtMXYxaC0xdi0yaDF2LTJoMnpNMTcgM2gzdjNoLTN6TTEgOWgxdjFoLTF6TTMgOWgxdjFoLTF6TTcgOWgydjFoLTJ6TTE2IDloMXYxaC0xek0xOSA5aDF2MWgtMXpNMjEgOWgxdjJoLTJ2LTFoMXpNNCAxMGgydjFoLTF2MWgtMXpNMTQgMTBoMnYxaC0yek0xIDExaDJ2MWgtMXYxaDF2LTFoMXYxaDF2LTFoMXYtMWgzdjFoLTJ2MWgtMXYxaC01ek0xNyAxMWgxdjFoMXYxaDF2MmgtMXYtMWgtMXYtMWgtMXpNMTkgMTFoMXYxaC0xek0yMCAxMmgydjZoLTF2LTJoLTF2LTFoMXYtMmgtMXpNNyAxM2gxdjFoLTF6TTkgMTNoMXYzaC0xek0xNiAxNGgydjFoLTF2MWgtM3YtMWgyek0xIDE1aDd2N2gtN3pNMTEgMTVoMXYxaC0xek0xOCAxNWgxdjFoLTF6TTIgMTZ2NWg1di01ek0xMyAxNmgxdjFoLTF6TTE5IDE2aDF2MWgtMXpNMyAxN2gzdjNoLTN6TTExIDE3aDF2MWgtMXpNMTQgMTdoNXYxaC0xdjNoLTF2LTFoLTF2LTFoLTF2MWgxdjJoLTR2LTFoLTJ2LTFoMXYtMWgxdi0xaDF2MWgxek0xMCAxOGgxdjFoLTF6TTE5IDE4aDF2MWgtMXpNOSAxOWgxdjFoLTF6TTIwIDE5aDJ2M2gtM3YtMWgydi0xaC0xek0xMyAyMHYxaDF2LTF6TTkgMjFoMXYxaC0xeiIvPjwvc3ZnPg==
      required:
        - mime_type
        - content

    BarCode:
      description: Immagine del barcode codificata in base64
      type: object
      properties:
        mime_type:
          description: Formato dell'immagine codificata
          type: string
          enum:
            - image/png
          example:
            image/png
        content:
          description: Rappresentazione base64 dell'immagine
          type: string
          example: >-
            PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyMyAyMyI+PHBhdGggZmlsbD0iYmxhY2siIGQ9Ik0xIDFoN3Y3aC03ek05IDFoMXYxaC0xek0xMSAxaDJ2MWgtMXYxaC0ydi0xaDF6TTE1IDFoN3Y3aC03ek0yIDJ2NWg1di01ek0xNiAydjVoNXYtNXpNMyAzaDN2M2gtM3pNOSAzaDF2MWgtMXpNMTIgM2gxdjJoMXY0aC0xdi0yaC0xdjNoLTF2MWgxdi0xaDF2MWgxdjFoLTF2MWgydi0xaDF2MmgtNHYtMmgtMXYxaC0xdi0yaC0xdi0xaDF2LTFoMXYtMmgtMXYxaC0xdi0yaDF2LTJoMnpNMTcgM2gzdjNoLTN6TTEgOWgxdjFoLTF6TTMgOWgxdjFoLTF6TTcgOWgydjFoLTJ6TTE2IDloMXYxaC0xek0xOSA5aDF2MWgtMXpNMjEgOWgxdjJoLTJ2LTFoMXpNNCAxMGgydjFoLTF2MWgtMXpNMTQgMTBoMnYxaC0yek0xIDExaDJ2MWgtMXYxaDF2LTFoMXYxaDF2LTFoMXYtMWgzdjFoLTJ2MWgtMXYxaC01ek0xNyAxMWgxdjFoMXYxaDF2MmgtMXYtMWgtMXYtMWgtMXpNMTkgMTFoMXYxaC0xek0yMCAxMmgydjZoLTF2LTJoLTF2LTFoMXYtMmgtMXpNNyAxM2gxdjFoLTF6TTkgMTNoMXYzaC0xek0xNiAxNGgydjFoLTF2MWgtM3YtMWgyek0xIDE1aDd2N2gtN3pNMTEgMTVoMXYxaC0xek0xOCAxNWgxdjFoLTF6TTIgMTZ2NWg1di01ek0xMyAxNmgxdjFoLTF6TTE5IDE2aDF2MWgtMXpNMyAxN2gzdjNoLTN6TTExIDE3aDF2MWgtMXpNMTQgMTdoNXYxaC0xdjNoLTF2LTFoLTF2LTFoLTF2MWgxdjJoLTR2LTFoLTJ2LTFoMXYtMWgxdi0xaDF2MWgxek0xMCAxOGgxdjFoLTF6TTE5IDE4aDF2MWgtMXpNOSAxOWgxdjFoLTF6TTIwIDE5aDJ2M2gtM3YtMWgydi0xaC0xek0xMyAyMHYxaDF2LTF6TTkgMjFoMXYxaC0xeiIvPjwvc3ZnPg==
      required:
        - mime_type
        - content