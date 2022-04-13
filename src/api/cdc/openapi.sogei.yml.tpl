openapi: 3.0.0
info:
  title: Liberty REST APIs
  description: Discover REST APIs available within Liberty
  version: 1.0.0
servers:
- url: ${host}
tags:
- name: unsecured
  description: metodi di utilità
- name: /secured/utente
  description: metodi inerenti all'utente
paths:
  /CDCUtenteWS/rest/secured/beneficiario/registrazione:
    post:
      tags:
      - /secured/utente
      summary: 'Prima registrazione del beneficiario sul db '
      operationId: registraBeneficiario
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/InputBeneficiarioBean'
      responses:
        "200":
          description: Tutto OK
        "400":
          description: Validazioni non superate
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ProblemBean'
        "401":
          description: Utente non autorizzato
        "403":
          description: Utente non loggato
        "500":
          description: Errore interno.
  /CDCUtenteWS/rest/unsecured/versione:
    get:
      tags:
      - unsecured
      responses:
        default:
          description: Default response
          content:
            text/plain: {}
  /CDCUtenteWS/rest/unsecured/finestraRegistrazione:
    get:
      tags:
      - unsecured
      summary: Restituisce la finestra temporale per la registrazione utente
      operationId: finestraRegistrazione
      responses:
        "200":
          description: Tutto OK
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/FinestraRegistrazioneBean'
        "400":
          description: Validazioni non superate
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ProblemBean'
        "500":
          description: Errore interno.
components:
  schemas:
    FinestraRegistrazioneBean:
      type: object
      properties:
        dataInizio:
          type: string
          format: date
        dataFine:
          type: string
          format: date
        valida:
          type: boolean
    ProblemBean:
      type: object
      properties:
        type:
          type: string
        title:
          type: string
        status:
          type: integer
          format: int32
        detail:
          type: string
        instance:
          type: string
        errorCode:
          type: string
    InputBeneficiarioBean:
      type: object
      properties:
        anniRif:
          type: array
          items:
            type: string
