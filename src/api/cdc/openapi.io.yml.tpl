openapi: 3.0.0
info:
  title: Carta della Cultutra REST APIs
  description: API to request Carta della Cultura
  version: 0.0.1
servers:
  - url: ${host}

tags:
  - name: Fase 2
    description: N.B. Id


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

  /carte/{carta}:
    get:
      tags:
        - Fase 2
      summary: "Dettaglio della carta specificata"
      parameters: &idcard_path_param
        - in: path
          name: carta
          required: true
          schema:
            $ref: '#/components/schemas/IdCarta'
          description: "Id o Anno della Carta della Cultura"
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

    delete:
      tags:
        - Fase 2
      summary: "Cancella l'iscrizione per la carta della cultura specificata. N.B. Non elimina la registazione dell'intera iniziativa"
      operationId: revokeCard
      parameters:
        *idcard_path_param
      responses:
        "200":
          description: Cancellazione effettuata con successo
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

  /carte/{carta}/buoni:
    get:
      tags:
        - Fase 2
      summary: |
        Ritorna la lista di buoni creati con la carta specificata.
        Supporta la paginazione basata su chiave (key-based) utilizzando come chiave
        la data di creazione dei buoni.
      operationId: getVouchersOfCard
      parameters:
        - in: path
          name: carta
          required: true
          schema:
            $ref: '#/components/schemas/IdCarta'
          description: "Id o Anno della Carta della Cultura"
        - in: query
          name: since_data_creazione
          required: false
          schema:
            $ref: '#/components/schemas/DateISO8601'
          description: |
            Data di creazione dell'ultimo buono della pagina. Funge da chiaave per key-based pagination. La data DEVE essere formattata secondo ISO 8601.
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
        *idcard_path_param
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ValoreBuono'
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


  /buoni/{idBuono}:
    get:
      tags:
        - Fase 2
      summary: "Dettaglio di un buono specifico"
      parameters:
        - in: path
          name: idBuono
          description: "Id del buono"
          required: true
          schema:
            $ref: '#/components/schemas/Id'
      responses:
        "200":
          description: "Dettaglio del buono. L'esercente su cui è stato speso il buono, non è valorizzato se lo stato è DISPONIBILE, analogamente la dataSpesa"
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
          name: idBuono
          description: "Id del buono"
          required: true
          schema:
            $ref: '#/components/schemas/Id'
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
      summary: Ritorna la lista degli esercenti disponibili
      parameters:
        - in: query
          name: tipo
          required: false
          schema:
            $ref: '#/components/schemas/TipoEsercente'
        - in: query
          name: offset
          required: false
          description: "Offset per la paginazione"
          schema:
            type: integer
            example: 1
        - in: query
          name: limit
          required: false
          description: "Numero massimi di elementi per la pagina"
          schema:
            type: integer
            example: 10
            maximum: 10
            minimum: 1
      responses:
        "200":
          description: "Lista degli esercenti"
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PageEsercenti'
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
      description: "Lo stato del buono. DISPONIBILE quando il buono è stato generato ma non ancora speso, altrimenti diventa SPESO."

    Buono:
      type: object
      properties:
        id: &voucher_id
          $ref: '#/components/schemas/Id'
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
        id: *voucher_id
        valore: *voucher_value
        stato: *voucher_status
        dataCreazione: *voucher_creation_date
        dataSpesa:
          description: "Data spesa del buono in formato ISO 8601"
          $ref: '#/components/schemas/DateISO8601'
        code:
          type: number
          example: 1234567890
          description: "Codice univoco del buono"
        qrCode:
          type: string
          example: "qr code payload"
          description: "QrCode"
        barCode:
          type: string
          example: "bar code payload"
          description: "BarCode"
        esercente:
          $ref: '#/components/schemas/Esercente'

    BuonoPagina:
      type: object
      properties:
        buoni:
          type: array
          items:
            $ref: '#/components/schemas/Buono'
        prossimo:
          $ref: '#/components/schemas/DateISO8601'

    CartaDellaCultura:
      type: object
      properties:
        id:
          $ref: '#/components/schemas/Id'
        annoRiferimento:
          $ref: '#/components/schemas/Anno'
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

    ValoreBuono:
      type: object
      properties:
        valore:
          type: number
          example: 33
          description: "Valore dell'importo del buono da generare"

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

    TipoEsercente:
      type: string
      enum:
        - ONLINE
        - FISICO

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

    PageEsercenti:
      type: object
      properties:
        esercenti:
          type: array
          items:
            $ref: '#/components/schemas/Esercente'
        prossimoOffset:
          type: integer


    IdCarta:
      oneOf:
        - $ref: '#/components/schemas/Id'
        - $ref: '#/components/schemas/Anno'

    Id:
      type: string
      format: uuid
      example: 961acd44-d578-4fc0-b28b-c0c900c13131

    DateISO8601:
      type: string
      format: date-time
      example: "2022-06-22T11:19:45.000Z"