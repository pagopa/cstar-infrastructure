resource "null_resource" "cosmos_connector" {
  #TODO: DA VEDERE COME SCATENARE IL TRIGGER
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      curl -X PUT {host}/connectors/cosmos-connector/config \
      -H "Content-Type: application/json" \
      --data '{
        "connector.class": "com.mongodb.kafka.connect.MongoSourceConnector",
        "connection.uri": "${kubernetes_secret.kafka_connect_secret[count.index].data.COSMOS_CONNECTION_STRING}",
        "database": "idpay",
        "collection": "transaction_in_progress",
        "topic.namespace.map": "{\"idpay.transaction_in_progress\": \"idpay-transactions-cdc\"}",
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
