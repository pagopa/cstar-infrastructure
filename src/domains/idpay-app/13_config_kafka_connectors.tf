data "azurerm_cosmosdb_account" "idpay_cosmos_db" {
  name                = "cstar-${var.env_short}-cosmos-mongo-db-account"
  resource_group_name = "cstar-${var.env_short}-db-rg"
}

resource "null_resource" "cosmos_connector" {
  provisioner "local-exec" {
    command = <<-EOT
      curl -X PUT https://${var.ingress_load_balancer_hostname}/idpay/kafkaconnect/idpaykafkaconnect/connectors/cosmos-connector/config \
      -H "Content-Type: application/json" \
      --data '{
        "connector.class": "com.mongodb.kafka.connect.MongoSourceConnector",
        "connection.uri": "${format(local.mongodb_connection_uri_template, data.azurerm_cosmosdb_account.idpay_cosmos_db.name, data.azurerm_cosmosdb_account.idpay_cosmos_db.primary_readonly_key, data.azurerm_cosmosdb_account.idpay_cosmos_db.name, data.azurerm_cosmosdb_account.idpay_cosmos_db.name)}",
        "database": "idpay",
        "collection": "transaction_in_progress",
        "topic.namespace.map": "{\"idpay.transaction_in_progress\": \"idpay-transactions\"}",
        "server.api.version": "4.2",
        "copy.existing": false,
        "key.converter": "org.apache.kafka.connect.json.JsonConverter",
        "key.converter.schemas.enable": false,
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "value.converter.schemas.enable": false,
        "publish.full.document.only": true,
        "output.json.formatter": "com.mongodb.kafka.connect.source.json.formatter.SimplifiedJson",
        "heartbeat.interval.ms": 5000,
        "mongo.errors.log.enable": true,
        "output.format.value": "json",
        "output.format.key": "schema",
        "output.schema.key": "{\"type\":\"record\",\"name\":\"keySchema\",\"fields\":[{\"name\":\"fullDocument.stream_id\",\"type\":\"string\"}]}",
        "pipeline": "[{\"$match\":{\"operationType\":{\"$in\":[\"insert\",\"update\",\"replace\"]}}},{\"$project\":{\"_id\":1,\"fullDocument\":1,\"ns\":1,\"documentKey\":1}},{\"$match\":{\"fullDocument.status\":{\"$in\":[\"AUTHORIZED\",\"CANCELED\",\"REWARDED\"]}}}]"
      }'
    EOT
  }
}
