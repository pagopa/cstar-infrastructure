prefix          = "cstar"
env_short       = "p"
env             = "prod"
domain          = "idpay"
location        = "westeurope"
location_string = "West Europe"
location_short  = "weu"
instance        = "prod01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
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

ingress_load_balancer_ip       = "10.11.100.250"
ingress_load_balancer_hostname = "prod01.idpay.internal.cstar.pagopa.it"
reverse_proxy_be_io            = "10.1.0.250"

#
# Dns
#
dns_zone_internal_prefix = "internal.cstar"
external_domain          = "pagopa.it"

#
# Enable components
#
enable = {
  idpay = {
    eventhub = true
  }
}

# Enrolled payment instrument event hub
eventhub_pim = {
  enrolled_pi_eventhub  = "rtd-enrolled-pi"
  revoked_pi_eventhub   = "rtd-revoked-pi"
  namespace_enrolled_pi = "cstar-p-evh-ns"
  namespace_revoked_pi  = "cstar-p-evh-ns-fa-01"
  resource_group_name   = "cstar-p-msg-rg"
}

#
# PDV
#
pdv_tokenizer_url = "https://api.tokenizer.pdv.pagopa.it/tokenizer/v1"
pdv_timeout_sec   = 5

#
# PM
#
pm_service_base_url = "https://api-io.cstar.pagopa.it"
pm_backend_url      = "https://api.platform.pagopa.it"

#
# Check IBAN
#
checkiban_base_url = "https://bankingservices.pagopa.it"

#
# SelfCare API
#
selc_base_url = "https://api.selfcare.pagopa.it"


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

# Storage
storage_account_replication_type   = "RAGZRS"
storage_delete_retention_days      = 90
storage_enable_versioning          = true
storage_advanced_threat_protection = true

#
# RTD reverse proxy
#
reverse_proxy_rtd = "10.1.0.250"

#
# SMTP Server
#
mail_server_host = "smtp.google.com"
