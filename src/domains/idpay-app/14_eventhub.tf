locals {
  enable_evh = 0 //var.env_short == "d" ? 1 : 0
  enable_secret = 0
  mongodb_connection_uri_template = "mongodb://%s:%s@%s.mongo.cosmos.azure.com:10255/?ssl=true&replicaSet=globaldb&retrywrites=false&maxIdleTimeMS=120000&appName=@%s@"
  jaas_config_template_idpay = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"%s\";"
}

# eventhub for POC
resource "azurerm_eventhub_namespace" "cdc_evh" {
  count               = local.enable_evh
  name                = "idpay-cdc"
  location            = var.location
  resource_group_name = "cstar-${var.env_short}-idpay-msg-rg"
  sku                 = "Standard"
  zone_redundant      = true
  minimum_tls_version = 1.2
  network_rulesets {
    default_action = "Allow"
  }
}

# access key for kafka connect with manage access
resource "azurerm_eventhub_namespace_authorization_rule" "evh_namespace_access_key" {
  count               = local.enable_evh
  name                = "kafka-connect-access-key"
  namespace_name      = azurerm_eventhub_namespace.cdc_evh[0].name
  resource_group_name = "cstar-${var.env_short}-idpay-msg-rg"
  manage              = true
  listen              = true
  send                = true
}

resource "azurerm_key_vault_secret" "event_hub_root_key_idpay_00" {
  name         = "evh-root-jaas-config-idpay-00"
  value        = format(local.jaas_config_template_idpay, azurerm_eventhub_namespace_authorization_rule.evh_namespace_access_key[count.index].primary_connection_string)
  content_type = "text/plain"

  key_vault_id = module.key_vault_idpay.id
}

data "azurerm_cosmosdb_account" "idpay_cosmos_db" {
  name                = "cstar-${var.env_short}-cosmos-mongo-db-account"
  resource_group_name = "cstar-${var.env_short}-db-rg"
}

resource "kubernetes_deployment" "kafka_connect" {
  count = local.enable_secret
  metadata {
    name      = "kafka-debezium"
    namespace = "strimzi"
  }
  spec {
    replicas = "1"
    selector {
      match_labels = {
        app = "kafka-connect-debezium"
      }
    }

    template {
      metadata {
        labels = {
          app = "kafka-connect-debezium"
        }
      }
      spec {
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              topology_key = "kubernetes.io/hostname"
            }
          }
        }
        container {
          name              = "kafka-connect-debezium"
          image_pull_policy = "Always"
          image             = "cstardcommonacr.azurecr.io/kafka-connectors"

          port {
            container_port = 8083
          }

          env_from {
            config_map_ref {
              name = "kafka-connect-config"
            }
          }

          env_from {
            secret_ref {
              name = "kafka-connect-secret"
            }
          }

          resources {
            limits = {
              cpu    = "400m"
              memory = "512Mi"
            }
          }
          liveness_probe {
            http_get {
              path = "/connectors"
              port = "8083"
            }
            initial_delay_seconds = 60
            period_seconds        = 5
            timeout_seconds       = 5
            success_threshold     = 1
            failure_threshold     = 10
          }
          readiness_probe {
            http_get {
              path = "/connectors"
              port = "8083"
            }
            initial_delay_seconds = 40
            period_seconds        = 10
            timeout_seconds       = 5
            success_threshold     = 1
            failure_threshold     = 3
          }
        }
      }
    }
  }
  depends_on = [
    kubernetes_config_map.kafka_connect_config,
    kubernetes_secret.kafka_connect_secret
  ]
}

resource "kubernetes_config_map" "kafka_connect_config" {
  count = local.enable_secret
  metadata {
    name      = "kafka-connect-config"
    namespace = "strimzi"
  }

  data = {
    BOOTSTRAP_SERVERS       = "idpay-poc-cdc.servicebus.windows.net:9093"
    GROUP_ID                = "poc-cdc-cluster"
    CONFIG_STORAGE_TOPIC    = "poc-cdc-cluster-configs"
    OFFSET_STORAGE_TOPIC    = "poc-cdc-cluster-offsets"
    STATUS_STORAGE_TOPIC    = "poc-cdc-cluster-status"
    CONNECT_KEY_CONVERTER   = "org.apache.kafka.connect.json.JsonConverter"
    CONNECT_VALUE_CONVERTER = "org.apache.kafka.connect.json.JsonConverter"
    # worker config
    CONNECT_SECURITY_PROTOCOL = "SASL_SSL"
    CONNECT_SASL_MECHANISM    = "PLAIN"

    # producer config
    CONNECT_PRODUCER_SECURITY_PROTOCOL = "SASL_SSL"
    CONNECT_PRODUCER_SASL_MECHANISM    = "PLAIN"

    # eventhub configs
    CONNECT_METADATA_MAX_AGE_MS : "180000"
    CONNECT_CONNECTIONS_MAX_IDLE_MS : "180000"
    CONNECT_MAX_REQUEST_SIZE : "1000000"

    # allows to get secrets from environment variables
    CONNECT_CONFIG_PROVIDERS : "env"
    CONNECT_CONFIG_PROVIDERS_ENV_CLASS : "org.apache.kafka.common.config.provider.EnvVarConfigProvider"

    # open telemetry
    ENABLE_OTEL                                 = "true"
    OTEL_SERVICE_NAME                           = "kafka-connect"
    OTEL_TRACES_EXPORTER                        = "otlp"
    OTEL_METRICS_EXPORTER                       = "otlp"
    OTEL_PROPAGATORS                            = "tracecontext"
    OTEL_EXPORTER_OTLP_ENDPOINT                 = "http://opentelemetry-collector.strimzi.svc.cluster.local:4317"
    OTEL_TRACES_SAMPLER                         = "always_on"
    JAVA_TOOL_OPTIONS                           = "-javaagent:./opentelemetry-javaagent.jar"
    OTEL_INSTRUMENTATION_COMMON_DEFAULT_ENABLED = "false"
    OTEL_INSTRUMENTATION_MONGO_ENABLED          = "true"
    OTEL_INSTRUMENTATION_KAFKA_ENABLED          = "true"
  }
}

resource "kubernetes_secret" "kafka_connect_secret" {
  count = enable_secret
  metadata {
    name      = "kafka-connect-secret"
    namespace = "debezium"
  }
  data = {
    CONNECT_SASL_JAAS_CONFIG : "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"${azurerm_eventhub_namespace_authorization_rule.evh_namespace_access_key[count.index].primary_connection_string}\";"
    CONNECT_PRODUCER_SASL_JAAS_CONFIG : "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"${azurerm_eventhub_namespace_authorization_rule.evh_namespace_access_key[count.index].primary_connection_string}\";"
    COSMOS_CONNECTION_STRING : format(
      local.mongodb_connection_uri_template,
      data.azurerm_cosmosdb_account.idpay_cosmos_db.name,
      data.azurerm_cosmosdb_account.idpay_cosmos_db.primary_readonly_key,
      data.azurerm_cosmosdb_account.idpay_cosmos_db.name,
      data.azurerm_cosmosdb_account.idpay_cosmos_db.name
    )
  }
}
