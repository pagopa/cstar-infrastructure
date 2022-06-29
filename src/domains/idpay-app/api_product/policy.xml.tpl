<policies>
    <inbound>
        <!-- Extract Token from Authorization header parameter -->
        <set-variable name="token" value="@(context.Request.Headers.GetValueOrDefault("Authorization","scheme param").Split(' ').Last())" />
        <!--set-variable name="token" value="@(context.Request.Headers.GetValueOrDefault("Authorization","scheme param"))" /-->
        <cache-lookup-value key="@((string)context.Variables["token"])" variable-name="fiscalCode"  />
        <set-variable name="bypassCacheStorage" value="false" />
        <choose>
            <!-- If API Management doesn’t find it in the cache, make a request for it and store it -->
            <when condition="@(!context.Variables.ContainsKey("fiscalCode"))">
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
                        <set-variable name="fiscalCode" value="@((string)((IResponse)context.Variables["tokenstate"]).Body.As<JObject>()["fiscal_code"])" />
                        <set-variable name="bypassCacheStorage" value="true" />
                    </when>
                    <otherwise>
                        %{ if env_short != "u" ~}
                        <return-response>
                            <set-status code="401" reason="Unauthorized" />
                        </return-response>
                        %{ else ~}
                        <send-request mode="new" response-variable-name="tokenstate" timeout="${appio_timeout_sec}" ignore-error="true">
                            <set-url>https://app-backend.io.italia.it/bpd/api/v1/user</set-url>
                            <set-method>GET</set-method>
                            <set-header name="Authorization" exists-action="override">
                                <value>@("Bearer " +(string)context.Variables["token"])</value>
                            </set-header>
                        </send-request>
                        <choose>
                            <when condition="@(context.Variables["tokenstate"] == null)">
                                <return-response>
                                    <set-status code="504" reason="Backend IO Timeout" />
                                </return-response>
                            </when>
                            <when condition="@(((IResponse)context.Variables["tokenstate"]).StatusCode == 200)">
                                <set-variable name="fiscalCode" value="@((string)((IResponse)context.Variables["tokenstate"]).Body.As<JObject>()["fiscal_code"])" />
                                <set-variable name="bypassCacheStorage" value="true" />
                            </when>
                            <otherwise>
                                <return-response>
                                    <set-status code="401" reason="Unauthorized" />
                                </return-response>
                            </otherwise>
                        </choose>
                        %{ endif ~}
                    </otherwise>
                </choose>
            </when>
        </choose>
        <choose>
            <!-- Check active property in response -->
            <when condition="@(context.Variables["fiscalCode"] == null)">
                <!-- Return 401 Unauthorized with http-problem payload -->
                <return-response>
                    <set-status code="401" reason="Unauthorized" />
                    <set-header name="WWW-Authenticate" exists-action="override">
                        <value>Bearer error="invalid_token"</value>
                    </set-header>
                </return-response>
            </when>
            <otherwise>
                <set-header name="x-fiscal-code" exists-action="override">
                    <value>@((string)context.Variables["fiscalCode"])</value>
                </set-header>
                <set-header name="x-user-id" exists-action="override">
                    <value>@((string)context.Variables["fiscalCode"])</value>
                </set-header>
                <set-header name="x-apim-request-id" exists-action="override">
                    <value>@(context.RequestId.ToString())</value>
                </set-header>
                <choose>
                    <when condition="@("true".Equals((string)context.Variables["bypassCacheStorage"]))">
                        <!-- Store result in cache -->
                        <cache-store-value key="@((string)context.Variables["token"])" value="@((string)context.Variables["fiscalCode"])" duration="3600"  />
                    </when>
                </choose>
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
        <return-response>
            <set-status code="500" reason="Policy Error" />
        </return-response>
    </on-error>
</policies>
