resource "azurerm_resource_group" "tae_df_rg" {
  count    = var.enable.tae.adf ? 1 : 0
  name     = format("%s-tae-df-rg", local.project)
  location = var.location
  tags     = var.tags
}

module "tae_data_factory" {

  count = var.enable.tae.adf ? 1 : 0

  source = "git::https://github.com/pagopa/azurerm.git//data_factory?ref=v2.18.4"

  # Naming
  location              = var.location
  resource_group_name   = azurerm_resource_group.tae_df_rg[count.index].name
  name                  = format("%s-%s", local.project, "tae") # Transato per Agenzia delle Entrate
  custom_domain_enabled = "tae"

  # Data Factory Repository
  github_conf = {
    account_name    = "pagopa"             # (Required) Specifies the GitHub account name.
    branch_name     = "main"               # - (Required) Specifies the collaboration branch of the repository to get code from.
    git_url         = "https://github.com" # (Required) Specifies the GitHub Enterprise host name. For example: https://github.mydomain.com. Use https://github.com for open source repositories.
    repository_name = "tae-data-factory"   # (Required) Specifies the name of the git repository.
    root_folder     = "/"                  #(Required) Specifies the root folder within the repository. Set to / for the top level.
  }

  # Networking & Security

  private_endpoint = {
    enabled   = true
    subnet_id = module.adf_snet[count.index].id
    private_dns_zone = {
      id   = azurerm_private_dns_zone.adf[count.index].id
      name = azurerm_private_dns_zone.adf[count.index].name
      rg   = azurerm_resource_group.rg_vnet.name
    }
  }

  resources_managed_private_enpoint = tomap(
    {
      (module.cstarblobstorage.id) = "blob"
    }
  )

  # Tags
  tags = var.tags

}

data "azurerm_data_factory" "tae_adf" {

  count = var.enable.tae.adf ? 1 : 0

  name                = format("%s-%s", local.project, "tae")
  resource_group_name = azurerm_resource_group.tae_df_rg[count.index].name
}

data "azurerm_storage_account" "acquirer_sa" {

  count = var.enable.tae.adf ? 1 : 0

  name                = replace(format("%s-blobstorage", local.project), "-", "")
  resource_group_name = format("%s-storage-rg", local.project)
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "tae_adf_sa_linked_service" {

  count = var.enable.tae.adf ? 1 : 0

  resource_group_name = azurerm_resource_group.tae_df_rg[count.index].name
  name                = format("%s-%s-sa-linked-service", local.project, "tae")
  data_factory_id     = data.azurerm_data_factory.tae_adf[count.index].id

  service_endpoint = data.azurerm_storage_account.acquirer_sa[count.index].primary_blob_endpoint

  use_managed_identity = true
}

resource "azurerm_role_assignment" "adf_data_contributor_role_on_sa" {

  count = var.enable.tae.adf ? 1 : 0

  scope                = data.azurerm_storage_account.acquirer_sa[count.index].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_data_factory.tae_adf[count.index].identity[0].principal_id
}


data "azurerm_cosmosdb_account" "mongo" {

  count = var.enable.tae.adf ? 1 : 0

  name                = format("%s-cosmos-mongo-db-account", local.project)
  resource_group_name = format("%s-db-rg", local.project)

}

resource "azurerm_data_factory_linked_service_cosmosdb_mongoapi" "tae_adf_mongo_linked_service" {

  count = var.enable.tae.adf ? 1 : 0

  resource_group_name = azurerm_resource_group.tae_df_rg[count.index].name
  name                = format("%s-%s-mongo-linked-service", local.project, "tae")
  data_factory_id     = data.azurerm_data_factory.tae_adf[count.index].id

  connection_string              = module.cosmosdb_account_mongodb[count.index].connection_strings[0]
  database                       = resource.azurerm_cosmosdb_mongo_database.transaction_aggregate[count.index].name
  server_version_is_32_or_higher = true

}

data "azurerm_storage_account" "sftp_sa" {

  count = var.enable.tae.adf ? 1 : 0

  name                = replace(format("%s-sftp", local.project), "-", "")
  resource_group_name = format("%s-sftp-rg", local.project)
}

resource "azurerm_role_assignment" "adf_data_contributor_role_on_sftp" {

  count = var.enable.tae.adf ? 1 : 0

  scope                = data.azurerm_storage_account.sftp_sa[count.index].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_data_factory.tae_adf[count.index].identity[0].principal_id
}


resource "azurerm_data_factory_linked_service_azure_blob_storage" "tae_adf_sftp_linked_service" {

  count = var.enable.tae.adf ? 1 : 0

  resource_group_name = azurerm_resource_group.tae_df_rg[count.index].name
  name                = format("%s-%s-sftp-linked-service", local.project, "tae")
  data_factory_id     = data.azurerm_data_factory.tae_adf[count.index].id

  service_endpoint = data.azurerm_storage_account.sftp_sa[count.index].primary_blob_endpoint

  use_managed_identity = true
}
