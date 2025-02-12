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
        description: 'ENG: Id of the iniziative - IT: Identificativo dell''iniziativa'
        required: true
        content:
          application/json:
            schema:
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

    FileData:
      type: object
      properties:
        contentType:
          type: string
          description: The MIME type of the file
          example: application/pdf
        data:
          type: string
          description: The file's base64-encoded content
          example: "JVBERi0xLjcNCiW1tbW1DQoxIDAgb2JqDQo8PC9UeXBlL0NhdGFsb2cvUGFnZXMgMiAwIFIvTGFuZyhpdC1JVCkgL1N0cnVjdFRyZWVSb290IDggMCBSL01hcmtJbmZvPDwvTWFya2VkIHRydWU+Pi9PdXRwdXRJbnRlbnRzWzw8L1R5cGUvT3V0cHV0SW50ZW50L1MvR1RTX1BERkExL091dHB1dENvbmRpdGlvbklkZW50aWZpZXIoc1JHQikgL1JlZ2lzdHJ5TmFtZShodHRwOi8vd3d3LmNvbG9yLm9yZykgL0luZm8oQ3JlYXRvcjogSFAgICAgIE1hbnVmYWN0dXJlcjpJRUMgICAgTW9kZWw6c1JHQikgL0Rlc3RPdXRwdXRQcm9maWxlIDE4IDAgUj4+XSAvTWV0YWRhdGEgMTkgMCBSL1ZpZXdlclByZWZlcmVuY2VzIDIwIDAgUj4+DQplbmRvYmoNCjIgMCBvYmoNCjw8L1R5cGUvUGFnZXMvQ291bnQgMS9LaWRzWyAzIDAgUl0gPj4NCmVuZG9iag0KMyAwIG9iag0KPDwvVHlwZS9QYWdlL1BhcmVudCAyIDAgUi9SZXNvdXJjZXM8PC9Gb250PDwvRjEgNSAwIFI+Pi9Qcm9jU2V0Wy9QREYvVGV4dC9JbWFnZUIvSW1hZ2VDL0ltYWdlSV0gPj4vTWVkaWFCb3hbIDAgMCA1OTUuMzIgODQxLjkyXSAvQ29udGVudHMgNCAwIFIvU3RydWN0UGFyZW50cyAwPj4NCmVuZG9iag0KNCAwIG9iag0KPDwvRmlsdGVyL0ZsYXRlRGVjb2RlL0xlbmd0aCAyMDE+Pg0Kc3RyZWFtDQp4nLWQPQvCMBCG90D+wzsmgtdcmrQpiIOtioKgUHAQB9EqDn6i/n7bH1BwqDfcdHfP8x6iJQaDaJHPCpjhEKMix0MKQ6apEFKGgc88xRbBMWUWz0qKdQ9XKUalFNGEwUzGoTxK0UwbMFJLxjqkPiMXUF7qizg1bSrFRhV6i3IuxbjeX0nRBS9QSFp5N933av/WHKuL7jtVXTVb9bp1rsHWkQ9tGvgDLyVuwx10rM64P7WrH+DVp0m+614hicklP0bGeJHjC3gEd44NCmVuZHN0cmVhbQ0KZW5kb2JqDQo1IDAgb2JqDQo8PC9UeXBlL0ZvbnQvU3VidHlwZS9UcnVlVHlwZS9OYW1lL0YxL0Jhc2VGb250L0JDREVFRStDYWxpYnJpL0VuY29kaW5nL1dpbkFuc2lFbmNvZGluZy9Gb250RGVzY3JpcHRvciA2IDAgUi9GaXJzdENoYXIgMzIvTGFzdENoYXIgMTE4L1dpZHRocyAxNSAwIFI+Pg0KZW5kb2JqDQo2IDAgb2JqDQo8PC9UeXBlL0ZvbnREZXNjcmlwdG9yL0ZvbnROYW1lL0JDREVFRStDYWxpYnJpL0ZsYWdzIDMyL0l0YWxpY0FuZ2xlIDAvQXNjZW50IDc1MC9EZXNjZW50IC0yNTAvQ2FwSGVpZ2h0IDc1MC9BdmdXaWR0aCA1MjEvTWF4V2lkdGggMTc0My9Gb250V2VpZ2h0IDQwMC9YSGVpZ2h0IDI1MC9TdGVtViA1Mi9Gb250QkJveFsgLTUwMyAtMjUwIDEyNDAgNzUwXSAvRm9udEZpbGUyIDE2IDAgUj4+DQplbmRvYmoNCjcgMCBvYmoNCjw8L0F1dGhvciggKSAvQ3JlYXRvcij+/wBNAGkAYwByAG8AcwBvAGYAdACuACAAVwBvAHIAZAAgAHAAZQByACAATwBmAGYAaQBjAGUAIAAzADYANSkgL0NyZWF0aW9uRGF0ZShEOjIwMjAwMzMwMTE1MzI3KzAyJzAwJykgL01vZERhdGUoRDoyMDIwMDMzMDExNTMyNyswMicwMCcpIC9Qcm9kdWNlcij+/wBNAGkAYwByAG8AcwBvAGYAdACuACAAVwBvAHIAZAAgAHAAZQByACAATwBmAGYAaQBjAGUAIAAzADYANSkgPj4NCmVuZG9iag0KOCAwIG9iag0KPDwvVHlwZS9TdHJ1Y3RUcmVlUm9vdC9Sb2xlTWFwIDkgMCBSL1BhcmVudFRyZWUgMTAgMCBSL0tbIDEyIDAgUl0gL1BhcmVudFRyZWVOZXh0S2V5IDE+Pg0KZW5kb2JqDQo5IDAgb2JqDQo8PC9Gb290bm90ZS9Ob3RlL0VuZG5vdGUvTm90ZS9UZXh0Ym94L1NlY3QvSGVhZGVyL1NlY3QvRm9vdGVyL1NlY3QvSW5saW5lU2hhcGUvU2VjdC9Bbm5vdGF0aW9uL1NlY3QvQXJ0aWZhY3QvU2VjdC9Xb3JrYm9vay9Eb2N1bWVudC9Xb3Jrc2hlZXQvUGFydC9N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cmRmOmFib3V0PSIiICB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iPgo8L3JkZjpEZXNjcmlwdGlvbj4KPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgIHhtbG5zOnhtcFJpZ2h0cz0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3JpZ2h0cy8iPgo8eG1wUmlnaHRzOk1hcmtlZD5UcnVlPC94bXBSaWdodHM6TWFya2VkPjwvcmRmOkRlc2NyaXB0aW9uPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCjwvcmRmOlJERj48L3g6eG1wbWV0YT48P3hwYWNrZXQgZW5kPSJ3Ij8+DQplbmRzdHJlYW0NCmVuZG9iag0KMTggMCBvYmoNCjw8L04gMy9GaWx0ZXIvRmxhdGVEZWNvZGUvTGVuZ3RoIDI1OTM+Pg0Kc3RyZWFtDQp4nJ2Wd1RU1xaHz713eqHNMHQYeq9SBhDpHaRXURhmBhjKAMMM2AsiKhBRRKQpggQFDBgNRWJFFAsBUQF7QIKAEoNRbKhkRtZKfHl57+Xl98c939pn73P32XvftS4AJC8/Li8dlgIgjSfgB3u60COjounYfgADPMAAcwCYrKwM/xCPUCCSt7srPUvkBP5Fr4cBJF5vGXsF0ung/5M0K4MvAAAKFPESNieLJeI8EafmCDLE9lkRU+NTxAyjxMwXJShieTEnLrLRZ59FdhIzO43HFrE45wx2GlvMPSLekS3kiBjxE3F+NpeTI+LbItZKFaZxRfxWHJvGYWYBgCKJ7QIOK0nEZiIm8UODXUW8FAAcKfELjv+CBZzVAvGlXNMz1vC5iUkCuh5Ln25ua8uge3FyUjkCgXEgk5XC5LPprulpGUzeGgAW7/xZMuLa0kVFtja3tbY2tjAx/6JQ/3Xzb0rc20V6GfS5ZxCt7w/bX/ml1wHAmBPVZvcftvgKADq2ASB/7w+b1iEAJEV9ax/44j408bwkCQQZdqamOTk5JlwOy0Rc0N/1Px3+hr54n4n4uN/LQ3fjJDCFqQK6uG6s9NR0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c2NyaXB0aW9uPgo8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiAgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIj4KPHhtcDpDcmVhdG9yVG9vbD5NaWNyb3NvZnTCriBXb3JkIHBlciBPZmZpY2UgMzY1PC94bXA6Q3JlYXRvclRvb2w+PHhtcDpDcmVhdGVEYXRlPjIwMjAtMDMtMzBUMTE6NTM6MjcrMDI6MDA8L3htcDpDcmVhdGVEYXRlPjx4bXA6TW9kaWZ5RGF0ZT4yMDIwLTAzLTMwVDExOjUzOjI3KzAyOjAwPC94bXA6TW9kaWZ5RGF0ZT48L3JkZjpEZXNjcmlwdGlvbj4KPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIj4KPHhtcE1NOkRvY3VtZW50SUQ+dXVpZDpGMUZBRTc1Ni1GMkE1LTQzM0EtQkI0Ri1FQUQyRDcxMTE3QkY8L3htcE1NOkRvY3VtZW50SUQ+PHhtcE1NOkluc3RhbmNlSUQ+dXVpZDpGMUZBRTc1Ni1GMkE1LTQzM0EtQkI0Ri1FQUQyRDcxMTE3QkY8L3htcE1NOkluc3RhbmNlSUQ+PC9yZGY6RGVzY3JpcHRpb24+CjxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiICB4bWxuczpwZGZhaWQ9Imh0dHA6Ly93d3cuYWlpbS5vcmcvcGRmYS9ucy9pZC8iPgo8cGRmYWlkOnBhcnQ+MzwvcGRmYWlkOnBhcnQ+PHBkZmFpZDpjb25mb3JtYW5jZT5BPC9wZGZhaWQ6Y29uZm9ybWFuY2U+PC9yZGY6RGVzY3JpcHRpb24+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAo8L3JkZjpSREY+PC94OnhtcG1ldGE+PD94cGFja2V0IGVuZD0idyI/Pg0KZW5kc3RyZWFtDQplbmRvYmoNCjIwIDAgb2JqDQo8PC9EaXNwbGF5RG9jVGl0bGUgdHJ1ZT4+DQplbmRvYmoNCnhyZWYNCjAgMjENCjAwMDAwMDAwMDAgNjU1MzUgZg0KMDAwMDAwMDAxNyAwMDAwMCBuDQowMDAwMDAwMzY0IDAwMDAwIG4NCjAwMDAwMDA0MjAgMDAwMDAgbg0KMDAwMDAwMDYwMCAwMDAwMCBuDQowMDAwMDAwODc1IDAwMDAwIG4NCjAwMDAwMDEwNDMgMDAwMDAgbg0KMDAwMDAwMTI4MiAwMDAwMCBuDQowMDAwMDAxNTM2IDAwMDAwIG4NCjAwMDAwMDE2NDMgMDAwMDAgbg0KMDAwMDAwMTg5NiAwMDAwMCBuDQowMDAwMDAxOTM3IDAwMDAwIG4NCjAwMDAwMDE5NzAgMDAwMDAgbg0KMDAwMDAwMjA0MSAwMDAwMCBuDQowMDAwMDAyMTEwIDAwMDAwIG4NCjAwMDAwMDIxNDAgMDAwMDAgbg0KMDAwMDAwMjM2NyAwMDAwMCBuDQowMDAwMDI5NDQ3IDAwMDAwIG4NCjAwMDAwMzA5OTMgMDAwMDAgbg0KMDAwMDAzMzY2NiAwMDAwMCBuDQowMDAwMDM2OTg4IDAwMDAwIG4NCnRyYWlsZXINCjw8L1NpemUgMjEvUm9vdCAxIDAgUi9JbmZvIDcgMCBSL0lEWzw1NkU3RkFGMUE1RjIzQTQzQkI0RkVBRDJENzExMTdCRj48NTZFN0ZBRjFBNUYyM0E0M0JCNEZFQUQyRDcxMTE3QkY+XSA+Pg0Kc3RhcnR4cmVmDQozNzAzMw0KJSVFT0Y="
        filename:
          type: string
          description: The name of the file
          example: "Documento di prova.pdf"

    ExpenseDataDTO:
      type: object
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
        fileList:
          type: array
          items:
            $ref: '#/components/schemas/FileData'
          description: A list of files associated with the expense

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
