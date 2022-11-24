resource "azurerm_data_factory_custom_dataset" "enrolled_payment_instrument_dataset" {

  name            = "enrolled_payment_instrument_dataset"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  type            = "CosmosDbMongoDbApiCollection"

  linked_service {
    name = azurerm_data_factory_linked_service_cosmosdb_mongoapi.cosmos_linked_service.name
  }

  type_properties_json = <<JSON
  {
    "collection": "enrolled_payment_instrument"
  }
  JSON

  description = "Enrolled payment instrument to be stored into a blob CSV"
  annotations = ["enrolled-hpan-dataset"]
}

resource "azurerm_data_factory_custom_dataset" "hpans_blob_csv_destination" {

  for_each = var.hpan_blob_storage_container_name

  name            = "hpans_blob_csv_destination_${each.key}"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  type            = "DelimitedText"

  linked_service {
    name = azurerm_data_factory_linked_service_azure_blob_storage.storage_account_linked_service.name
  }

  type_properties_json = <<JSON
  {
    "location": {
        "type": "AzureBlobStorageLocation",
        "container": "${var.hpan_blob_storage_container_name[each.key]}"
    },
    "columnDelimiter": ",",
    "escapeChar": "\\",
    "quoteChar": ""
  }
  JSON

  description = "Destination blob storage csv hpans"
}

resource "azurerm_data_factory_custom_dataset" "binary_source_dataset" {

  for_each = var.hpan_blob_storage_container_name

  name            = "binary_source_dataset_${each.key}"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  type            = "Binary"

  linked_service {
    name = azurerm_data_factory_linked_service_azure_blob_storage.storage_account_linked_service.name
  }

  parameters = {
    filenamePattern = ""
  }

  type_properties_json = <<JSON
  {
    "location": {
        "type": "AzureBlobStorageLocation",
        "fileName": {
            "value": "@dataset().filenamePattern",
            "type": "Expression"
        },
        "container": "${var.hpan_blob_storage_container_name[each.key]}"
    }
  }
  JSON
}

resource "azurerm_data_factory_custom_dataset" "binary_destination_dataset" {

  for_each = var.hpan_blob_storage_container_name

  name            = "binary_destination_dataset_${each.key}"
  data_factory_id = data.azurerm_data_factory.datafactory.id
  type            = "Binary"

  linked_service {
    name = azurerm_data_factory_linked_service_azure_blob_storage.storage_account_linked_service.name
  }

  parameters = {
    filename = ""
  }

  type_properties_json = <<JSON
  {
    "location": {
        "type": "AzureBlobStorageLocation",
        "fileName": {
            "value": "@dataset().filename",
            "type": "Expression"
        },
        "container": "${var.hpan_blob_storage_container_name[each.key]}"
    },
    "compression": {
        "type": "ZipDeflate",
        "level": "Fastest"
    }
  }
  JSON
}