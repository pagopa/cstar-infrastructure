prefix          = "cstar"
env_short       = "p"
env             = "prod"
domain          = "rtd"
location        = "westeurope"
location_string = "West Europe"
location_short  = "weu"
instance        = "prod01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Prod"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### External resources

monitor_resource_group_name                 = "cstar-p-monitor-rg"
log_analytics_workspace_name                = "cstar-p-law"
log_analytics_workspace_resource_group_name = "cstar-p-monitor-rg"

### Aks

aks_name                = "cstar-p-weu-prod01-aks"
aks_resource_group_name = "cstar-p-weu-prod01-aks-rg"
aks_cluster_domain_name = "prod01"

ingress_load_balancer_ip       = "10.11.100.250"
ingress_load_balancer_hostname = "prod01.rtd.internal.cstar.pagopa.it"
reverse_proxy_be_io            = "10.1.0.250"
reverse_proxy_ip_old_k8s       = "10.1.0.250"

#
# External references
#
pagopa_platform_url = "https://api.platform.pagopa.it"

#
# Dns
#
dns_zone_internal_prefix = "internal.cstar"
external_domain          = "pagopa.it"

#
# Features flags
#
enable = {
  blob_storage_event_grid_integration = true
  internal_api                        = true
  csv_transaction_apis                = false
  ingestor                            = true
  file_register                       = false
  enrolled_payment_instrument         = true
  mongodb_storage                     = false
  file_reporter                       = true
  payment_instrument                  = false
  exporter                            = false
  alternative_gateway                 = false
  api_payment_instrument              = false
  tkm_integration                     = false
  pm_integration                      = true
  hashed_pans_container               = true
  batch_service_api                   = true
  tae_api                             = true
  tae_blob_containers                 = true
  sender_auth                         = true
  csv_transaction_apis                = true
  mock_io_api                         = false
}
#
# Hashpan generation pipeline related variables
#
hpan_blob_storage_container_name = {
  hpan = "cstar-hashed-pans"
}
enable_hpan_pipeline_periodic_trigger     = false
enable_hpan_par_pipeline_periodic_trigger = false

#
# TLS Checker
#
# chart releases: https://github.com/pagopa/aks-microservice-chart-blueprint/releases
# image tags: https://github.com/pagopa/infra-ssl-check/releases
tls_cert_check_helm = {
  chart_version = "1.21.0"
  image_name    = "ghcr.io/pagopa/infra-ssl-check"
  image_tag     = "v1.2.2@sha256:22f4b53177cc8891bf10cbd0deb39f60e1cd12877021c3048a01e7738f63e0f9"
}

#
# Eventhubs
#
event_hub_hubs = [
  {
    name       = "rtd-pi-to-app"
    retention  = 7
    partitions = 8
    consumers = [
      "rtd-pi-to-app-consumer-group"
    ]
    policies = [
      {
        name   = "rtd-pi-to-app-consumer-policy"
        listen = true
        send   = true
        manage = false
      },
      {
        name   = "rtd-pi-to-app-producer-policy"
        listen = false
        send   = true
        manage = false
      }
    ]
  },
  {
    name       = "rtd-pi-from-app"
    retention  = 7
    partitions = 8
    consumers = [
      "rtd-pi-from-app-consumer-group"
    ]
    policies = [
      {
        name   = "rtd-pi-from-app-consumer-policy"
        listen = true
        send   = true
        manage = false
      },
      {
        name   = "rtd-pi-from-app-producer-policy"
        listen = false
        send   = true
        manage = false
      }
    ]
  },
  {
    name       = "rtd-split-by-pi"
    retention  = 7
    partitions = 8
    consumers = [
      "rtd-split-by-pi-consumer-group"
    ]
    policies = [
      {
        name   = "rtd-split-by-pi-consumer-policy"
        listen = true
        send   = true
        manage = false
      },
      {
        name   = "rtd-split-by-pi-producer-policy"
        listen = false
        send   = true
        manage = false
      }
    ]
  },
  {
    name       = "rtd-file-register-projector"
    retention  = 7
    partitions = 1
    consumers = [
      "rtd-file-reporter-consumer-group"
    ]
    policies = [
      {
        name   = "rtd-file-register-projector-consumer-policy"
        listen = true
        send   = false
        manage = false
      },
      {
        name   = "rtd-file-register-projector-producer-policy"
        listen = false
        send   = true
        manage = false
      }
    ]
  },
  {
    name       = "rtd-dlq-trx"
    retention  = 1
    partitions = 1
    consumers = [
      "rtd-ingestor-dlq-consumer-group"
    ]
    policies = [
      {
        name   = "rtd-dlq-trx-consumer-policy"
        listen = true
        send   = false
        manage = false
      },
      {
        name   = "rtd-dlq-trx-producer-policy"
        listen = false
        send   = true
        manage = false
      }
    ]
  }
]

#
# Config maps
#
configmap_rtdsplitbypiproducer = {
  KAFKA_RTD_SPLIT_PARTITION_COUNT = 8
}

configmap_rtdpitoappproducer = {
  KAFKA_RTD_PI_TO_APP_PARTITION_COUNT = 8
}

configmaps_rtdsenderauth = {
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "INFO"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
}

configmaps_rtdpieventprocessor = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/app/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "INFO"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
}

configmaps_rtdenrolledpaymentinstrument = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/app/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "rtdenrolledpaymentinstrument"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "INFO"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  BASEURL_TOKEN_FINDER                                   = ""
}

configmaps_rtdingestor = {
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "INFO"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
}

configmaps_rtdfileregister = {
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "INFO"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
}

configmaps_rtddecrypter = {
  ENABLE_CHUNK_UPLOAD                                    = true
  SPLITTER_LINE_THRESHOLD                                = 2000000
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "INFO"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
}

configmaps_rtdfilereporter = {
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "INFO"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
}

configmaps_rtdexporter = {
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "INFO"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
}

# See cidr_subnet_k8s
k8s_ip_filter_range = {
  from = "10.1.0.1"
  to   = "10.1.127.254"
}

k8s_ip_filter_range_aks = {
  from = "10.11.0.1"
  to   = "10.11.127.254"
}

pm_backend_url                       = "https://api.platform.pagopa.it"
batch_service_last_supported_version = "1.3.2"

