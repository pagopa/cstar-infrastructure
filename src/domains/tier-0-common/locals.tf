locals {
  #
  # Domain label.
  #
  domain = "tier-0"

  #
  # Project label.
  #
  project = "${var.prefix}-${var.env_short}-${local.domain}"

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
