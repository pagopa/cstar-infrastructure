{
    "openapi": "3.0.1",
    "info": {
        "title": "BPD Info Privacy",
        "description": "",
        "version": "1.0"
    },
    "servers": [{
        "url": "https://prod.cstar.pagopa.it/cstar-bpd"
    }],
    "paths": {
        "/info-privacy": {
            "get": {
                "summary": "CstarInfoPrivacy",
                "description": "CstarInfoPrivacy",
                "operationId": "cstarinfoprivacy",
                "responses": {
                    "200": {
                        "description": "null"
                    }
                }
            }
        }
    },
    "components": {}
}