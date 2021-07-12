openapi: 3.0.1
info:
  title: Registro Transazioni Digitali
  description: >-
    RESTful API provided by the "Payment Manager" system to the "Registro
    Transazioni Digitali" system
  version: 1.7.1
servers:
  - url: https://${host}/pp-restapi-rtd/v1
tags:
  - name: np-wallets
    description: Sub-collection of "Natural Persons' Wallet" resources
  - name: static-contents
    description: Collection of "Static Content" resources
paths:
  /wallets/np-wallets:
    post:
      tags:
        - np-wallets
      summary: Create new NP Wallet resource
      operationId: createWalletNP
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/WalletNPInput'
        required: true
      responses:
        '201':
          description: Resource NP Wallet created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/WalletNPResource'
        '400':
          description: Bad Request
          content: {}
        '500':
          description: Internal Server Error
          content: {}
      x-codegen-request-body-name: body
  /wallets/np-wallets/get-wallets/{fiscalCode}:
    get:
      tags:
        - np-wallets
      summary: Retrieves user's RTD instruments list
      operationId: getUserRtdWallets
      parameters:
        - in: path
          name: fiscalCode
          description: user's fiscal code
          required: true
          schema:
            type: string
      responses:
        '200':
          description: User's RTD wallets list
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/WalletNPResponse'
        '404':
          description: Not Found
          content: {}
        '500':
          description: Internal Server Error
          content: {}
  /static-contents/wallets/hashing:
    get:
      tags:
        - static-contents
      summary: Gets info about cryptographic hash function used with wallets
      operationId: getStaticWalletsHash
      responses:
        '200':
          description: Info about cryptographic hash function used with wallets
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/WalletsHashingInfo'
        '404':
          description: Not Found
          content: {}
        '500':
          description: Internal Server Error
          content: {}
  /static-contents/wallets/hashing/actions/evaluate:
    post:
      tags:
        - static-contents
      summary: >-
        Evaluates the cryptographic hash function used with wallets against a
        PAN provided in input
      operationId: evaluateStaticWalletsHash
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/WalletsHashingEvaluationInput'
        required: true
      responses:
        '200':
          description: >-
            Result of evaluating the cryptographic hash function used with
            wallets against the PAN provided in input
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/WalletsHashingEvaluation'
        '500':
          description: Internal Server Error
          content: {}
      x-codegen-request-body-name: body
  /static-contents/wallets/hashing/actions/evaluate/enc:
    post:
      tags:
        - static-contents
      summary: Returns an hashpan starting from a pgp-encrypted pan
      operationId: evaluateStaticWalletHashEnc
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/WalletsHashingEvaluationInput'
        required: true
      responses:
        '200':
          description: hashpan returned
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/WalletsHashingEvaluation'
        '500':
          description: Internal Server Error
          content: { }
