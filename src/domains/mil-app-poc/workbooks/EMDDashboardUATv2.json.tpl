{
  "version": "Notebook/1.0",
  "items": [
    {
      "type": 11,
      "content": {
        "version": "LinkItem/1.0",
        "style": "tabs",
        "links": [
          {
            "id": "ddde8bae-1136-42ce-acff-959cdd9b79d8",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Panoramica API EMD",
            "subTarget": "emd",
            "style": "emd"
          },
          {
            "id": "5c0b7a34-3f4a-4a42-94cf-27b6a68a7f10",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Monitoraggio Errori",
            "subTarget": "errors",
            "style": "error"
          },
          {
            "id": "8e6b9f72-42f3-4c7c-b3f3-8f1a5e6f2a7b",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Monitoraggio Prestazioni",
            "subTarget": "performance",
            "style": "performance"
          },
          {
            "id": "auth-tab-001",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Autenticazione",
            "subTarget": "autenticazione",
            "style": "auth"
          }
        ]
      },
      "name": "Collegamenti - 0"
    },
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "parameters": [
          {
            "id": "59922e7a-c4cd-45ce-817e-d22bb63909e1",
            "version": "KqlParameterItem/1.0",
            "name": "evaluation_window",
            "label": "Finestra di valutazione",
            "type": 4,
            "typeSettings": {
              "selectableValues": [
                {
                  "durationMs": 300000
                },
                {
                  "durationMs": 3600000
                },
                {
                  "durationMs": 86400000
                },
                {
                  "durationMs": 259200000
                },
                {
                  "durationMs": 604800000
                },
                {
                  "durationMs": 1209600000
                },
                {
                  "durationMs": 2592000000
                }
              ]
            },
            "timeContext": {
              "durationMs": 86400000
            },
            "value": {
              "durationMs": 604800000
            }
          }
        ],
        "style": "pills",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "name": "Parametri - 2"
    },
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "parameters": [
          {
            "id": "59922e7a-c4cd-45ce-817e-d22bb63909e1",
            "version": "KqlParameterItem/1.0",
            "name": "evaluation_window",
            "label": "Finestra di valutazione",
            "type": 4,
            "typeSettings": {
              "selectableValues": [
                {
                  "durationMs": 300000
                },
                {
                  "durationMs": 3600000
                },
                {
                  "durationMs": 86400000
                },
                {
                  "durationMs": 259200000
                },
                {
                  "durationMs": 604800000
                },
                {
                  "durationMs": 1209600000
                },
                {
                  "durationMs": 2592000000
                }
              ]
            },
            "timeContext": {
              "durationMs": 86400000
            },
            "value": {
              "durationMs": 604800000
            }
          }
        ],
        "style": "pills",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "name": "Parametri - 2"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Panoramica API",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s has 'emd/message-core/sendMessage'\n| extend outcome = case(httpStatus_d == 200, \"NO_CHANNELS_ENABLED\", httpStatus_d == 202, \"OK\", \"Unknown\")\n| summarize count() by outcome, tostring(httpStatus_d)",
              "size": 0,
              "title": "API sendMessage",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "piechart"
            },
            "name": "Esiti sendMessage"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s has '/emd/mil/citizen/' and httpMethod_s != 'PUT'\n| where httpStatus_d == 200\n| extend fiscalCode = extract('/emd/mil/citizen/([^/]+)/', 1, requestUri_s)\n| summarize count() by fiscalCode, tostring(toint(httpStatus_d))",
              "size": 0,
              "title": "API Salvataggio Consenso Cittadino",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "table",
              "tileSettings": {
                "showBorder": false,
                "titleContent": {
                  "columnMatch": "fiscalCode",
                  "formatter": 1
                },
                "leftContent": {
                  "columnMatch": "count_",
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
              }
            },
            "name": "Dettagli Salvataggio Consenso"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s has '/emd/mil/citizen/' and httpMethod_s == 'PUT'\n| where httpStatus_d in (200,202)\n| extend fiscalCode = extract('/emd/mil/citizen/([^/]+)/', 1, requestUri_s)\n| summarize count() by fiscalCode, tostring(toint(httpStatus_d))",
              "size": 0,
              "title": "API State Switch",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "table"
            },
            "name": "Dettagli State Switch API"
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "emd"
      },
      "name": "Panoramica API"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Monitoraggio Errori",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s has \"emd/message-core/sendMessage\" or requestUri_s has \"emd/mil/citizen/\"\n| where httpStatus_d !in (200, 202)\n| summarize count() by tostring(httpStatus_d)\n",
              "size": 0,
              "title": "Errori Totali API",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "piechart"
            },
            "name": "Errori Totali API"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s has 'emd/message-core/sendMessage'\n| where httpStatus_d !in (200, 202)\n| summarize count() by tostring(toint(httpStatus_d))\n",
              "size": 0,
              "title": "Errori API sendMessage",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "table",
              "tileSettings": {
                "showBorder": false,
                "titleContent": {
                  "columnMatch": "httpStatus_d",
                  "formatter": 1
                },
                "leftContent": {
                  "columnMatch": "count_",
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
                  "columnMatch": "httpStatus_d",
                  "formatter": 1
                },
                "centerContent": {
                  "columnMatch": "count_",
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
              "mapSettings": {
                "locInfo": "LatLong",
                "sizeSettings": "count_",
                "sizeAggregation": "Sum",
                "legendMetric": "count_",
                "legendAggregation": "Sum",
                "itemColorSettings": {
                  "type": "heatmap",
                  "colorAggregation": "Sum",
                  "nodeColorField": "count_",
                  "heatmapPalette": "greenRed"
                }
              }
            },
            "name": "Errori API sendMessage"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s has '/emd/mil/citizen/' and httpMethod_s != 'PUT'\n| where httpStatus_d !in (200, 202)\n| extend fiscalCode = extract('/emd/mil/citizen/([^/]+)/', 1, requestUri_s)\n| summarize count() by fiscalCode, tostring(toint(httpStatus_d))",
              "size": 0,
              "title": "Errori API Salvataggio Consenso",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "table"
            },
            "name": "Errori API Salvataggio Consenso"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s has '/emd/mil/citizen/' and httpMethod_s == 'PUT'\n| where httpStatus_d !in (200, 202)\n| extend fiscalCode = extract('/emd/mil/citizen/([^/]+)/', 1, requestUri_s)\n| summarize count() by fiscalCode, tostring(toint(httpStatus_d))",
              "size": 0,
              "title": "Errori API State Switch",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "visualization": "table"
            },
            "name": "Errori API State Switch"
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "errors"
      },
      "name": "Monitoraggio Errori"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Monitoraggio Prestazioni",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s has 'emd/message-core/sendMessage'\n| summarize avgLatency = avg(timeTaken_d) by bin(TimeGenerated, 1h)",
              "size": 0,
              "title": "Latenza Media - sendMessage",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "linechart"
            },
            "name": "Latenza Media - sendMessage"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s has \"emd/message-core/sendMessage\" or requestUri_s has \"emd/mil/citizen/\"\n| summarize totalRequests = count() by bin(TimeGenerated, 1h), requestUri_s\n| order by bin(TimeGenerated, 1h)\n",
              "size": 0,
              "title": "Volume Richieste nel Tempo",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "linechart"
            },
            "name": "Volume Richieste nel Tempo"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s has \"emd/message-core/sendMessage\" or requestUri_s has \"emd/mil/citizen/\"\n| where httpStatus_d !in (200,202)\n| summarize errorCount = count() by clientIP_s\n| top 10 by errorCount\n",
              "size": 0,
              "title": "Top IP Client con Errori",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "table",
              "mapSettings": {
                "locInfo": "LatLong",
                "sizeSettings": "errorCount",
                "sizeAggregation": "Sum",
                "legendMetric": "errorCount",
                "legendAggregation": "Sum",
                "itemColorSettings": {
                  "nodeColorField": "errorCount",
                  "colorAggregation": "Sum",
                  "type": "heatmap",
                  "heatmapPalette": "greenRed"
                }
              }
            },
            "name": "Top IP Client con Errori"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s has \"emd/message-core/sendMessage\" or requestUri_s has \"emd/mil/citizen/\"\n| where httpStatus_d in (500)\n| summarize avgLatency = avg(timeTaken_d) by bin(TimeGenerated, 1h)\n",
              "size": 0,
              "title": "Correlazione Latenza Errori (HTTP 500)",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "linechart"
            },
            "name": "Correlazione Latenza Errori (HTTP 500)"
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "performance"
      },
      "name": "Monitoraggio Prestazioni"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Autenticazione",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/auth/token'\n| project stato = tostring(serverStatus_s)\n| summarize count() by stato",
              "size": 0,
              "title": "Panoramica Token",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "piechart",
              "chartSettings": {
                "seriesLabelSettings": [
                  {
                    "seriesName": "200",
                    "color": "green"
                  },
                  {
                    "seriesName": "401",
                    "color": "redBright"
                  }
                ]
              }
            },
            "name": "Panoramica Token"
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "autenticazione"
      },
      "name": "Autenticazione"
    }
  ]
}
