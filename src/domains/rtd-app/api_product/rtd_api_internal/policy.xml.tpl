<!--
    IMPORTANT:
    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.
    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.
    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.
    - To add a policy, place the cursor at the desired insertion point and select a policy from the sidebar.
    - To remove a policy, delete the corresponding policy statement from the policy document.
    - Position the <base> element within a section element to inherit all policies from the corresponding section element in the enclosing scope.
    - Remove the <base> element to prevent inheriting policies from the corresponding section element in the enclosing scope.
    - Policies are applied in the order of their appearance, from the top down.
    - Comments within policy elements are not supported and may disappear. Place your comments between policy elements or at a higher level scope.
-->
<policies>
  <inbound>
    <base />

    <!--
      The policy is not meant to be publicy accessible. The following filter will prevent any Access
      from external sources, even in case of product/subscription configuration errors.
    -->
    <ip-filter action="allow">
      <address-range from="${k8s-cluster-ip-range-from}" to="${k8s-cluster-ip-range-to}" />
      <address-range from="${k8s-cluster-aks-ip-range-from}" to="${k8s-cluster-aks-ip-range-to}"/>
    </ip-filter>

    <set-header name="x-user-id" exists-action="override">
      <value>@(context.User.Id)</value>
    </set-header>
    <set-header name="x-apim-request-id" exists-action="override">
      <value>@(context.RequestId.ToString())</value>
    </set-header>
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
