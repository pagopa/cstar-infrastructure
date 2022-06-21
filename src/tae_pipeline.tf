resource "azurerm_data_factory_pipeline" "test" {
  
  count = var.enable.tae.adf ? 1 : 0
  resource_group_name = azurerm_resource_group.tae_df_rg[count.index].name

  name            = "test"
  data_factory_id = data.azurerm_data_factory.tae_adf[count.index].id
  variables = {
    "bob" = "item1"
  }
  activities_json = <<JSON
[
    {
        "name": "Append variable1",
        "type": "AppendVariable",
        "dependsOn": [],
        "userProperties": [],
        "typeProperties": {
            "variableName": "bob",
            "value": "something"
        }
    }
]
  JSON
}