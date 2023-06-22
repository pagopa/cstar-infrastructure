<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | >=0.1.1 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 2.21.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 3.40.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | = 2.5.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | = 2.11.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | = 3.1.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | = 4.0.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cert_mounter"></a> [cert\_mounter](#module\_cert\_mounter) | git::https://github.com/pagopa/terraform-azurerm-v3.git//cert_mounter | v6.15.2 |
| <a name="module_domain_pod_identity"></a> [domain\_pod\_identity](#module\_domain\_pod\_identity) | git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_pod_identity | v6.15.2 |
| <a name="module_idpay_api_acquirer_product"></a> [idpay\_api\_acquirer\_product](#module\_idpay\_api\_acquirer\_product) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v6.15.2 |
| <a name="module_idpay_api_assistance"></a> [idpay\_api\_assistance](#module\_idpay\_api\_assistance) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_api_assistance_product"></a> [idpay\_api\_assistance\_product](#module\_idpay\_api\_assistance\_product) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v6.15.2 |
| <a name="module_idpay_api_io_product"></a> [idpay\_api\_io\_product](#module\_idpay\_api\_io\_product) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v6.15.2 |
| <a name="module_idpay_api_issuer_product"></a> [idpay\_api\_issuer\_product](#module\_idpay\_api\_issuer\_product) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v6.15.2 |
| <a name="module_idpay_api_merchant_mock_product"></a> [idpay\_api\_merchant\_mock\_product](#module\_idpay\_api\_merchant\_mock\_product) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v6.15.2 |
| <a name="module_idpay_api_mil_product"></a> [idpay\_api\_mil\_product](#module\_idpay\_api\_mil\_product) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v6.15.2 |
| <a name="module_idpay_api_mock_product"></a> [idpay\_api\_mock\_product](#module\_idpay\_api\_mock\_product) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v6.15.2 |
| <a name="module_idpay_api_portal_merchants_product"></a> [idpay\_api\_portal\_merchants\_product](#module\_idpay\_api\_portal\_merchants\_product) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v6.15.2 |
| <a name="module_idpay_api_portal_product"></a> [idpay\_api\_portal\_product](#module\_idpay\_api\_portal\_product) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v6.15.2 |
| <a name="module_idpay_audit_storage"></a> [idpay\_audit\_storage](#module\_idpay\_audit\_storage) | git::https://github.com/pagopa/terraform-azurerm-v3.git//storage_account | v6.15.2 |
| <a name="module_idpay_group_portal"></a> [idpay\_group\_portal](#module\_idpay\_group\_portal) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_iban_io"></a> [idpay\_iban\_io](#module\_idpay\_iban\_io) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_initiative_portal"></a> [idpay\_initiative\_portal](#module\_idpay\_initiative\_portal) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_initiative_storage"></a> [idpay\_initiative\_storage](#module\_idpay\_initiative\_storage) | git::https://github.com/pagopa/terraform-azurerm-v3.git//storage_account | v6.15.2 |
| <a name="module_idpay_merchant_portal"></a> [idpay\_merchant\_portal](#module\_idpay\_merchant\_portal) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_merchants_notification_email_api"></a> [idpay\_merchants\_notification\_email\_api](#module\_idpay\_merchants\_notification\_email\_api) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_merchants_permission_portal"></a> [idpay\_merchants\_permission\_portal](#module\_idpay\_merchants\_permission\_portal) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_merchants_portal"></a> [idpay\_merchants\_portal](#module\_idpay\_merchants\_portal) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_mil"></a> [idpay\_mil](#module\_idpay\_mil) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_notification_email_api"></a> [idpay\_notification\_email\_api](#module\_idpay\_notification\_email\_api) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_onboarding_workflow_io"></a> [idpay\_onboarding\_workflow\_io](#module\_idpay\_onboarding\_workflow\_io) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_onboarding_workflow_issuer"></a> [idpay\_onboarding\_workflow\_issuer](#module\_idpay\_onboarding\_workflow\_issuer) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_payment_io"></a> [idpay\_payment\_io](#module\_idpay\_payment\_io) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_permission_portal"></a> [idpay\_permission\_portal](#module\_idpay\_permission\_portal) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_qr_code_payment_acquirer"></a> [idpay\_qr\_code\_payment\_acquirer](#module\_idpay\_qr\_code\_payment\_acquirer) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_qr_code_payment_io"></a> [idpay\_qr\_code\_payment\_io](#module\_idpay\_qr\_code\_payment\_io) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_qr_code_payment_mock_merchant"></a> [idpay\_qr\_code\_payment\_mock\_merchant](#module\_idpay\_qr\_code\_payment\_mock\_merchant) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_refund_storage"></a> [idpay\_refund\_storage](#module\_idpay\_refund\_storage) | git::https://github.com/pagopa/terraform-azurerm-v3.git//storage_account | v6.15.2 |
| <a name="module_idpay_timeline_io"></a> [idpay\_timeline\_io](#module\_idpay\_timeline\_io) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_timeline_issuer"></a> [idpay\_timeline\_issuer](#module\_idpay\_timeline\_issuer) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_wallet_io"></a> [idpay\_wallet\_io](#module\_idpay\_wallet\_io) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_idpay_wallet_issuer"></a> [idpay\_wallet\_issuer](#module\_idpay\_wallet\_issuer) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_tls_checker"></a> [tls\_checker](#module\_tls\_checker) | git::https://github.com/pagopa/terraform-azurerm-v3.git//tls_checker | v6.15.2 |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.apim-merchant-id-retriever](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource.idpay_audit_log_table](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource.idpay_refund_storage_topic_event_subscription](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource.idpay_workbook](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) | resource |
| [azurerm_api_management_api.devops_idpay_color](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api.idpay_merchants_token_exchange](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api.idpay_mock_api](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api.idpay_token_exchange](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api_diagnostic.idpay_apim_api_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_operation.devops_idpay_color_get_envs](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.idpay_merchants_token_exchange](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.idpay_mock_create_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.idpay_mock_notificator_messages](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.idpay_mock_notificator_profiles](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.idpay_mock_tos_version](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.idpay_mock_update_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.idpay_mock_upload_service_logo](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.idpay_token_exchange](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.idpay_token_exchange_test](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation_policy.idpay_merchants_token_exchange_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.idpay_mock_create_service_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.idpay_mock_notificator_messages_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.idpay_mock_notificator_profiles_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.idpay_mock_tos_version_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.idpay_mock_update_service_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.idpay_mock_upload_service_logo_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.idpay_token_exchange_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.idpay_token_exchange_policy_test](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_policy.example](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_api_policy) | resource |
| [azurerm_api_management_certificate.idpay_merchants_token_exchange_cert_jwt](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_certificate) | resource |
| [azurerm_api_management_certificate.idpay_token_exchange_cert_jwt](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_certificate) | resource |
| [azurerm_api_management_named_value.idpay_apim_subscription_mocked_acquirer_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.initiative_storage_access_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.pdv_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.refund_storage_access_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.selc_external_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_product_api.idpay_mock_product_api](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_product_api) | resource |
| [azurerm_api_management_subscription.idpay_apim_subscription_mocked_acquirer](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/api_management_subscription) | resource |
| [azurerm_eventgrid_system_topic.idpay_refund_storage_topic](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/eventgrid_system_topic) | resource |
| [azurerm_key_vault_access_policy.apim](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_certificate.idpay_jwt_signing_cert](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_certificate.idpay_merchants_jwt_signing_cert](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_secret.aks_apiserver_url](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.appinsights-instrumentation-key](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.azure_devops_sa_cacrt](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.azure_devops_sa_token](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.enrolled_pi_producer_connection_uri](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.initiative_storage_access_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.initiative_storage_blob_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.initiative_storage_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.ranking_p7m_cert](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.ranking_p7m_private_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.refund_storage_access_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.refund_storage_blob_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.refund_storage_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.revoked_pi_consumer_connection_uri](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_log_analytics_data_export_rule.idpay_audit_analytics_export_rule](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/log_analytics_data_export_rule) | resource |
| [azurerm_log_analytics_linked_storage_account.idpay_audit_analytics_linked_storage](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/log_analytics_linked_storage_account) | resource |
| [azurerm_monitor_action_group.slackIdpay](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_scheduled_query_rules_alert_v2.CompleteOnboarding](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/monitor_scheduled_query_rules_alert_v2) | resource |
| [azurerm_monitor_scheduled_query_rules_alert_v2.CosmosServerSideRetry](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/monitor_scheduled_query_rules_alert_v2) | resource |
| [azurerm_monitor_scheduled_query_rules_alert_v2.CreateTransaction](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/monitor_scheduled_query_rules_alert_v2) | resource |
| [azurerm_monitor_scheduled_query_rules_alert_v2.RewardOutcomeFile](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/monitor_scheduled_query_rules_alert_v2) | resource |
| [azurerm_private_dns_a_record.ingress](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_endpoint.idpay_initiative_storage_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.rg_refund_storage](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.event_grid_sender_role_on_refund_storage_topic](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/role_assignment) | resource |
| [azurerm_storage_container.idpay_logo_container](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.idpay_merchant_container](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.idpay_oidc_config](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.idpay_ranking_container](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.idpay_refund_container](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/storage_container) | resource |
| [helm_release.reloader](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [kubernetes_config_map.appinsights-config](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.idpay-common](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.idpay-eventhub-00](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.idpay-eventhub-01](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.notification-email](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rest-client](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtd-eventhub](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_namespace.domain_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/namespace) | resource |
| [kubernetes_namespace.system_domain_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/namespace) | resource |
| [kubernetes_role_binding.deployer_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.system_deployer_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/role_binding) | resource |
| [kubernetes_service_account.azure_devops](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/service_account) | resource |
| [local_file.idpay_audit_dcr_file_tmp](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.oidc_configuration_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.idpay_audit_dce](https://registry.terraform.io/providers/hashicorp/null/3.1.1/docs/resources/resource) | resource |
| [null_resource.idpay_audit_dcr](https://registry.terraform.io/providers/hashicorp/null/3.1.1/docs/resources/resource) | resource |
| [null_resource.idpay_audit_dcra](https://registry.terraform.io/providers/hashicorp/null/3.1.1/docs/resources/resource) | resource |
| [null_resource.idpay_audit_lh](https://registry.terraform.io/providers/hashicorp/null/3.1.1/docs/resources/resource) | resource |
| [null_resource.upload_oidc_configuration](https://registry.terraform.io/providers/hashicorp/null/3.1.1/docs/resources/resource) | resource |
| [tls_private_key.p7m_key](https://registry.terraform.io/providers/hashicorp/tls/4.0.4/docs/resources/private_key) | resource |
| [tls_self_signed_cert.p7m_self_signed_cert](https://registry.terraform.io/providers/hashicorp/tls/4.0.4/docs/resources/self_signed_cert) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azurerm_api_management.apim_core](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/api_management) | data source |
| [azurerm_api_management_user.idpay_apim_user_mocked_acquirer](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/api_management_user) | data source |
| [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/application_insights) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/client_config) | data source |
| [azurerm_dns_zone.public](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/dns_zone) | data source |
| [azurerm_eventhub.eventhub_idpay_reward_notification_storage_events](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/eventhub) | data source |
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.kv_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.alert-slack-idpay](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.cdn_storage_access_secret](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.pdv_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.selc_external_api_key_secret](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_monitor_action_group.domain](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_private_dns_zone.internal](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.apim_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.private_endpoint_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/subscription) | data source |
| [azurerm_virtual_machine_scale_set.idpay_audit_resource_vmss](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/virtual_machine_scale_set) | data source |
| [kubernetes_secret.azure_devops_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/data-sources/secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_cluster_domain_name"></a> [aks\_cluster\_domain\_name](#input\_aks\_cluster\_domain\_name) | Name of the aks cluster domain. eg: dev01 | `string` | n/a | yes |
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | AKS cluster name | `string` | n/a | yes |
| <a name="input_aks_resource_group_name"></a> [aks\_resource\_group\_name](#input\_aks\_resource\_group\_name) | AKS cluster resource name | `string` | n/a | yes |
| <a name="input_aks_vmss_name"></a> [aks\_vmss\_name](#input\_aks\_vmss\_name) | AKS nodepool scale set name | `string` | n/a | yes |
| <a name="input_appio_timeout_sec"></a> [appio\_timeout\_sec](#input\_appio\_timeout\_sec) | AppIo timeout (sec) | `number` | `5` | no |
| <a name="input_checkiban_base_url"></a> [checkiban\_base\_url](#input\_checkiban\_base\_url) | Check IBAN uri. | `string` | `"127.0.0.1"` | no |
| <a name="input_dns_zone_internal_prefix"></a> [dns\_zone\_internal\_prefix](#input\_dns\_zone\_internal\_prefix) | The dns subdomain. | `string` | `null` | no |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns subdomain. | `string` | `"cstar"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_enable_p7m_self_sign"></a> [enable\_p7m\_self\_sign](#input\_enable\_p7m\_self\_sign) | p7m self-signed certificate | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_event_hub_port"></a> [event\_hub\_port](#input\_event\_hub\_port) | n/a | `number` | `9093` | no |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `"pagopa.it"` | no |
| <a name="input_idpay_alert_enabled"></a> [idpay\_alert\_enabled](#input\_idpay\_alert\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_idpay_mocked_acquirer_apim_user_id"></a> [idpay\_mocked\_acquirer\_apim\_user\_id](#input\_idpay\_mocked\_acquirer\_apim\_user\_id) | APIm user id of mocked acquirer | `string` | `null` | no |
| <a name="input_idpay_mocked_merchant_enable"></a> [idpay\_mocked\_merchant\_enable](#input\_idpay\_mocked\_merchant\_enable) | Enable mocked merchant APIs | `bool` | `false` | no |
| <a name="input_ingress_load_balancer_hostname"></a> [ingress\_load\_balancer\_hostname](#input\_ingress\_load\_balancer\_hostname) | n/a | `string` | n/a | yes |
| <a name="input_ingress_load_balancer_ip"></a> [ingress\_load\_balancer\_ip](#input\_ingress\_load\_balancer\_ip) | n/a | `string` | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | One of beta, prod01, prod02 | `string` | n/a | yes |
| <a name="input_io_backend_base_url"></a> [io\_backend\_base\_url](#input\_io\_backend\_base\_url) | BE IO backend url | `string` | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | n/a | `string` | `"~/.kube"` | no |
| <a name="input_location"></a> [location](#input\_location) | One of westeurope, northeurope | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | One of wue, neu | `string` | n/a | yes |
| <a name="input_location_string"></a> [location\_string](#input\_location\_string) | One of West Europe, North Europe | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Specifies the name of the Log Analytics Workspace. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | The name of the resource group in which the Log Analytics workspace is located in. | `string` | n/a | yes |
| <a name="input_mail_server_host"></a> [mail\_server\_host](#input\_mail\_server\_host) | SMTP server hostname | `string` | n/a | yes |
| <a name="input_mail_server_port"></a> [mail\_server\_port](#input\_mail\_server\_port) | SMTP server port | `string` | `"587"` | no |
| <a name="input_monitor_resource_group_name"></a> [monitor\_resource\_group\_name](#input\_monitor\_resource\_group\_name) | Monitor resource group name | `string` | n/a | yes |
| <a name="input_one_trust_privacynotice_base_url"></a> [one\_trust\_privacynotice\_base\_url](#input\_one\_trust\_privacynotice\_base\_url) | OneTrust PrivacyNotice Base Url | `string` | n/a | yes |
| <a name="input_p7m_cert_validity_hours"></a> [p7m\_cert\_validity\_hours](#input\_p7m\_cert\_validity\_hours) | n/a | `number` | `87600` | no |
| <a name="input_pdv_retry_count"></a> [pdv\_retry\_count](#input\_pdv\_retry\_count) | PDV max retry number | `number` | `3` | no |
| <a name="input_pdv_retry_delta"></a> [pdv\_retry\_delta](#input\_pdv\_retry\_delta) | PDV delta | `number` | `1` | no |
| <a name="input_pdv_retry_interval"></a> [pdv\_retry\_interval](#input\_pdv\_retry\_interval) | PDV interval between each retry | `number` | `5` | no |
| <a name="input_pdv_retry_max_interval"></a> [pdv\_retry\_max\_interval](#input\_pdv\_retry\_max\_interval) | PDV max interval between each retry | `number` | `15` | no |
| <a name="input_pdv_timeout_sec"></a> [pdv\_timeout\_sec](#input\_pdv\_timeout\_sec) | PDV timeout (sec) | `number` | `15` | no |
| <a name="input_pdv_tokenizer_url"></a> [pdv\_tokenizer\_url](#input\_pdv\_tokenizer\_url) | PDV uri. Endpoint for encryption of pii information. | `string` | `"127.0.0.1"` | no |
| <a name="input_pm_backend_url"></a> [pm\_backend\_url](#input\_pm\_backend\_url) | Payment manager backend url (enrollment) | `string` | n/a | yes |
| <a name="input_pm_service_base_url"></a> [pm\_service\_base\_url](#input\_pm\_service\_base\_url) | PM Service uri. Endpoint to retrieve Payment Instruments information. | `string` | `"127.0.0.1"` | no |
| <a name="input_pm_timeout_sec"></a> [pm\_timeout\_sec](#input\_pm\_timeout\_sec) | Payment manager timeout (sec) | `number` | `5` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_reverse_proxy_be_io"></a> [reverse\_proxy\_be\_io](#input\_reverse\_proxy\_be\_io) | AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller. | `string` | `"127.0.0.1"` | no |
| <a name="input_reverse_proxy_rtd"></a> [reverse\_proxy\_rtd](#input\_reverse\_proxy\_rtd) | AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller. | `string` | `"127.0.0.1"` | no |
| <a name="input_selc_base_url"></a> [selc\_base\_url](#input\_selc\_base\_url) | SelfCare api backend url | `string` | n/a | yes |
| <a name="input_selc_timeout_sec"></a> [selc\_timeout\_sec](#input\_selc\_timeout\_sec) | SelfCare api timeout (sec) | `number` | `5` | no |
| <a name="input_storage_account_replication_type"></a> [storage\_account\_replication\_type](#input\_storage\_account\_replication\_type) | Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Changing this forces a new resource to be created when types LRS, GRS and RAGRS are changed to ZRS, GZRS or RAGZRS and vice versa | `string` | `"LRS"` | no |
| <a name="input_storage_advanced_threat_protection"></a> [storage\_advanced\_threat\_protection](#input\_storage\_advanced\_threat\_protection) | Enable threat advanced protection | `bool` | `false` | no |
| <a name="input_storage_delete_retention_days"></a> [storage\_delete\_retention\_days](#input\_storage\_delete\_retention\_days) | Number of days to retain deleted files | `number` | `5` | no |
| <a name="input_storage_enable_versioning"></a> [storage\_enable\_versioning](#input\_storage\_enable\_versioning) | Enable versioning | `bool` | `false` | no |
| <a name="input_storage_public_network_access_enabled"></a> [storage\_public\_network\_access\_enabled](#input\_storage\_public\_network\_access\_enabled) | Enable public network access | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |
| <a name="input_tls_cert_check_helm"></a> [tls\_cert\_check\_helm](#input\_tls\_cert\_check\_helm) | tls cert helm chart configuration | <pre>object({<br>    chart_version = string,<br>    image_name    = string,<br>    image_tag     = string<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
