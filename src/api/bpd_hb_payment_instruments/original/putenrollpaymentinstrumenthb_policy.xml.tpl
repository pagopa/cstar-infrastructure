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
        <choose>
            <when condition="@(context.Request.Body != null && context.Request.Body.As<JObject>(preserveContent: true)["fiscalCode"] != null)">
                <set-variable name="taxCode" value="@(context.Request.Body.As<JObject>(preserveContent: true)["fiscalCode"])" />
                <set-variable name="channel" value="@(context.Request.Body.As<JObject>(preserveContent: true)["channel"])" />
                <set-variable name="expireMonth" value="@(context.Request.Body.As<JObject>(preserveContent: true)["exprireMonth"])" />
                <set-variable name="expireYear" value="@(context.Request.Body.As<JObject>(preserveContent: true)["expireYear"])" />
                <set-variable name="type" value="@(context.Request.Body.As<JObject>(preserveContent: true)["type"])" />
                <set-variable name="holder" value="@(context.Request.Body.As<JObject>(preserveContent: true)["holder"])" />
                <set-variable name="brand" value="@(context.Request.Body.As<JObject>(preserveContent: true)["brand"])" />
                <set-variable name="issuerAbiCode" value="@(context.Request.Body.As<JObject>(preserveContent: true)["issuerAbiCode"])" />
                <set-variable name="pan" value="@(context.Request.Body.As<JObject>(preserveContent: true)["id"])" />
                <choose>
                    <when condition="@(String.Equals(context.Request.Body.As<JObject>(preserveContent: true)["brand"].ToString(),"PAGOBANCOMAT", StringComparison.OrdinalIgnoreCase))">
                        <set-variable name="walletType" value="Bancomat" />
                        <set-variable name="brand" value="OTHER" />
                    </when>
                    <otherwise>
                        <set-variable name="walletType" value="Card" />
                    </otherwise>
                </choose>
                <send-request mode="new" response-variable-name="hpan" timeout="${pm-timeout-sec}" ignore-error="true">
                    <set-url>@("${pm-backend-url}/pp-restapi-rtd/v1/wallets/np-wallets")</set-url>
                    <set-method>POST</set-method>
                    <set-header name="Content-Type" exists-action="override">
                        <value>application/json</value>
                    </set-header>
                    <set-body>@{
                       return new JObject(
                               new JProperty("taxCode", context.Variables["taxCode"]),
                               new JProperty("channel", context.Variables["channel"]),
                               new JProperty("walletType", context.Variables["walletType"]),
                                new JProperty("info",
                                    new JObject(
                                        new JProperty("pan",context.Variables["pan"]),
                                        new JProperty("expireMonth", context.Variables["expireMonth"]),
                                        new JProperty("expireYear", context.Variables["expireYear"]),
                                        new JProperty("type", context.Variables["type"]),
                                        new JProperty("holder", context.Variables["holder"]),
                                        new JProperty("brand", context.Variables["brand"]),
                                        new JProperty("issuerAbiCode", context.Variables["issuerAbiCode"])))).ToString();
                   }</set-body>
                    %{ if env_short != "d" ~}
<authentication-certificate thumbprint="${bpd-pm-client-certificate-thumbprint}" />
%{ endif ~}
                </send-request>
                <choose>
                    <when condition="@(context.Variables["hpan"] == null)">
                        <return-response>
                            <set-status code="504" reason="Gateway Timeout" />
                        </return-response>
                    </when>
                    <!-- Check active property in response -->
                    <when condition="@(((IResponse)context.Variables["hpan"]).StatusCode == 201)">
                        <set-variable name="hpan" value="@(((IResponse)context.Variables["hpan"]).Body.As<JObject>())" />
                        <set-backend-service base-url="http://${reverse-proxy-ip}/bpdmsenrollment" />
                        <rewrite-uri template="@("/bpd/enrollment/hb/payment-instruments/"+ ((JObject)context.Variables["hpan"])["hashCode"])" />
                        <set-body>@("{ \"fiscalCode\": \""+context.Variables["taxCode"]+"\",\"channel\":\""+context.Variables["channel"]+"\"}")</set-body>
                    </when>
                    <otherwise>
                        <return-response>
                            <set-status code="@(((IResponse)context.Variables["hpan"]).StatusCode)" reason="ErrorPM" />
                        </return-response>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <return-response>
                    <set-status code="400" />
                </return-response>
            </otherwise>
        </choose>
        <base />
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