components:
  schemas:
    CardType:
      type: string
      enum:
        - CRD
        - DEB
        - PP
    WalletNPInput:
      required:
        - taxCode
        - info
        - walletType
      type: object
      properties:
        taxCode:
          type: string
        channel:
          type: string
        walletType:
          type: string
          enum:
            - Card
            - Bancomat
            - Satispay
            - BPay
        info:
          type: object
          oneOf:
            - $ref: '#/components/schemas/WalletCardInfoInput'
            - $ref: '#/components/schemas/WalletSatispayInfoInput'
            - $ref: '#/components/schemas/WalletBpayInfoInput'
          discriminator:
            propertyName: walletType
            mapping:
              Card: '#/components/schemas/WalletCardInfoInput'
              Bancomat: '#/components/schemas/WalletCardInfoInput'
              Satispay: '#/components/schemas/WalletSatispayInfoInput'
              BPay: '#/components/schemas/WalletBpayInfoInput'
    WalletCardInfoInput:
      required:
        - expireMonth
        - expireYear
        - pan
        - type
      type: object
      properties:
        pan:
          type: string
          description: encrypted with PGP
        expireMonth:
          maxLength: 2
          minLength: 2
          type: string
          example: '01'
        expireYear:
          maxLength: 4
          minLength: 4
          type: string
          example: '2022'
        type:
          $ref: '#/components/schemas/CardType'
        holder:
          type: string
        brand:
          type: string
          enum:
            - VISA
            - MASTERCARD
            - MAESTRO
            - VISA_ELECTRON
            - AMEX
            - OTHER
        issuerAbiCode:
          maxLength: 5
          minLength: 5
          type: string
          format: ABI Code
    WalletNPResource:
      type: object
      properties:
        taxCode:
          type: string
          maxLength: 16
          minLength: 16
        hashCode:
          type: string
        salt:
          type: string
        createTimestamp:
          pattern: '^\d{2}-\d{2}-\d{4} \d{2}:\d{2}:\d{2}$'
          type: string
          format: date
          example: '31-01-2020 00:00:00'
    SecretKey:
      type: object
      properties:
        algorithm:
          type: string
        format:
          type: string
        encoded:
          type: string
        destroyed:
          type: string
    WalletNPResponse:
      type: object
      properties:
        taxCode:
          type: string
        channel:
          type: string
        walletType:
          type: string
          enum:
            - Card
            - Bancomat
            - Satispay
            - BPay
        info:
          type: object
          oneOf:
            - $ref: '#/components/schemas/WalletCardInfoInput'
            - $ref: '#/components/schemas/WalletSatispayInfoInput'
            - $ref: '#/components/schemas/WalletBpayInfoInput'
          discriminator:
            propertyName: walletType
            mapping:
              Card: '#/components/schemas/WalletCardInfoInput'
              Bancomat: '#/components/schemas/WalletCardInfoInput'
              Satispay: '#/components/schemas/WalletSatispayInfoInput'
              BPay: '#/components/schemas/WalletBpayInfoInput'
        hsmEnabledHashEncryptionKey:
          type: string
        hsmDisabledEncryptionKey:
          $ref: '#/components/schemas/SecretKey'
        hashCode:
          type: string
    WalletsHashingInfo:
      type: object
      properties:
        family:
          type: string
          example: SHA-256
        salt:
          type: string
    WalletsHashingEvaluationInput:
      type: object
      properties:
        pan:
          type: string
    WalletsHashingEvaluation:
      type: object
      properties:
        hashPan:
          type: string
        salt:
          type: string
    WalletSatispayInfoInput:
      required:
        - id
      type: object
      properties:
        id:
          type: string
    WalletBpayInfoInput:
      required:
        - codGruppo
        - codIstituto
        - nomeBanca
        - nomeOffuscato
        - cognomeOffuscato
        - numeroTelefonicoOffuscato
        - numeroTelefonicoCriptato
        - UIDCriptato
        - statoServizio
        - infoStrumenti
      type: object
      properties:
        codGruppo:
          type: string
        codIstituto:
          type: string
        nomeBanca:
          type: string
        nomeOffuscato:
          type: string
        cognomeOffuscato:
          type: string
        numeroTelefonicoOffuscato:
          type: string
        numeroTelefonicoCriptato:
          type: string
        UIDCriptato:
          type: string
        statoServizio:
          type: string
          enum:
            - ATT
            - DIS
            - SOSP
            - SAT_GG
            - SAT_MM
            - SAT_NO
            - NFC_IN_COR
            - NFC_ESTINTO
            - ATTPND
            - DISPND
        infoStrumenti:
          type: array
          items:
            $ref: '#/components/schemas/InfoStrumenti'
    InfoStrumenti:
      required:
        - iban
        - flgPreferitoPagamento
        - flgPreferitoRicezione
      type: object
      properties:
        iban:
          type: string
        flgPreferitoPagamento:
          type: boolean
        flgPreferitoRicezione:
          type: boolean
