resource "helm_release" "prometheus" {
  count = var.env_short == "d" ? 1 : 0 # only in dev
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "" # latest
  namespace  = kubernetes_namespace.monitoring[0].metadata[0].name

  values = [
    templatefile(format("%s/monitoring/prometheus_stack.yaml.tpl", path.module), {
      # general settings
      app_name = "cstar-monitoring" 
      deployment_namespace = "monitoring"
      k8s_target_version = "1.21.2"
      common_labels = jsonencode({})

      # rules
      create_default_rules_flag = true
      enable_alertmanager_rule = false
      enable_etcd_rule = true
      enable_general_rule = true
      enable_k8s_rule = true
      enable_kube_api_server_rule = true
      enable_kube_api_server_availability_rule = true
      enable_kube_api_server_error_rule = true
      enable_kube_api_server_slos_rule = true
      enable_kubelet_rule = true
      enable_prometheus_general_rule = true
      enable_prometheus_node_alerting_rule = true
      enable_kube_prometheus_node_recording_rule = true
      enable_kubernetes_absent_rule = true
      enable_kuybernetes_apps_rule = true
      enable_kubernetes_resources_rule = true
      enable_kubernetes_storage_rule = true
      enable_kubernetes_system_rule = true
      enable_kube_scheduler_rule = true
      enable_kube_state_metric_rule = true
      enable_network_rule = true
      enable_node_rule = true
      enable_prometheus_rule = true
      enable_prometheus_operator_rule = true
      enable_time_rule = true
      runbook_url_prefix = "https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#"

      # Alert Manager
      enable_alertmanager = false
      enable_alertmanager_ingress = false

      # Grafana
      enable_grafana = false
      enable_grafana_ingress = false
      enable_grafana_dashboard = false

      # Components to scrape
      enable_kube_api_server_scrape = true
      enable_kubelet_cadvisor_scrape = true
      enable_kube_controller_manager_scrape = true
      enable_scraping_core_dns = true
      enable_kube_dns_scrape = false # not installed
      enable_kube_etcd_scrape = true
      enable_scraping_kube_scheduler = true
      enable_kube_proxy_scrape = true
      enable_kube_state_metrics_scrape = true
      enable_node_exporter = true

      # Operator
      enable_prometheus_operator = true
      operator_image_repo = "quay.io/prometheus-operator/prometheus-operator"
      operator_image_tag = "v0.50.0"

      # Prometheus
      prometheus_enabled = true
      scrape_interval = "30s"
      scrape_timeout = ""
      scrape_evaluation_interval = ""
      prometheus_image_repo = "quay.io/prometheus/prometheus"
      prometheus_image_tag = "v2.28.1"
      metrics_retention_period = "10d"
      replicas_count = 1
      shards_count = 1



    })
  ]
}
