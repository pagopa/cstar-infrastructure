<policies>
  <inbound>
    <base />
    <set-header name="x-ibm-client-secret" exists-action="override">
      <value>{{x-ibm-client-secret}}</value>
    </set-header>
    <set-header name="x-ibm-client-id" exists-action="override">
      <value>{{x-ibm-client-id}}</value>
    </set-header>
    <set-header name="Ocp-Apim-Subscription-Key" exists-action="delete" />
  </inbound>
  <backend>
    <base />
  </backend>
  <outbound>
    <base />
  </outbound>
  <on-error>
    <base />
  </on-error>
</policies>