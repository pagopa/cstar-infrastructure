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
        <set-backend-service base-url="https://${ingress_load_balancer_hostname}/idpayportalwelfarebackendinitiative" />
        <set-variable name="varOrgNameFromValidToken" value="@(((Jwt)context.Variables["validatedToken"]).Claims.GetValueOrDefault("org_name", ""))" />
        <set-variable name="varOrgVatFromValidToken" value="@(((Jwt)context.Variables["validatedToken"]).Claims.GetValueOrDefault("org_vat", ""))" />
        <set-variable name="varUserIdFromValidToken" value="@(((Jwt)context.Variables["validatedToken"]).Claims.GetValueOrDefault("uid", ""))" />
        <set-variable name="varUserOrgRoleFromValidToken" value="@(((Jwt)context.Variables["validatedToken"]).Claims.GetValueOrDefault("org_role", ""))" />
        <set-header name="Content-Type" exists-action="override">
            <value>application/json</value>
        </set-header>
        <set-header name="organization-user-id" exists-action="override">
            <value>@((string)context.Variables["varUserIdFromValidToken"])</value>
        </set-header>
        <set-body>@{
            var requestToBeModified = context.Request.Body.As<JObject>(preserveContent: true);
            requestToBeModified.Add(new JProperty("organizationName", context.Variables["varOrgNameFromValidToken"]));
            requestToBeModified.Add(new JProperty("organizationVat", context.Variables["varOrgVatFromValidToken"]));
            requestToBeModified.Add(new JProperty("organizationUserId", context.Variables["varUserIdFromValidToken"]));
            requestToBeModified.Add(new JProperty("organizationUserRole", context.Variables["varUserOrgRoleFromValidToken"]));
            return requestToBeModified.ToString();
            }
        </set-body>
        <rewrite-uri template="@("/idpay/organization/"+((Jwt)context.Variables["validatedToken"]).Claims.GetValueOrDefault("org_id", "")+"/initiative/{initiativeId}/info")" />
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
