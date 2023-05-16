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
        <cache-lookup-value key="salt" variable-name="salt" />
        <choose>
            <!-- If API Management find it in the cache, make a request for it and store it -->
            <when condition="@(context.Variables.ContainsKey("salt"))">
                <return-response>
                    <set-body>@((string)context.Variables["salt"])</set-body>
                </return-response>
            </when>
            <otherwise>
                %{ if mock_response ~}
                    <return-response>
                        <set-body>FAKE_SALT</set-body>
                    </return-response>
                %{ else ~}
                    <set-variable name="pagopaPlatformKey" value="{{${pagopa-platform-api-key-name}}}"/>
                    <send-request mode="new" response-variable-name="saltResponse" timeout="5" ignore-error="true">
                      <set-url>@("${pm-backend-url}/payment-manager/auth-rtd/v1/static-contents/wallets/hashing")</set-url>
                      <set-method>GET</set-method>
                      <set-header name="Ocp-Apim-Subscription-Key" exists-action="override">
                        <value>@(context.Variables.GetValueOrDefault<string>("pagopaPlatformKey"))</value>
                      </set-header>
                    </send-request>
                %{ endif ~}
            </otherwise>
        </choose>
    </inbound>
    <backend>
    </backend>
    <outbound>
        <base />
        <choose>
              <when condition="@(((IResponse)context.Variables["saltResponse"]).StatusCode >= 200 &&  ((IResponse)context.Variables["saltResponse"]).StatusCode < 300)">
                <set-variable name="salt" value="@((string)((IResponse)context.Variables["saltResponse"]).Body.As<JObject>()["salt"])" />
                <!-- Store result in cache -->
                <cache-store-value key="salt" value="@((string)context.Variables["salt"])" duration="86400" />
                <set-body>@((string)context.Variables["salt"])</set-body>
            </when>
        </choose>
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
