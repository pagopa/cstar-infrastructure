locals {
  #
  # Application label.
  #
  application = "mil"

  #
  # Project label.
  #
  project = "${var.prefix}-${var.env_short}-${local.application}"

  #
  # Resources tags.
  #
  tags = {
    CreatedBy   = "Terraform"
    Environment = var.env
    Owner       = var.prefix
    Source      = "https://github.com/pagopa/cstar-infrastructure/tree/main/src/domains/mil-common"
    CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
    Application = local.application
  }
}
