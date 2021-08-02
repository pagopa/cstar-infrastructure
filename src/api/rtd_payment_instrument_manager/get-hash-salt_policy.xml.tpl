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
                <set-backend-service base-url="${pm-backend-url}/pp-restapi-rtd/v1" />
                <rewrite-uri template="/static-contents/wallets/hashing" />
                %{ if env_short != "d" ~}
                <authentication-certificate thumbprint="${rtd-pm-client-certificate-thumbprint}" />
                %{ endif ~}
            </otherwise>
        </choose>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
        <choose>
            <when condition="@(context.Response.StatusCode >= 200 &&  context.Response.StatusCode < 300)">
                <set-variable name="salt" value="@((string)context.Response.Body.As<JObject>()["salt"])" />
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
