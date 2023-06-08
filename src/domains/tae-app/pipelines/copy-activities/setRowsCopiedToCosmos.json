{
    "name": "Set rowsCopiedToCosmos",
    "type": "SetVariable",
    "dependsOn": [
        {
            "activity": "SenderAggregatesToDatastore",
            "dependencyConditions": [
                "Succeeded"
            ]
        }
    ],
    "userProperties": [],
    "typeProperties": {
        "variableName": "rowsCopiedToCosmos",
        "value": {
            "value": "@string(activity('SenderAggregatesToDatastore').output.rowsCopied)",
            "type": "Expression"
        }
    }
}