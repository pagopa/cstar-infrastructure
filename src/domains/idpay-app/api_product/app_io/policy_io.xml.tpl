<policies>
    <inbound>
        <!-- Fix sender code for IO API -->
        <set-variable name="senderCode" value="APP_IO" />
        <!-- Extract Token from Authorization header parameter -->
        <set-variable name="token" value="@(context.Request.Headers.GetValueOrDefault("Authorization","scheme param").Split(' ').Last())" />
        <!-- The variable present in cache is the pii of the user obtaind with PDV  /-->
        <cache-lookup-value key="@((string)context.Variables["token"]+"-idpay")" variable-name="tokenPDV" />
        <set-variable name="bypassCacheStorage" value="false" />
        <choose>
            <!-- If API Management doesn’t find it in the cache, make a request for it and store it -->
            <when condition="@(!context.Variables.ContainsKey("tokenPDV"))">
                <send-request mode="new" response-variable-name="tokenstate" timeout="${appio_timeout_sec}" ignore-error="true">
                    %{ if env_short != "p" ~}
                      <!--MOCK-->
                      <set-url>@("http://${reverse_proxy_be_io}/cstariobackendtest/bpd/pagopa/api/v1/user?token="+(string)context.Variables["token"])</set-url>
                      <set-method>GET</set-method>
                    %{ else ~}
                      <!--AppIO Produzione-->
                      <set-url>https://api-app.io.pagopa.it/bpd/api/v1/user</set-url>
                      <set-method>GET</set-method>
                      <set-header name="Authorization" exists-action="override">
                          <value>@("Bearer " +(string)context.Variables["token"])</value>
                      </set-header>
                    %{ endif ~}
                </send-request>
                %{ if env_short == "u" ~}
                <!-- Call to IO BE as a fallback only for UAT environment -->
                <choose>
                    <when condition="@(context.Variables["tokenstate"] == null || ((IResponse)context.Variables["tokenstate"]).StatusCode != 200)">
                        <send-request mode="new" response-variable-name="tokenstate" timeout="${appio_timeout_sec}" ignore-error="true">
                            <set-url>https://api-app.io.pagopa.it/bpd/api/v1/user</set-url>
                            <set-method>GET</set-method>
                            <set-header name="Authorization" exists-action="override">
                                <value>@("Bearer " +(string)context.Variables["token"])</value>
                            </set-header>
                        </send-request>
                    </when>
                </choose>
                %{ endif ~}
                <choose>
                    <when condition="@(context.Variables["tokenstate"] == null)">
                        <return-response>
                            <set-status code="504" reason="Backend IO Timeout" />
                        </return-response>
                    </when>
                    <when condition="@(((IResponse)context.Variables["tokenstate"]).StatusCode == 200)">
                        <set-variable name="bypassCacheStorage" value="true" />
                        <choose>
                            <!-- Check active property in response -->
                            <when condition="@((string)((IResponse)context.Variables["tokenstate"]).Body.As<JObject>(preserveContent: true)["fiscal_code"] == null)">
                                <!-- Return 401 Unauthorized with http-problem payload -->
                                <return-response>
                                    <set-status code="401" reason="Unauthorized" />
                                    <set-header name="WWW-Authenticate" exists-action="override">
                                        <value>Bearer error="invalid_token"</value>
                                    </set-header>
                                </return-response>
                            </when>
                            <when condition="@(!(Regex.IsMatch(((string)((IResponse)context.Variables["tokenstate"]).Body.As<JObject>(preserveContent: true)["fiscal_code"]), "^([A-Za-z]{6}[0-9lmnpqrstuvLMNPQRSTUV]{2}[abcdehlmprstABCDEHLMPRST]{1}[0-9lmnpqrstuvLMNPQRSTUV]{2}[A-Za-z]{1}[0-9lmnpqrstuvLMNPQRSTUV]{3}[A-Za-z]{1})$") | Regex.IsMatch(((string)((IResponse)context.Variables["tokenstate"]).Body.As<JObject>(preserveContent: true)["fiscal_code"]), "(^[0-9]{11})$")))">
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
                                <set-variable name="pii" value="@((string)((IResponse)context.Variables["tokenstate"]).Body.As<JObject>()["fiscal_code"])" />
                                <retry condition="@((context.Variables["responsePDV"] == null)  || (((IResponse)context.Variables["responsePDV"]).StatusCode == 429))"
                                       count="${pdv_retry_count}" interval="${pdv_retry_interval}"
                                       max-interval="${pdv_retry_max_interval}"
                                       delta="${pdv_retry_delta}"
                                       first-fast-retry="false">
                                    <send-request mode="new" response-variable-name="responsePDV" timeout="${pdv_timeout_sec}" ignore-error="true">
                                        <set-url>${pdv_tokenizer_url}/tokens</set-url>
                                        <set-method>PUT</set-method>
                                        <set-header name="x-api-key" exists-action="override">
                                            <value>{{pdv-api-key}}</value>
                                        </set-header>
                                        <set-body>@{
                                                return new JObject(
                                                        new JProperty("pii", ((string)context.Variables["pii"])
                                                        )).ToString();
                                            }</set-body>
                                    </send-request>
                                </retry>
                                <choose>
                                    <when condition="@(context.Variables["responsePDV"] == null)">
                                        <return-response>
                                            <set-status code="408" reason="PDV Timeout" />
                                        </return-response>
                                    </when>
                                    <when condition="@(((IResponse)context.Variables["responsePDV"]).StatusCode == 200)">
                                        <set-variable name="tokenPDV" value="@((string)((IResponse)context.Variables["responsePDV"]).Body.As<JObject>()["token"])" />
                                        <set-variable name="bypassCacheStorage" value="true" />
                                    </when>
                                    <otherwise>
                                        <return-response>
                                            <set-status code="401" reason="Unauthorized" />
                                        </return-response>
                                    </otherwise>
                                </choose>
                                <choose>
                                    <when condition="@("true".Equals((string)context.Variables["bypassCacheStorage"]))">
                                        <!-- Store result in cache -->
                                        <cache-store-value key="@((string)context.Variables["token"]+"-idpay")" value="@((string)context.Variables["tokenPDV"])" duration="3600" />
                                    </when>
                                </choose>
                            </otherwise>
                        </choose>
                    </when>
                    <otherwise>
                        <return-response>
                            <set-status code="401" reason="Unauthorized" />
                        </return-response>
                    </otherwise>
                </choose>
            </when>
        </choose>
        <set-header name="x-user-id" exists-action="override">
            <value>@((string)context.Variables["tokenPDV"])</value>
        </set-header>
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
        <return-response>
            <set-status code="500" reason="Policy Error" />
        </return-response>
    </on-error>
</policies>
