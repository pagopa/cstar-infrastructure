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
paths:
  /CDCUtenteWS/rest/unsecured/versione:
    get:
      tags:
      - unsecured
      responses:
        default:
          description: Default response
          content:
            text/plain: {}