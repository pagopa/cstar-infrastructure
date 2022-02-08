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
        <set-variable name="v_fiscalcode" value="@((string)context.Request.Body.As<JObject>(preserveContent: true)["id"])" />
        <!--set-variable name="v_vatNumbers" value="@(context.Request.Body.As<JObject>(preserveContent: true)["vatNumbers"])" /-->
        <cache-remove-value key="@((string)context.Variables["v_fiscalcode"] + "-getcustomer")"  />
        <!--
        <choose>
            <when condition="@(context.Variables.ContainsKey("v_vatNumbers"))">
                <set-body>@{return new JObject(new JProperty("vatNumbers",context.Variables["v_vatNumbers"])).ToString();}</set-body>
            </when>
        </choose>
        -->
        <set-backend-service base-url="http://${reverse-proxy-ip}/famsenrollment" />
        <rewrite-uri template="@("/fa/enrollment/customer/"+(string)context.Variables["v_fiscalcode"])" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <set-variable name="cs1" value="FISCAL CODE" />
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>