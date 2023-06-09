{
    "name": "If rowsCopiedToCosmos equals rowsCopiedOnIntContainer",
    "type": "IfCondition",
    "dependsOn": [
        {
            "activity": "If rowsCopiedToCosmos equals rowsCopiedToSFTP",
            "dependencyConditions": [
                "Succeeded"
            ]
        }
    ],
    "userProperties": [],
    "typeProperties": {
        "expression": {
            "value": "@equals(variables('rowsCopiedToCosmos'),string(activity('AggregatesOnIntegrationContainer').output.rowsCopied))",
            "type": "Expression"
        },
        "ifFalseActivities": [
            {
                "name": "Fail rowsCopiedToCosmos equals rowsCopiedOnIntContainer",
                "type": "Fail",
                "dependsOn": [],
                "userProperties": [],
                "typeProperties": {
                    "message": {
                        "value": "@concat('rowsCopiedToCosmos (',variables('rowsCopiedToCosmos'),') not equal to rowsCopiedToLog (',string(activity('AggregatesOnIntegrationContainer').output.rowsCopied),')')",
                        "type": "Expression"
                    },
                    "errorCode": "412"
                }
            }
        ]
    }
}
