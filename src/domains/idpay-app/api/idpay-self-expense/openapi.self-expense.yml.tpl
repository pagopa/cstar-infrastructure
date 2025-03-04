openapi: 3.0.1
info:
  title: IDPAY Self Expense IO API v2
  description: IDPAY Self Expense IO
  version: '2.0'

servers:
  - url: https://api-io.dev.cstar.pagopa.it/idpay/self-expense

tags:
  - name: WebView
    description: 'WebView IO'
  - name: Operations
    description: 'Operations IO'
paths:

 '/login':
    get:
      tags:
        - WebView
      summary: >-
          ENG: Redirect to IO Authorization API - IT: Rediret verso l'API di autorizzazione di IO
      operationId: login
      security: []
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
        '302':
          description: "Redirezione al deep link generato con l'header 'Location' accodando clientId, redirect_uri e state"
          headers:
            Location:
              description: "Deeplink url generated"
              schema:
                type: string
                format: uri
                maxLength: 2048
                pattern: "^(https?|ftp):\\/\\/[a-zA-Z0-9.-]+(:[0-9]+)?(\\/[a-zA-Z0-9._~!$&'()*+,;=:@%-]*)*(\\?[a-zA-Z0-9._~!$&'()*+,;=:@%/?-]*)?(#[a-zA-Z0-9._~!$&'()*+,;=:@%/?-]*)?$"
                example: "https://oauth.io.pagopa.it/authorize?client_id=clientId1                            q          &response_type=code&scope=openid&20profile&redirect_uri=/idpay/self-expense/redirect&state=state1"
        '500':
          description: Internal Server Error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SelfPaymentErrorDTO'
              example:
                code: "LOGIN_FAIL"
                message: "Login failed due to unknown error"

 '/redirect':
    get:
      tags:
        - WebView
      summary: >-
             ENG: Redirect to webview url with sessionId - IT: Rediret verso l'url della webview con il sessionId
      operationId: getRedirect
      security: []
      parameters:
        - name: Accept-Language
          in: header
          description: 'ENG: Language - IT: Lingua'
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: code
          in: query
          description: 'ENG: AppIO AuthCode- IT: AuthCode di AppIo'
          required: true
          schema:
            type: string
            example: 1234
        - name: state
          in: query
          description: 'ENG: state generated from client - IT: state generato dal client'
          required: true
          schema:
            type: string
            example: 8bab3eb1-5323-416c-b8e2-daf0ecd08541-1738169548-PodId
      responses:
        '302':
          description: "Redirezione al link della webView con l'header 'Location' accodando il sessionId"
          headers:
            Location:
              description: "WebView url redirect"
              schema:
                type: string
                format: uri
                maxLength: 2048
                pattern: "^(https?|ftp):\\/\\/[a-zA-Z0-9.-]+(:[0-9]+)?(\\/[a-zA-Z0-9._~!$&'()*+,;=:@%-]*)*(\\?[a-zA-Z0-9._~!$&'()*+,;=:@%/?-]*)?(#[a-zA-Z0-9._~!$&'()*+,;=:@%/?-]*)?$"
                example: "https://example.pagopa.it/session/sessionId1"
        '404':
          description: State not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SelfPaymentErrorDTO'
              example:
                code: "STATE_NOT_FOUND"
                message: "State not found"
        '500':
          description: Internal Server Error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SelfPaymentErrorDTO'
              example:
                code: "TOKEN_VALIDATION"
                message: "Token validation failed, possibly due to expiration or tampering"

 '/session/{sessionId}':
    get:
      tags:
        - WebView
      summary: >-
        ENG: Return mil-auth accessToken by sessionId - IT: Restituisce il mil-auth accessToken mediante il sessionId
      operationId: session
      security: []
      parameters:
        - name: Accept-Language
          in: header
          description: 'ENG: Language - IT: Lingua'
          schema:
            type: string
            example: it-IT
            default: it-IT
          required: true
        - name: sessionId
          in: path
          description: 'ENG: Session identifier - IT: Identificativo della sessione'
          required: true
          schema:
            type: string
            example: a8b1f5c3-3b9c-4d90-8f9a-ec2a5b673de9-pod-1234-1675062377884
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MilAuthAccessTokenDTO'
        '404':
          description: Session not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SelfPaymentErrorDTO'
              example:
                code: "SESSION_NOT_FOUND"
                message: "The session could not be found or does not exist"
        '500':
          description: Internal Server Error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SelfPaymentErrorDTO'
              example:
                code: "SESSION_FAIL"
                message: "Session error, unable to authenticate user"


 '/get-child':
    get:
      tags:
        - Operations
      summary: >-
        ENG: Return child list of the parent - IT: Restituisce la lista di figli del genitore
      operationId: getChildForUserId
      security:
      - bearerAuth: []
      parameters:
        - name: Accept-Language
          in: header
          description: 'ENG: Language - IT: Lingua'
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
                $ref: '#/components/schemas/ChildResponseDTO'
        '404':
          description: ANPR info not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SelfPaymentErrorDTO'
              example:
                code: "ANPR_INFO_NOT_FOUND"
                message: "Anpr info could not be found."
        '500':
          description: Internal Server Error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SelfPaymentErrorDTO'
              example:
                code: "SESSION_FAIL"
                message: "Session error, unable to authenticate user"

 '/save-expense-data':
    post:
      tags:
        - Operations
      summary: >-
        ENG: Save expense data - IT:Salvataggio dei dati di spesa
      operationId: saveExpenseData
      security:
       - bearerAuth: []
      requestBody:
         required: true
         content:
           multipart/form-data:
             schema:
               type: object
               properties:
                 files:
                   type: array
                   items:
                     type: string
                     format: binary
                   description: Multiple PDF files associated with the expense
                 expenseData:
                  $ref: '#/components/schemas/ExpenseDataDTO'

      responses:
          '200':
            description: Ok
          '500':
            description: Internal Server Error
            content:
              application/json:
                schema:
                  $ref: '#/components/schemas/SelfPaymentErrorDTO'
                example:
                  code: EXPENSE_DATA_ERROR_DB_SAVE
                  message: Error on save into DB expense_data document

