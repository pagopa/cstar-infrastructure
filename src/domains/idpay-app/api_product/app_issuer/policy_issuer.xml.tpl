<policies>
    <inbound>
        <base />
        <!-- Extract Token from Fiscal-Code header parameter -->
        <set-variable name="fiscalCode" value="@(context.Request.Headers.GetValueOrDefault("Fiscal-Code", ""))" />
        <!-- The variable present in cache is the pii of the user obtaind with PDV  /-->
        <cache-lookup-value key="@((string)context.Variables["fiscalCode"])" variable-name="tokenPDV" />
        <!-- Extract the channel internal id from header parameter -->
        <set-variable name="keyHash" value="@{
                    System.Security.Cryptography.SHA256 hasher = System.Security.Cryptography.SHA256.Create();
                    return BitConverter.ToString(hasher.ComputeHash(System.Text.Encoding.UTF8.GetBytes(context.Request.Headers.GetValueOrDefault("Ocp-Apim-Subscription-Key","")))).Replace("-", "").ToLowerInvariant();
                    }" />
        <choose>
            <when condition="@(!context.Variables.ContainsKey("keyHash"))">
                <!-- Return 401 Unauthorized with subscription id issue -->
                <return-response>
                    <set-status code="401" reason="Unauthorized" />
                </return-response>
            </when>
            <when condition="@(!(Regex.IsMatch(((string)context.Variables["fiscalCode"]), "^([A-Za-z]{6}[0-9lmnpqrstuvLMNPQRSTUV]{2}[abcdehlmprstABCDEHLMPRST]{1}[0-9lmnpqrstuvLMNPQRSTUV]{2}[A-Za-z]{1}[0-9lmnpqrstuvLMNPQRSTUV]{3}[A-Za-z]{1})$") | Regex.IsMatch(((string)context.Variables["fiscalCode"]), "(^[0-9]{11})$")))">
                <return-response>
                    <set-status code="400" reason="Bad Request" />
                    <set-header name="Content-Type" exists-action="override">
                        <value>application/json</value>
                    </set-header>
                    <set-body>{
                        "code": "FISCAL_CODE_NOT_VALID",
                        "message": "Fiscal code not valid!"
                        }</set-body>
                </return-response>
            </when>
            <otherwise>
            <set-variable name="senderCode" value="ISSUER_TEST" />
            <!--
                <send-request mode="new" response-variable-name="senderCode" timeout="60" ignore-error="true">
                    <set-url>@("http://${rtd_ingress_ip}/rtdmssenderauth/sender-code?internalId="+(string)context.Variables["keyHash"])</set-url>
                    <set-method>GET</set-method>
                </send-request>
                <choose>
                    <when condition="@(((IResponse)context.Variables["senderCode"]).StatusCode != 200)">
                        <return-response>
                            <set-status code="400" reason="Bad Request" />
                            <set-header name="Content-Type" exists-action="override">
                                <value>application/json</value>
                            </set-header>
                            <set-body>@{
                                return new JObject(
                                        new JProperty("code", "it.gov.pagopa.idpay.issuer"),
                                        new JProperty("message", "Cannot retrive sender code")
                                    ).ToString();
                                }
                            </set-body>
                        </return-response>
                    </when>
                    <otherwise>
                        <set-variable name="senderCode" value="@((string)((IResponse)context.Variables["senderCode"]).Body.As<JObject>()["senderCode"])" />
                    </otherwise>
                </choose>
            -->
            </otherwise>
        </choose>
        <choose>
            <!-- If API Management doesn’t find it in the cache, make a request for it and store it -->
            <when condition="@(!context.Variables.ContainsKey("tokenPDV"))">
                <send-request mode="new" response-variable-name="responsePDV" timeout="${appio_timeout_sec}" ignore-error="true">
                    <set-url>${pdv_tokenizer_url}/tokens</set-url>
                    <set-method>PUT</set-method>
                    <set-header name="x-api-key" exists-action="override">
                        <value>{{pdv-api-key}}</value>
                    </set-header>
                    <set-body>@{
                            return new JObject(
                                    new JProperty("pii", (string)context.Variables["fiscalCode"])
                                    ).ToString();
                        }</set-body>
                </send-request>
                <choose>
                    <when condition="@(context.Variables["responsePDV"] == null)">
                        <return-response>
                            <set-status code="504" reason="PDV Timeout" />
                        </return-response>
                    </when>
                    <when condition="@(((IResponse)context.Variables["responsePDV"]).StatusCode == 200)">
                        <set-variable name="tokenPDV" value="@((string)((IResponse)context.Variables["responsePDV"]).Body.As<JObject>()["token"])" />
                        <cache-store-value key="@((string)context.Variables["fiscalCode"])" value="@((string)context.Variables["tokenPDV"])" duration="900" />
                    </when>
                    <otherwise>
                        <return-response>
                            <set-status code="401" reason="Unauthorized" />
                        </return-response>
                    </otherwise>
                </choose>
            </when>
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
        <return-response>
            <set-status code="500" reason="Policy Error" />
        </return-response>
    </on-error>
</policies>
