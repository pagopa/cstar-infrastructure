locals {
  enable_poc_strimzi              = var.env_short == "d" ? 1 : 0
  mongodb_connection_uri_template = "mongodb://%s:%s@%s.mongo.cosmos.azure.com:10255/?ssl=true&replicaSet=globaldb&retrywrites=false&maxIdleTimeMS=120000&appName=@%s@"
}

resource "kubernetes_namespace" "strimzi" {
  count = local.enable_poc_strimzi
  metadata {
    name = "strimzi"
  }
}

# install k8s operator
resource "helm_release" "strimzi" {
  count = local.enable_poc_strimzi

  repository = "https://strimzi.io/charts/"
  chart      = "strimzi-kafka-operator"
  name       = "strimzi-kafka-operator"
  version    = "0.38.0"

  namespace = kubernetes_namespace.strimzi[count.index].metadata[0].name
}

# provide a connection string for eventhub as k8s secret
resource "kubernetes_secret" "strimzi_evh_connectionstring" {
  count = local.enable_poc_strimzi
  metadata {
    name      = "strimzi-evh-connectionstring"
    namespace = kubernetes_namespace.strimzi[count.index].metadata[0].name
  }

  data = {
    eventhubsusername : "$ConnectionString"
    eventhubspassword : azurerm_eventhub_namespace_authorization_rule.poc_cdc_evh_access_key[count.index].primary_connection_string
  }
}

# create a resource for kafka-connect. Strimzi will provide to create it
resource "kubernetes_manifest" "strimzi_kafka_connect" {
  count    = local.enable_poc_strimzi
  manifest = yamldecode(file("./poc-cdc/strimzi/kafka-connect.yml"))

  depends_on = [
    kubernetes_secret.strimzi_evh_connectionstring,
    kubernetes_config_map.kafka_connect_jmx_config
  ]
}

resource "kubernetes_manifest" "strimzi_cosmos_connector" {
  count    = 0
  manifest = yamldecode(file("./poc-cdc/strimzi/mongo-connector.yml"))

  depends_on = [
    kubernetes_secret.rtd_cosmos_connection_string
  ]
}

resource "kubernetes_manifest" "strimzi_cosmos_connector_debezium" {
  count    = 0
  manifest = yamldecode(file("./poc-cdc/strimzi/debezium-connector.yml"))

  depends_on = [
    kubernetes_secret.rtd_cosmos_connection_string
  ]
}

data "azurerm_cosmosdb_account" "rtd_cosmos_db" {
  name                = "cstar-d-cosmos-mongo-db-account"
  resource_group_name = "cstar-d-db-rg"
}

resource "kubernetes_secret" "rtd_cosmos_connection_string" {
  count = local.enable_poc_strimzi
  metadata {
    name      = "rtd-cosmos-connection-string"
    namespace = kubernetes_namespace.strimzi[count.index].metadata[0].name
  }

  data = {
    uri : format(
      local.mongodb_connection_uri_template,
      data.azurerm_cosmosdb_account.rtd_cosmos_db.name,
      data.azurerm_cosmosdb_account.rtd_cosmos_db.primary_readonly_key,
      data.azurerm_cosmosdb_account.rtd_cosmos_db.name,
      data.azurerm_cosmosdb_account.rtd_cosmos_db.name
    )
  }
}

# Strimzi also support opentelemetry, create an instance to try it
# This will export data to azure.
resource "helm_release" "opentelemetry_collecotr" {
  count      = local.enable_poc_strimzi
  chart      = "opentelemetry-collector"
  name       = "opentelemetry-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  version    = "0.73.1"

  namespace = kubernetes_namespace.strimzi[count.index].metadata[0].name

  values = [
    templatefile("./poc-cdc/collector/values.yml", {
      azure_monitor_connection_string : data.azurerm_application_insights.application_insights.instrumentation_key
    })
  ]
}

resource "kubernetes_cluster_role" "otel_role" {
  count = local.enable_poc_strimzi
  metadata {
    name = "otel-role"
  }
  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "watch", "list"]
  }
}

resource "kubernetes_cluster_role_binding" "opentelemetry_rolebinding" {
  count = local.enable_poc_strimzi
  metadata {
    name = "opentelemetry-collector-prom-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "otel-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "opentelemetry-collector"
    namespace = kubernetes_namespace.strimzi[count.index].metadata[0].name
  }
}

resource "kubernetes_config_map" "kafka_connect_jmx_config" {
  count = local.enable_poc_strimzi
  metadata {
    name      = "kafka-conect-jmx-config"
    namespace = kubernetes_namespace.strimzi[count.index].metadata[0].name
  }

  data = {
    "config.yml" : file("./poc-cdc/strimzi/jmx.yml")
  }
}
