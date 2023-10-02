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
        <!-- Storage related variables -->
        <set-variable name="storagePrivateFqdn" value="${initiative-storage-account-name}" />
        <set-variable name="containerName" value="ranking" />
        <!-- section: rewrite request to backend -->
        <!-- change base backend url -->
        <set-backend-service base-url="@{
                return "https://" + context.Variables["storagePrivateFqdn"] + "/" + context.Variables["containerName"];
        }" />
        <set-method>GET</set-method>
        <!-- rewrite request to backend -->
        <rewrite-uri template="@(string.Format("{0}/{1}/{2}",
                    context.Request.MatchedParameters["organizationId"],
                    context.Request.MatchedParameters["initiativeId"],
                    context.Request.MatchedParameters["filename"])
        )" />
        <!-- section: rewrite request to backend -->
        <!-- change base backend url -->
        <authentication-managed-identity resource="https://storage.azure.com/" output-token-variable-name="msi-access-token" ignore-error="false" />
        <set-header name="Authorization" exists-action="override">
            <value>@("Bearer " + (string)context.Variables["msi-access-token"])</value>
        </set-header>
        <set-header name="X-Ms-Version" exists-action="override">
            <value>2019-12-12</value>
        </set-header>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
        <set-header name="x-ms-error-code" exists-action="delete" />
        <set-header name="x-ms-version" exists-action="delete" />
        <set-header name="x-ms-request-id" exists-action="delete" />
        <set-header name="x-ms-creation-time" exists-action="delete" />
        <set-header name="x-ms-lease-status" exists-action="delete" />
        <set-header name="x-ms-lease-state" exists-action="delete" />
        <set-header name="x-ms-blob-type" exists-action="delete" />
        <set-header name="x-ms-server-encrypted" exists-action="delete" />
        <set-header name="ETag" exists-action="delete" />
        <set-header name="Content-Disposition" exists-action="override">
            <value>@("attachment; filename="+context.Request.MatchedParameters["filename"])</value>
        </set-header>
        <set-header name="Content-Type" exists-action="override">
            <value>application/octet-stream</value>
        </set-header>
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