components:
  schemas:

    MilAuthAccessTokenDTO:
        type: object
        properties:
          access_token:
            type: string
            description: "Il token di accesso fornito dal servizio di autenticazione"
            example: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5ceyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5ceyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
          token_type:
            type: string
            description: "Il tipo di token (es. Bearer)"
            example: Bearer
          expires_in:
            type: string
            description: "Il tempo in secondi prima che il token scada"
            example: 900
        required:
          - access_token
          - token_type
          - expires_in

    Child:
      type: object
      properties:
        userId:
          type: string
          description: User ID of the child
          example: "f765429e-d8c5-11ef-a329-005056ae5232"
        nome:
          type: string
          description: First name of the child
          example: "Beppe"
        cognome:
          type: string
          description: Last name of the child
          example: "Vessicchio"

    ChildResponseDTO:
      type: object
      properties:
        userId:
          type: string
          description: Fiscal code of the requester, encrypted
          example: "e326e920-5c66-45f5-b146-73cba5c945e7"
        childList:
          type: array
          items:
            $ref: '#/components/schemas/Child'
          required:
            - childList
      required:
       - userId


    ExpenseDataDTO:
      type: object
      description: JSON object that contains expense info
      properties:
        name:
          type: string
          description: The name of the person associated with the expense
          example: "Beppe"
        surname:
          type: string
          description: The surname of the person associated with the expense
          example: "Vessicchio"
        amount:
          type: number
          format: float
          description: The amount of the expense
          example: "200"
        expenseDate:
          type: string
          format: date-time
          description: The date and time the expense was incurred
          example: "2024-03-10T11:33:42.698+00:00"
        companyName:
          type: string
          description: The company associated with the expense
          example: "Mille Mani S.r.l."
        entityId:
          type: string
          description: The ID of the entity responsible for the expense
          example: "01532570064"
        fiscalCode:
          type: string
          description: The fiscal code of the person or entity hashed
          example: "e326e920-5c66-45f5-b146-73cba5c945e7"
        description:
          type: string
          description: A description of the expense
          example: "Expense description"

    SelfPaymentErrorDTO:
      type: object
      required:
        - code
        - message
      properties:
        code:
          type: string
          enum:
            - LOGIN_FAIL
            - SESSION_FAIL
            - STATE_NOT_FOUND
            - TOKEN_VALIDATION
            - TOKEN_DESERIALIZATION
            - USER_SAVE_FAIL
            - TOKEN_SAVE_FAIL
            - SESSION_NOT_FOUND
            - ANPR_INFO_NOT_FOUND
            - EXPENSE_DATA_ERROR_DB_SAVE
          description: >-
            "ENG: Error code description:
             LOGIN_FAIL: Login failed due to unknown error.
             SESSION_FAIL: Session error, unable to authenticate user.
             STATE_NOT_FOUND: The required state could not be found.
             TOKEN_VALIDATION: Token validation failed, possibly due to expiration or tampering.
             TOKEN_DESERIALIZATION: Error deserializing the token data.
             USER_SAVE_FAIL: Failure to save the user data in the system.
             TOKEN_SAVE_FAIL: Failure to save the token in the system.
             SESSION_NOT_FOUND: The session could not be found or does not exist.
             ANPR_INFO_NOT_FOUND: Anpr info could not be found.
             EXPENSE_DATA_ERROR_DB_SAVE: Error on save into DB expense_data document.
             - IT: Descrizione dei codici di errore:
             LOGIN_FAIL: Login fallito a causa di un errore sconosciuto.
             SESSION_FAIL: Errore di sessione, impossibile autenticare l'utente.
             STATE_NOT_FOUND: Stato richiesto non trovato.
             TOKEN_VALIDATION: Validazione del token fallita, probabilmente per scadenza o manomissione.
             TOKEN_DESERIALIZATION: Errore nella deserializzazione dei dati del token.
             USER_SAVE_FAIL: Impossibile salvare i dati dell'utente nel sistema.
             TOKEN_SAVE_FAIL: Impossibile salvare il token nel sistema.
             SESSION_NOT_FOUND: La sessione non è stata trovata o non esiste.
             ANPR_INFO_NOT_FOUND: Le Anpr info non possono essere recuperate.
             EXPENSE_DATA_ERROR_DB_SAVE: Errore nel salvare sul DB expense_data il document."
        message:
          type: string
          description: "ENG: Error message - IT: Messaggio di errore"



  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
