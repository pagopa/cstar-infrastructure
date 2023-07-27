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
        <send-request mode="new" response-variable-name="responsePDV" timeout="${pdv_timeout_sec}" ignore-error="true">
            <set-url>${pdv_tokenizer_url}/tokens</set-url>
            <set-method>PUT</set-method>
            <set-header name="x-api-key" exists-action="override">
                <value>{{pdv-api-key}}</value>
            </set-header>
            <set-body>@{
                    return new JObject(
                            new JProperty("pii", context.Request.Headers.GetValueOrDefault("Fiscal-Code")
                            )).ToString();
                }</set-body>
        </send-request>
        <choose>
            <when condition="@(context.Variables["responsePDV"] == null)">
                <return-response>
                    <set-status code="504" reason="PDV Timeout" />
                </return-response>
            </when>
            <when condition="@(((IResponse)context.Variables["responsePDV"]).StatusCode == 200)">
                <set-backend-service base-url="https://${ingress_load_balancer_hostname}/idpayadmissibility" />
                <rewrite-uri template="@("/idpay/isee/mock/"+(string)((IResponse)context.Variables["responsePDV"]).Body.As<JObject>()["token"])" />
            </when>
            <otherwise>
                <return-response>
                    <set-status code="401" reason="Unauthorized" />
                </return-response>
            </otherwise>
        </choose>
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
