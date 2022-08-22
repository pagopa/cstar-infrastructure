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
        <set-variable name="idHeader" value="@(context.Request.Headers.GetValueOrDefault("id",""))" />
        <!--<cache-lookup-value key="@((string)context.Variables["idHeader"])" variable-name="hpanPM"  />-->
        <set-variable name="pan" value="@(context.Request.Headers["id"][0].Replace("\\n", "\n"))" />
        <choose>
            <when condition="@(!context.Variables.ContainsKey("hpanPM"))">
                <send-request mode="new" response-variable-name="hpan" timeout="${pm-timeout-sec}" ignore-error="true">
                    <set-url>@("${pm-backend-url}/pp-restapi-rtd/v1/static-contents/wallets/hashing/actions/evaluate/enc")</set-url>
                    <set-method>POST</set-method>
                    <set-header name="Content-Type" exists-action="override">
                        <value>application/json</value>
                    </set-header>
                    <set-body>@{
                       return new JObject(new JProperty("pan", context.Variables["pan"])).ToString();
                   }</set-body>
                    %{ if env_short != "d" ~}
                        <authentication-certificate thumbprint="${bpd-pm-client-certificate-thumbprint}" />
                    %{ endif ~}
                </send-request>
                <set-variable name="hpanStatusCode" value="@(((IResponse)context.Variables["hpan"]).StatusCode)" />
                <choose>
                    <!-- Check active property in response -->
                    <when condition="@((int)context.Variables["hpanStatusCode"] == 200)">
                        <set-variable name="hpanPM" value="@(((JObject)((IResponse)context.Variables["hpan"]).Body.As<JObject>())["hashPan"])" />
                        <!--<cache-store-value key="@((string)context.Variables["idHeader"])" value="@((string)context.Variables["hpanPM"])"  duration="86400" />-->
                    </when>
                    <when condition="@((int)context.Variables["hpanStatusCode"] != 200)">
                        <return-response>
                            <set-status code="@((int)context.Variables["hpanStatusCode"])" reason="Wallet Service Error" />
                        </return-response>
                    </when>
                </choose>
            </when>
        </choose>
        <rewrite-uri template="@("/"+context.Variables["hpanPM"])" copy-unmatched-params="true" />
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