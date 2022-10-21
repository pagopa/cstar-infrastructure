prefix         = "cstar"
env_short      = "u"
env            = "uat"
domain         = "idpay"
location       = "westeurope"
location_short = "weu"
instance       = "uat01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

lock_enable = true

terraform_remote_state_core = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "cstarinfrastterraformuat"
  container_name       = "azurestate"
  key                  = "terraform.tfstate"
}

### External resources

monitor_resource_group_name                 = "cstar-u-monitor-rg"
log_analytics_workspace_name                = "cstar-u-law"
log_analytics_workspace_resource_group_name = "cstar-u-monitor-rg"

### Aks

aks_name                = "cstar-u-weu-uat01-aks"
aks_resource_group_name = "cstar-u-weu-uat01-aks-rg"

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

# Enrolled payment instrument event hub
eventhub_pim = {
  enrolled_pi_eventhub = "rtd-enrolled-pi"
  revoked_pi_eventhub  = "rtd-revoked-pi"
  namespace_name       = "cstar-u-evh-ns"
  resource_group_name  = "cstar-u-msg-rg"
}

#
# PDV
#
pdv_tokenizer_url = "https://api.uat.tokenizer.pdv.pagopa.it/tokenizer/v1"

#
# Check IBAN
#
checkiban_base_url = "https://bankingservices-sandbox.pagopa.it"

#
# SelfCare API
#
selc_base_url = "https://api.uat.selfcare.pagopa.it"
