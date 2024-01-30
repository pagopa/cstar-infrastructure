data "azurerm_cosmosdb_account" "idpay_cosmos_db" {
  name                = "cstar-${var.env_short}-cosmos-mongo-db-account"
  resource_group_name = "cstar-${var.env_short}-db-rg"
}

resource "terracurl_request" "cosmos_connector" {
  name         = "cosmos_connector"
  url          = "https://${var.ingress_load_balancer_hostname}/idpaykafkaconnect/connectors/cosmos-connector/config"
  method       = "PUT"
  request_body = file("cosmos_connector.json")
  response_codes = [
    200,
    201,
    204
  ]

  headers = {
    Content-Type = "application/json"
  }
}
