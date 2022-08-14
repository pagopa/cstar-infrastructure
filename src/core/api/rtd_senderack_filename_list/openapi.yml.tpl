openapi: 3.0.0
info:
  title: REST API File Register for TAE
  description: API to retrieve the file status
  version: 0.0.1
servers:
- url: ${host}
paths:
  /sender-ade-ack:
    get:
      responses:
        200:
          description: Sender ack file list
          content:
            application/json: 
              schema:
                $ref: '#/components/schemas/SenderAdeAckList'

components:
  schemas:
    SenderAdeAckList:
      type: object
      properties:
        fileNameList:
          type: array
          items: 
            type: string
