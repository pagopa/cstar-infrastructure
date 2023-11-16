locals {
  enable_poc         = var.env_short == "d" ? 1 : 0
  enable_poc_strimzi = var.env_short == "d" ? 1 : 0
}

# eventhub for POC
resource "azurerm_eventhub_namespace" "poc_cdc_evh" {
  count               = local.enable_poc
  name                = "idpay-poc-cdc"
  location            = var.location
  resource_group_name = "cstar-d-idpay-msg-rg"
  sku                 = "Standard"
  zone_redundant      = true
  minimum_tls_version = 1.2
  network_rulesets {
    default_action = "Allow"
  }
}

# access key for kafka connect with manage access
resource "azurerm_eventhub_namespace_authorization_rule" "poc_cdc_evh_access_key" {
  count               = local.enable_poc
  name                = "kafka-connect-access-key"
  namespace_name      = azurerm_eventhub_namespace.poc_cdc_evh[count.index].name
  resource_group_name = "cstar-d-idpay-msg-rg"
  manage              = true
  listen              = true
  send                = true
}

# POC 1: using kafka connect from confluent helm chart
resource "helm_release" "kafka_connect" {
  count      = local.enable_poc
  repository = "https://confluentinc.github.io/cp-helm-charts/"
  chart      = "cp-helm-charts"
  name       = "poc-cdc-kafka-connect"
  namespace  = "idpay"
  values = [
    templatefile("poc-cdc/kafka-connect.yml", {
      jaas-secret-name : kubernetes_secret.kafka_connect_jaas[0].metadata[0].name
    })
  ]
  force_update = true
  depends_on = [
    kubernetes_secret.kafka_connect_jaas
  ]
}

resource "kubernetes_secret" "kafka_connect_jaas" {
  count = local.enable_poc
  metadata {
    name      = "kafka-connect-jaas"
    namespace = "idpay"
  }

  data = {
    // take from KV
    "kafka_jaas.conf" : (
      <<-EOF
      KafkaClient {
        org.apache.kafka.common.security.plain.PlainLoginModule required
        username="$ConnectionString"
        password="${azurerm_eventhub_namespace_authorization_rule.poc_cdc_evh_access_key[count.index].primary_connection_string}";
      };
      EOF
    )
  }
}

resource "kubernetes_namespace" "strimzi" {
  count = local.enable_poc_strimzi
  metadata {
    name = "strimzi"
  }
}

# POC 1 Alt: Strimzi
# Install strimzi as k8s operator
resource "helm_release" "strimzi" {
  count = local.enable_poc_strimzi

  repository = "https://strimzi.io/charts/"
  chart      = "strimzi-kafka-operator"
  name       = "strimzi-kafka-operator"
  version    = "0.38.0"

  namespace = kubernetes_namespace.strimzi[count.index].metadata[0].name
}

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

#resource "kubernetes_manifest" "strimzi_kafka_connect" {
#  count    = local.enable_poc_strimzi
#  manifest = yamldecode(file("./poc-cdc/strimzi/kafka-connect.yml"))
#}


# OpenTelemetry Collector
resource "helm_release" "opentelemetry_collecotr" {
  count      = 0
  chart      = "opentelemetry-collector"
  name       = "opentelemetry-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  version    = "0.73.1"

  namespace = kubernetes_namespace.strimzi[count.index].metadata[0].name

  values = [
    templatefile("./poc-cdc/collector/values.yml", {
      azure_monitor_connection_string : ""
    })
  ]
}
