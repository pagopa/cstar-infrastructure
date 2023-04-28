{
  "version": "Notebook/1.0",
  "items": [
    {
      "type": 1,
      "content": {
        "json": "### This workbook is intended to show the performance observed during the enrollment instrument from issuer processing. \r\nFor more functional information about the enrollment instrument from issuer see:\r\nhttps://pagopa.atlassian.net/wiki/spaces/IDPAY/pages/504627600/Analisi+funzionale+dei+servizi+del+beneficiario#Servizi-del-beneficiario---APP-ISSUER\r\n\r\nFor more technical information about the enrollment instrument from issuer see: \r\nhttps://pagopa.atlassian.net/wiki/spaces/IDPAY/pages/506954092/Servizi+del+Beneficiario#API-%5BIssuer%5D---Enrollment-di-un-Metodo-di-Pagamento-%E2%80%93-Fase-di-Enrollment"
      },
      "name": "text - 2"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Parameters",
        "items": [
          {
            "type": 1,
            "content": {
              "json": "These parameters are required, you can choose all of them or just one, it depends on what you want to observe.\r\n\r\nThe parameter **apps** contains all the microservices needed in this flow.\r\n\r\nThe parameter **innerSteps** contains the references to the single's API inside of each microservice.\r\n\r\nUse the **eventHubname** parameter above to see one or multiple queue in this flow. \r\n\r\n",
              "style": "info"
            },
            "showPin": false,
            "name": "text - 1"
          }
        ]
      },
      "name": "Parameters"
    },
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "parameters": [
          {
            "id": "42e3cbc4-8a7f-4b7c-93a3-b832459ead7c",
            "version": "KqlParameterItem/1.0",
            "name": "timeRange",
            "type": 4,
            "isRequired": true,
            "typeSettings": {
              "selectableValues": [
                {
                  "durationMs": 300000
                },
                {
                  "durationMs": 900000
                },
                {
                  "durationMs": 1800000
                },
                {
                  "durationMs": 86400000
                }
              ],
              "allowCustom": true
            },
            "timeContext": {
              "durationMs": 86400000
            },
            "value": {
              "durationMs": 120000,
              "endTime": "2023-03-06T13:43:00.000Z"
            }
          },
          {
            "id": "46787506-eb62-4d3f-a4fd-c8bf3877672e",
            "version": "KqlParameterItem/1.0",
            "name": "timeSpan",
            "type": 10,
            "description": "The timespan used to aggregate data",
            "isRequired": true,
            "typeSettings": {
              "additionalResourceOptions": [],
              "showDefault": false
            },
            "jsonData": "[\r\n{\"label\": \"500ms\", \"value\": 500, \"selected\": false},\r\n{\"label\": \"1s\", \"value\": 1000, \"selected\": false},\r\n{\"label\": \"10s\", \"value\": 10000, \"selected\": true},\r\n{\"label\": \"30s\", \"value\": 30000, \"selected\": false},\r\n{\"label\": \"1m\", \"value\": 60000, \"selected\": false},\r\n{\"label\": \"2m\", \"value\": 120000, \"selected\": false}\r\n]",
            "timeContext": {
              "durationMs": 86400000
            }
          },
          {
            "id": "f1209eb8-12a8-4ad5-9958-313e4a9360bf",
            "version": "KqlParameterItem/1.0",
            "name": "apps",
            "type": 2,
            "isRequired": true,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "typeSettings": {
              "additionalResourceOptions": [
                "value::all"
              ],
              "showDefault": false
            },
            "jsonData": "[\r\n        {\"value\": \"idpay-wallet\", \"selected\": true},\r\n        {\"value\": \"idpay-payment-instrument\", \"selected\": true},\r\n        {\"value\": \"idpay-reward-calculator\", \"selected\": true},\r\n        {\"value\": \"idpay-timeline\", \"selected\": true}\r\n\r\n\r\n]",
            "timeContext": {
              "durationMs": 86400000
            }
          },
          {
            "id": "f827f452-987f-4855-a8a2-7fd54f3560b1",
            "version": "KqlParameterItem/1.0",
            "name": "dbCollections",
            "type": 2,
            "isRequired": true,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "isHiddenWhenLocked": true,
            "typeSettings": {
              "additionalResourceOptions": [
                "value::all"
              ],
              "showDefault": false
            },
            "jsonData": "[\r\n    \"wallet\",\r\n    \"payment_instrument\",\r\n    \"hpan_initiatives_lookup\",\r\n    \"timeline\"\r\n]\r\n",
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange",
            "value": [
              "value::all"
            ]
          },
          {
            "id": "dd6af48d-6dfb-4572-9a5e-2409600397ea",
            "version": "KqlParameterItem/1.0",
            "name": "flows",
            "type": 2,
            "isRequired": true,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "isHiddenWhenLocked": true,
            "typeSettings": {
              "additionalResourceOptions": [
                "value::all"
              ],
              "showDefault": false
            },
            "jsonData": "[\r\n   {\"label\": \"idpay-wallet\", \"value\": \"ENROLL_INSTRUMENT_ISSUER\",    \"selected\": true},\r\n   {\"label\": \"idpay-wallet\", \"value\": \"PROCESS_ACK\", \"selected\": true},\r\n   {\"label\": \"idpay-payment-instrument\", \"value\": \"ENROLL_FROM_ISSUER\", \"selected\": true},\r\n   {\"label\": \"idpay-payment-instrument\", \"value\": \"PROCESS_RTD_MESSAGE\", \"selected\": true},\r\n   {\"label\": \"idpay-payment-instrument\", \"value\": \"PROCESS_ACK_FROM_RULE_ENGINE\", \"selected\": true},\r\n   {\"label\": \"idpay-reward-calculator\", \"value\": \"HPAN_INITIATIVE_OP\", \"selected\": true},\r\n   {\"label\": \"idpay-timeline \", \"value\": \"SAVE_OPERATION\", \"selected\": true}\r\n\r\n]",
            "timeContext": {
              "durationMs": 86400000
            }
          },
          {
            "id": "509368cc-acfe-43c2-8e98-3219118a845d",
            "version": "KqlParameterItem/1.0",
            "name": "innerSteps",
            "type": 2,
            "isRequired": true,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "typeSettings": {
              "additionalResourceOptions": [
                "value::all"
              ],
              "showDefault": false
            },
            "jsonData": "[\r\n        {\"label\": \"Enroll Instrument from wallet\", \"value\": \"{\\\"label\\\": \\\"Enroll Instrument from wallet\\\", \\\"value\\\": \\\"ENROLL_INSTRUMENT_ISSUER\\\"}\", \"selected\": true},\r\n        {\"label\": \"Processing ack from wallet\", \"value\": \"{\\\"label\\\": \\\"Processing l'ack from wallet\\\", \\\"value\\\": \\\"PROCESS_ACK\\\"}\", \"selected\": true},\r\n\t\t{\"label\": \"Enroll Instrument from PI\", \"value\": \"{\\\"label\\\": \\\"Enroll Instrument from PI\\\", \\\"value\\\": \\\"ENROLL_FROM_ISSUER\\\"}\", \"selected\": true},\r\n        {\"label\": \"Process rtd ack from PI\", \"value\": \"{\\\"label\\\": \\\"Process rtd ack from PI\\\", \\\"value\\\": \\\"PROCESS_RTD_MESSAGE\\\"}\", \"selected\": true},\r\n        {\"label\": \"Process rule engine ack from PI\", \"value\": \"{\\\"label\\\": \\\"Process rule engine ack from PI\\\", \\\"value\\\": \\\"PROCESS_ACK_FROM_RULE_ENGINE\\\"}\", \"selected\": true},\r\n        {\"label\": \"Reward Calculator save instrument\", \"value\": \"{\\\"label\\\": \\\"Reward Calculator save instrument\\\", \\\"value\\\": \\\"HPAN_INITIATIVE_OP\\\"}\", \"selected\": true},\r\n        {\"label\": \"Timeline save operation\", \"value\": \"{\\\"label\\\": \\\"Timeline save operation\\\", \\\"value\\\": \\\"SAVE_OPERATION\\\"}\", \"selected\": true}\r\n]"
          },
          {
            "id": "c4825ba3-5603-4bd4-a2e4-e172c3aa12c5",
            "version": "KqlParameterItem/1.0",
            "name": "eventHubName",
            "type": 2,
            "isRequired": true,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "typeSettings": {
              "additionalResourceOptions": [
                "value::all"
              ],
              "showDefault": false
            },
            "jsonData": "[\r\n    \"idpay-hpan-update\",\r\n    \"idpay-hpan-update-outcome\"\r\n]",
            "value": [
              "value::all"
            ]
          },
          {
            "id": "8ac41983-2bc2-4160-b21e-6b49bca1a5ad",
            "version": "KqlParameterItem/1.0",
            "name": "operationName",
            "type": 2,
            "isRequired": true,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "typeSettings": {
              "additionalResourceOptions": [
                "value::all"
              ],
              "showDefault": false
            },
            "jsonData": "[\r\n        {\"value\": \"${env_short}-idpay-issuer-wallet;rev=1 - enrollInstrument\", \"selected\": true}\r\n\r\n]",
            "value": [
              "${env_short}-idpay-issuer-wallet;rev=1 - enrollInstrument"
            ]
          },
          {
            "id": "de4d170d-642c-4c7b-8dda-6cbeea968c9a",
            "version": "KqlParameterItem/1.0",
            "name": "totalFailureCode",
            "type": 2,
            "isRequired": true,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "isHiddenWhenLocked": true,
            "typeSettings": {
              "additionalResourceOptions": [
                "value::all"
              ],
              "showDefault": false
            },
            "jsonData": "[\r\n  {\"value\": \"400\", \"selected\": true},\r\n  {\"value\": \"401\", \"selected\": true},\r\n  {\"value\": \"403\", \"selected\": true},\r\n  {\"value\": \"405\", \"selected\": true},\r\n  {\"value\": \"406\", \"selected\": true},\r\n  {\"value\": \"407\", \"selected\": true},\r\n  {\"value\": \"408\", \"selected\": true},\r\n  {\"value\": \"409\", \"selected\": true},\r\n  {\"value\": \"410\", \"selected\": true},\r\n  {\"value\": \"411\", \"selected\": true},\r\n  {\"value\": \"412\", \"selected\": true},\r\n  {\"value\": \"413\", \"selected\": true},\r\n  {\"value\": \"414\", \"selected\": true},\r\n  {\"value\": \"415\", \"selected\": true},\r\n  {\"value\": \"416\", \"selected\": true},\r\n  {\"value\": \"417\", \"selected\": true},\r\n  {\"value\": \"418\", \"selected\": true},\r\n  {\"value\": \"422\", \"selected\": true},\r\n  {\"value\": \"425\", \"selected\": true},\r\n  {\"value\": \"426\", \"selected\": true},\r\n  {\"value\": \"428\", \"selected\": true},\r\n  {\"value\": \"429\", \"selected\": true},\r\n  {\"value\": \"431\", \"selected\": true},\r\n  {\"value\": \"451\", \"selected\": true},\r\n  {\"value\": \"500\", \"selected\": true},\r\n  {\"value\": \"501\", \"selected\": true},\r\n  {\"value\": \"502\", \"selected\": true},\r\n  {\"value\": \"503\", \"selected\": true},\r\n  {\"value\": \"504\", \"selected\": true},\r\n  {\"value\": \"505\", \"selected\": true},\r\n  {\"value\": \"506\", \"selected\": true},\r\n  {\"value\": \"507\", \"selected\": true},\r\n  {\"value\": \"508\", \"selected\": true},\r\n  {\"value\": \"510\", \"selected\": true},\r\n  {\"value\": \"511\", \"selected\": true}\r\n]\r\n",
            "value": [
              "400",
              "401",
              "403",
              "405",
              "406",
              "407",
              "408",
              "409",
              "410",
              "411",
              "412",
              "413",
              "414",
              "415",
              "416",
              "417",
              "418",
              "422",
              "425",
              "426",
              "428",
              "429",
              "431",
              "451",
              "500",
              "501",
              "502",
              "503",
              "504",
              "505",
              "506",
              "507",
              "508",
              "510",
              "511"
            ]
          },
          {
            "id": "a830953a-cb62-4189-bf2a-6d472b6b232f",
            "version": "KqlParameterItem/1.0",
            "name": "podName",
            "type": 2,
            "isRequired": true,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "isHiddenWhenLocked": true,
            "typeSettings": {
              "additionalResourceOptions": [
                "value::all"
              ],
              "showDefault": false
            },
            "jsonData": "[\r\n    \"idpayonboardingworkflow\",\r\n    \"idpaywallet\",\r\n    \"idpaypaymentinstrument\",\r\n    \"idpayiban\",\r\n    \"idpaytimeline\",\r\n    \"idpaynotificationmanager\"\r\n]",
            "value": [
              "value::all"
            ]
          },
          {
            "id": "0ea6b1cd-fab1-4bed-a5f9-c6eed1422e65",
            "version": "KqlParameterItem/1.0",
            "name": "totalResponseCode",
            "type": 2,
            "isRequired": true,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "typeSettings": {
              "additionalResourceOptions": [
                "value::all"
              ],
              "selectAllValue": "",
              "showDefault": false
            },
            "jsonData": "[\r\n  {\"value\": \"200\", \"selected\": true},\r\n  {\"value\": \"201\", \"selected\": true},\r\n  {\"value\": \"202\", \"selected\": true},\r\n  {\"value\": \"204\", \"selected\": true},\r\n  {\"value\": \"206\", \"selected\": true},\r\n  {\"value\": \"400\", \"selected\": true},\r\n  {\"value\": \"401\", \"selected\": true},\r\n  {\"value\": \"403\", \"selected\": true},\r\n  {\"value\": \"404\", \"selected\": true},\r\n  {\"value\": \"405\", \"selected\": true},\r\n  {\"value\": \"406\", \"selected\": true},\r\n  {\"value\": \"407\", \"selected\": true},\r\n  {\"value\": \"408\", \"selected\": true},\r\n  {\"value\": \"409\", \"selected\": true},\r\n  {\"value\": \"410\", \"selected\": true},\r\n  {\"value\": \"411\", \"selected\": true},\r\n  {\"value\": \"412\", \"selected\": true},\r\n  {\"value\": \"413\", \"selected\": true},\r\n  {\"value\": \"414\", \"selected\": true},\r\n  {\"value\": \"415\", \"selected\": true},\r\n  {\"value\": \"416\", \"selected\": true},\r\n  {\"value\": \"417\", \"selected\": true},\r\n  {\"value\": \"418\", \"selected\": true},\r\n  {\"value\": \"422\", \"selected\": true},\r\n  {\"value\": \"425\", \"selected\": true},\r\n  {\"value\": \"426\", \"selected\": true},\r\n  {\"value\": \"428\", \"selected\": true},\r\n  {\"value\": \"429\", \"selected\": true},\r\n  {\"value\": \"431\", \"selected\": true},\r\n  {\"value\": \"451\", \"selected\": true},\r\n  {\"value\": \"500\", \"selected\": true},\r\n  {\"value\": \"501\", \"selected\": true},\r\n  {\"value\": \"502\", \"selected\": true},\r\n  {\"value\": \"503\", \"selected\": true},\r\n  {\"value\": \"504\", \"selected\": true},\r\n  {\"value\": \"505\", \"selected\": true},\r\n  {\"value\": \"506\", \"selected\": true},\r\n  {\"value\": \"507\", \"selected\": true},\r\n  {\"value\": \"508\", \"selected\": true},\r\n  {\"value\": \"510\", \"selected\": true},\r\n  {\"value\": \"511\", \"selected\": true}\r\n]\r\n",
            "value": [
              "200",
              "201",
              "202",
              "204",
              "206",
              "400",
              "401",
              "403",
              "404",
              "405",
              "406",
              "407",
              "408",
              "409",
              "410",
              "411",
              "412",
              "413",
              "414",
              "415",
              "416",
              "417",
              "418",
              "422",
              "425",
              "426",
              "428",
              "429",
              "431",
              "451",
              "500",
              "501",
              "502",
              "503",
              "504",
              "505",
              "506",
              "507",
              "508",
              "510",
              "511"
            ]
          },
          {
            "id": "e20dc5c3-66c4-414b-b737-109fa04e1ec5",
            "version": "KqlParameterItem/1.0",
            "name": "totalSuccessCode",
            "type": 2,
            "isRequired": true,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "isHiddenWhenLocked": true,
            "typeSettings": {
              "additionalResourceOptions": [
                "value::all"
              ],
              "showDefault": false
            },
            "jsonData": "[\r\n  {\"value\": \"200\", \"selected\": true},\r\n  {\"value\": \"201\", \"selected\": true},\r\n  {\"value\": \"202\", \"selected\": true},\r\n  {\"value\": \"204\", \"selected\": true},\r\n  {\"value\": \"206\", \"selected\": true},\r\n  {\"value\": \"404\", \"selected\": true}\r\n]",
            "value": [
              "200",
              "201",
              "202",
              "204",
              "206",
              "404"
            ]
          }
        ],
        "style": "pills",
        "queryType": 0,
        "resourceType": "microsoft.insights/components"
      },
      "name": "parameters - 0"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Result Code Details",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "let startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\nlet interval = endTime-startTime;\r\nlet totalCount = requests\r\n| where timestamp between (startTime .. endTime)\r\n| where operation_Name in ({operationName})\r\n| summarize Total = count() by operation_Name;\r\nlet data = requests\r\n| where timestamp between (startTime .. endTime)\r\n| where operation_Name in ({operationName})\r\n| where resultCode in ({totalResponseCode});\r\ndata\r\n| join kind=inner totalCount on operation_Name\r\n| summarize Count = count(), Users = dcount(user_Id) by operation_Name, resultCode, Total//, timestamp=bin(timestamp,interval)\r\n| project ['Request Name'] = operation_Name, ['Result Code'] = resultCode, ['Total Response'] = Count, ['Rate %'] = (Count*100)/Total, ['Users Affected'] = Users\r\n| sort by ['Request Name']\r\n",
              "size": 0,
              "showAnalytics": true,
              "queryType": 0,
              "resourceType": "microsoft.insights/components",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
              ],
              "gridSettings": {
                "formatters": [
                  {
                    "columnMatch": "Result Code",
                    "formatter": 18,
                    "formatOptions": {
                      "thresholdsOptions": "icons",
                      "thresholdsGrid": [
                        {
                          "operator": "==",
                          "thresholdValue": "429",
                          "representation": "4",
                          "text": "{0}{1}"
                        },
                        {
                          "operator": "==",
                          "thresholdValue": "404",
                          "representation": "success",
                          "text": "{0}{1}"
                        },
                        {
                          "operator": "startsWith",
                          "thresholdValue": "5",
                          "representation": "4",
                          "text": "{0}{1}"
                        },
                        {
                          "operator": "startsWith",
                          "thresholdValue": "2",
                          "representation": "success",
                          "text": "{0}{1}"
                        },
                        {
                          "operator": "Default",
                          "thresholdValue": null,
                          "representation": "warning",
                          "text": "{0}{1}"
                        }
                      ]
                    }
                  },
                  {
                    "columnMatch": "Total Response",
                    "formatter": 8,
                    "formatOptions": {
                      "min": 1,
                      "palette": "blue"
                    }
                  },
                  {
                    "columnMatch": "Rate %",
                    "formatter": 8,
                    "formatOptions": {
                      "min": 0,
                      "max": 100,
                      "palette": "yellowGreenBlue"
                    },
                    "numberFormat": {
                      "unit": 1,
                      "options": {
                        "style": "decimal",
                        "useGrouping": false
                      }
                    }
                  },
                  {
                    "columnMatch": "Users Affected",
                    "formatter": 8,
                    "formatOptions": {
                      "min": 0,
                      "palette": "blueDark"
                    }
                  },
                  {
                    "columnMatch": "Group",
                    "formatter": 1
                  },
                  {
                    "columnMatch": "Failed with Result Code",
                    "formatter": 18,
                    "formatOptions": {
                      "thresholdsOptions": "icons",
                      "thresholdsGrid": [
                        {
                          "operator": "startsWith",
                          "thresholdValue": "5",
                          "representation": "4",
                          "text": "{0}{1}"
                        },
                        {
                          "operator": "==",
                          "thresholdValue": "429",
                          "representation": "4",
                          "text": "{0}{1}"
                        },
                        {
                          "operator": "startsWith",
                          "thresholdValue": "2",
                          "representation": "success",
                          "text": "{0}{1}"
                        },
                        {
                          "operator": "==",
                          "thresholdValue": "404",
                          "representation": "success",
                          "text": "{0}{1}"
                        },
                        {
                          "operator": "Default",
                          "thresholdValue": null,
                          "representation": "2",
                          "text": "{0}{1}"
                        }
                      ],
                      "compositeBarSettings": {
                        "labelText": "",
                        "columnSettings": [
                          {
                            "columnName": "Failed with Result Code",
                            "color": "blue"
                          }
                        ]
                      }
                    },
                    "numberFormat": {
                      "unit": 0,
                      "options": {
                        "style": "decimal"
                      }
                    }
                  },
                  {
                    "columnMatch": "Total Failures",
                    "formatter": 8,
                    "formatOptions": {
                      "min": 1,
                      "palette": "blue"
                    }
                  },
                  {
                    "columnMatch": "Failure rate %",
                    "formatter": 8,
                    "formatOptions": {
                      "min": 0,
                      "max": 100,
                      "palette": "redGreen"
                    }
                  }
                ]
              },
              "sortBy": [],
              "tileSettings": {
                "showBorder": false,
                "titleContent": {
                  "columnMatch": "Request Name",
                  "formatter": 1
                },
                "leftContent": {
                  "columnMatch": "Total Failures",
                  "formatter": 12,
                  "formatOptions": {
                    "palette": "auto"
                  },
                  "numberFormat": {
                    "unit": 17,
                    "options": {
                      "maximumSignificantDigits": 3,
                      "maximumFractionDigits": 2
                    }
                  }
                }
              },
              "graphSettings": {
                "type": 0,
                "topContent": {
                  "columnMatch": "Request Name",
                  "formatter": 1
                },
                "leftContent": {
                  "columnMatch": "Failed with Result Code"
                },
                "centerContent": {
                  "columnMatch": "Total Failures",
                  "formatter": 1,
                  "numberFormat": {
                    "unit": 17,
                    "options": {
                      "maximumSignificantDigits": 3,
                      "maximumFractionDigits": 2
                    }
                  }
                },
                "rightContent": {
                  "columnMatch": "Failure rate %"
                },
                "bottomContent": {
                  "columnMatch": "Users Affected"
                },
                "nodeIdField": "Request Name",
                "sourceIdField": "Failed with Result Code",
                "targetIdField": "Total Failures",
                "graphOrientation": 3,
                "showOrientationToggles": false,
                "nodeSize": null,
                "staticNodeSize": 100,
                "colorSettings": null,
                "hivesMargin": 5
              },
              "chartSettings": {
                "showLegend": true,
                "showDataPoints": true
              },
              "mapSettings": {
                "locInfo": "LatLong",
                "sizeSettings": "Total Failures",
                "sizeAggregation": "Sum",
                "legendMetric": "Total Failures",
                "legendAggregation": "Sum",
                "itemColorSettings": {
                  "type": "heatmap",
                  "colorAggregation": "Sum",
                  "nodeColorField": "Total Failures",
                  "heatmapPalette": "greenRed"
                }
              }
            },
            "name": "query - 14"
          }
        ]
      },
      "customWidth": "50",
      "name": "Result Code Details",
      "styleSettings": {
        "maxWidth": "50"
      }
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Success Rate",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "let startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\nlet app = dynamic([{operationName}]);\r\n//let interval = totimespan({timeSpan:label});\r\nlet interval = 10m;\r\nlet startTimeRounded = bin(startTime, interval);\r\nlet endTimeRounded = bin(endTime, interval);\r\nlet data = requests\r\n| where timestamp {timeRange}\r\n| where operation_Name in ({operationName});\r\ndata\r\n| summarize Count =count(), CountFailed = countif(success == false) by operation_Name, bin(timestamp, interval)\r\n| join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval | mv-expand operation_Name=app | extend operation_Name=tostring(operation_Name)) on timestamp, operation_Name \r\n| project timestamp=coalesce(timestamp, timestamp1), operation_Name=coalesce(operation_Name, operation_Name1), ['Success Rate'] = coalesce((Count-CountFailed)/Count,1)",
              "size": 0,
              "aggregation": 3,
              "showAnalytics": true,
              "title": "Success Rate",
              "timeContextFromParameter": "timeRange",
              "queryType": 0,
              "resourceType": "microsoft.insights/components",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
              ],
              "visualization": "linechart",
              "gridSettings": {
                "formatters": [
                  {
                    "columnMatch": "Failed with Result Code",
                    "formatter": 18,
                    "formatOptions": {
                      "thresholdsOptions": "icons",
                      "thresholdsGrid": [
                        {
                          "operator": "startsWith",
                          "thresholdValue": "5",
                          "representation": "4",
                          "text": "{0}{1}"
                        },
                        {
                          "operator": "==",
                          "thresholdValue": "429",
                          "representation": "4",
                          "text": "{0}{1}"
                        },
                        {
                          "operator": "Default",
                          "thresholdValue": null,
                          "representation": "2",
                          "text": "{0}{1}"
                        }
                      ],
                      "compositeBarSettings": {
                        "labelText": "",
                        "columnSettings": [
                          {
                            "columnName": "Failed with Result Code",
                            "color": "blue"
                          }
                        ]
                      }
                    },
                    "numberFormat": {
                      "unit": 0,
                      "options": {
                        "style": "decimal"
                      }
                    }
                  },
                  {
                    "columnMatch": "Total Failures",
                    "formatter": 8,
                    "formatOptions": {
                      "min": 0,
                      "palette": "blue"
                    }
                  },
                  {
                    "columnMatch": "Failure rate %",
                    "formatter": 8,
                    "formatOptions": {
                      "min": 0,
                      "max": 100,
                      "palette": "greenRed"
                    }
                  },
                  {
                    "columnMatch": "Users Affected",
                    "formatter": 8,
                    "formatOptions": {
                      "min": 0,
                      "palette": "blueDark"
                    }
                  }
                ],
                "sortBy": [
                  {
                    "itemKey": "Request Name",
                    "sortOrder": 1
                  }
                ]
              },
              "sortBy": [
                {
                  "itemKey": "Request Name",
                  "sortOrder": 1
                }
              ],
              "tileSettings": {
                "showBorder": false,
                "titleContent": {
                  "columnMatch": "Request Name",
                  "formatter": 1
                },
                "leftContent": {
                  "columnMatch": "Total Failures",
                  "formatter": 12,
                  "formatOptions": {
                    "palette": "auto"
                  },
                  "numberFormat": {
                    "unit": 17,
                    "options": {
                      "maximumSignificantDigits": 3,
                      "maximumFractionDigits": 2
                    }
                  }
                }
              },
              "graphSettings": {
                "type": 0,
                "topContent": {
                  "columnMatch": "Request Name",
                  "formatter": 1
                },
                "leftContent": {
                  "columnMatch": "Failed with Result Code"
                },
                "centerContent": {
                  "columnMatch": "Total Failures",
                  "formatter": 1,
                  "numberFormat": {
                    "unit": 17,
                    "options": {
                      "maximumSignificantDigits": 3,
                      "maximumFractionDigits": 2
                    }
                  }
                },
                "rightContent": {
                  "columnMatch": "Failure rate %"
                },
                "bottomContent": {
                  "columnMatch": "Users Affected"
                },
                "nodeIdField": "Request Name",
                "sourceIdField": "Failed with Result Code",
                "targetIdField": "Total Failures",
                "graphOrientation": 3,
                "showOrientationToggles": false,
                "nodeSize": null,
                "staticNodeSize": 100,
                "colorSettings": null,
                "hivesMargin": 5
              },
              "chartSettings": {
                "showDataPoints": true,
                "ySettings": {
                  "numberFormatSettings": {
                    "unit": 0,
                    "options": {
                      "style": "percent",
                      "useGrouping": true
                    },
                    "missingSparkDataOption": "Max"
                  },
                  "min": 0,
                  "max": 1
                }
              },
              "mapSettings": {
                "locInfo": "LatLong",
                "sizeSettings": "Total Failures",
                "sizeAggregation": "Sum",
                "legendMetric": "Total Failures",
                "legendAggregation": "Sum",
                "itemColorSettings": {
                  "type": "heatmap",
                  "colorAggregation": "Sum",
                  "nodeColorField": "Total Failures",
                  "heatmapPalette": "greenRed"
                }
              }
            },
            "name": "Success Rate"
          }
        ]
      },
      "customWidth": "50",
      "name": "Success Rate",
      "styleSettings": {
        "maxWidth": "50"
      }
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "//PERFORMANCE LOG: Execution statistics\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\n// Configuring applications' logs to search\r\nlet apps = dynamic([{apps:value}]);\r\nlet flows = dynamic([{flows:value}]);\r\n// Querying data\r\nlet FlowsMap = (arr: dynamic) {\r\n    toscalar (\r\n    range x from 0 to array_length(arr) - 1 step 1\r\n    | summarize x = make_list(strcat('[', arr[x], ']'))\r\n    )\r\n};\r\nlet data = ContainerLog\r\n| where TimeGenerated between (startTime .. endTime)\r\n| join kind=inner (\r\nKubePodInventory\r\n| where TimeGenerated between (startTime .. endTime)\r\nand Namespace == \"idpay\"\r\nand ServiceName has_any (apps)\r\n| distinct Computer, ContainerID, PodUid, ServiceName\r\n)//KubePodInventory Contains namespace information\r\non Computer, ContainerID\r\n| parse kind=regex flags=U LogEntry with \"^\" timestamp  \"\\\\s\\\\[\" appName \"\\\\]\\\\s\" level \"\\\\s\\\\[\" thread \"\\\\]\\\\s\\\\[\" logger \"\\\\]\\\\s-\\\\s\" message \"$\"\r\n| project\r\ntimestamp=datetime_local_to_utc(todatetime(timestamp), \"Europe/Rome\"),\r\nlevel, appName, PodUid, thread, logger, message, ServiceName\r\n| where message startswith \"[PERFORMANCE_LOG]\" and message has_any (flows)\r\n| parse kind=regex flags=U message with \"^\\\\[PERFORMANCE_LOG\\\\] \\\\[[^\\\\]]+\\\\] Time occurred to perform business logic: \" ms: int \" ms\"\r\n| where isnotnull(ms);\r\ndata\r\n| summarize\r\navg(ms), max(ms), min(ms), stdev(ms), percentile(ms, 95), percentile(ms, 90), count(), startTime=min(timestamp), endTime=max(timestamp)\r\nby appName, ServiceName\r\n| join kind=inner (data\r\n| summarize tps=count() by appName, bin(timestamp, 1s)\r\n| summarize max(tps), avg(tps) by appName)\r\non appName\r\n| join kind=inner (data\r\n| summarize maxWorkingPodNumber=count_distinct(PodUid) by appName)\r\non appName\r\n| join kind=inner (KubePodInventory\r\n| where TimeGenerated between(startTime .. endTime)\r\nand Namespace == \"idpay\"\r\nand ServiceName has_any (apps)\r\n| distinct PodUid, ServiceName\r\n| summarize totalPodCount=count() by ServiceName)\r\non ServiceName\r\n| project\r\nappName, count_, duration=endTime - startTime, avg_ms=toreal((endTime - startTime) / 1millis) / count_,\r\navg_ms_single=avg_ms, percentile_ms_95_single=percentile_ms_95, percentile_ms_90_single=percentile_ms_90, min_ms_single=min_ms, max_ms_single=max_ms,\r\nstdev_ms_single=stdev_ms, tpm=count_ / toreal((endTime - startTime) / 1m), avg_tps, max_tps, maxWorkingPodNumber, totalPodCount, startTime, endTime\r\n| sort by appName asc",
        "size": 1,
        "showAnalytics": true,
        "title": "Execution statistics",
        "timeContextFromParameter": "timeRange",
        "showExportToExcel": true,
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "crossComponentResources": [
          "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-law"
        ],
        "visualization": "table",
        "gridSettings": {
          "formatters": [
            {
              "columnMatch": "avg_ms",
              "formatter": 0,
              "formatOptions": {
                "customColumnWidthSetting": "13ch"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "minimumFractionDigits": 2,
                  "maximumFractionDigits": 2
                }
              }
            },
            {
              "columnMatch": "avg_ms_single",
              "formatter": 0,
              "formatOptions": {
                "customColumnWidthSetting": "18ch"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "minimumFractionDigits": 2,
                  "maximumFractionDigits": 2
                }
              }
            },
            {
              "columnMatch": "percentile_ms_95_single",
              "formatter": 0,
              "formatOptions": {
                "customColumnWidthSetting": "26ch"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "percentile_ms_90_single",
              "formatter": 0,
              "formatOptions": {
                "customColumnWidthSetting": "26ch"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "min_ms_single",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "max_ms_single",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "stdev_ms_single",
              "formatter": 0,
              "formatOptions": {
                "customColumnWidthSetting": "20ch"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "minimumFractionDigits": 2,
                  "maximumFractionDigits": 2
                }
              }
            },
            {
              "columnMatch": "tpm",
              "formatter": 0,
              "formatOptions": {
                "customColumnWidthSetting": "14ch"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "maximumFractionDigits": 0
                }
              }
            },
            {
              "columnMatch": "avg_tps",
              "formatter": 0,
              "formatOptions": {
                "customColumnWidthSetting": "14ch"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "maximumFractionDigits": 0
                }
              }
            },
            {
              "columnMatch": "max_tps",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "maximumFractionDigits": 0
                }
              }
            },
            {
              "columnMatch": "throughputMinute",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "minimumFractionDigits": 0,
                  "maximumFractionDigits": 0
                }
              }
            },
            {
              "columnMatch": "max_parallelismPerSecond",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            }
          ],
          "sortBy": [
            {
              "itemKey": "appName",
              "sortOrder": 2
            }
          ]
        },
        "sortBy": [
          {
            "itemKey": "appName",
            "sortOrder": 2
          }
        ]
      },
      "name": "Execution statistics"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "//PERFORMANCE LOG: Execution statistics [steps]\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\n// Configuring applications' logs to search\r\nlet apps = dynamic([{apps:value}]);\r\nlet flows = dynamic([{innerSteps:$.value}]);\r\nlet flowLabels = dynamic([{innerSteps:$.label}]);\r\n// Querying data\r\nlet FlowsMap = (arr: dynamic) {\r\n    toscalar (\r\n    range x from 0 to array_length(arr) - 1 step 1\r\n    | summarize x = make_list(strcat('[', arr[x], ']'))\r\n    )\r\n};\r\nlet data = ContainerLog\r\n| where TimeGenerated between (startTime .. endTime)\r\n| join kind=inner (\r\nKubePodInventory\r\n| where TimeGenerated between (startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps)\r\n| distinct Computer, ContainerID, PodUid, ServiceName\r\n)//KubePodInventory Contains namespace information\r\non Computer, ContainerID\r\n| parse kind=regex flags=U LogEntry with \"^\" timestamp  \"\\\\s\\\\[\" appName \"\\\\]\\\\s\" level \"\\\\s\\\\[\" thread \"\\\\]\\\\s\\\\[\" logger \"\\\\]\\\\s-\\\\s\" message \"$\"\r\n| project timestamp=datetime_local_to_utc(todatetime(timestamp), \"Europe/Rome\"), level, appName, PodUid, thread, logger, message, ServiceName\r\n| where message startswith \"[PERFORMANCE_LOG]\" and message has_any (FlowsMap(flows))\r\n| parse kind=regex flags=U message with \"^\\\\[PERFORMANCE_LOG\\\\] \\\\[\" flow \"\\\\] Time occurred to perform business logic: \" ms:int \" ms\"\r\n| where isnotnull(ms);\r\ndata\r\n| summarize avg(ms), max(ms), min(ms), stdev(ms), percentile(ms, 95), percentile(ms, 90), count(), startTime=min(timestamp), endTime=max(timestamp) by appName, flow, ServiceName\r\n| join kind=inner (data | summarize tps=count() by appName, flow, bin(timestamp, 1s) | summarize max(tps), avg(tps) by appName, flow) on appName, flow\r\n| join kind=inner (data | summarize maxWorkingPodNumber=count_distinct(PodUid) by appName, flow) on appName, flow\r\n| join kind=inner (KubePodInventory | where TimeGenerated between(startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps) | distinct PodUid, ServiceName | summarize totalPodCount=count() by ServiceName) on ServiceName\r\n| sort by array_index_of(flows, flow) asc\r\n| project //appName,\r\ninnerStep=tostring(flowLabels[array_index_of(flows, flow)]),\r\ncount_, duration=endTime - startTime, avg_ms=toreal((endTime - startTime)/1millis)/count_, avg_ms_single=avg_ms, percentile_ms_95_single=percentile_ms_95, percentile_ms_90_single=percentile_ms_90, min_ms_single=min_ms, max_ms_single=max_ms, stdev_ms_single=stdev_ms, tpm=count_/toreal((endTime - startTime)/1m), avg_tps, max_tps, maxWorkingPodNumber, totalPodCount, startTime, endTime",
        "size": 1,
        "showAnalytics": true,
        "title": "Inner steps execution statistics",
        "timeContextFromParameter": "timeRange",
        "showExportToExcel": true,
        "exportToExcelOptions": "all",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "crossComponentResources": [
          "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/microsoft.operationalinsights/workspaces/${prefix}-law"
        ],
        "gridSettings": {
          "formatters": [
            {
              "columnMatch": "avg_ms",
              "formatter": 0,
              "formatOptions": {
                "customColumnWidthSetting": "14ch"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "minimumFractionDigits": 2,
                  "maximumFractionDigits": 2
                }
              }
            },
            {
              "columnMatch": "avg_ms_single",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "minimumFractionDigits": 2,
                  "maximumFractionDigits": 2
                }
              }
            },
            {
              "columnMatch": "percentile_ms_95_single",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "minimumFractionDigits": 2,
                  "maximumFractionDigits": 2
                }
              }
            },
            {
              "columnMatch": "percentile_ms_90_single",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "minimumFractionDigits": 2,
                  "maximumFractionDigits": 2
                }
              }
            },
            {
              "columnMatch": "min_ms_single",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "max_ms_single",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "stdev_ms_single",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "minimumFractionDigits": 2,
                  "maximumFractionDigits": 2
                }
              }
            },
            {
              "columnMatch": "tpm",
              "formatter": 0,
              "formatOptions": {
                "customColumnWidthSetting": "14ch"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "maximumFractionDigits": 0
                }
              }
            },
            {
              "columnMatch": "avg_tps",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "maximumFractionDigits": 0
                }
              }
            },
            {
              "columnMatch": "max_tps",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "maximumFractionDigits": 0
                }
              }
            },
            {
              "columnMatch": "throughputMinute",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "minimumFractionDigits": 2,
                  "maximumFractionDigits": 2
                }
              }
            },
            {
              "columnMatch": "max_parallelismPerSecond",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            }
          ]
        }
      },
      "name": "Inner Steps execution statistics"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "API Metrics",
        "items": [
          {
            "type": 10,
            "content": {
              "chartId": "workbook4f062300-869b-4c89-92fb-dde776822f52",
              "version": "MetricsItem/2.0",
              "size": 0,
              "chartType": 2,
              "resourceType": "microsoft.insights/components",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 120000,
                "endTime": "2023-03-06T13:43:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.insights/components/kusto",
                  "metric": "microsoft.insights/components/kusto-Server-requests/count",
                  "aggregation": 1,
                  "splitBy": "operation/name"
                }
              ],
              "title": "Total Requests by API",
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "1",
                  "key": "operation/name",
                  "operator": 0,
                  "valueParam": "operationName"
                }
              ],
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "customWidth": "50",
            "name": "Total Requests by API",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbook08b43573-4f30-4cc4-b43c-d815fb70e74f",
              "version": "MetricsItem/2.0",
              "size": 0,
              "chartType": 2,
              "resourceType": "microsoft.insights/components",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 120000,
                "endTime": "2023-03-06T13:43:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.insights/components/kusto",
                  "metric": "microsoft.insights/components/kusto-Server-requests/count",
                  "aggregation": 1,
                  "splitBy": "request/resultCode"
                }
              ],
              "title": "Total Requests by Code",
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "1",
                  "key": "operation/name",
                  "operator": 0,
                  "valueParam": "operationName"
                }
              ],
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "customWidth": "50",
            "name": "Total Requests by Code",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 1,
            "content": {
              "json": "This graph shows the total number of requests made to each API of interest to the flow\r\n",
              "style": "info"
            },
            "customWidth": "50",
            "name": "text - 5",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 1,
            "content": {
              "json": "This graph shows the total number of requests made to each API involved in the flow, splitted by response code",
              "style": "info"
            },
            "customWidth": "50",
            "name": "text - 5 - Copy",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbookee5739b6-13ea-4078-9e54-fe441dc60a03",
              "version": "MetricsItem/2.0",
              "size": 0,
              "chartType": 2,
              "resourceType": "microsoft.insights/components",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 120000,
                "endTime": "2023-03-06T13:43:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.insights/components/kusto",
                  "metric": "microsoft.insights/components/kusto-Server-requests/duration",
                  "aggregation": 4,
                  "splitBy": "operation/name"
                }
              ],
              "title": "Requests Response Time",
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "1",
                  "key": "operation/name",
                  "operator": 0,
                  "valueParam": "operationName"
                }
              ],
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "name": "Requests Response Time"
          },
          {
            "type": 1,
            "content": {
              "json": "This graph shows the requests' average response time, splitted by API",
              "style": "info"
            },
            "name": "text - 7"
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbookbc8a9be9-61d1-49c6-8bd5-b9ebcb4017fd",
              "version": "MetricsItem/2.0",
              "size": 0,
              "chartType": 2,
              "resourceType": "microsoft.insights/components",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 120000,
                "endTime": "2023-03-06T13:43:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.insights/components/kusto",
                  "metric": "microsoft.insights/components/kusto-Server-requests/count",
                  "aggregation": 1,
                  "splitBy": "operation/name"
                }
              ],
              "title": "Failed Requests by API",
              "gridFormatType": 1,
              "tileSettings": {
                "showBorder": false,
                "titleContent": {
                  "columnMatch": "Name",
                  "formatter": 13
                },
                "leftContent": {
                  "columnMatch": "Value",
                  "formatter": 12,
                  "formatOptions": {
                    "palette": "auto"
                  },
                  "numberFormat": {
                    "unit": 17,
                    "options": {
                      "maximumSignificantDigits": 3,
                      "maximumFractionDigits": 2
                    }
                  }
                }
              },
              "mapSettings": {
                "locInfo": "AzureResource",
                "sizeSettings": "Value",
                "sizeAggregation": "Sum",
                "legendMetric": "Value",
                "legendAggregation": "Sum",
                "itemColorSettings": {
                  "type": "heatmap",
                  "colorAggregation": "Sum",
                  "nodeColorField": "Value",
                  "heatmapPalette": "greenRed"
                },
                "locInfoColumn": "Name"
              },
              "graphSettings": {
                "type": 0,
                "topContent": {
                  "columnMatch": "Subscription",
                  "formatter": 1
                },
                "centerContent": {
                  "columnMatch": "Value",
                  "formatter": 1,
                  "numberFormat": {
                    "unit": 17,
                    "options": {
                      "maximumSignificantDigits": 3,
                      "maximumFractionDigits": 2
                    }
                  }
                }
              },
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "1",
                  "key": "operation/name",
                  "operator": 0,
                  "valueParam": "operationName"
                },
                {
                  "id": "2",
                  "key": "request/resultCode",
                  "operator": 0,
                  "valueParam": "totalFailureCode"
                }
              ],
              "gridSettings": {
                "formatters": [
                  {
                    "columnMatch": "Subscription",
                    "formatter": 5
                  },
                  {
                    "columnMatch": "Name",
                    "formatter": 13,
                    "formatOptions": {
                      "linkTarget": "Resource"
                    }
                  },
                  {
                    "columnMatch": ".*\\/Server requests$",
                    "formatter": 1
                  },
                  {
                    "columnMatch": "microsoft.insights/components/kusto-Server-requests/count Timeline",
                    "formatter": 5
                  },
                  {
                    "columnMatch": "microsoft.insights/components/kusto-Server-requests/count",
                    "formatter": 1,
                    "numberFormat": {
                      "unit": 0,
                      "options": null
                    }
                  },
                  {
                    "columnMatch": "Metric",
                    "formatter": 1
                  },
                  {
                    "columnMatch": "Aggregation",
                    "formatter": 5
                  },
                  {
                    "columnMatch": "Value",
                    "formatter": 1
                  },
                  {
                    "columnMatch": "Timeline",
                    "formatter": 9
                  }
                ],
                "rowLimit": 10000
              }
            },
            "customWidth": "50",
            "name": "Failed Requests by API",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbook08b43573-4f30-4cc4-b43c-d815fb70e74f",
              "version": "MetricsItem/2.0",
              "size": 0,
              "chartType": 2,
              "resourceType": "microsoft.insights/components",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 120000,
                "endTime": "2023-03-06T13:43:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.insights/components/kusto",
                  "metric": "microsoft.insights/components/kusto-Server-requests/count",
                  "aggregation": 1,
                  "splitBy": "request/resultCode"
                }
              ],
              "title": "Failed Requests by Code",
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "1",
                  "key": "operation/name",
                  "operator": 0,
                  "valueParam": "operationName"
                },
                {
                  "id": "2",
                  "key": "request/resultCode",
                  "operator": 0,
                  "valueParam": "totalFailureCode"
                }
              ],
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "customWidth": "50",
            "name": "Failed Requests by Code",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 1,
            "content": {
              "json": "This graph shows failed requests splitted by API that contains only the following codes:\r\n\r\n**429, 500, 501, 503, 504**",
              "style": "info"
            },
            "customWidth": "50",
            "name": "text - 8",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 1,
            "content": {
              "json": "This graph shows failed requests made to each API involved in the flow, splitted by the following codes:\r\n\r\n**429, 500, 501, 503, 504**",
              "style": "info"
            },
            "customWidth": "50",
            "name": "text - 9",
            "styleSettings": {
              "maxWidth": "50"
            }
          }
        ]
      },
      "customWidth": "50",
      "name": "API Metrics",
      "styleSettings": {
        "maxWidth": "50",
        "showBorder": true
      }
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Kafka Metrics",
        "items": [
          {
            "type": 1,
            "content": {
              "json": "##### This section is dedicated to all kafka queues used in this flow.\r\n\r\n##### To a better understanding of each topic check the design review's link (there where exists one) below each graph."
            },
            "name": "text - 4"
          },
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "title": "All involved event hubs",
              "items": [
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook36ccb4c3-de37-478d-bca4-d39f8de39ac3",
                    "version": "MetricsItem/2.0",
                    "size": 1,
                    "chartType": 2,
                    "resourceType": "microsoft.eventhub/namespaces",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-rtd-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-rtd-evh-ns",
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01",
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-00"
                    ],
                    "timeContextFromParameter": "timeRange",
                    "timeContext": {
                      "durationMs": 120000,
                      "endTime": "2023-03-06T13:43:00.000Z"
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.eventhub/namespaces",
                        "metric": "microsoft.eventhub/namespaces--IncomingMessages",
                        "aggregation": 1,
                        "splitBy": null
                      },
                      {
                        "namespace": "microsoft.eventhub/namespaces",
                        "metric": "microsoft.eventhub/namespaces--OutgoingMessages",
                        "aggregation": 1
                      }
                    ],
                    "title": "Total requests",
                    "showOpenInMe": true,
                    "filters": [
                      {
                        "id": "1",
                        "key": "EntityName",
                        "operator": 0,
                        "values": [
                          "idpay-hpan-update-outcome",
                          "rtd-pi-to-app",
                          "rtd-pi-from-app",
                          "idpay-timeline",
                          "idpay-hpan-update"
                        ]
                      }
                    ],
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "name": "eventhubs incoming-outgoins"
                }
              ]
            },
            "name": "all-eventhubs"
          },
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "title": "idpay-evh-ns-00",
              "items": [
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook9a50d864-3896-4c0d-9118-acc13018b273",
                    "version": "MetricsItem/2.0",
                    "size": 1,
                    "chartType": 2,
                    "resourceType": "microsoft.eventhub/namespaces",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-00"
                    ],
                    "timeContextFromParameter": "timeRange",
                    "timeContext": {
                      "durationMs": 120000,
                      "endTime": "2023-03-06T13:43:00.000Z"
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.eventhub/namespaces",
                        "metric": "microsoft.eventhub/namespaces--IncomingMessages",
                        "aggregation": 1,
                        "splitBy": "EntityName"
                      }
                    ],
                    "title": "Incoming Messages",
                    "showOpenInMe": true,
                    "filters": [
                      {
                        "id": "1",
                        "key": "EntityName",
                        "operator": 0,
                        "values": [
                          "idpay-timeline"
                        ]
                      }
                    ],
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Incoming Messages",
                  "styleSettings": {
                    "maxWidth": "50"
                  }
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook1f104917-d8f3-4f24-ae7a-b636dd85dd9e",
                    "version": "MetricsItem/2.0",
                    "size": 1,
                    "chartType": 2,
                    "resourceType": "microsoft.eventhub/namespaces",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-00"
                    ],
                    "timeContextFromParameter": "timeRange",
                    "timeContext": {
                      "durationMs": 120000,
                      "endTime": "2023-03-06T13:43:00.000Z"
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.eventhub/namespaces",
                        "metric": "microsoft.eventhub/namespaces--OutgoingMessages",
                        "aggregation": 1,
                        "splitBy": "EntityName"
                      }
                    ],
                    "title": "Outgoing Messages",
                    "showOpenInMe": true,
                    "filters": [
                      {
                        "id": "1",
                        "key": "EntityName",
                        "operator": 0,
                        "values": [
                          "idpay-timeline"
                        ]
                      }
                    ],
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Outgoing Messages",
                  "styleSettings": {
                    "maxWidth": "50"
                  }
                },
                {
                  "type": 1,
                  "content": {
                    "json": "This queue topic is used when the process ack arrives to wallet, the microservice wallet send the intrument's information to Timeline that reads the messages and save in it database.",
                    "style": "info"
                  },
                  "customWidth": "50",
                  "name": "text - 2",
                  "styleSettings": {
                    "maxWidth": "50"
                  }
                },
                {
                  "type": 1,
                  "content": {
                    "json": "This queue topic is used when the process ack arrives to wallet, the microservice wallet send the intrument's information to Timeline.",
                    "style": "info"
                  },
                  "customWidth": "50",
                  "name": "text - 3",
                  "styleSettings": {
                    "maxWidth": "50"
                  }
                }
              ]
            },
            "name": "idpay-evh-ns-00\\"
          },
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "title": "idpay-evh-ns-01",
              "items": [
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook9a50d864-3896-4c0d-9118-acc13018b273",
                    "version": "MetricsItem/2.0",
                    "size": 1,
                    "chartType": 2,
                    "resourceType": "microsoft.eventhub/namespaces",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
                    ],
                    "timeContextFromParameter": "timeRange",
                    "timeContext": {
                      "durationMs": 120000,
                      "endTime": "2023-03-06T13:43:00.000Z"
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.eventhub/namespaces",
                        "metric": "microsoft.eventhub/namespaces--IncomingMessages",
                        "aggregation": 1,
                        "splitBy": "EntityName"
                      }
                    ],
                    "title": "Incoming Messages",
                    "showOpenInMe": true,
                    "filters": [
                      {
                        "id": "3",
                        "key": "EntityName",
                        "operator": 0,
                        "valueParam": "eventHubName"
                      }
                    ],
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Incoming Messages",
                  "styleSettings": {
                    "maxWidth": "50"
                  }
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook1f104917-d8f3-4f24-ae7a-b636dd85dd9e",
                    "version": "MetricsItem/2.0",
                    "size": 1,
                    "chartType": 2,
                    "resourceType": "microsoft.eventhub/namespaces",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
                    ],
                    "timeContextFromParameter": "timeRange",
                    "timeContext": {
                      "durationMs": 120000,
                      "endTime": "2023-03-06T13:43:00.000Z"
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.eventhub/namespaces",
                        "metric": "microsoft.eventhub/namespaces--OutgoingMessages",
                        "aggregation": 1,
                        "splitBy": "EntityName"
                      }
                    ],
                    "title": "Outgoing Messages",
                    "showOpenInMe": true,
                    "filters": [
                      {
                        "id": "1",
                        "key": "EntityName",
                        "operator": 0,
                        "valueParam": "eventHubName"
                      }
                    ],
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Outgoing Messages",
                  "styleSettings": {
                    "maxWidth": "50"
                  }
                },
                {
                  "type": 1,
                  "content": {
                    "json": "This two graphs show the incoming and outgoing messages from the eventhub ${prefix}-idpay-evh-ns-01 filtered by the folowing topics:\r\n\r\n1. idpay-hpan-update (see design rewiew [Payment Instrument](https://pagopa.atlassian.net/wiki/spaces/IDPAY/pages/506954092/Servizi+del+Beneficiario#API---Enrollment-di-un-Metodo-di-Pagamento-V2))\r\n2. idpay-hpan-update-outcome (see design rewiew [Rule Engine](https://pagopa.atlassian.net/wiki/spaces/IDPAY/pages/507839510/Rule+Engine+-+Calcolo+Benefici#Alimentazione-tabella-di-lookup-hpan-initiativeId))",
                    "style": "info"
                  },
                  "name": "text - 2"
                }
              ]
            },
            "name": "idpay-evh-ns-01"
          },
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "title": "rtd-evh-ns",
              "items": [
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook9a50d864-3896-4c0d-9118-acc13018b273",
                    "version": "MetricsItem/2.0",
                    "size": 1,
                    "chartType": 2,
                    "resourceType": "microsoft.eventhub/namespaces",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-rtd-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-rtd-evh-ns"
                    ],
                    "timeContextFromParameter": "timeRange",
                    "timeContext": {
                      "durationMs": 120000,
                      "endTime": "2023-03-06T13:43:00.000Z"
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.eventhub/namespaces",
                        "metric": "microsoft.eventhub/namespaces--IncomingMessages",
                        "aggregation": 1,
                        "splitBy": "EntityName"
                      }
                    ],
                    "title": "Incoming Messages",
                    "showOpenInMe": true,
                    "filters": [
                      {
                        "id": "4",
                        "key": "EntityName",
                        "operator": 0,
                        "values": [
                          "rtd-pi-from-app"
                        ]
                      }
                    ],
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Incoming Messages",
                  "styleSettings": {
                    "maxWidth": "50"
                  }
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook1f104917-d8f3-4f24-ae7a-b636dd85dd9e",
                    "version": "MetricsItem/2.0",
                    "size": 1,
                    "chartType": 2,
                    "resourceType": "microsoft.eventhub/namespaces",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-rtd-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-rtd-evh-ns"
                    ],
                    "timeContextFromParameter": "timeRange",
                    "timeContext": {
                      "durationMs": 120000,
                      "endTime": "2023-03-06T13:43:00.000Z"
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.eventhub/namespaces",
                        "metric": "microsoft.eventhub/namespaces--OutgoingMessages",
                        "aggregation": 1,
                        "splitBy": "EntityName"
                      }
                    ],
                    "title": "Outgoing Messages",
                    "showOpenInMe": true,
                    "filters": [
                      {
                        "id": "2",
                        "key": "EntityName",
                        "operator": 0,
                        "values": [
                          "rtd-pi-to-app"
                        ]
                      }
                    ],
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Outgoing Messages",
                  "styleSettings": {
                    "maxWidth": "50"
                  }
                },
                {
                  "type": 1,
                  "content": {
                    "json": "This queue topics are used from RTD to the ack process.\r\n\r\nAfter ricieving the ack from rule engine, payment instrument sends a new request messagge to rtd using the topic rtd-pi-from-app.\r\n\r\nOnce RTD has processing the request, sends back a new ack to payment instrument using the topic rtd-pi-to-app.",
                    "style": "info"
                  },
                  "name": "text - 2"
                }
              ]
            },
            "name": "rtd-evh-ns"
          }
        ]
      },
      "customWidth": "50",
      "name": "Kafka Metrics",
      "styleSettings": {
        "margin": "0",
        "padding": "10px",
        "maxWidth": "50"
      }
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Processing distribution",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "//PERFORMANCE LOG: Distribution of onboarding citizen processing\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\nlet interval = totimespan({timeSpan:label});\r\n// Configuring applications' logs to search\r\nlet apps = dynamic([{apps:value}]);\r\nlet flows = dynamic([{flows:value}]);\r\n// Querying data\r\nlet startTimeRounded = bin(startTime, interval);\r\nlet endTimeRounded = bin(endTime, interval);\r\nlet FlowsMap = (arr: dynamic) {\r\n    toscalar (\r\n    range x from 0 to array_length(arr) - 1 step 1\r\n    | summarize x = make_list(strcat('[', arr[x], ']'))\r\n    )\r\n};\r\nlet data = ContainerLog\r\n| where TimeGenerated between (startTime .. endTime)\r\n| join kind=inner (\r\nKubePodInventory\r\n| where TimeGenerated between (startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps)\r\n| distinct Computer, ContainerID, PodUid\r\n)//KubePodInventory Contains namespace information\r\non Computer, ContainerID\r\n| parse kind=regex flags=U LogEntry with \"^\" timestamp  \"\\\\s\\\\[\" appName \"\\\\]\\\\s\" level \"\\\\s+\\\\[\" thread \"\\\\]\\\\s\\\\[\" logger \"\\\\]\\\\s-\\\\s\" message \"$\"\r\n| project timestamp=datetime_local_to_utc(todatetime(timestamp), \"Europe/Rome\"), level, appName, PodUid, thread, logger, message\r\n| where message startswith \"[PERFORMANCE_LOG]\" and message has_any (FlowsMap(flows))\r\n| parse kind=regex flags=U message with \"^\\\\[PERFORMANCE_LOG\\\\] \\\\[\" flow \"\\\\] Time occurred to perform business logic: \" ms:int \" ms\"\r\n| where isnotnull(ms);\r\n// just intervals having data\r\n//data | summarize avg(ms) by appName, flow, bin(timestamp, interval)\r\n// intervals having data or empty appName\r\ndata \r\n| summarize count() by appName, flow, bin(timestamp, interval) \r\n| join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval) on timestamp \r\n| project timestamp=coalesce(timestamp, timestamp1), appName, flow, count_\r\n// intervals on all appNames, evenif no data \r\n//data | summarize count() by appName, flow, bin(timestamp, interval) | join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval | mv-expand appName=apps | extend appName=tostring(appName)) on timestamp, appName | project timestamp=coalesce(timestamp, timestamp1), appName=coalesce(appName, appName1), flow, count_\r\n// no appName distinction\r\n//data | make-series kind=nonempty count() on timestamp from startTimeRounded to endTimeRounded step interval\r\n//| project flow=strcat(appName, \"[\", flow, \"]\"), count_, timestamp\r\n| order by timestamp desc\r\n| render columnchart with(kind=unstacked, title=\"Distribution of onboarding citizen processing\")",
              "size": 1,
              "showAnalytics": true,
              "title": "Distribution of enrollment instrument processing",
              "timeContextFromParameter": "timeRange",
              "timeBrushParameterName": "timeRange",
              "showExportToExcel": true,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-law"
              ],
              "visualization": "unstackedbar"
            },
            "name": "Distribution of enrollment instrument processing"
          },
          {
            "type": 1,
            "content": {
              "json": "This graph shows the number of execution involved in the performance log, splitted by flow",
              "style": "info"
            },
            "name": "text - 7"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "//PERFORMANCE LOG: Distribution of single onboarding average ms\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\nlet interval = totimespan({timeSpan:label});\r\n// Configuring applications' logs to search\r\nlet apps = dynamic([{apps:value}]);\r\nlet flows = dynamic([{flows:value}]);\r\n// Querying data\r\nlet startTimeRounded = bin(startTime, interval);\r\nlet endTimeRounded = bin(endTime, interval);\r\nlet FlowsMap = (arr: dynamic) {\r\n    toscalar (\r\n    range x from 0 to array_length(arr) - 1 step 1\r\n    | summarize x = make_list(strcat('[', arr[x], ']'))\r\n    )\r\n};\r\nlet data = ContainerLog\r\n| where TimeGenerated between (startTime .. endTime)\r\n| join kind=inner (\r\nKubePodInventory\r\n| where TimeGenerated between (startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps)\r\n| distinct Computer, ContainerID, PodUid\r\n)//KubePodInventory Contains namespace information\r\non Computer, ContainerID\r\n| parse kind=regex flags=U LogEntry with \"^\" timestamp  \"\\\\s\\\\[\" appName \"\\\\]\\\\s\" level \"\\\\s+\\\\[\" thread \"\\\\]\\\\s\\\\[\" logger \"\\\\]\\\\s-\\\\s\" message \"$\"\r\n| project timestamp=datetime_local_to_utc(todatetime(timestamp), \"Europe/Rome\"), level, appName, PodUid, thread, logger, message\r\n| where message startswith \"[PERFORMANCE_LOG]\" and message has_any (FlowsMap(flows))\r\n| parse kind=regex flags=U message with \"^\\\\[PERFORMANCE_LOG\\\\] \\\\[\" flow \"\\\\] Time occurred to perform business logic: \" ms:int \" ms\"\r\n| where isnotnull(ms);\r\n// just intervals having data\r\n//data | summarize avg(ms) by appName, flow, bin(timestamp, interval)\r\n// intervals having data or empty appName\r\ndata | summarize avg(ms) by appName, flow, bin(timestamp, interval) | join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval) on timestamp | project timestamp=coalesce(timestamp, timestamp1), appName, flow, avg_ms\r\n// intervals on all appNames, evenif no data \r\n//data | summarize avg(ms) by appName, flow, bin(timestamp, interval) | join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval | mv-expand appName=apps | extend appName=tostring(appName)) on timestamp, appName | project timestamp=coalesce(timestamp, timestamp1), appName=coalesce(appName, appName1), flow, avg_ms\r\n// no appName distinction\r\n//data | make-series kind=nonempty avg(ms) on timestamp from startTimeRounded to endTimeRounded step interval\r\n//| project flow=strcat(appName, \"[\", flow, \"]\"), avg_ms, timestamp\r\n| order by timestamp desc\r\n| render columnchart with(kind=unstacked, title=\"Distribution of single onboarding average ms\")\r\n\r\n",
              "size": 1,
              "showAnalytics": true,
              "title": "Distribution of single enrollment average ms",
              "timeContextFromParameter": "timeRange",
              "timeBrushParameterName": "timeRange",
              "showExportToExcel": true,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-law"
              ],
              "visualization": "unstackedbar"
            },
            "name": "Distribution of single enrollment average ms"
          },
          {
            "type": 1,
            "content": {
              "json": "This graph shows the flow's single execution average response time, splitted by flow",
              "style": "info"
            },
            "name": "text - 8"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "//PERFORMANCE LOG: Distribution of commits\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\nlet interval = totimespan({timeSpan:label});\r\n// Configuring applications' logs to search\r\nlet apps = dynamic([{apps:value}]);\r\nlet flows = dynamic([{flows:value}]);\r\n// Querying data\r\nlet startTimeRounded = bin(startTime, interval);\r\nlet endTimeRounded = bin(endTime, interval);\r\nlet FlowsMap = (arr: dynamic) {\r\n    toscalar (\r\n    range x from 0 to array_length(arr) - 1 step 1\r\n    | summarize x = make_list(strcat('[', arr[x], ']'))\r\n    )\r\n};\r\nlet data = ContainerLog\r\n| where TimeGenerated between (startTime .. endTime)\r\n| join kind=inner (\r\nKubePodInventory\r\n| where TimeGenerated between (startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps)\r\n| distinct Computer, ContainerID, PodUid\r\n)//KubePodInventory Contains namespace information\r\non Computer, ContainerID\r\n| parse kind=regex flags=U LogEntry with \"^\" timestamp  \"\\\\s\\\\[\" appName \"\\\\]\\\\s\" level \"\\\\s+\\\\[\" thread \"\\\\]\\\\s\\\\[\" logger \"\\\\]\\\\s-\\\\s\" message \"$\"\r\n| project timestamp=datetime_local_to_utc(todatetime(timestamp), \"Europe/Rome\"), level, appName, PodUid, thread, logger, message\r\n| where message startswith \"[KAFKA_COMMIT]\" and message has_any (FlowsMap(flows))\r\n| parse kind=regex flags=U message with \"^\\\\[KAFKA_COMMIT\\\\]\\\\[\" flow \"\\\\] Committing \" commitSize:int \" messages\"\r\n| where isnotnull(commitSize);\r\n// just intervals having data\r\n//data | summarize sum(commitSize) by appName, flow, bin(timestamp, interval)\r\n// intervals having data or empty appName\r\ndata | summarize sum(commitSize) by appName, flow, bin(timestamp, interval) | join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval) on timestamp | project timestamp=coalesce(timestamp, timestamp1), appName, flow, sum_commitSize\r\n// intervals on all appNames, evenif no data \r\n//data | summarize sum(commitSize) by appName, flow, bin(timestamp, interval) | join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval | mv-expand appName=apps | extend appName=tostring(appName)) on timestamp, appName | project timestamp=coalesce(timestamp, timestamp1), appName=coalesce(appName, appName1), flow, sum_commitSize\r\n// no appName distinction\r\n//data | make-series kind=nonempty sum(commitSize) on timestamp from startTimeRounded to endTimeRounded step interval\r\n//| project flow=strcat(appName, \"[\", flow, \"]\"), sum_commitSize, timestamp\r\n| order by timestamp desc\r\n| render columnchart with(kind=unstacked, title=\"Distribution of Kafka messages commits\")\r\n\r\n",
              "size": 1,
              "showAnalytics": true,
              "title": "Distribution of Kafka messages commits",
              "timeContextFromParameter": "timeRange",
              "timeBrushParameterName": "timeRange",
              "showExportToExcel": true,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-law"
              ],
              "visualization": "barchart"
            },
            "name": "Distribution of Kafka messages commits"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "//PERFORMANCE LOG: Distribution of trx status\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\nlet interval = totimespan({timeSpan:label});\r\n// Configuring applications' logs to search\r\nlet apps = dynamic(['idpay-payment-instrument']);\r\nlet flows = dynamic(['RESULT']);\r\n// Querying data\r\nlet startTimeRounded = bin(startTime, interval);\r\nlet endTimeRounded = bin(endTime, interval);\r\nlet FlowsMap = (arr: dynamic) {\r\n    toscalar (\r\n    range x from 0 to array_length(arr) - 1 step 1\r\n    | summarize x = make_list(strcat('[', arr[x], ']'))\r\n    )\r\n};\r\nlet data = ContainerLog\r\n| where TimeGenerated between (startTime .. endTime)\r\n| join kind=inner (\r\nKubePodInventory\r\n| where TimeGenerated between (startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps)\r\n| distinct Computer, ContainerID, PodUid\r\n)//KubePodInventory Contains namespace information\r\non Computer, ContainerID\r\n| parse kind=regex flags=U LogEntry with \"^\" timestamp  \"\\\\s\\\\[\" appName \"\\\\]\\\\s\" level \"\\\\s+\\\\[\" thread \"\\\\]\\\\s\\\\[\" logger \"\\\\]\\\\s-\\\\s\" message \"$\"\r\n| project timestamp=datetime_local_to_utc(todatetime(timestamp), \"Europe/Rome\"), level, appName, PodUid, thread, logger, message\r\n| where message startswith \"[PROCESS_ACK_ENROLL]\" and message has_any (FlowsMap(flows));\r\ndata | summarize count() by result=case(message contains \"ACTIVE\", \"ACTIVE\", \"ENROLLMENT_FAILED\"), bin(timestamp, interval) | join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval) on timestamp | project timestamp=coalesce(timestamp, timestamp1), result, count_\r\n| sort by timestamp\r\n| render columnchart with(kind=unstacked, title=\"Distribution of onboarding's result\")",
              "size": 1,
              "showAnalytics": true,
              "title": "Distribution of enrollment result",
              "timeContextFromParameter": "timeRange",
              "showExportToExcel": true,
              "exportToExcelOptions": "all",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-law"
              ],
              "visualization": "unstackedbar"
            },
            "customWidth": "50",
            "name": "Distribution of enrollment result",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "// APPLICATION LOGS\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\nlet interval = totimespan({timeSpan:label});\r\n// Configuring applications' logs to search\r\nlet apps = dynamic([{apps:value}]);\r\n// Querying data\r\nlet startTimeRounded = bin(startTime, interval);\r\nlet endTimeRounded = bin(endTime, interval);\r\nlet data = ContainerLog\r\n| where TimeGenerated between(startTime .. endTime)\r\n| join kind=inner (\r\nKubePodInventory\r\n| where TimeGenerated between(startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps)\r\n| distinct Computer, ContainerID, PodUid\r\n)//KubePodInventory Contains namespace information\r\non Computer, ContainerID\r\n| parse kind=regex flags=U LogEntry with \"^\" timestamp  \"\\\\s\\\\[\" appName \"\\\\]\\\\s\" level \"\\\\s+\\\\[\" thread \"\\\\]\\\\s\\\\[\" logger \"\\\\]\\\\s-\\\\s\" message \"$\"\r\n| project timestamp=datetime_local_to_utc(todatetime(timestamp), \"Europe/Rome\"), level, appName, PodUid, thread, logger, message\r\n| order by timestamp;\r\ndata\r\n| where level in (\"WARN\", \"ERROR\")\r\n| summarize count() by appName, level, bin(timestamp, interval) | join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval) on timestamp | project timestamp=coalesce(timestamp, timestamp1), strcat(level, '[', appName, ']'), count_\r\n| sort by timestamp\r\n| render columnchart with(kind=unstacked, title=\"Distribution of warn/errors\")",
              "size": 1,
              "showAnalytics": true,
              "title": "Distribution of warn/errors",
              "timeContextFromParameter": "timeRange",
              "showExportToExcel": true,
              "exportToExcelOptions": "all",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/microsoft.operationalinsights/workspaces/${prefix}-law"
              ],
              "visualization": "unstackedbar"
            },
            "customWidth": "50",
            "name": "Distribution of warn/errors",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 1,
            "content": {
              "json": "ACTIVE and ENROLLMENT_FAILED counts are performed on idpay-payment-instrument logs, thus it will be influeced by the number of messages read by that ms",
              "style": "warning"
            },
            "customWidth": "50",
            "name": "RewardedDiscardedDisclaimer",
            "styleSettings": {
              "maxWidth": "59"
            }
          },
          {
            "type": 1,
            "content": {
              "json": "WARN and ERRORS counts are performed checking all the logs produced by the selected apps, thus it could contains alerts not related to the current logics",
              "style": "info"
            },
            "customWidth": "50",
            "name": "ErrorWarnDisclaimer",
            "styleSettings": {
              "maxWidth": "50"
            }
          }
        ]
      },
      "customWidth": "50",
      "name": "Processing distribution",
      "styleSettings": {
        "maxWidth": "50"
      }
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Cosmos DB",
        "items": [
          {
            "type": 10,
            "content": {
              "chartId": "workbookc40881cd-42b1-4a91-a095-0aba2bfbca5f",
              "version": "MetricsItem/2.0",
              "size": 1,
              "chartType": 2,
              "resourceType": "microsoft.documentdb/databaseaccounts",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-idpay-mongodb-account"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 120000,
                "endTime": "2023-03-06T13:43:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.documentdb/databaseaccounts",
                  "metric": "microsoft.documentdb/databaseaccounts-Requests-TotalRequestUnits",
                  "aggregation": 1,
                  "splitBy": "CollectionName"
                }
              ],
              "title": "Cosmos DB Requests Units",
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "2",
                  "key": "CollectionName",
                  "operator": 0,
                  "valueParam": "dbCollections"
                }
              ],
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "customWidth": "50",
            "name": "Cosmos DB Requests Units",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbookdfee1d78-8786-42b2-8ed5-ebe31e2ba523",
              "version": "MetricsItem/2.0",
              "size": 1,
              "chartType": 2,
              "resourceType": "microsoft.documentdb/databaseaccounts",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-idpay-mongodb-account"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 120000,
                "endTime": "2023-03-06T13:43:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.documentdb/databaseaccounts",
                  "metric": "microsoft.documentdb/databaseaccounts-Requests-TotalRequestUnits",
                  "aggregation": 1,
                  "splitBy": "StatusCode"
                }
              ],
              "title": "Cosmos Errors",
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "1",
                  "key": "StatusCode",
                  "operator": 1,
                  "values": [
                    "200",
                    "201",
                    "204",
                    "404",
                    "412",
                    "449",
                    "409"
                  ]
                },
                {
                  "id": "2",
                  "key": "CollectionName",
                  "operator": 0,
                  "valueParam": "dbCollections"
                }
              ],
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "customWidth": "50",
            "name": "Cosmos Errors",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 1,
            "content": {
              "json": "This graph shows the number of Request Units, splitted by collection",
              "style": "info"
            },
            "customWidth": "50",
            "name": "text - 6",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 1,
            "content": {
              "json": "This graph shows the number of collections' errors involved in the apps",
              "style": "info"
            },
            "customWidth": "50",
            "name": "text - 7",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbook694b2aec-e7b0-440e-82b1-de66fce0b7ac",
              "version": "MetricsItem/2.0",
              "size": 1,
              "chartType": 2,
              "resourceType": "microsoft.documentdb/databaseaccounts",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-idpay-mongodb-account"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 120000,
                "endTime": "2023-03-06T13:43:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.documentdb/databaseaccounts",
                  "metric": "microsoft.documentdb/databaseaccounts-Requests-NormalizedRUConsumption",
                  "aggregation": 3,
                  "splitBy": null
                }
              ],
              "title": "Normalized RU Consumption",
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "2",
                  "key": "CollectionName",
                  "operator": 0,
                  "valueParam": "dbCollections"
                }
              ],
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "name": "Normalized RU Consumption"
          },
          {
            "type": 1,
            "content": {
              "json": "This graph shows the Request Units consumed by the collections involved in the apps (in percentile)",
              "style": "info"
            },
            "name": "text - 8"
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbook8c1c4726-5a2d-4261-ae75-c019aef53bf3",
              "version": "MetricsItem/2.0",
              "size": 1,
              "chartType": 2,
              "resourceType": "microsoft.documentdb/databaseaccounts",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-idpay-mongodb-account"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 120000,
                "endTime": "2023-03-06T13:43:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.documentdb/databaseaccounts",
                  "metric": "microsoft.documentdb/databaseaccounts-Requests-MongoRequests",
                  "aggregation": 7,
                  "splitBy": "CommandName"
                }
              ],
              "title": "Mongo DB Operations",
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "1",
                  "key": "CollectionName",
                  "operator": 0,
                  "valueParam": "dbCollections"
                }
              ],
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "name": "Mongo DB Operations"
          },
          {
            "type": 1,
            "content": {
              "json": "This graph shows the number of collections' requests, splitted by operation",
              "style": "info"
            },
            "name": "text - 9"
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbook026603f3-d8cc-46de-9ef1-456243f40556",
              "version": "MetricsItem/2.0",
              "size": 1,
              "chartType": 2,
              "resourceType": "microsoft.documentdb/databaseaccounts",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-idpay-mongodb-account"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 120000,
                "endTime": "2023-03-06T13:43:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.documentdb/databaseaccounts",
                  "metric": "microsoft.documentdb/databaseaccounts-Requests-DataUsage",
                  "aggregation": 1,
                  "splitBy": "CollectionName"
                }
              ],
              "title": "Data Usage",
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "1",
                  "key": "CollectionName",
                  "operator": 0,
                  "valueParam": "dbCollections"
                }
              ],
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "customWidth": "50",
            "name": "Data Usage",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbooka6bbd238-c717-4839-b457-3f07c4e7ebd4",
              "version": "MetricsItem/2.0",
              "size": 1,
              "chartType": 2,
              "resourceType": "microsoft.documentdb/databaseaccounts",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-idpay-mongodb-account"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 120000,
                "endTime": "2023-03-06T13:43:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.documentdb/databaseaccounts",
                  "metric": "microsoft.documentdb/databaseaccounts-Requests-DocumentCount",
                  "aggregation": 1,
                  "splitBy": "CollectionName"
                }
              ],
              "title": " Document Count",
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "1",
                  "key": "CollectionName",
                  "operator": 0,
                  "valueParam": "dbCollections"
                }
              ],
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "customWidth": "50",
            "name": " Document Count",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 1,
            "content": {
              "json": ""
            },
            "customWidth": "50",
            "name": "text - 10",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 1,
            "content": {
              "json": "This graph shows the collections' dimension, splitted by collection",
              "style": "info"
            },
            "customWidth": "50",
            "name": "text - 11",
            "styleSettings": {
              "maxWidth": "50"
            }
          }
        ]
      },
      "customWidth": "50",
      "name": "Cosmos DB",
      "styleSettings": {
        "maxWidth": "50",
        "showBorder": true
      }
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Warning and Errors",
        "expandable": true,
        "items": [
          {
            "type": 1,
            "content": {
              "json": "WARN and ERRORS are obtained checking all the logs/events produced (the logs are restricted to the selected apps), thus it could contains alerts not related to the current logics",
              "style": "info"
            },
            "name": "text - 8"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "// APPLICATION LOGS\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\n// Configuring applications' logs to search\r\nlet apps = dynamic([{apps:value}]);\r\n// Querying data\r\nlet data = ContainerLog\r\n| where TimeGenerated between(startTime .. endTime)\r\n| join kind=inner (\r\nKubePodInventory\r\n| where TimeGenerated between(startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps)\r\n| distinct Computer, ContainerID, PodUid\r\n)//KubePodInventory Contains namespace information\r\non Computer, ContainerID\r\n| parse kind=regex flags=U LogEntry with \"^\" timestamp  \"\\\\s\\\\[\" appName \"\\\\]\\\\s\" level \"\\\\s+\\\\[\" thread \"\\\\]\\\\s\\\\[\" logger \"\\\\]\\\\s-\\\\s\" message \"$\"\r\n| project timestamp=datetime_local_to_utc(todatetime(timestamp), \"Europe/Rome\"), level, appName, PodUid, thread, logger, message\r\n| order by timestamp;\r\ndata\r\n| where level in (\"WARN\", \"ERROR\")\r\n| project timestamp, appName, level, message\r\n| sort by timestamp asc",
              "size": 1,
              "timeContextFromParameter": "timeRange",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-law"
              ]
            },
            "name": "query - 0"
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbook725c6cc8-6676-42e5-930c-1469e49d8b4d",
              "version": "MetricsItem/2.0",
              "size": 1,
              "chartType": 2,
              "resourceType": "microsoft.eventhub/namespaces",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 120000,
                "endTime": "2023-03-06T13:43:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.eventhub/namespaces",
                  "metric": "microsoft.eventhub/namespaces--IncomingMessages",
                  "aggregation": 1,
                  "splitBy": null
                }
              ],
              "title": "Topic errors",
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "2",
                  "key": "EntityName",
                  "operator": 0,
                  "values": [
                    "idpay-errors"
                  ]
                }
              ],
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "name": "Topic errors"
          }
        ]
      },
      "name": "Warning and Errors"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Cluster Metrics",
        "items": [
          {
            "type": 10,
            "content": {
              "chartId": "workbook4ff901ba-f592-405c-b520-5b7c8f17bc06",
              "version": "MetricsItem/2.0",
              "size": 0,
              "chartType": 2,
              "resourceType": "microsoft.containerservice/managedclusters",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${env}01-aks-rg/providers/Microsoft.ContainerService/managedClusters/${prefix}-${location_short}-${env}01-aks"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 120000,
                "endTime": "2023-03-06T13:43:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.containerservice/managedclusters",
                  "metric": "microsoft.containerservice/managedclusters-Nodes (PREVIEW)-node_cpu_usage_percentage",
                  "aggregation": 4,
                  "splitBy": "node"
                }
              ],
              "title": "Cluster CPU Usage ",
              "showOpenInMe": true,
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "name": "Cluster CPU Usage "
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbook3fc01a1c-c9b3-4135-9a95-cfa0513d9af6",
              "version": "MetricsItem/2.0",
              "size": 0,
              "chartType": 2,
              "resourceType": "microsoft.containerservice/managedclusters",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${env}01-aks-rg/providers/Microsoft.ContainerService/managedClusters/${prefix}-${location_short}-${env}01-aks"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 120000,
                "endTime": "2023-03-06T13:43:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.containerservice/managedclusters",
                  "metric": "microsoft.containerservice/managedclusters-Nodes (PREVIEW)-node_memory_working_set_percentage",
                  "aggregation": 4,
                  "splitBy": "node"
                }
              ],
              "title": "Cluster Memory Usage",
              "showOpenInMe": true,
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "name": "Cluster Memory Usage"
          }
        ]
      },
      "customWidth": "50",
      "name": "Cluster AKS Metrics",
      "styleSettings": {
        "maxWidth": "50"
      }
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "POD Metrics",
        "items": [
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "title": "Distribution of pods",
              "items": [
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "//PERFORMANCE LOG: Distribution of working pods\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\nlet interval = totimespan({timeSpan:label});\r\n// Configuring applications' logs to search\r\nlet apps = dynamic([{apps:value}]);\r\nlet flows = dynamic([{flows:value}]);\r\n// Querying data\r\nlet startTimeRounded = bin(startTime, interval);\r\nlet endTimeRounded = bin(endTime, interval);\r\nlet FlowsMap = (arr: dynamic) {\r\n    toscalar (\r\n    range x from 0 to array_length(arr) - 1 step 1\r\n    | summarize x = make_list(strcat('[', arr[x], ']'))\r\n    )\r\n};\r\nlet data = ContainerLog\r\n| where TimeGenerated between (startTime .. endTime)\r\n| join kind=inner (\r\nKubePodInventory\r\n| where TimeGenerated between (startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps)\r\n| distinct Computer, ContainerID, PodUid, ServiceName\r\n)//KubePodInventory Contains namespace information\r\non Computer, ContainerID\r\n| parse kind=regex flags=U LogEntry with \"^\" timestamp  \"\\\\s\\\\[\" appName \"\\\\]\\\\s\" level \"\\\\s+\\\\[\" thread \"\\\\]\\\\s\\\\[\" logger \"\\\\]\\\\s-\\\\s\" message \"$\"\r\n| project timestamp=datetime_local_to_utc(todatetime(timestamp), \"Europe/Rome\"), level, appName, ServiceName, PodUid, thread, logger, message\r\n| where message startswith \"[PERFORMANCE_LOG]\" and message has_any (FlowsMap(flows))\r\n| parse kind=regex flags=U message with \"^\\\\[PERFORMANCE_LOG\\\\] \\\\[\" flow \"\\\\] Time occurred to perform business logic: \" ms:int \" ms\"\r\n| where isnotnull(ms);\r\n// just intervals having data\r\n//data | summarize count() by PodUid, bin(timestamp, interval)\r\n// intervals having data or empty appName\r\ndata | distinct PodUid, appName, bin(timestamp, interval) | summarize count() by appName, timestamp | join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval) on timestamp | project timestamp=coalesce(timestamp, timestamp1), appName, count_\r\n| order by timestamp desc\r\n| render columnchart with(kind=unstacked, title=\"Distribution of working pods\")",
                    "size": 4,
                    "showAnalytics": true,
                    "title": "Distribution of working pods",
                    "timeContextFromParameter": "timeRange",
                    "showExportToExcel": true,
                    "exportToExcelOptions": "all",
                    "queryType": 0,
                    "resourceType": "microsoft.operationalinsights/workspaces",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-law"
                    ],
                    "visualization": "linechart",
                    "chartSettings": {
                      "showMetrics": false
                    }
                  },
                  "customWidth": "50",
                  "name": "Distribution of working pods",
                  "styleSettings": {
                    "maxWidth": "50"
                  }
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "//PERFORMANCE LOG: Distribution of working pods\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\nlet interval = totimespan({timeSpan:label});\r\n// Configuring applications' logs to search\r\nlet apps = dynamic([{apps:value}]);\r\n// Querying data\r\nlet startTimeRounded = bin(startTime, interval);\r\nlet endTimeRounded = bin(endTime, interval);\r\nKubePodInventory\r\n| where TimeGenerated between(startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps)\r\n| distinct ServiceName, PodUid, TimeGenerated=bin(TimeGenerated, interval)\r\n| summarize totalPodCount=count() by ServiceName, TimeGenerated\r\n| order by TimeGenerated desc\r\n| render columnchart with(kind=unstacked, title=\"Distribution of total pods\")",
                    "size": 4,
                    "showAnalytics": true,
                    "title": "Distribution of total pods",
                    "timeContextFromParameter": "timeRange",
                    "showExportToExcel": true,
                    "queryType": 0,
                    "resourceType": "microsoft.operationalinsights/workspaces",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-law"
                    ],
                    "visualization": "linechart",
                    "chartSettings": {
                      "showMetrics": false,
                      "ySettings": {
                        "min": 0
                      }
                    }
                  },
                  "customWidth": "50",
                  "name": "Distribution of total pods",
                  "styleSettings": {
                    "maxWidth": "50"
                  }
                }
              ]
            },
            "name": "Distribution of pods"
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbookaa6d31c8-539e-4bc2-939d-d5277a8c82b2",
              "version": "MetricsItem/2.0",
              "size": 1,
              "chartType": 2,
              "resourceType": "microsoft.insights/components",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 120000,
                "endTime": "2023-03-06T13:43:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.insights/components/kusto",
                  "metric": "microsoft.insights/components/kusto-Performance Counters-performanceCounters/processCpuPercentage",
                  "aggregation": 4,
                  "splitBy": "cloud/roleName"
                }
              ],
              "title": "Process CPU",
              "gridFormatType": 1,
              "tileSettings": {
                "showBorder": false,
                "titleContent": {
                  "columnMatch": "Name",
                  "formatter": 13
                },
                "leftContent": {
                  "columnMatch": "Value",
                  "formatter": 12,
                  "formatOptions": {
                    "palette": "auto"
                  },
                  "numberFormat": {
                    "unit": 17,
                    "options": {
                      "maximumSignificantDigits": 3,
                      "maximumFractionDigits": 2
                    }
                  }
                }
              },
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "1",
                  "key": "cloud/roleName",
                  "operator": 0,
                  "valueParam": "podName"
                }
              ],
              "gridSettings": {
                "formatters": [
                  {
                    "columnMatch": "Subscription",
                    "formatter": 5
                  },
                  {
                    "columnMatch": "Name",
                    "formatter": 13,
                    "formatOptions": {
                      "linkTarget": "Resource"
                    }
                  },
                  {
                    "columnMatch": "Metric",
                    "formatter": 1
                  },
                  {
                    "columnMatch": "Aggregation",
                    "formatter": 5
                  },
                  {
                    "columnMatch": "Value",
                    "formatter": 1
                  },
                  {
                    "columnMatch": "Timeline",
                    "formatter": 9
                  },
                  {
                    "columnMatch": "microsoft.insights/components/kusto-Performance Counters-performanceCounters/processCpuPercentage",
                    "formatter": 1,
                    "numberFormat": {
                      "unit": 1,
                      "options": null
                    }
                  }
                ],
                "rowLimit": 10000,
                "labelSettings": [
                  {
                    "columnId": "microsoft.insights/components/kusto-Performance Counters-performanceCounters/processCpuPercentage",
                    "label": "Process CPU (Average)"
                  },
                  {
                    "columnId": "microsoft.insights/components/kusto-Performance Counters-performanceCounters/processCpuPercentage Timeline",
                    "label": "Process CPU (Average) Timeline"
                  }
                ]
              }
            },
            "name": "Process CPU"
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbook9847fe68-9cbe-4c35-a52e-7cf90b312f36",
              "version": "MetricsItem/2.0",
              "size": 0,
              "chartType": 2,
              "resourceType": "microsoft.insights/components",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 120000,
                "endTime": "2023-03-06T13:43:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.insights/components/kusto",
                  "metric": "microsoft.insights/components/kusto-Custom-customMetrics/Heap Memory Used (MB)",
                  "aggregation": 4,
                  "splitBy": "cloud/roleName"
                }
              ],
              "title": "Heap Memory Used (MB)",
              "gridFormatType": 1,
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "1",
                  "key": "cloud/roleName",
                  "operator": 0,
                  "valueParam": "podName"
                }
              ],
              "gridSettings": {
                "formatters": [
                  {
                    "columnMatch": "Subscription",
                    "formatter": 5
                  },
                  {
                    "columnMatch": "Name",
                    "formatter": 13,
                    "formatOptions": {
                      "linkTarget": "Resource"
                    }
                  },
                  {
                    "columnMatch": "microsoft.insights/components/kusto-Custom-customMetrics/Heap Memory Used (MB) Timeline",
                    "formatter": 5
                  },
                  {
                    "columnMatch": "microsoft.insights/components/kusto-Custom-customMetrics/Heap Memory Used (MB)",
                    "formatter": 1,
                    "numberFormat": {
                      "unit": 0,
                      "options": null
                    }
                  },
                  {
                    "columnMatch": "Metric",
                    "formatter": 1
                  },
                  {
                    "columnMatch": "Aggregation",
                    "formatter": 5
                  },
                  {
                    "columnMatch": "Value",
                    "formatter": 1
                  },
                  {
                    "columnMatch": "Timeline",
                    "formatter": 9
                  }
                ],
                "rowLimit": 10000
              }
            },
            "name": "Heap Memory Used (MB)"
          }
        ]
      },
      "customWidth": "50",
      "name": "POD Metrics",
      "styleSettings": {
        "maxWidth": "50"
      }
    }
  ],
  "fallbackResourceIds": [
    "Azure Monitor"
  ],
  "$schema": "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
}
