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
             - IT: Descrizione dei codici di errore:
             LOGIN_FAIL: Login fallito a causa di un errore sconosciuto.
             SESSION_FAIL: Errore di sessione, impossibile autenticare l'utente.
             STATE_NOT_FOUND: Stato richiesto non trovato.
             TOKEN_VALIDATION: Validazione del token fallita, probabilmente per scadenza o manomissione.
             TOKEN_DESERIALIZATION: Errore nella deserializzazione dei dati del token.
             USER_SAVE_FAIL: Impossibile salvare i dati dell'utente nel sistema.
             TOKEN_SAVE_FAIL: Impossibile salvare il token nel sistema.
             SESSION_NOT_FOUND: La sessione non è stata trovata o non esiste."
        message:
          type: string
          description: "ENG: Error message - IT: Messaggio di errore"



