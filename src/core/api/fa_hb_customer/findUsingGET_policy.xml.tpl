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
        <set-variable name="v_fiscalcode" value="@(context.Request.Headers.GetValueOrDefault("id",""))" />
        <cache-lookup-value key="@((string)context.Variables["v_fiscalcode"] + "-getcustomer")" variable-name="getCustomerResponse"  />
        <choose>
            <!-- If API Management find it in the cache, make a request for it and store it -->
            <when condition="@(context.Variables.ContainsKey("getCustomerResponse"))">
                <return-response response-variable-name="getCustomerResponse" />
            </when>
            <otherwise>
                <rewrite-uri template="@("/"+(string)context.Variables["v_fiscalcode"]+"?isIssuer=true")" copy-unmatched-params="true" />
            </otherwise>
        </choose>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <choose>
            <when condition="@(context.Response.StatusCode >= 200 &&  context.Response.StatusCode < 300)">
                <!-- Store result in cache -->
                <cache-store-value key="@((string)context.Variables["v_fiscalcode"] + "-getcustomer")" value="@(context.Response)" duration="86400"  />
            </when>
        </choose>
        <set-variable name="cs1" value="IBAN, FISCAL CODE" />
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>