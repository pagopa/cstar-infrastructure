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
      # parameters:
      #   - name: sender
      #     in: path
      #     description: ID of sender
      #     required: true
      #     schema:
      #       type: string
#           format: int64
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
            $ref: '#/components/schemas/FileName'
    FileName: 
      type: object
      required: 
        - name
      properties:
        name: 
          type: string


  # /ack-storage/{id}:
  #   get:
  #     parameters:
  #       - name: id
  #         in: path
  #         description: file name
  #         required: true
  #         schema:
  #           type: string
  #     responses:
  #       200:
  #         description: file content
  #         content:
  #           application/octet-stream: {}