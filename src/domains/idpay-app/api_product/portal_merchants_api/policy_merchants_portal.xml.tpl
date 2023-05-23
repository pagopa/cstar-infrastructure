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
        <cors allow-credentials="true">
            <allowed-origins>
              %{ for origin in origins ~}
              <origin>${origin}</origin>
              %{ endfor ~}
            </allowed-origins>
            <allowed-methods preflight-result-max-age="300">
                <method>*</method>
            </allowed-methods>
            <allowed-headers>
                <header>*</header>
            </allowed-headers>
            <expose-headers>
                <header>*</header>
            </expose-headers>
        </cors>
        <validate-jwt header-name="Authorization" failed-validation-httpcode="401" require-expiration-time="true" require-scheme="Bearer" require-signed-tokens="true" output-token-variable-name="validatedToken">
            <issuer-signing-keys>
                <key certificate-id="${jwt_cert_signing_kv_id}" />
            </issuer-signing-keys>
            <audiences>
                <audience>idpay.merchant.welfare.pagopa.it</audience>
            </audiences>
            <issuers>
                <issuer>https://api-io.dev.cstar.pagopa.it</issuer>
            </issuers>
            <required-claims>
                <claim name="acquirer_id" match="all" />
                <claim name="merchant_id" match="all" />
                <claim name="uid" match="all" />
                <claim name="name" match="all" />
                <claim name="family_name" match="all" />
                <claim name="email" match="all" />
                <claim name="org_id" match="all" />
                <claim name="org_vat" match="all" />
                <claim name="org_party_role" match="all" />
                <claim name="org_role" match="all" />
                <claim name="org_name" match="all" />
            </required-claims>
        </validate-jwt>

        <set-variable name="acquirerId" value="@(((Jwt)context.Variables["validatedToken"]).Claims.GetValueOrDefault("acquirer_id", ""))" />
        <set-variable name="merchantId" value="@(((Jwt)context.Variables["validatedToken"]).Claims.GetValueOrDefault("merchant_id", ""))" />

        <set-header name="x-acquirer-id" exists-action="override">
            <value>@((String)context.Variables["acquirerId"])</value>
        </set-header>
        <set-header name="x-merchant-id" exists-action="override">
            <value>@((String)context.Variables["merchantId"])</value>
        </set-header>
        <set-header name="x-user-id" exists-action="override">
            <value>@(((Jwt)context.Variables["validatedToken"]).Claims.GetValueOrDefault("uid", ""))</value>
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
