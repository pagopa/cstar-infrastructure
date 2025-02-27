locals {
  project      = "${var.prefix}-${var.env_short}"
  project_pair = "${var.prefix}-${var.env_short}-${var.location_pair_short}"

  aks_network_prefix = local.project
  aks_network_indexs = {
    for n in var.aks_networks :
    index(var.aks_networks.*.domain_name, n.domain_name) => n
  }

  #
  # Platform
  #
  rg_container_registry_common_name = "${local.project}-container-registry-rg"
  container_registry_common_name    = "${local.project}-common-acr"

  #
  # IdPay
  #
  idpay_rg_keyvault_name = "${local.project}-idpay-sec-rg"
  idpay_keyvault_name    = "${local.project}-idpay-kv"

  #
  # RTD
  #
  rtd_rg_keyvault_name = "${local.project}-rtd-sec-rg"
  rtd_keyvault_name    = "${local.project}-rtd-kv"

  # Temporary fallback to old ingress over non-dev environments
  ingress_load_balancer_hostname_https = "https://${var.ingress_load_balancer_hostname}"

  # Azure DevOps
  azuredevops_agent_vm_app_name   = "${local.project}-vmss-ubuntu-app-azdoa"
  azuredevops_agent_vm_infra_name = "${local.project}-vmss-ubuntu-infra-next-azdoa"
  azuredevops_agent_vm_perf_name  = "${local.project}-vmss-ubuntu-perf-azdoa"
  azuredevops_rg_name             = "${local.project}-azdoa-rg"
  azuredevops_subnet_name         = "${local.project}-azdoa-snet"

  # Dns Forwarder
  dns_forwarder_vm_image_name = "${local.project}-dns-forwarder-ubuntu2204-image-v1"

  apim_hostname = "api%{if var.env_short == "p"}.%{else}.${var.env}.%{endif}cstar.pagopa.it"

  azdo_managed_identity_rg_name = "${var.prefix}-${var.env_short}-identity-rg"
  azdo_iac_managed_identities   = toset(["azdo-${var.env}-${var.prefix}-iac-deploy-v2", "azdo-${var.env}-${var.prefix}-iac-plan-v2"])

  vnet_securehub_rg_name             = "${var.prefix}-${var.env_short}-itn-core-network-rg"
  vnet_securehub_core_hub_name       = "${var.prefix}-${var.env_short}-itn-core-hub-vnet"
  vnet_securehub_spoke_platform_name = "${var.prefix}-${var.env_short}-itn-core-spoke-platform-vnet"

  secure_hub_vnets = { for r in data.azurerm_resources.vnets_secure_hub.resources : r.id => r }
  all_vnets        = { for vnet in data.azurerm_resources.vnets.resources : vnet.id => vnet }
}
