locals {
  product = "${var.prefix}-${var.env_short}"
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"

  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"

  subscription_name = "${var.env}-${var.prefix}"

  azdo_managed_identity_rg_name = "${var.prefix}-${var.env_short}-identity-rg"
  azdo_iac_managed_identities   = toset(["azdo-${var.env}-${var.prefix}-iac-deploy-v2", "azdo-${var.env}-${var.prefix}-iac-plan-v2"])

}

# ------------------------------------------------------------------------------
# Assignment of the following roles to IaC service principals on domain key
# vault:
#   - Key Vault Crypto Officer
#   - Key Vault Certificates Officer
#   - Key Vault Secrets Officer
#
# TODO
# ----
# Evaluate the possibility of creating custom role with the following
# permissions:
#   - keys........: Get, List, Import
#   - secrets.....: Get, List, Set
#   - certificates: SetIssuers, DeleteIssuers, Purge, List, Get, Import
# ------------------------------------------------------------------------------

locals {
  iac_roles = [
    "Key Vault Crypto Officer",
    "Key Vault Certificates Officer",
    "Key Vault Secrets Officer"
  ]
}
