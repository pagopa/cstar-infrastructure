{
  "version": "Notebook/1.0",
  "items": [
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "parameters": [
          {
            "id": "75b945d9-1f77-40e6-a8f6-2356759b8c3b",
            "version": "KqlParameterItem/1.0",
            "name": "timeRangeOverall",
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
              "durationMs": 86400000
            }
          },
          {
            "version": "KqlParameterItem/1.0",
            "name": "timeRangeBeneficiary",
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
              "durationMs": 86400000
            },
            "id": "9c0cdac3-ecdd-46e8-a521-cc03ca45515b"
          },
          {
            "version": "KqlParameterItem/1.0",
            "name": "timeRangeEnte",
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
              "durationMs": 86400000
            },
            "id": "758d1979-c585-4692-b0c3-c97db96b52de"
          },
          {
            "version": "KqlParameterItem/1.0",
            "name": "timeRangeMerchant",
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
              "durationMs": 86400000
            },
            "id": "2cf67bf4-f445-4fe4-9375-bcbd19b9e8d7"
          },
          {
            "version": "KqlParameterItem/1.0",
            "name": "timeRangePayment",
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
              "durationMs": 86400000
            },
            "id": "e39254bc-334b-43ec-b064-87a2889fc3ca"
          },
          {
            "id": "4a7b6e18-8b58-4227-86a9-c6ac65cd7bb8",
            "version": "KqlParameterItem/1.0",
            "name": "timeSpan",
            "type": 10,
            "isRequired": true,
            "typeSettings": {
              "additionalResourceOptions": [],
              "showDefault": false
            },
            "jsonData": "[\r\n{\"label\": \"30s\", \"value\": 30000, \"selected\": false},\r\n{\"label\": \"1m\", \"value\": 60000, \"selected\": true},\r\n{\"label\": \"2m\", \"value\": 120000, \"selected\": false},\r\n{\"label\": \"10m\", \"value\": 600000, \"selected\": false},\r\n{\"label\": \"30m\", \"value\": 3600000, \"selected\": false}\r\n]",
            "timeContext": {
              "durationMs": 86400000
            }
          },
          {
            "id": "8f1076a3-72ca-40c2-9bda-c49e5ce96e7d",
            "version": "KqlParameterItem/1.0",
            "name": "apiBeneficiary",
            "type": 2,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "isHiddenWhenLocked": true,
            "typeSettings": {
              "additionalResourceOptions": [],
              "showDefault": false
            },
            "jsonData": "[\r\n    {\"value\": \"getIban\", \"selected\": true},\r\n    {\"value\": \"getIbanList\", \"selected\": true},\r\n    {\"value\": \"getWallet\", \"selected\": true},\r\n    {\"value\": \"getWalletDetail\", \"selected\": true},\r\n    {\"value\": \"enrollIban\", \"selected\": true},\r\n    {\"value\": \"enrollInstrument\", \"selected\": true},\r\n    {\"value\": \"getInstrumentList\", \"selected\": true},\r\n    {\"value\": \"deleteInstrument\", \"selected\": true},\r\n    {\"value\": \"unsubscribe\", \"selected\": true},\r\n    {\"value\": \"getWalletStatus\", \"selected\": true},\r\n    {\"value\": \"getInitiativesWithInstrument\", \"selected\": true},\r\n    {\"value\": \"getTimeline\", \"selected\": true},\r\n    {\"value\": \"getTimelineDetail\", \"selected\": true},\r\n    {\"value\": \"getInitiativeData\", \"selected\": true},\r\n    {\"value\": \"onboardingCitizen\", \"selected\": true},\r\n    {\"value\": \"checkPrerequisites\", \"selected\": true},\r\n    {\"value\": \"consentOnboarding\", \"selected\": true},\r\n    {\"value\": \"onboardingStatus\", \"selected\": true}\r\n]",
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange"
          },
          {
            "id": "789c75b9-40fe-4ad2-a3e3-1ad2a057bf08",
            "version": "KqlParameterItem/1.0",
            "name": "apiEnte",
            "type": 2,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "isHiddenWhenLocked": true,
            "typeSettings": {
              "additionalResourceOptions": [],
              "showDefault": false
            },
            "jsonData": "[\r\n    {\"value\": \"sendEmail\", \"selected\": true},\r\n    {\"value\": \"getInstitutionProductUserInfo\", \"selected\": true},\r\n    {\"value\": \"uploadGroupOfBeneficiary\", \"selected\": true},\r\n    {\"value\": \"getGroupOfBeneficiaryStatusAndDetails\", \"selected\": true},\r\n    {\"value\": \"getCitizenStatusForInitiative\", \"selected\": true},\r\n    {\"value\": \"getInitiativeBeneficiaryView\", \"selected\": true},\r\n    {\"value\": \"getListOfOrganization\", \"selected\": true},\r\n    {\"value\": \"getInitativeSummary\", \"selected\": true},\r\n    {\"value\": \"getBeneficiaryConfigRules\", \"selected\": true},\r\n    {\"value\": \"getTransactionConfigRules\", \"selected\": true},\r\n    {\"value\": \"getMccConfig\", \"selected\": true},\r\n    {\"value\": \"initiativeStatistics\", \"selected\": true},\r\n    {\"value\": \"getInitiativeDetail\", \"selected\": true},\r\n    {\"value\": \"getIban\", \"selected\": true},\r\n    {\"value\": \"getTimeline\", \"selected\": true},\r\n    {\"value\": \"getTimelineDetail\", \"selected\": true},\r\n    {\"value\": \"getWalletDetail\", \"selected\": true},\r\n    {\"value\": \"getInstrumentList\", \"selected\": true},\r\n    {\"value\": \"logicallyDeleteInitiative\", \"selected\": true},\r\n    {\"value\": \"uploadAndUpdateLogo\", \"selected\": true},\r\n    {\"value\": \"saveInitiativeServiceInfo\", \"selected\": true},\r\n    {\"value\": \"updateInitiativeServiceInfo\", \"selected\": true},\r\n    {\"value\": \"updateInitiativeGeneralInfo\", \"selected\": true},\r\n    {\"value\": \"updateInitiativeBeneficiary\", \"selected\": true},\r\n    {\"value\": \"updateTrxAndRewardRules\", \"selected\": true},\r\n    {\"value\": \"updateInitiativeRefundRule\", \"selected\": true},\r\n    {\"value\": \"updateInitiativeGeneralInfoDraft\", \"selected\": true},\r\n    {\"value\": \"updateInitiativeBeneficiaryDraft\", \"selected\": true},\r\n    {\"value\": \"updateTrxAndRewardRulesDraft\", \"selected\": true},\r\n    {\"value\": \"updateInitiativeRefundRuleDraft\", \"selected\": true},\r\n    {\"value\": \"updateInitiativeApprovedStatus\", \"selected\": true},\r\n    {\"value\": \"updateInitiativeToCheckStatus\", \"selected\": true},\r\n    {\"value\": \"updateInitiativePublishedStatus\", \"selected\": true},\r\n    {\"value\": \"getOnboardingStatus\", \"selected\": true},\r\n    {\"value\": \"getInitiativeOnboardingRankingStatusPaged\", \"selected\": true},\r\n    {\"value\": \"getRankingFileDownload\", \"selected\": true},\r\n    {\"value\": \"notifyCitizenRankings\", \"selected\": true},\r\n    {\"value\": \"getRewardNotificationExportsPaged\", \"selected\": true},\r\n    {\"value\": \"getRewardNotificationImportsPaged\", \"selected\": true},\r\n    {\"value\": \"getRewardFileDownload\", \"selected\": true},\r\n    {\"value\": \"putDispFileUpload\", \"selected\": true},\r\n    {\"value\": \"getDispFileErrors\", \"selected\": true},\r\n    {\"value\": \"getExportSummary\", \"selected\": true},\r\n    {\"value\": \"getExportRefundsListPaged\", \"selected\": true},\r\n    {\"value\": \"getRefundDetail\", \"selected\": true},\r\n    {\"value\": \"getPagoPaAdminToken\", \"selected\": true},\r\n    {\"value\": \"userPermission\", \"selected\": true},\r\n    {\"value\": \"saveConsent\", \"selected\": true},\r\n    {\"value\": \"retrieveConsent\", \"selected\": true}\r\n]",
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange"
          },
          {
            "id": "3afa2d0e-bc7c-415d-ab17-0ebe4b496fcc",
            "version": "KqlParameterItem/1.0",
            "name": "apiMerchant",
            "type": 2,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "isHiddenWhenLocked": true,
            "typeSettings": {
              "additionalResourceOptions": [],
              "showDefault": false
            },
            "jsonData": "[\r\n\t{\"value\": \"uploadMerchantList\", \"selected\": true},\r\n\t{\"value\": \"getMerchantList\", \"selected\": true},\r\n\t{\"value\": \"getMerchantInitiativeList\", \"selected\": true},\r\n\t{\"value\": \"getMerchantDetail\", \"selected\": true}\r\n]",
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange"
          },
          {
            "id": "22f2e1f5-d0f8-4761-bed0-b4951357f2e5",
            "version": "KqlParameterItem/1.0",
            "name": "apiPayment",
            "type": 2,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "isHiddenWhenLocked": true,
            "typeSettings": {
              "additionalResourceOptions": [],
              "showDefault": false
            },
            "jsonData": "[\r\n    {\"value\": \"createTransaction\", \"selected\": true},\r\n    {\"value\": \"putPreAuthPayment\", \"selected\": true},\r\n    {\"value\": \"putAuthPayment\", \"selected\": true},\r\n    {\"value\": \"confirmPaymentQRCode\", \"selected\": true},\r\n    {\"value\": \"getTransaction\", \"selected\": true},\r\n    {\"value\": \"getStatusTransaction\", \"selected\": true}\r\n]",
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange"
          },
          {
            "id": "49e10ca9-6da1-49a0-9ddd-9e8bd017d51c",
            "version": "KqlParameterItem/1.0",
            "name": "apis",
            "type": 2,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "isHiddenWhenLocked": true,
            "typeSettings": {
              "additionalResourceOptions": [],
              "showDefault": false
            },
            "jsonData": "[\r\n    {\"value\": \"getIban\", \"selected\": true},\r\n    {\"value\": \"getIbanList\", \"selected\": true},\r\n    {\"value\": \"getWallet\", \"selected\": true},\r\n    {\"value\": \"getWalletDetail\", \"selected\": true},\r\n    {\"value\": \"enrollIban\", \"selected\": true},\r\n    {\"value\": \"enrollInstrument\", \"selected\": true},\r\n    {\"value\": \"getInstrumentList\", \"selected\": true},\r\n    {\"value\": \"deleteInstrument\", \"selected\": true},\r\n    {\"value\": \"unsubscribe\", \"selected\": true},\r\n    {\"value\": \"getWalletStatus\", \"selected\": true},\r\n    {\"value\": \"getInitiativesWithInstrument\", \"selected\": true},\r\n    {\"value\": \"getTimeline\", \"selected\": true},\r\n    {\"value\": \"getTimelineDetail\", \"selected\": true},\r\n    {\"value\": \"getInitiativeData\", \"selected\": true},\r\n    {\"value\": \"onboardingCitizen\", \"selected\": true},\r\n    {\"value\": \"checkPrerequisites\", \"selected\": true},\r\n    {\"value\": \"consentOnboarding\", \"selected\": true},\r\n    {\"value\": \"onboardingStatus\", \"selected\": true},\r\n\r\n    {\"value\": \"sendEmail\", \"selected\": true},\r\n    {\"value\": \"getInstitutionProductUserInfo\", \"selected\": true},\r\n    {\"value\": \"uploadGroupOfBeneficiary\", \"selected\": true},\r\n    {\"value\": \"getGroupOfBeneficiaryStatusAndDetails\", \"selected\": true},\r\n    {\"value\": \"getCitizenStatusForInitiative\", \"selected\": true},\r\n    {\"value\": \"getInitiativeBeneficiaryView\", \"selected\": true},\r\n    {\"value\": \"getListOfOrganization\", \"selected\": true},\r\n    {\"value\": \"getInitativeSummary\", \"selected\": true},\r\n    {\"value\": \"getBeneficiaryConfigRules\", \"selected\": true},\r\n    {\"value\": \"getTransactionConfigRules\", \"selected\": true},\r\n    {\"value\": \"getMccConfig\", \"selected\": true},\r\n    {\"value\": \"initiativeStatistics\", \"selected\": true},\r\n    {\"value\": \"getInitiativeDetail\", \"selected\": true},\r\n    {\"value\": \"getIban\", \"selected\": true},\r\n    {\"value\": \"getTimeline\", \"selected\": true},\r\n    {\"value\": \"getTimelineDetail\", \"selected\": true},\r\n    {\"value\": \"getWalletDetail\", \"selected\": true},\r\n    {\"value\": \"getInstrumentList\", \"selected\": true},\r\n    {\"value\": \"logicallyDeleteInitiative\", \"selected\": true},\r\n    {\"value\": \"uploadAndUpdateLogo\", \"selected\": true},\r\n    {\"value\": \"saveInitiativeServiceInfo\", \"selected\": true},\r\n    {\"value\": \"updateInitiativeServiceInfo\", \"selected\": true},\r\n    {\"value\": \"updateInitiativeGeneralInfo\", \"selected\": true},\r\n    {\"value\": \"updateInitiativeBeneficiary\", \"selected\": true},\r\n    {\"value\": \"updateTrxAndRewardRules\", \"selected\": true},\r\n    {\"value\": \"updateInitiativeRefundRule\", \"selected\": true},\r\n    {\"value\": \"updateInitiativeGeneralInfoDraft\", \"selected\": true},\r\n    {\"value\": \"updateInitiativeBeneficiaryDraft\", \"selected\": true},\r\n    {\"value\": \"updateTrxAndRewardRulesDraft\", \"selected\": true},\r\n    {\"value\": \"updateInitiativeRefundRuleDraft\", \"selected\": true},\r\n    {\"value\": \"updateInitiativeApprovedStatus\", \"selected\": true},\r\n    {\"value\": \"updateInitiativeToCheckStatus\", \"selected\": true},\r\n    {\"value\": \"updateInitiativePublishedStatus\", \"selected\": true},\r\n    {\"value\": \"getOnboardingStatus\", \"selected\": true},\r\n    {\"value\": \"getInitiativeOnboardingRankingStatusPaged\", \"selected\": true},\r\n    {\"value\": \"getRankingFileDownload\", \"selected\": true},\r\n    {\"value\": \"notifyCitizenRankings\", \"selected\": true},\r\n    {\"value\": \"getRewardNotificationExportsPaged\", \"selected\": true},\r\n    {\"value\": \"getRewardNotificationImportsPaged\", \"selected\": true},\r\n    {\"value\": \"getRewardFileDownload\", \"selected\": true},\r\n    {\"value\": \"putDispFileUpload\", \"selected\": true},\r\n    {\"value\": \"getDispFileErrors\", \"selected\": true},\r\n    {\"value\": \"getExportSummary\", \"selected\": true},\r\n    {\"value\": \"getExportRefundsListPaged\", \"selected\": true},\r\n    {\"value\": \"getRefundDetail\", \"selected\": true},\r\n    {\"value\": \"getPagoPaAdminToken\", \"selected\": true},\r\n    {\"value\": \"userPermission\", \"selected\": true},\r\n    {\"value\": \"saveConsent\", \"selected\": true},\r\n    {\"value\": \"retrieveConsent\", \"selected\": true},\r\n\r\n    {\"value\": \"uploadMerchantList\", \"selected\": true},\r\n\t{\"value\": \"getMerchantList\", \"selected\": true},\r\n\t{\"value\": \"getMerchantInitiativeList\", \"selected\": true},\r\n\t{\"value\": \"getMerchantDetail\", \"selected\": true},\r\n\r\n    {\"value\": \"createTransaction\", \"selected\": true},\r\n    {\"value\": \"putPreAuthPayment\", \"selected\": true},\r\n    {\"value\": \"putAuthPayment\", \"selected\": true},\r\n    {\"value\": \"confirmPaymentQRCode\", \"selected\": true},\r\n    {\"value\": \"getTransaction\", \"selected\": true},\r\n    {\"value\": \"getStatusTransaction\", \"selected\": true}\r\n]",
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange"
          },
          {
            "id": "8fa882e8-6681-4e02-ad8d-886ee80b1542",
            "version": "KqlParameterItem/1.0",
            "name": "eventhubBeneficiary",
            "type": 2,
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
            "jsonData": "[\r\n    \"idpay-onboarding-outcome\",\r\n    \"idpay-onboarding-ranking-request\",\r\n    \"idpay-onboarding-notification\",\r\n    \"idpay-notification-request\",\r\n    \"idpay-timeline\",\r\n    \"idpay-checkiban-evaluation\",\r\n    \"idpay-errors\",\r\n    \"idpay-hpan-update\",\r\n    \"idpay-hpan-update-outcome\",\r\n    \"idpay-transaction\",\r\n    \"idpay-reward-notification-response\",\r\n    \"idpay-onboarding-request\"\r\n]",
            "defaultValue": "value::all"
          },
          {
            "id": "67abb4ea-5233-4a0d-882e-b4e3725572d5",
            "version": "KqlParameterItem/1.0",
            "name": "eventhubEnte",
            "type": 2,
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
            "jsonData": "[\r\n    \"idpay-notification-request\",\r\n    \"idpay-onboarding-notification\",\r\n    \"idpay-onboarding-outcome\",\r\n    \"idpay-onboarding-ranking-request\",\r\n    \"idpay-errors\",\r\n    \"idpay-transaction\",\r\n    \"idpay-rule-update\",\r\n    \"idpay-onboarding-request\"\r\n]",
            "defaultValue": "value::all"
          },
          {
            "id": "45bdb374-f242-4274-8169-32ea993c080a",
            "version": "KqlParameterItem/1.0",
            "name": "eventhubMerchant",
            "type": 2,
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
            "jsonData": "[\r\n    \"idpay-reward-notification-storage-events\",\r\n    \"idpay-errors\"\r\n]",
            "defaultValue": "value::all"
          },
          {
            "id": "cd0faec6-6915-4f4e-8aeb-d3a75c3aa691",
            "version": "KqlParameterItem/1.0",
            "name": "eventhubPayment",
            "type": 2,
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
            "jsonData": "[\r\n    \"idpay-transaction\"\r\n]",
            "defaultValue": "value::all"
          },
          {
            "id": "86ee2dd4-8da1-42e4-b58f-39d582fc0651",
            "version": "KqlParameterItem/1.0",
            "name": "eventhubs",
            "type": 2,
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
            "jsonData": "[\r\n    \"idpay-onboarding-outcome\",\r\n    \"idpay-onboarding-ranking-request\",\r\n    \"idpay-onboarding-notification\",\r\n    \"idpay-notification-request\",\r\n    \"idpay-timeline\",\r\n    \"idpay-checkiban-evaluation\",\r\n    \"idpay-errors\",\r\n    \"idpay-hpan-update\",\r\n    \"idpay-hpan-update-outcome\",\r\n    \"idpay-transaction\",\r\n    \"idpay-reward-notification-response\",\r\n    \"idpay-onboarding-request\",\r\n    \"idpay-rule-update\",\r\n    \"idpay-reward-notification-storage-events\",\r\n    \"idpay-transaction\"\r\n]",
            "defaultValue": "value::all"
          }
        ],
        "style": "pills",
        "queryType": 0,
        "resourceType": "microsoft.insights/components"
      },
      "name": "parameters - 2"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "items": [
          {
            "type": 11,
            "content": {
              "version": "LinkItem/1.0",
              "style": "tabs",
              "links": [
                {
                  "id": "af5a3000-400d-4b80-92a2-7454bfefbdaa",
                  "cellValue": "selectedTab",
                  "linkTarget": "parameter",
                  "linkLabel": "OPEX - OVERALL",
                  "subTarget": "all",
                  "style": "link",
                  "linkIsContextBlade": true
                },
                {
                  "id": "49c95533-9c20-465a-b92b-5bec7f8a46ad",
                  "cellValue": "selectedTab",
                  "linkTarget": "parameter",
                  "linkLabel": "OPEX - BENEFICIARIO",
                  "subTarget": "beneficiary",
                  "style": "link",
                  "linkIsContextBlade": true
                },
                {
                  "id": "604127de-d061-4f1b-88c0-cfb9c7c2ed60",
                  "cellValue": "selectedTab",
                  "linkTarget": "parameter",
                  "linkLabel": "OPEX - ENTE",
                  "subTarget": "ente",
                  "style": "link"
                },
                {
                  "id": "a13f3fde-87c4-42a0-b1a8-fb156f2321a1",
                  "cellValue": "selectedTab",
                  "linkTarget": "parameter",
                  "linkLabel": "OPEX - MERCHANT",
                  "subTarget": "merchant",
                  "style": "link",
                  "linkIsContextBlade": true
                },
                {
                  "id": "637d117b-30b0-4a0a-9be7-23ffdd23c322",
                  "cellValue": "selectedTab",
                  "linkTarget": "parameter",
                  "linkLabel": "OPEX - PAGAMENTI",
                  "subTarget": "payment",
                  "style": "link"
                }
              ]
            },
            "name": "links - 0"
          },
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "items": [
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeOverall:start};\r\nlet endTime = {timeRangeOverall:end};\r\nlet interval = endTime-startTime;\r\nlet totalCount = requests\r\n| where timestamp between (startTime .. endTime)\r\n| where operation_Name has_any ({apis})\r\n| summarize Total = count() by operation_Name;\r\nlet data = requests\r\n| where timestamp between (startTime .. endTime)\r\n| where operation_Name has_any ({apis});\r\ndata\r\n| join kind=inner totalCount on operation_Name\r\n| summarize Count = count(), Users = dcount(user_Id) by operation_Name, resultCode, Total//, timestamp=bin(timestamp,interval)\r\n| project ['Request Name'] = operation_Name, ['Result Code'] = resultCode, ['Total Response'] = Count, ['Rate %'] = (Count*100)/Total, ['Users Affected'] = Users\r\n| sort by ['Request Name']",
                    "size": 0,
                    "timeContextFromParameter": "timeRangeOverall",
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
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeOverall:start};\nlet endTime = {timeRangeOverall:end};\nlet interval = totimespan({timeSpan:label});\n\nlet tot = AzureDiagnostics\n| where requestUri_s has 'idpay'\n| summarize tot = todouble(count()) by bin(TimeGenerated, interval);\nlet y = AzureDiagnostics\n| where requestUri_s has 'idpay'\n| where httpStatus_d < 400 or httpStatus_d == 404\n| summarize n_ok=count() by bin(TimeGenerated, interval);\ny\n| join kind=inner tot  on TimeGenerated | project TimeGenerated, availability = n_ok/tot\n",
                    "size": 0,
                    "aggregation": 3,
                    "showAnalytics": true,
                    "title": "Availability @ AppGateway",
                    "queryType": 0,
                    "resourceType": "microsoft.operationalinsights/workspaces",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-law"
                    ],
                    "visualization": "timechart"
                  },
                  "customWidth": "50",
                  "name": "Availability @ AppGateway"
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeOverall:start};\r\nlet endTime = {timeRangeOverall:end};\r\nlet interval = totimespan({timeSpan:label});\r\n\r\nlet dataset = requests\r\n    // additional filters can be applied here\r\n    | where timestamp between (startTime .. endTime) \r\n        and operation_Name has_any ({apis})\r\n;\r\ndataset\r\n| summarize percentile_95=percentile(duration, 95) by bin(timestamp, interval)\r\n| project timestamp, percentile_95, watermark=1000\r\n| render timechart",
                    "size": 0,
                    "aggregation": 3,
                    "showAnalytics": true,
                    "title": "Requests duration p95",
                    "queryType": 0,
                    "resourceType": "microsoft.insights/components",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                    ],
                    "visualization": "timechart"
                  },
                  "customWidth": "50",
                  "name": "Requests duration p95"
                },
                {
                  "type": 12,
                  "content": {
                    "version": "NotebookGroup/1.0",
                    "groupType": "editable",
                    "title": "API",
                    "items": [
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbooka988ef27-8dda-41dd-8df0-8b15a16c6599",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeOverall",
                          "timeContext": {
                            "durationMs": 86400000
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "customDimensions/Operation Name"
                            }
                          ],
                          "title": "Requests by API",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apis"
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by API"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook3bad6310-d83f-41df-925d-4b24f93a0885",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeOverall",
                          "timeContext": {
                            "durationMs": 86400000
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "request/resultCode"
                            }
                          ],
                          "title": "Requests by code 2xx",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apis"
                            },
                            {
                              "id": "2",
                              "key": "request/resultCode",
                              "operator": 0,
                              "values": [
                                "200",
                                "201",
                                "202",
                                "204"
                              ]
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by code 2xx"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook3bad6310-d83f-41df-925d-4b24f93a0885",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeOverall",
                          "timeContext": {
                            "durationMs": 86400000
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "request/resultCode"
                            }
                          ],
                          "title": "Requests by code 4xx",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apis"
                            },
                            {
                              "id": "2",
                              "key": "request/resultCode",
                              "operator": 0,
                              "values": [
                                "400",
                                "401",
                                "403",
                                "404",
                                "429"
                              ]
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by code 4xx"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook3bad6310-d83f-41df-925d-4b24f93a0885",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeOverall",
                          "timeContext": {
                            "durationMs": 0
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "request/resultCode"
                            }
                          ],
                          "title": "Requests by code 5xx",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apis"
                            },
                            {
                              "id": "2",
                              "key": "request/resultCode",
                              "operator": 0,
                              "values": [
                                "500",
                                "501",
                                "503",
                                "504"
                              ]
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by code 5xx"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook5c67947b-ac01-422c-86e0-3b8f5322f3c7",
                          "version": "MetricsItem/2.0",
                          "size": 0,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeOverall",
                          "timeContext": {
                            "durationMs": 0
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/duration",
                              "aggregation": 4,
                              "splitBy": "operation/name"
                            }
                          ],
                          "title": "Requests response time",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apis"
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests response time"
                      }
                    ]
                  },
                  "customWidth": "50",
                  "name": "API"
                },
                {
                  "type": 12,
                  "content": {
                    "version": "NotebookGroup/1.0",
                    "groupType": "editable",
                    "items": [
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook2f4c21ef-b2c2-4013-8a15-04e72dbdd9fa",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.eventhub/namespaces",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01",
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-00"
                          ],
                          "timeContextFromParameter": "timeRangeOverall",
                          "timeContext": {
                            "durationMs": 86400000
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
                          "title": "Eventhubs incoming-outgoing",
                          "gridFormatType": 1,
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "EntityName",
                              "operator": 0,
                              "valueParam": "eventhubs"
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
                                "columnMatch": "microsoft.eventhub/namespaces--IncomingMessages Timeline",
                                "formatter": 5
                              },
                              {
                                "columnMatch": "microsoft.eventhub/namespaces--IncomingMessages",
                                "formatter": 1,
                                "numberFormat": {
                                  "unit": 0,
                                  "options": null
                                }
                              },
                              {
                                "columnMatch": "microsoft.eventhub/namespaces--OutgoingMessages Timeline",
                                "formatter": 5
                              },
                              {
                                "columnMatch": "microsoft.eventhub/namespaces--OutgoingMessages",
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
                        "name": "Eventhubs incoming-outgoing"
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
                                "chartId": "workbook3e41622d-4b0a-4f4f-b335-b65ef5c909d1",
                                "version": "MetricsItem/2.0",
                                "size": 0,
                                "chartType": 2,
                                "resourceType": "microsoft.eventhub/namespaces",
                                "metricScope": 0,
                                "resourceIds": [
                                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-00"
                                ],
                                "timeContextFromParameter": "timeRangeOverall",
                                "timeContext": {
                                  "durationMs": 86400000
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
                                    "valueParam": "eventhubs"
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
                                "chartId": "workbook95d246e7-53f0-4e0a-9c7b-b99deec02502",
                                "version": "MetricsItem/2.0",
                                "size": 0,
                                "chartType": 2,
                                "resourceType": "microsoft.eventhub/namespaces",
                                "metricScope": 0,
                                "resourceIds": [
                                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-00"
                                ],
                                "timeContextFromParameter": "timeRangeOverall",
                                "timeContext": {
                                  "durationMs": 86400000
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
                                    "valueParam": "eventhubs"
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
                            }
                          ]
                        },
                        "name": "idpay-evh-ns-00"
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
                                "chartId": "workbook3e41622d-4b0a-4f4f-b335-b65ef5c909d1",
                                "version": "MetricsItem/2.0",
                                "size": 0,
                                "chartType": 2,
                                "resourceType": "microsoft.eventhub/namespaces",
                                "metricScope": 0,
                                "resourceIds": [
                                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
                                ],
                                "timeContextFromParameter": "timeRangeOverall",
                                "timeContext": {
                                  "durationMs": 86400000
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
                                    "valueParam": "eventhubs"
                                  }
                                ],
                                "gridSettings": {
                                  "rowLimit": 10000
                                }
                              },
                              "customWidth": "50",
                              "name": "Incoming Messages - Copy",
                              "styleSettings": {
                                "maxWidth": "50"
                              }
                            },
                            {
                              "type": 10,
                              "content": {
                                "chartId": "workbook95d246e7-53f0-4e0a-9c7b-b99deec02502",
                                "version": "MetricsItem/2.0",
                                "size": 0,
                                "chartType": 2,
                                "resourceType": "microsoft.eventhub/namespaces",
                                "metricScope": 0,
                                "resourceIds": [
                                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
                                ],
                                "timeContextFromParameter": "timeRangeOverall",
                                "timeContext": {
                                  "durationMs": 86400000
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
                                    "valueParam": "eventhubs"
                                  }
                                ],
                                "gridSettings": {
                                  "rowLimit": 10000
                                }
                              },
                              "customWidth": "50",
                              "name": "Outgoing Messages - Copy",
                              "styleSettings": {
                                "maxWidth": "50"
                              }
                            }
                          ]
                        },
                        "name": "idpay-evh-ns-01"
                      }
                    ]
                  },
                  "customWidth": "50",
                  "name": "group - 5"
                }
              ]
            },
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "all"
            },
            "name": "all"
          },
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "items": [
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeBeneficiary:start};\r\nlet endTime = {timeRangeBeneficiary:end};\r\nlet interval = endTime-startTime;\r\n\r\nlet totalCount = requests\r\n| where timestamp between (startTime .. endTime)\r\n| where operation_Name has_any ({apiBeneficiary})\r\n| summarize Total = count() by operation_Name;\r\nlet data = requests\r\n| where timestamp between (startTime .. endTime)\r\n| where operation_Name has_any ({apiBeneficiary});\r\ndata\r\n| join kind=inner totalCount on operation_Name\r\n| summarize Count = count(), Users = dcount(user_Id) by operation_Name, resultCode, Total//, timestamp=bin(timestamp,interval)\r\n| project ['Request Name'] = operation_Name, ['Result Code'] = resultCode, ['Total Response'] = Count, ['Rate %'] = (Count*100)/Total, ['Users Affected'] = Users\r\n| sort by ['Request Name']",
                    "size": 0,
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
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeBeneficiary:start};\nlet endTime = {timeRangeBeneficiary:end};\nlet interval = totimespan({timeSpan:label});\n\nrequests\n| where timestamp between (startTime .. endTime)\n| where operation_Name has_any ({apiBeneficiary})\n| summarize total = count(), n_ok = countif(resultCode startswith '2'  or resultCode == '404') by bin(timestamp,interval)\n| project timestamp, availability = todouble(n_ok)/total\n| join kind=fullouter (range timestamp from startTime to endTime step interval) on timestamp\n| project timestamp=coalesce(timestamp,timestamp1), availability = coalesce(availability,1.0), watermark=0.99",
                    "size": 0,
                    "aggregation": 3,
                    "showAnalytics": true,
                    "title": "Availability",
                    "queryType": 0,
                    "resourceType": "microsoft.insights/components",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                    ],
                    "visualization": "timechart"
                  },
                  "customWidth": "50",
                  "name": "Availability"
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeBeneficiary:start};\r\nlet endTime = {timeRangeBeneficiary:end};\r\nlet interval = totimespan({timeSpan:label});\r\n\r\nlet dataset = requests\r\n    // additional filters can be applied here\r\n    | where timestamp between (startTime .. endTime) \r\n        and operation_Name has_any ({apiBeneficiary})\r\n;\r\ndataset\r\n| summarize percentile_95=percentile(duration, 95) by bin(timestamp, interval)\r\n| project timestamp, percentile_95, watermark=1000\r\n| render timechart",
                    "size": 0,
                    "aggregation": 3,
                    "showAnalytics": true,
                    "title": "Requests duration p95",
                    "queryType": 0,
                    "resourceType": "microsoft.insights/components",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                    ]
                  },
                  "customWidth": "50",
                  "name": "Requests duration p95"
                },
                {
                  "type": 12,
                  "content": {
                    "version": "NotebookGroup/1.0",
                    "groupType": "editable",
                    "title": "API",
                    "items": [
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbooka988ef27-8dda-41dd-8df0-8b15a16c6599",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeBeneficiary",
                          "timeContext": {
                            "durationMs": 86400000
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "customDimensions/Operation Name"
                            }
                          ],
                          "title": "Requests by API",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiBeneficiary"
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by API"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook3bad6310-d83f-41df-925d-4b24f93a0885",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeBeneficiary",
                          "timeContext": {
                            "durationMs": 86400000
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "request/resultCode"
                            }
                          ],
                          "title": "Requests by code 2xx",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiBeneficiary"
                            },
                            {
                              "id": "2",
                              "key": "request/resultCode",
                              "operator": 0,
                              "values": [
                                "200",
                                "201",
                                "202",
                                "204"
                              ]
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by code 2xx"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook3bad6310-d83f-41df-925d-4b24f93a0885",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeBeneficiary",
                          "timeContext": {
                            "durationMs": 86400000
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "request/resultCode"
                            }
                          ],
                          "title": "Requests by code 4xx",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiBeneficiary"
                            },
                            {
                              "id": "2",
                              "key": "request/resultCode",
                              "operator": 0,
                              "values": [
                                "400",
                                "401",
                                "403",
                                "404",
                                "429"
                              ]
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by code 4xx"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook3bad6310-d83f-41df-925d-4b24f93a0885",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeBeneficiary",
                          "timeContext": {
                            "durationMs": 86400000
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "request/resultCode"
                            }
                          ],
                          "title": "Requests by code 5xx",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiBeneficiary"
                            },
                            {
                              "id": "2",
                              "key": "request/resultCode",
                              "operator": 0,
                              "values": [
                                "500",
                                "501",
                                "503",
                                "504"
                              ]
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by code 5xx"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook5c67947b-ac01-422c-86e0-3b8f5322f3c7",
                          "version": "MetricsItem/2.0",
                          "size": 0,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeBeneficiary",
                          "timeContext": {
                            "durationMs": 86400000
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/duration",
                              "aggregation": 4,
                              "splitBy": "operation/name"
                            }
                          ],
                          "title": "Requests response time",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiBeneficiary"
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests response time"
                      }
                    ]
                  },
                  "customWidth": "50",
                  "name": "API"
                },
                {
                  "type": 12,
                  "content": {
                    "version": "NotebookGroup/1.0",
                    "groupType": "editable",
                    "items": [
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook2f4c21ef-b2c2-4013-8a15-04e72dbdd9fa",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.eventhub/namespaces",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01",
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-00"
                          ],
                          "timeContextFromParameter": "timeRangeBeneficiary",
                          "timeContext": {
                            "durationMs": 86400000
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
                          "title": "Eventhubs incoming-outgoing",
                          "gridFormatType": 1,
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "EntityName",
                              "operator": 0,
                              "valueParam": "eventhubBeneficiary"
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
                                "columnMatch": "microsoft.eventhub/namespaces--IncomingMessages Timeline",
                                "formatter": 5
                              },
                              {
                                "columnMatch": "microsoft.eventhub/namespaces--IncomingMessages",
                                "formatter": 1,
                                "numberFormat": {
                                  "unit": 0,
                                  "options": null
                                }
                              },
                              {
                                "columnMatch": "microsoft.eventhub/namespaces--OutgoingMessages Timeline",
                                "formatter": 5
                              },
                              {
                                "columnMatch": "microsoft.eventhub/namespaces--OutgoingMessages",
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
                        "name": "Eventhubs incoming-outgoing"
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
                                "chartId": "workbook3e41622d-4b0a-4f4f-b335-b65ef5c909d1",
                                "version": "MetricsItem/2.0",
                                "size": 0,
                                "chartType": 2,
                                "resourceType": "microsoft.eventhub/namespaces",
                                "metricScope": 0,
                                "resourceIds": [
                                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-00"
                                ],
                                "timeContextFromParameter": "timeRangeBeneficiary",
                                "timeContext": {
                                  "durationMs": 86400000
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
                                    "valueParam": "eventhubBeneficiary"
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
                                "chartId": "workbook95d246e7-53f0-4e0a-9c7b-b99deec02502",
                                "version": "MetricsItem/2.0",
                                "size": 0,
                                "chartType": 2,
                                "resourceType": "microsoft.eventhub/namespaces",
                                "metricScope": 0,
                                "resourceIds": [
                                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-00"
                                ],
                                "timeContextFromParameter": "timeRangeBeneficiary",
                                "timeContext": {
                                  "durationMs": 86400000
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
                                    "valueParam": "eventhubBeneficiary"
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
                            }
                          ]
                        },
                        "name": "idpay-evh-ns-00"
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
                                "chartId": "workbook3e41622d-4b0a-4f4f-b335-b65ef5c909d1",
                                "version": "MetricsItem/2.0",
                                "size": 0,
                                "chartType": 2,
                                "resourceType": "microsoft.eventhub/namespaces",
                                "metricScope": 0,
                                "resourceIds": [
                                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
                                ],
                                "timeContextFromParameter": "timeRangeBeneficiary",
                                "timeContext": {
                                  "durationMs": 86400000
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
                                    "valueParam": "eventhubBeneficiary"
                                  }
                                ],
                                "gridSettings": {
                                  "rowLimit": 10000
                                }
                              },
                              "customWidth": "50",
                              "name": "Incoming Messages - Copy",
                              "styleSettings": {
                                "maxWidth": "50"
                              }
                            },
                            {
                              "type": 10,
                              "content": {
                                "chartId": "workbook95d246e7-53f0-4e0a-9c7b-b99deec02502",
                                "version": "MetricsItem/2.0",
                                "size": 0,
                                "chartType": 2,
                                "resourceType": "microsoft.eventhub/namespaces",
                                "metricScope": 0,
                                "resourceIds": [
                                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
                                ],
                                "timeContextFromParameter": "timeRangeBeneficiary",
                                "timeContext": {
                                  "durationMs": 86400000
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
                                    "valueParam": "eventhubBeneficiary"
                                  }
                                ],
                                "gridSettings": {
                                  "rowLimit": 10000
                                }
                              },
                              "customWidth": "50",
                              "name": "Outgoing Messages - Copy",
                              "styleSettings": {
                                "maxWidth": "50"
                              }
                            }
                          ]
                        },
                        "name": "idpay-evh-ns-01"
                      }
                    ]
                  },
                  "customWidth": "50",
                  "name": "group - 5"
                }
              ]
            },
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "beneficiary"
            },
            "name": "beneficiary"
          },
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "items": [
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeEnte:start};\r\nlet endTime = {timeRangeEnte:end};\r\nlet interval = endTime-startTime;\r\n\r\nlet totalCount = requests\r\n| where timestamp between (startTime .. endTime)\r\n| where operation_Name has_any ({apiEnte})\r\n| summarize Total = count() by operation_Name;\r\nlet data = requests\r\n| where timestamp between (startTime .. endTime)\r\n| where operation_Name has_any ({apiEnte});\r\ndata\r\n| join kind=inner totalCount on operation_Name\r\n| summarize Count = count(), Users = dcount(user_Id) by operation_Name, resultCode, Total//, timestamp=bin(timestamp,interval)\r\n| project ['Request Name'] = operation_Name, ['Result Code'] = resultCode, ['Total Response'] = Count, ['Rate %'] = (Count*100)/Total, ['Users Affected'] = Users\r\n| sort by ['Request Name']",
                    "size": 0,
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
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeEnte:start};\nlet endTime = {timeRangeEnte:end};\nlet interval = totimespan({timeSpan:label});\n\nrequests\n| where timestamp between (startTime .. endTime)\n| where operation_Name has_any ({apiEnte})\n| summarize total = count(), n_ok = countif(resultCode startswith '2' or resultCode == '404') by bin(timestamp,interval)\n| project timestamp, availability = todouble(n_ok)/total\n| join kind=fullouter (range timestamp from startTime to endTime step interval) on timestamp\n| project timestamp=coalesce(timestamp,timestamp1), availability = coalesce(availability,1.0), watermark=0.99",
                    "size": 0,
                    "aggregation": 3,
                    "title": "Availability",
                    "queryType": 0,
                    "resourceType": "microsoft.insights/components",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                    ],
                    "visualization": "timechart"
                  },
                  "customWidth": "50",
                  "name": "Availability"
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeEnte:start};\r\nlet endTime = {timeRangeEnte:end};\r\nlet interval = totimespan({timeSpan:label});\r\n\r\nlet dataset = requests\r\n    // additional filters can be applied here\r\n    | where timestamp between (startTime .. endTime) \r\n        and operation_Name has_any ({apiEnte})\r\n;\r\ndataset\r\n| summarize percentile_95=percentile(duration, 95) by bin(timestamp, interval)\r\n| project timestamp, percentile_95, watermark=1000\r\n| render timechart",
                    "size": 0,
                    "aggregation": 3,
                    "showAnalytics": true,
                    "title": "Requests duration p95",
                    "queryType": 0,
                    "resourceType": "microsoft.insights/components",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                    ]
                  },
                  "customWidth": "50",
                  "name": "Requests duration p95"
                },
                {
                  "type": 12,
                  "content": {
                    "version": "NotebookGroup/1.0",
                    "groupType": "editable",
                    "title": "API",
                    "items": [
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbooka988ef27-8dda-41dd-8df0-8b15a16c6599",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeEnte",
                          "timeContext": {
                            "durationMs": 86400000
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "customDimensions/Operation Name"
                            }
                          ],
                          "title": "Requests by API",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiEnte"
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by API"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook3bad6310-d83f-41df-925d-4b24f93a0885",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeEnte",
                          "timeContext": {
                            "durationMs": 86400000
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "request/resultCode"
                            }
                          ],
                          "title": "Requests by code 2xx",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiEnte"
                            },
                            {
                              "id": "2",
                              "key": "request/resultCode",
                              "operator": 0,
                              "values": [
                                "200",
                                "201",
                                "202",
                                "204"
                              ]
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by code 2xx"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook3bad6310-d83f-41df-925d-4b24f93a0885",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeEnte",
                          "timeContext": {
                            "durationMs": 86400000
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "request/resultCode"
                            }
                          ],
                          "title": "Requests by code 4xx",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiEnte"
                            },
                            {
                              "id": "2",
                              "key": "request/resultCode",
                              "operator": 0,
                              "values": [
                                "400",
                                "401",
                                "403",
                                "404",
                                "429"
                              ]
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by code 4xx"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook3bad6310-d83f-41df-925d-4b24f93a0885",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeEnte",
                          "timeContext": {
                            "durationMs": 86400000
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "request/resultCode"
                            }
                          ],
                          "title": "Requests by code 5xx",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiEnte"
                            },
                            {
                              "id": "2",
                              "key": "request/resultCode",
                              "operator": 0,
                              "values": [
                                "500",
                                "501",
                                "503",
                                "504"
                              ]
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by code 5xx"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook5c67947b-ac01-422c-86e0-3b8f5322f3c7",
                          "version": "MetricsItem/2.0",
                          "size": 0,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeEnte",
                          "timeContext": {
                            "durationMs": 86400000
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/duration",
                              "aggregation": 4,
                              "splitBy": "operation/name"
                            }
                          ],
                          "title": "Requests response time",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiEnte"
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests response time"
                      }
                    ]
                  },
                  "customWidth": "50",
                  "name": "API"
                },
                {
                  "type": 12,
                  "content": {
                    "version": "NotebookGroup/1.0",
                    "groupType": "editable",
                    "items": [
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook2f4c21ef-b2c2-4013-8a15-04e72dbdd9fa",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.eventhub/namespaces",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01",
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-00"
                          ],
                          "timeContextFromParameter": "timeRangeEnte",
                          "timeContext": {
                            "durationMs": 86400000
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
                          "title": "Eventhubs incoming-outgoing",
                          "gridFormatType": 1,
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "EntityName",
                              "operator": 0,
                              "valueParam": "eventhubEnte"
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
                                "columnMatch": "microsoft.eventhub/namespaces--IncomingMessages Timeline",
                                "formatter": 5
                              },
                              {
                                "columnMatch": "microsoft.eventhub/namespaces--IncomingMessages",
                                "formatter": 1,
                                "numberFormat": {
                                  "unit": 0,
                                  "options": null
                                }
                              },
                              {
                                "columnMatch": "microsoft.eventhub/namespaces--OutgoingMessages Timeline",
                                "formatter": 5
                              },
                              {
                                "columnMatch": "microsoft.eventhub/namespaces--OutgoingMessages",
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
                        "name": "Eventhubs incoming-outgoing"
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
                                "chartId": "workbook3e41622d-4b0a-4f4f-b335-b65ef5c909d1",
                                "version": "MetricsItem/2.0",
                                "size": 0,
                                "chartType": 2,
                                "resourceType": "microsoft.eventhub/namespaces",
                                "metricScope": 0,
                                "resourceIds": [
                                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-00"
                                ],
                                "timeContextFromParameter": "timeRangeEnte",
                                "timeContext": {
                                  "durationMs": 86400000
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
                                    "valueParam": "eventhubEnte"
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
                                "chartId": "workbook95d246e7-53f0-4e0a-9c7b-b99deec02502",
                                "version": "MetricsItem/2.0",
                                "size": 0,
                                "chartType": 2,
                                "resourceType": "microsoft.eventhub/namespaces",
                                "metricScope": 0,
                                "resourceIds": [
                                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-00"
                                ],
                                "timeContextFromParameter": "timeRangeEnte",
                                "timeContext": {
                                  "durationMs": 86400000
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
                                    "valueParam": "eventhubEnte"
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
                            }
                          ]
                        },
                        "name": "idpay-evh-ns-00"
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
                                "chartId": "workbook3e41622d-4b0a-4f4f-b335-b65ef5c909d1",
                                "version": "MetricsItem/2.0",
                                "size": 0,
                                "chartType": 2,
                                "resourceType": "microsoft.eventhub/namespaces",
                                "metricScope": 0,
                                "resourceIds": [
                                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
                                ],
                                "timeContextFromParameter": "timeRangeEnte",
                                "timeContext": {
                                  "durationMs": 86400000
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
                                    "valueParam": "eventhubEnte"
                                  }
                                ],
                                "gridSettings": {
                                  "rowLimit": 10000
                                }
                              },
                              "customWidth": "50",
                              "name": "Incoming Messages - Copy",
                              "styleSettings": {
                                "maxWidth": "50"
                              }
                            },
                            {
                              "type": 10,
                              "content": {
                                "chartId": "workbook95d246e7-53f0-4e0a-9c7b-b99deec02502",
                                "version": "MetricsItem/2.0",
                                "size": 0,
                                "chartType": 2,
                                "resourceType": "microsoft.eventhub/namespaces",
                                "metricScope": 0,
                                "resourceIds": [
                                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
                                ],
                                "timeContextFromParameter": "timeRangeEnte",
                                "timeContext": {
                                  "durationMs": 86400000
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
                                    "valueParam": "eventhubEnte"
                                  }
                                ],
                                "gridSettings": {
                                  "rowLimit": 10000
                                }
                              },
                              "customWidth": "50",
                              "name": "Outgoing Messages - Copy",
                              "styleSettings": {
                                "maxWidth": "50"
                              }
                            }
                          ]
                        },
                        "name": "idpay-evh-ns-01"
                      }
                    ]
                  },
                  "customWidth": "50",
                  "name": "group - 5"
                }
              ]
            },
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "ente"
            },
            "name": "ente"
          },
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "items": [
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeMerchant:start};\r\nlet endTime = {timeRangeMerchant:end};\r\nlet interval = endTime-startTime;\r\n\r\nlet totalCount = requests\r\n| where timestamp between (startTime .. endTime)\r\n| where operation_Name has_any ({apiMerchant})\r\n| summarize Total = count() by operation_Name;\r\nlet data = requests\r\n| where timestamp between (startTime .. endTime)\r\n| where operation_Name has_any ({apiMerchant});\r\ndata\r\n| join kind=inner totalCount on operation_Name\r\n| summarize Count = count(), Users = dcount(user_Id) by operation_Name, resultCode, Total//, timestamp=bin(timestamp,interval)\r\n| project ['Request Name'] = operation_Name, ['Result Code'] = resultCode, ['Total Response'] = Count, ['Rate %'] = (Count*100)/Total, ['Users Affected'] = Users\r\n| sort by ['Request Name']",
                    "size": 0,
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
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeMerchant:start};\nlet endTime = {timeRangeMerchant:end};\nlet interval = totimespan({timeSpan:label});\n\nrequests\n| where timestamp between (startTime .. endTime)\n| where operation_Name has_any ({apiMerchant})\n| summarize total = count(), n_ok = countif(resultCode startswith '2' or resultCode == '404') by bin(timestamp,interval)\n| project timestamp, availability = todouble(n_ok)/total\n| join kind=fullouter (range timestamp from startTime to endTime step interval) on timestamp\n| project timestamp=coalesce(timestamp,timestamp1), availability = coalesce(availability,1.0), watermark = 0.99",
                    "size": 0,
                    "aggregation": 3,
                    "title": "Availability",
                    "queryType": 0,
                    "resourceType": "microsoft.insights/components",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                    ],
                    "visualization": "timechart"
                  },
                  "customWidth": "50",
                  "name": "Availability"
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeMerchant:start};\r\nlet endTime = {timeRangeMerchant:end};\r\nlet interval = totimespan({timeSpan:label});\r\n\r\nlet dataset = requests\r\n    // additional filters can be applied here\r\n    | where timestamp between (startTime .. endTime) \r\n        and operation_Name has_any ({apiMerchant})\r\n;\r\ndataset\r\n| summarize percentile_95=percentile(duration, 95) by bin(timestamp, interval)\r\n| project timestamp, percentile_95, watermark=1000\r\n| render timechart",
                    "size": 0,
                    "aggregation": 3,
                    "showAnalytics": true,
                    "title": "Requests duration p95",
                    "queryType": 0,
                    "resourceType": "microsoft.insights/components",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                    ]
                  },
                  "customWidth": "50",
                  "name": "Requests duration p95"
                },
                {
                  "type": 12,
                  "content": {
                    "version": "NotebookGroup/1.0",
                    "groupType": "editable",
                    "title": "API",
                    "items": [
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbooka988ef27-8dda-41dd-8df0-8b15a16c6599",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeMerchant",
                          "timeContext": {
                            "durationMs": 86400000
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "customDimensions/Operation Name"
                            }
                          ],
                          "title": "Requests by API",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiMerchant"
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by API"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook3bad6310-d83f-41df-925d-4b24f93a0885",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeMerchant",
                          "timeContext": {
                            "durationMs": 86400000
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "request/resultCode"
                            }
                          ],
                          "title": "Requests by code 2xx",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiMerchant"
                            },
                            {
                              "id": "2",
                              "key": "request/resultCode",
                              "operator": 0,
                              "values": [
                                "200",
                                "201",
                                "202",
                                "204"
                              ]
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by code 2xx"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook3bad6310-d83f-41df-925d-4b24f93a0885",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeMerchant",
                          "timeContext": {
                            "durationMs": 86400000
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "request/resultCode"
                            }
                          ],
                          "title": "Requests by code 4xx",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiMerchant"
                            },
                            {
                              "id": "2",
                              "key": "request/resultCode",
                              "operator": 0,
                              "values": [
                                "400",
                                "401",
                                "403",
                                "404",
                                "429"
                              ]
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by code 4xx"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook3bad6310-d83f-41df-925d-4b24f93a0885",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeMerchant",
                          "timeContext": {
                            "durationMs": 86400000
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "request/resultCode"
                            }
                          ],
                          "title": "Requests by code 5xx",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiMerchant"
                            },
                            {
                              "id": "2",
                              "key": "request/resultCode",
                              "operator": 0,
                              "values": [
                                "500",
                                "501",
                                "503",
                                "504"
                              ]
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by code 5xx"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook5c67947b-ac01-422c-86e0-3b8f5322f3c7",
                          "version": "MetricsItem/2.0",
                          "size": 0,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangeMerchant",
                          "timeContext": {
                            "durationMs": 86400000
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/duration",
                              "aggregation": 4,
                              "splitBy": "operation/name"
                            }
                          ],
                          "title": "Requests response time",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiMerchant"
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests response time"
                      }
                    ]
                  },
                  "customWidth": "50",
                  "name": "API"
                },
                {
                  "type": 12,
                  "content": {
                    "version": "NotebookGroup/1.0",
                    "groupType": "editable",
                    "items": [
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook2f4c21ef-b2c2-4013-8a15-04e72dbdd9fa",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.eventhub/namespaces",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
                          ],
                          "timeContextFromParameter": "timeRangeMerchant",
                          "timeContext": {
                            "durationMs": 86400000
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
                          "title": "Eventhubs incoming-outgoing",
                          "gridFormatType": 1,
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "EntityName",
                              "operator": 0,
                              "valueParam": "eventhubMerchant"
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
                                "columnMatch": "microsoft.eventhub/namespaces--IncomingMessages Timeline",
                                "formatter": 5
                              },
                              {
                                "columnMatch": "microsoft.eventhub/namespaces--IncomingMessages",
                                "formatter": 1,
                                "numberFormat": {
                                  "unit": 0,
                                  "options": null
                                }
                              },
                              {
                                "columnMatch": "microsoft.eventhub/namespaces--OutgoingMessages Timeline",
                                "formatter": 5
                              },
                              {
                                "columnMatch": "microsoft.eventhub/namespaces--OutgoingMessages",
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
                        "name": "Eventhubs incoming-outgoing"
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
                                "chartId": "workbook3e41622d-4b0a-4f4f-b335-b65ef5c909d1",
                                "version": "MetricsItem/2.0",
                                "size": 0,
                                "chartType": 2,
                                "resourceType": "microsoft.eventhub/namespaces",
                                "metricScope": 0,
                                "resourceIds": [
                                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
                                ],
                                "timeContextFromParameter": "timeRangeMerchant",
                                "timeContext": {
                                  "durationMs": 86400000
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
                                    "valueParam": "eventhubMerchant"
                                  }
                                ],
                                "gridSettings": {
                                  "rowLimit": 10000
                                }
                              },
                              "customWidth": "50",
                              "name": "Incoming Messages - Copy",
                              "styleSettings": {
                                "maxWidth": "50"
                              }
                            },
                            {
                              "type": 10,
                              "content": {
                                "chartId": "workbook95d246e7-53f0-4e0a-9c7b-b99deec02502",
                                "version": "MetricsItem/2.0",
                                "size": 0,
                                "chartType": 2,
                                "resourceType": "microsoft.eventhub/namespaces",
                                "metricScope": 0,
                                "resourceIds": [
                                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
                                ],
                                "timeContextFromParameter": "timeRangeMerchant",
                                "timeContext": {
                                  "durationMs": 86400000
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
                                    "valueParam": "eventhubMerchant"
                                  }
                                ],
                                "gridSettings": {
                                  "rowLimit": 10000
                                }
                              },
                              "customWidth": "50",
                              "name": "Outgoing Messages - Copy",
                              "styleSettings": {
                                "maxWidth": "50"
                              }
                            }
                          ]
                        },
                        "name": "idpay-evh-ns-01"
                      }
                    ]
                  },
                  "customWidth": "50",
                  "name": "group - 5"
                }
              ]
            },
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "merchant"
            },
            "name": "merchant"
          },
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "items": [
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangePayment:start};\r\nlet endTime = {timeRangePayment:end};\r\nlet interval = endTime-startTime;\r\n\r\nlet totalCount = requests\r\n| where timestamp between (startTime .. endTime)\r\n| where operation_Name has_any ({apiPayment})\r\n| summarize Total = count() by operation_Name;\r\nlet data = requests\r\n| where timestamp between (startTime .. endTime)\r\n| where operation_Name has_any ({apiPayment});\r\ndata\r\n| join kind=inner totalCount on operation_Name\r\n| summarize Count = count(), Users = dcount(user_Id) by operation_Name, resultCode, Total//, timestamp=bin(timestamp,interval)\r\n| project ['Request Name'] = operation_Name, ['Result Code'] = resultCode, ['Total Response'] = Count, ['Rate %'] = (Count*100)/Total, ['Users Affected'] = Users\r\n| sort by ['Request Name']",
                    "size": 0,
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
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangePayment:start};\nlet endTime = {timeRangePayment:end};\nlet interval = totimespan({timeSpan:label});\n\nrequests\n| where timestamp between (startTime .. endTime)\n| where operation_Name has_any ({apiPayment})\n| summarize total = count(), n_ok = countif(resultCode startswith '2' or resultCode == '404') by bin(timestamp,interval)\n| project timestamp, availability = todouble(n_ok)/total\n| join kind=fullouter (range timestamp from startTime to endTime step interval) on timestamp\n| project timestamp=coalesce(timestamp,timestamp1), availability = coalesce(availability,1.0), watermark = 0.99",
                    "size": 0,
                    "aggregation": 3,
                    "title": "Availability",
                    "queryType": 0,
                    "resourceType": "microsoft.insights/components",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                    ],
                    "visualization": "timechart"
                  },
                  "customWidth": "50",
                  "name": "Availability"
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangePayment:start};\r\nlet endTime = {timeRangePayment:end};\r\nlet interval = totimespan({timeSpan:label});\r\n\r\nlet dataset = requests\r\n    // additional filters can be applied here\r\n    | where timestamp between (startTime .. endTime) \r\n        and operation_Name has_any ({apiPayment})\r\n;\r\ndataset\r\n| summarize percentile_95=percentile(duration, 95) by bin(timestamp, interval)\r\n| project timestamp, percentile_95, watermark=1000\r\n| render timechart",
                    "size": 0,
                    "aggregation": 3,
                    "showAnalytics": true,
                    "title": "Requests duration p95",
                    "queryType": 0,
                    "resourceType": "microsoft.insights/components",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                    ]
                  },
                  "customWidth": "50",
                  "name": "Requests duration p95"
                },
                {
                  "type": 12,
                  "content": {
                    "version": "NotebookGroup/1.0",
                    "groupType": "editable",
                    "title": "API",
                    "items": [
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbooka988ef27-8dda-41dd-8df0-8b15a16c6599",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangePayment",
                          "timeContext": {
                            "durationMs": 0
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "customDimensions/Operation Name"
                            }
                          ],
                          "title": "Requests by API",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiPayment"
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by API"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook3bad6310-d83f-41df-925d-4b24f93a0885",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangePayment",
                          "timeContext": {
                            "durationMs": 0
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "request/resultCode"
                            }
                          ],
                          "title": "Requests by code 2xx",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiPayment"
                            },
                            {
                              "id": "2",
                              "key": "request/resultCode",
                              "operator": 0,
                              "values": [
                                "200",
                                "201",
                                "202",
                                "204"
                              ]
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by code 2xx"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook3bad6310-d83f-41df-925d-4b24f93a0885",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangePayment",
                          "timeContext": {
                            "durationMs": 0
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "request/resultCode"
                            }
                          ],
                          "title": "Requests by code 4xx",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiPayment"
                            },
                            {
                              "id": "2",
                              "key": "request/resultCode",
                              "operator": 0,
                              "values": [
                                "400",
                                "401",
                                "403",
                                "404",
                                "429"
                              ]
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by code 4xx"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook3bad6310-d83f-41df-925d-4b24f93a0885",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangePayment",
                          "timeContext": {
                            "durationMs": 0
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/count",
                              "aggregation": 1,
                              "splitBy": "request/resultCode"
                            }
                          ],
                          "title": "Requests by code 5xx",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiPayment"
                            },
                            {
                              "id": "2",
                              "key": "request/resultCode",
                              "operator": 0,
                              "values": [
                                "500",
                                "501",
                                "503",
                                "504"
                              ]
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests by code 5xx"
                      },
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook5c67947b-ac01-422c-86e0-3b8f5322f3c7",
                          "version": "MetricsItem/2.0",
                          "size": 0,
                          "chartType": 2,
                          "resourceType": "microsoft.insights/components",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
                          ],
                          "timeContextFromParameter": "timeRangePayment",
                          "timeContext": {
                            "durationMs": 0
                          },
                          "metrics": [
                            {
                              "namespace": "microsoft.insights/components/kusto",
                              "metric": "microsoft.insights/components/kusto-Server-requests/duration",
                              "aggregation": 4,
                              "splitBy": "operation/name"
                            }
                          ],
                          "title": "Requests response time",
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "customDimensions/Operation Name",
                              "operator": 0,
                              "valueParam": "apiPayment"
                            }
                          ],
                          "gridSettings": {
                            "rowLimit": 10000
                          }
                        },
                        "name": "Requests response time"
                      }
                    ]
                  },
                  "customWidth": "50",
                  "name": "API"
                },
                {
                  "type": 12,
                  "content": {
                    "version": "NotebookGroup/1.0",
                    "groupType": "editable",
                    "items": [
                      {
                        "type": 10,
                        "content": {
                          "chartId": "workbook2f4c21ef-b2c2-4013-8a15-04e72dbdd9fa",
                          "version": "MetricsItem/2.0",
                          "size": 1,
                          "chartType": 2,
                          "resourceType": "microsoft.eventhub/namespaces",
                          "metricScope": 0,
                          "resourceIds": [
                            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
                          ],
                          "timeContextFromParameter": "timeRangePayment",
                          "timeContext": {
                            "durationMs": 1814400000,
                            "endTime": "2023-05-31T10:23:00.000Z"
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
                          "title": "Eventhubs incoming-outgoing",
                          "gridFormatType": 1,
                          "showOpenInMe": true,
                          "filters": [
                            {
                              "id": "1",
                              "key": "EntityName",
                              "operator": 0,
                              "valueParam": "eventhubPayment"
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
                                "columnMatch": "microsoft.eventhub/namespaces--IncomingMessages Timeline",
                                "formatter": 5
                              },
                              {
                                "columnMatch": "microsoft.eventhub/namespaces--IncomingMessages",
                                "formatter": 1,
                                "numberFormat": {
                                  "unit": 0,
                                  "options": null
                                }
                              },
                              {
                                "columnMatch": "microsoft.eventhub/namespaces--OutgoingMessages Timeline",
                                "formatter": 5
                              },
                              {
                                "columnMatch": "microsoft.eventhub/namespaces--OutgoingMessages",
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
                        "name": "Eventhubs incoming-outgoing"
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
                                "chartId": "workbook3e41622d-4b0a-4f4f-b335-b65ef5c909d1",
                                "version": "MetricsItem/2.0",
                                "size": 0,
                                "chartType": 2,
                                "resourceType": "microsoft.eventhub/namespaces",
                                "metricScope": 0,
                                "resourceIds": [
                                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
                                ],
                                "timeContextFromParameter": "timeRangePayment",
                                "timeContext": {
                                  "durationMs": 1814400000,
                                  "endTime": "2023-05-31T10:23:00.000Z"
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
                                    "valueParam": "eventhubPayment"
                                  }
                                ],
                                "gridSettings": {
                                  "rowLimit": 10000
                                }
                              },
                              "customWidth": "50",
                              "name": "Incoming Messages - Copy",
                              "styleSettings": {
                                "maxWidth": "50"
                              }
                            },
                            {
                              "type": 10,
                              "content": {
                                "chartId": "workbook95d246e7-53f0-4e0a-9c7b-b99deec02502",
                                "version": "MetricsItem/2.0",
                                "size": 0,
                                "chartType": 2,
                                "resourceType": "microsoft.eventhub/namespaces",
                                "metricScope": 0,
                                "resourceIds": [
                                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
                                ],
                                "timeContextFromParameter": "timeRangePayment",
                                "timeContext": {
                                  "durationMs": 1814400000,
                                  "endTime": "2023-05-31T10:23:00.000Z"
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
                                    "valueParam": "eventhubPayment"
                                  }
                                ],
                                "gridSettings": {
                                  "rowLimit": 10000
                                }
                              },
                              "customWidth": "50",
                              "name": "Outgoing Messages - Copy",
                              "styleSettings": {
                                "maxWidth": "50"
                              }
                            }
                          ]
                        },
                        "name": "idpay-evh-ns-01"
                      }
                    ]
                  },
                  "customWidth": "50",
                  "name": "group - 5"
                }
              ]
            },
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "payment"
            },
            "name": "payment"
          }
        ]
      },
      "name": "wrapper"
    }
  ],
  "fallbackResourceIds": [
    "Azure Monitor"
  ],
  "$schema": "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
}
