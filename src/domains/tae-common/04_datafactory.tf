resource "azurerm_resource_group" "data_factory_rg" {
  name     = "${local.project}-df-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_data_factory" "data_factory" {
  name                   = "${local.project}-df"
  location               = azurerm_resource_group.data_factory_rg.location
  resource_group_name    = azurerm_resource_group.data_factory_rg.name
  public_network_enabled = false

  # Still doesn't work: https://github.com/hashicorp/terraform-provider-azurerm/issues/12949
  managed_virtual_network_enabled = true

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_data_factory_integration_runtime_azure" "autoresolve" {
  name = "AutoResolveIntegrationRuntime"
  # resource_group_name     = azurerm_resource_group.data_factory_rg.name
  data_factory_id         = azurerm_data_factory.data_factory.id
  location                = "AutoResolve"
  virtual_network_enabled = true
}

resource "azurerm_private_endpoint" "data_factory_pe" {

  name                = "${azurerm_data_factory.data_factory.name}-pe"
  location            = azurerm_resource_group.data_factory_rg.location
  resource_group_name = azurerm_resource_group.data_factory_rg.name
  subnet_id           = data.azurerm_subnet.private_endpoint_snet.id

  private_dns_zone_group {
    name                 = "${azurerm_data_factory.data_factory.name}-private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.adf.id]
  }

  private_service_connection {
    name                           = "${azurerm_data_factory.data_factory.name}-private-service-connection"
    private_connection_resource_id = azurerm_data_factory.data_factory.id
    is_manual_connection           = false
    subresource_names              = ["datafactory"]
  }

  tags = var.tags
}

resource "azurerm_private_dns_a_record" "data_factory_a_record" {

  name                = azurerm_data_factory.data_factory.name
  zone_name           = data.azurerm_private_dns_zone.adf.name
  resource_group_name = data.azurerm_private_dns_zone.adf.resource_group_name
  ttl                 = 300
  records             = azurerm_private_endpoint.data_factory_pe.private_service_connection.*.private_ip_address

  tags = var.tags
}

resource "azurerm_data_factory_managed_private_endpoint" "managed_pe" {
  for_each = tomap(
    {
      (data.azurerm_storage_account.acquirer_sa.id)   = ["blob", "cstar${var.env_short}blobstorage.blob.core.windows.net"],
      (data.azurerm_storage_account.sftp_sa.id)       = ["blob", "cstar${var.env_short}sftp.blob.core.windows.net"],
      (module.cosmosdb_account.id)                    = ["SQL", "cstar-${var.env_short}-weu-tae-cosmos-db-account.documents.azure.com"],
      (data.azurerm_kusto_cluster.dexp_cluster[0].id) = ["cluster", ""]
    }
  )
  name               = replace(format("%s-%s-mng-private-endpoint", azurerm_data_factory.data_factory.name, substr(sha256(each.key), 0, 3)), "-", "_")
  data_factory_id    = azurerm_data_factory.data_factory.id
  target_resource_id = each.key
  subresource_name   = each.value[0]
  # fqdns              = [each.value[1]]
  fqdns = each.value[1] == "" ? null : [each.value[1]]
}

resource "azurerm_role_assignment" "adf_data_contributor_role_on_sa" {
  scope                = data.azurerm_storage_account.acquirer_sa.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.data_factory.identity[0].principal_id
}

resource "azurerm_role_assignment" "adf_data_contributor_role_on_sftp" {
  scope                = data.azurerm_storage_account.sftp_sa.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.data_factory.identity[0].principal_id
}

resource "azurerm_role_definition" "adf_pipeline_run_role" {
  name        = "${local.project}-df-run-pipeline-role"
  scope       = azurerm_data_factory.data_factory.id
  description = "ADF RunPipeline Role created via Terraform"

  permissions {
    actions     = ["Microsoft.DataFactory/factories/pipelines/createrun/action"]
    not_actions = []
  }

  assignable_scopes = [
    azurerm_data_factory.data_factory.id # automatically added, I put it here for clarity
  ]
}

resource "azurerm_role_assignment" "adf_pipeline_run_to_ops" {
  scope                = azurerm_data_factory.data_factory.id
  role_definition_name = azurerm_role_definition.adf_pipeline_run_role.name
  principal_id         = data.azuread_group.adgroup_operations.id
}
