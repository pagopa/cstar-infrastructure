locals {
  product = "${var.prefix}-${var.env_short}"
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"

  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"

  subscription_name = "${var.env}-${var.prefix}"

  azdo_managed_identity_rg_name = "${var.prefix}-${var.env_short}-identity-rg"
  azdo_iac_managed_identities   = toset(["azdo-${var.env}-${var.prefix}-iac-deploy-v2", "azdo-${var.env}-${var.prefix}-iac-plan-v2"])

  input_file = "./secret/${var.env}/configs.json"

  tags = {
    CreatedBy   = "Terraform"
    Environment = upper(var.env)
    Owner       = "CSTAR"
    Source      = "https://github.com/pagopa/cstar-infrastructure"
    CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
    Folder      = basename(abspath(path.module))
  }
}
