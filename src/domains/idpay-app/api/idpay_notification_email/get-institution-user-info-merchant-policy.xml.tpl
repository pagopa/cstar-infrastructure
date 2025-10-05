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
        <send-request mode="new" response-variable-name="institutionUserResponse" timeout="${selc_timeout_sec}" ignore-error="true">
            <set-url>@("${selc_base_url}/external/v1/institutions/" + ((Jwt)context.Variables["validatedToken"]).Claims.GetValueOrDefault("org_id", "") + "/products/prod-idpay-merchant/users?userId=" + ((Jwt)context.Variables["validatedToken"]).Claims.GetValueOrDefault("uid", ""))</set-url>
            <set-method>GET</set-method>
            <set-header name="x-selfcare-uid" exists-action="override">
                <value>idpay</value>
            </set-header>
            <set-header name="Ocp-Apim-Subscription-Key" exists-action="override">
                <value>{{${selc_external_api_key_reference}}}</value>
            </set-header>
        </send-request>
        <choose>
            <when condition="@(context.Response == null)">
                <return-response>
                    <set-status code="504" reason="Backend SelfCare Timeout" />
                    <set-body>@{
                        return new JObject(
                                new JProperty("code", "notification.email.selfcare.timeout"),
                                new JProperty("message", "Backend SelfCare Timeout")
                            ).ToString();
                    }</set-body>
                </return-response>
            </when>
            <when condition="@(context.Response.StatusCode == 200)">
                <return-response>
                    <set-header name="Content-Type" exists-action="override">
                        <value>application/json</value>
                    </set-header>
                    <set-body>@{
                        JArray instUserRespArray = ((IResponse)context.Variables["institutionUserResponse"]).Body.As<JArray>();
                        if(instUserRespArray.Count > 0)
                        {
                            return new JObject(
                                new JProperty("email", instUserRespArray.First().Value<string>("email"))
                            ).ToString();
                        }
                        else
                        {
                            return new JObject(
                                new JProperty("email", "")
                            ).ToString();
                        }
                    }</set-body>
                </return-response>
            </when>
            <otherwise>
                <return-response>
                    <set-status code="500" />
                    <set-header name="Content-Type" exists-action="override">
                        <value>application/json</value>
                    </set-header>
                    <set-body>@{
                        return new JObject(
                                new JProperty("code", "notification.email.error"),
                                new JProperty("message", "Cannot retrive institutional email")
                            ).ToString();
                    }</set-body>
                </return-response>
            </otherwise>
        </choose>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound />
    <on-error>
        <base />
    </on-error>
</policies>
