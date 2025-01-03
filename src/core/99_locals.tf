locals {
  apim_hostname = "api%{if var.env_short == "p"}.%{else}.${var.env}.%{endif}cstar.pagopa.it"

  azdo_managed_identity_rg_name = "${var.prefix}-${var.env_short}-identity-rg"
  azdo_iac_managed_identities   = toset(["azdo-${var.env}-${var.prefix}-iac-deploy-v2", "azdo-${var.env}-${var.prefix}-iac-plan-v2"])

}
