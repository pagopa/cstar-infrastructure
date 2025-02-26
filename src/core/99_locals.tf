locals {
  apim_hostname = "api%{if var.env_short == "p"}.%{else}.${var.env}.%{endif}cstar.pagopa.it"

  azdo_managed_identity_rg_name = "${var.prefix}-${var.env_short}-identity-rg"
  azdo_iac_managed_identities   = toset(["azdo-${var.env}-${var.prefix}-iac-deploy-v2", "azdo-${var.env}-${var.prefix}-iac-plan-v2"])

  vnet_securehub_rg_name             = "${var.prefix}-${var.env_short}-itn-core-network-rg"
  vnet_securehub_core_hub_name       = "${var.prefix}-${var.env_short}-itn-core-hub-vnet"
  vnet_securehub_spoke_platform_name = "${var.prefix}-${var.env_short}-itn-core-spoke-platform-vnet"

  secure_hub_vnets = { for r in data.azurerm_resources.vnets_secure_hub.resources : r.id => r }
  all_vnets        = { for vnet in data.azurerm_resources.vnets.resources : vnet.id => vnet }
}
