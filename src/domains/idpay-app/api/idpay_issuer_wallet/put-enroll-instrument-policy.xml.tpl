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
        <choose>
            <when condition="@(context.Request.Body != null)">
                <set-variable name="expireMonth" value="@(context.Request.Body.As<JObject>(preserveContent: true)["expireMonth"])" />
                <set-variable name="expireYear" value="@(context.Request.Body.As<JObject>(preserveContent: true)["expireYear"])" />
                <set-variable name="type" value="@(context.Request.Body.As<JObject>(preserveContent: true)["type"])" />
                <set-variable name="holder" value="@(context.Request.Body.As<JObject>(preserveContent: true)["holder"])" />
                <set-variable name="brand" value="@(context.Request.Body.As<JObject>(preserveContent: true)["brand"])" />
                <set-variable name="issuerAbiCode" value="@(context.Request.Body.As<JObject>(preserveContent: true)["issuerAbiCode"])" />
                <set-variable name="pgpPan" value="@(context.Request.Body.As<JObject>(preserveContent: true)["pgpPan"])" />
                <choose>
                    <when condition="@(String.Equals(context.Request.Body.As<JObject>(preserveContent: true)["brand"].ToString(), "PAGOBANCOMAT", StringComparison.OrdinalIgnoreCase))">
                        <set-variable name="walletType" value="Bancomat" />
                        <set-variable name="brand" value="OTHER" />
                    </when>
                    <otherwise>
                        <set-variable name="walletType" value="Card" />
                    </otherwise>
                </choose>
                <send-request mode="new" response-variable-name="pmResponse" timeout="${pm-timeout-sec}" ignore-error="true">
                    <set-url>@("${pm-backend-url}/payment-manager/auth-rtd/v1/wallets/np-wallets")</set-url>
                    <set-method>POST</set-method>
                    <set-header name="Content-Type" exists-action="override">
                        <value>application/json</value>
                    </set-header>
                    <set-header name="Ocp-Apim-Subscription-Key" exists-action="override">
                        <value>{{pagopa-platform-apim-api-key-primary}}</value>
                    </set-header>
                    <set-body>@{
                        return new JObject(
                            new JProperty("taxCode", context.Variables["fiscalCode"]),
                            new JProperty("channel", context.Variables["senderCode"]),
                            new JProperty("walletType", context.Variables["walletType"]),
                            new JProperty("info",
                                new JObject(
                                    new JProperty("pan",context.Variables["pgpPan"]),
                                    new JProperty("expireMonth", context.Variables["expireMonth"]),
                                    new JProperty("expireYear", context.Variables["expireYear"]),
                                    new JProperty("type", context.Variables["type"]),
                                    new JProperty("holder", context.Variables["holder"]),
                                    new JProperty("brand", context.Variables["brand"]),
                                    new JProperty("issuerAbiCode", context.Variables["issuerAbiCode"])))).ToString();
                        }
                   </set-body>
                </send-request>
                <choose>
                    <when condition="@(context.Variables["pmResponse"] == null)">
                        <return-response>
                            <set-status code="504" reason="Gateway Timeout" />
                        </return-response>
                    </when>
                    <!-- Check active property in response -->
                    <when condition="@(((IResponse)context.Variables["pmResponse"]).StatusCode == 201)">
                        <set-variable name="pmResponseBody" value="@(((IResponse)context.Variables["pmResponse"]).Body.As<JObject>())" />
                        <set-backend-service base-url="https://${ingress_load_balancer_hostname}/idpaywallet" />
                        <rewrite-uri template="@("idpay/wallet/{initiativeId}/"+ (string)context.Variables["tokenPDV"] + "/instruments")" />
                        <set-body>@{
                            return new JObject(
                                new JProperty("hpan", ((JObject)context.Variables["pmResponseBody"])["hashCode"]),
                                new JProperty("brandLogo", ((JObject)context.Variables["pmResponseBody"])["brandLogo"]),
                                new JProperty("brand", ((JObject)context.Variables["pmResponseBody"])["brand"]),
                                new JProperty("maskedPan", ((JObject)context.Variables["pmResponseBody"])["maskedPan"]),
                                new JProperty("channel", (string)context.Variables["senderCode"])
                            ).ToString();
                        }
                        </set-body>
                    </when>
                    <otherwise>
                        <return-response>
                            <set-status code="@(((IResponse)context.Variables["pmResponse"]).StatusCode)" reason="ErrorPM" />
                            <set-header name="Content-Type" exists-action="override">
                                <value>application/json</value>
                            </set-header>
                            <set-body>@(((IResponse)context.Variables["pmResponse"]).Body.As<JObject>().ToString())</set-body>
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
