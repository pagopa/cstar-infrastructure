prefix          = "cstar"
env_short       = "d"
env             = "dev"
domain          = "idpay"
location        = "westeurope"
location_string = "West Europe"
location_short  = "weu"
instance        = "dev01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### External resources

monitor_resource_group_name                 = "cstar-d-monitor-rg"
log_analytics_workspace_name                = "cstar-d-law"
log_analytics_workspace_resource_group_name = "cstar-d-monitor-rg"

### Aks

aks_name                = "cstar-d-weu-dev01-aks"
aks_resource_group_name = "cstar-d-weu-dev01-aks-rg"
aks_vmss_name           = "aks-cstdev01usr-34190646-vmss"
aks_cluster_domain_name = "dev01"

ingress_load_balancer_ip       = "10.11.100.250"
ingress_load_balancer_hostname = "dev01.idpay.internal.dev.cstar.pagopa.it"
reverse_proxy_be_io            = "10.1.0.250"

#
# Dns
#
dns_zone_internal_prefix = "internal.dev.cstar"
external_domain          = "pagopa.it"

#
# Enable components
#
enable = {
  idpay = {
    eventhub = true
  }
  mock_io_api = true
}

#
# PDV
#
pdv_tokenizer_url = "https://api.uat.tokenizer.pdv.pagopa.it/tokenizer/v1"
pdv_timeout_sec   = 15

#
# PM
#
pm_service_base_url = "https://api-io.uat.cstar.pagopa.it"
pm_backend_url      = "https://api.dev.platform.pagopa.it"

#
# Check IBAN
#
checkiban_base_url = "https://bankingservices-sandbox.pagopa.it"

#
# SelfCare API
#
selc_base_url = "https://api.dev.selfcare.pagopa.it"

#
# BE IO API
#
io_backend_base_url = "https://api-io.dev.cstar.pagopa.it/idpay/mock"

#
# ONE TRUST API
#
one_trust_privacynotice_base_url = "https://api-io.dev.cstar.pagopa.it/idpay/mock/api/privacynotice/v2"

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
storage_delete_retention_days = 5
storage_enable_versioning     = true

#
# RTD reverse proxy
#
reverse_proxy_rtd = "10.1.0.250"

#
# SMTP Server
#
mail_server_host = "smtp.ethereal.email"

idpay_mocked_merchant_enable       = true
idpay_mocked_acquirer_apim_user_id = "1"



