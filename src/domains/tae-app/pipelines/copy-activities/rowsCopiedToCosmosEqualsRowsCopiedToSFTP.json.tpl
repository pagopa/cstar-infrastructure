{
                "name": "If rowsCopiedToCosmos equals rowsCopiedToSFTP",
                "type": "IfCondition",
                "dependsOn": [
                    {
                        "activity": "If rowsCopiedToCosmos equals rowsCopiedToLog",
                        "dependencyConditions": [
                            "Succeeded"
                        ]
                    }
                ],
                "userProperties": [],
                "typeProperties": {
                    "expression": {
                        "value": "@equals(variables('rowsCopiedToCosmos'),string(activity('AggregatesToSftp').output.rowsCopied))",
                        "type": "Expression"
                    },
                    "ifFalseActivities": [
                        {
                            "name": "Fail rowsCopiedToCosmos equals rowsCopiedToSFTP",
                            "type": "Fail",
                            "dependsOn": [],
                            "userProperties": [],
                            "typeProperties": {
                                "message": {
                                    "value": "@concat('rowsCopiedToCosmos (',variables('rowsCopiedToCosmos'),') not equal to rowsCopiedToLog (',string(activity('AggregatesToSftp').output.rowsCopied),')')",
                                    "type": "Expression"
                                },
                                "errorCode": "412"
                            }
                        }
                    ]
                }
            }
