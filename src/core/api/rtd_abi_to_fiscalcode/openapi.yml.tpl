openapi: 3.0.0
info:
  title: API to convert acquirer's ABI to Fiscal Code
  description: API to convert acquirer's ABI to Fiscal Code
  version: 0.0.1
servers:
- url: "https://httpbin.org"
paths:
  /conversion-map :
    get:
      responses:
        default:
          description: Default response
          content:
            application/json: {}
