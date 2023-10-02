controller:
  service:
    loadBalancerIP: ${load_balancer_ip}
    externalTrafficPolicy: Local  
    annotations:
      service.beta.kubernetes.io/azure-load-balancer-internal: "true"
