prefix          = "cstar"
env_short       = "u"
env             = "uat"
domain          = "idpay"
location        = "westeurope"
location_string = "West Europe"
location_short  = "weu"
instance        = "uat01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### External resources

monitor_resource_group_name                 = "cstar-u-monitor-rg"
log_analytics_workspace_name                = "cstar-u-law"
log_analytics_workspace_resource_group_name = "cstar-u-monitor-rg"

### Aks

aks_name                = "cstar-u-weu-uat01-aks"
aks_resource_group_name = "cstar-u-weu-uat01-aks-rg"
aks_vmss_name           = "aks-cstuat01usr-39999986-vmss"
aks_cluster_domain_name = "uat01"

ingress_load_balancer_ip       = "10.11.100.250"
ingress_load_balancer_hostname = "uat01.idpay.internal.uat.cstar.pagopa.it"
reverse_proxy_be_io            = "10.1.0.250"

#
# Dns
#
dns_zone_internal_prefix = "internal.uat.cstar"
external_domain          = "pagopa.it"

#
# Enable components
#
enable = {
  idpay = {
    eventhub = true
  }
}

#
# PDV
#
pdv_tokenizer_url = "https://api.uat.tokenizer.pdv.pagopa.it/tokenizer/v1"
pdv_timeout_sec   = 5
#
# PM
#
pm_service_base_url = "https://api-io.uat.cstar.pagopa.it"
pm_backend_url      = "https://api.uat.platform.pagopa.it"

#
# Check IBAN
#
checkiban_base_url = "https://bankingservices-sandbox.pagopa.it"

#
# SelfCare API
#
selc_base_url = "https://api.uat.selfcare.pagopa.it"

#
# BE IO API
#
io_backend_base_url = "https://api.io.italia.it" #"https://api-io.uat.cstar.pagopa.it/idpay/mock"

#
# ONE TRUST API
#
one_trust_privacynotice_base_url = "https://app-de.onetrust.com/api/privacynotice/v2"

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
idpay_mocked_acquirer_apim_user_id = "rtd-uat-acquirer-pagopa-it"
idpay_alert_enabled                = true
