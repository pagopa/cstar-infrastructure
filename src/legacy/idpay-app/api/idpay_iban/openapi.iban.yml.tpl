openapi: 3.0.1
info:
  title: IDPAY Iban IO API
  description: IDPAY IBAN IO
  version: '1.0'
servers:
  - url: https://api-io.dev.cstar.pagopa.it/idpay/iban
paths:
  '/{iban}':
    get:
      tags:
        - iban
      summary: "ENG: Returns the details of the IBAN associated to the initiative by the citizen - IT: Ritorna i dettagli di un IBAN associato ad una iniziativa"
      operationId: getIban
      parameters:
        - name: Accept-Language
          in: header
          description: "ENG: Language - IT: Lingua"
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: iban
          in: path
          description: "ENG: The citizen IBAN - IT: IBAN del cittadino"
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
        '404':
          description: The requested ID was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/IbanErrorDTO'
              example:
                code: "IBAN_NOT_FOUND"
                message: "Iban not found"
        '429':
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/IbanErrorDTO'
              example:
                code: "IBAN_TOO_MANY_REQUESTS"
                message: "Too many requests"
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/IbanErrorDTO'
              example:
                code: "IBAN_GENERIC_ERROR"
                message: "Application error"
  '/':
    get:
      tags:
        - iban
      summary: "ENG: Returns the list of IBAN associated to the citizen - IT: Ritorna la lista di IBAN associati ad un cittadino"
      operationId: getIbanList
      parameters:
        - name: Accept-Language
          in: header
          description: "ENG: Language - IT: Lingua"
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
                $ref: '#/components/schemas/IbanListDTO'
        '401':
          description: Authentication failed
        '429':
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/IbanErrorDTO'
              example:
                code: "IBAN_TOO_MANY_REQUESTS"
                message: "Too many requests"
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/IbanErrorDTO'
              example:
                code: "IBAN_GENERIC_ERROR"
                message: "Application error"
components:
  schemas:
    IbanDTO:
      type: object
      required:
        - iban
        - checkIbanStatus
        - description
        - channel
      properties:
        iban:
          type: string
          description: "ENG: IBAN of the citizen - IT: IBAN del cittadino"
        checkIbanStatus:
          type: string
          description: "ENG: Status of checkIban - IT: Stato del checkIban"
        holderBank:
          type: string
          description: "ENG: Holder Bank name - IT: Nome della banca"
        description:
          type: string
          description: "ENG: General description associated with the iban - IT: Descrizione generale associata alll'IBAN"
        channel:
          type: string
          description: "ENG: Channel from which the IBAN has been inserted - IT: Canale da cui l'IBAN è stato inserito"
    IbanListDTO:
      type: object
      required:
        - ibanList
      properties:
        ibanList:
          type: array
          items:
            $ref: '#/components/schemas/IbanDTO'
          description: "ENG: The list of IBAN associated to a citizen - IT: Lista di IBAN associati ad un cittadino"
    IbanErrorDTO:
      type: object
      required:
        - code
        - message
      properties:
        code:
          type: string
          enum:
            - IBAN_NOT_FOUND
            - IBAN_INVALID_REQUEST
            - IBAN_TOO_MANY_REQUESTS
            - IBAN_GENERIC_ERROR
          description: >-
            "ENG: Error code: IBAN_NOT_FOUND: Iban not found,
             IBAN_INVALID_REQUEST: Something went wrong handling request,
             IBAN_TOO_MANY_REQUESTS: Too many requests,
             IBAN_GENERIC_ERROR: Application Error - IT: Codice di errore:
             IBAN_NOT_FOUND: Iban non trovato,
             IBAN_INVALID_REQUEST: Qualcosa è andato storto durante l'invio della richiesta,
             IBAN_TOO_MANY_REQUESTS: Troppe richieste,
             IBAN_GENERIC_ERROR: Errore generico"
        message:
          type: string
          description: "ENG: Error message - IT: Messaggio di errore"
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
security:
  - bearerAuth: [ ]
tags:
  - name: iban
    description: ''
