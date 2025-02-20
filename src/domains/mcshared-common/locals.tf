locals {
  #
  # Domain label.
  #
  domain = "mcshared"

  #
  # Project label.
  #
  product = "${var.prefix}-${var.env_short}"
  project = "${var.prefix}-${var.env_short}-${local.domain}"

  #
  # Resources tags.
  #
  tags = {
    CreatedBy   = "Terraform"
    Environment = var.env
    Owner       = var.prefix
    Source      = "https://github.com/pagopa/cstar-infrastructure/tree/main/src/domains/mcshared-common"
    CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
    Application = local.domain
  }

  #
  # Network
  #
  mc_public_ip_name                 = "${local.product}-weu-mc-pip"
  vnet_weu_core_name                = "${local.product}-vnet"
  vnet_weu_core_resource_group_name = "${local.product}-vnet-rg"

  #
  # GitHub repositories which must be identified and federated on Azure.
  #
  repositories = [
    {
      repository : "mil-auth"
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
