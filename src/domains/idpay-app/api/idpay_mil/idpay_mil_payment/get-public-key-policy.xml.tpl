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
        <set-variable name="isMerchantIdRequired" value="false" />
        <base />
        <send-request mode="new" response-variable-name="responseObj" timeout="30" ignore-error="true">
            <set-url>https://${keyvault-name}.vault.azure.net/keys/${idpay-mil-key}?api-version=7.4</set-url>
            <set-method>GET</set-method>
            <authentication-managed-identity resource="https://vault.azure.net" />
        </send-request>
        <return-response>
            <set-header name="Content-Type" exists-action="override">
                <value>application/json</value>
            </set-header>
            <set-body>
                @{
                    JObject getKeyResponse = ((IResponse)context.Variables["responseObj"]).Body.As<JObject>();
                    getKeyResponse["key"]["iat"] = getKeyResponse["attributes"]["created"];
                    getKeyResponse["key"]["exp"] = getKeyResponse["attributes"]["exp"];
                    return getKeyResponse["key"].ToString();
                }
            </set-body>
        </return-response>
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
