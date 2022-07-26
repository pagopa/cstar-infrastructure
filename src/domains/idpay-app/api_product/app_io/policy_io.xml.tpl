<policies>
    <inbound>
        <!-- Extract Token from Authorization header parameter -->
        <set-variable name="token" value="@(context.Request.Headers.GetValueOrDefault("Authorization","scheme param").Split(' ').Last())" />
         <!-- The variable present in cache is the pii of the user obtaind with PDV  /-->
        <cache-lookup-value key="@((string)context.Variables["token"])" variable-name="tokenPDV"  />
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
                      <set-url>https://app-backend.io.italia.it/bpd/api/v1/user</set-url>
                      <set-method>GET</set-method>
                      <set-header name="Authorization" exists-action="override">
                          <value>@("Bearer " +(string)context.Variables["token"])</value>
                      </set-header>
                    %{ endif ~}
                </send-request>
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
                            <otherwise>
                                <send-request mode="new" response-variable-name="responsePDV" timeout="${appio_timeout_sec}" ignore-error="true">
                                    <set-url>${pdv_tokenizer_url}</set-url>
                                    <set-method>PUT</set-method>
                                    <set-header name="x-api-key" exists-action="override">
                                        <value>${pdv_api_key}</value>
                                    </set-header>
                                    <set-body>@{
                                            return new JObject(
                                                    new JProperty("pii", ((string)((IResponse)context.Variables["tokenstate"]).Body.As<JObject>()["fiscal_code"])
                                                    )).ToString();
                                        }
                                    </set-body>
                                </send-request>
                                <choose>
                                    <when condition="@(context.Variables["responsePDV"] == null)">
                                        <return-response>
                                            <set-status code="504" reason="PDV Timeout" />
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
                                        <cache-store-value key="@((string)context.Variables["token"])" value="@((string)context.Variables["tokenPDV"])" duration="3600"  />
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
