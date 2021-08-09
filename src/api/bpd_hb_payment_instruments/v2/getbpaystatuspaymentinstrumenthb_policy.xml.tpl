<policies>
    <inbound>
        <base />
        <cache-lookup-value key="@(context.Request.Url.Query.GetValueOrDefault("id",""))" variable-name="hashpan" caching-type="internal" />
        <choose>
            <when condition="@(!context.Variables.ContainsKey("hashpan"))">
                <cache-lookup-value key="saltPM" variable-name="salt" caching-type="internal" />
                <choose>
                    <when condition="@(!context.Variables.ContainsKey("salt"))">
                        <send-request mode="new" response-variable-name="saltPMResponse" timeout="${pm-timeout-sec}" ignore-error="true">
                            <set-url>@("${pm-backend-url}/pp-restapi-rtd/v1/static-contents/wallets/hashing")</set-url>
                            <set-method>GET</set-method>
                            %{ if env_short != "d" ~}
                            <authentication-certificate thumbprint="${bpd-pm-client-certificate-thumbprint}" />
                            %{ endif ~}
                        </send-request>
                        <choose>
                            <when condition="@(((IResponse)context.Variables["saltPMResponse"]).StatusCode != 200)">
                                <return-response>
                                    <set-status code="500" reason="Errore PM get salt" />
                                </return-response>
                            </when>
                            <otherwise>
                                <set-variable name="salt" value="@((string)((IResponse)context.Variables["saltPMResponse"]).Body.As<JObject>()["salt"])" />
                                <cache-store-value key="saltPM" value="@((string)context.Variables["salt"])" duration="3600" caching-type="internal" />
                            </otherwise>
                        </choose>
                    </when>
                </choose>
                <set-variable name="hashpan" value="@{
                    System.Security.Cryptography.SHA256 hasher = System.Security.Cryptography.SHA256.Create();
                    byte[] hashByte = hasher.ComputeHash(System.Text.Encoding.UTF8.GetBytes((string)context.Request.Url.Query.GetValueOrDefault("id","")+(string)context.Variables["salt"]));

                    StringBuilder builder = new StringBuilder();  
                    for (int i = 0; i < hashByte.Length; i++)  
                    {  
                        builder.Append(hashByte[i].ToString("x2"));  
                    }
                    return builder.ToString();
                }" />
                <cache-store-value key="@(context.Request.Url.Query.GetValueOrDefault("id",""))" value="@((string)context.Variables["hashpan"])" duration="3600" caching-type="internal" />
            </when>
        </choose>
        <rewrite-uri template="@("/" + (string)context.Variables["hashpan"])" />
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
        <return-response>
            <set-status code="500" reason="Hashing Service Error" />
        </return-response>
    </on-error>
</policies>