locals {
  #
  # Domain label.
  #
  domain = "mil"

  #
  # Project label.
  #
  project = "${var.prefix}-${var.env_short}-${local.domain}"

  #
  # Resources tags.
  #
  tags = {
    CreatedBy   = "Terraform"
    Environment = var.env
    Owner       = var.prefix
    Source      = "https://github.com/pagopa/cstar-infrastructure/tree/main/src/domains/mil-common"
    CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
    Application = local.domain
  }

  #
  # GitHub repositories which must be identified and federated on Azure.
  #
  repositories = [
    {
      repository : "mil-debt-position"
    },
    {
      repository : "mil-fee-calculator"
    },
    {
      repository : "mil-idpay"
    },
    {
      repository : "mil-papos"
    },
    {
      repository : "mil-payment-notice"
    },
    {
      repository : "idpay-ipza-mock"
    }
  ]

  #
  # Roles that must be assigned to federated GitHub repository (see above).
  #
  resource_groups_roles_cd = [
    {
      resource_group_id : azurerm_resource_group.sec.id
      role : "Key Vault Reader"
    },
    {
      resource_group_id : azurerm_resource_group.app.id,
      role : "Contributor"
    }
  ]
}
