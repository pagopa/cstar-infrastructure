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
        <cache-lookup-value key="@(context.Request.MatchedParameters["id"])" variable-name="hashpan" caching-type="internal" />
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
                    byte[] hashByte = hasher.ComputeHash(System.Text.Encoding.UTF8.GetBytes((string)context.Request.MatchedParameters["id"]+(string)context.Variables["salt"]));

                    StringBuilder builder = new StringBuilder();  
                    for (int i = 0; i < hashByte.Length; i++)  
                    {  
                        builder.Append(hashByte[i].ToString("x2"));  
                    }
                    return builder.ToString();
                }" />
                <cache-store-value key="@(context.Request.MatchedParameters["id"])" value="@((string)context.Variables["hashpan"])" duration="3600" caching-type="internal" />
            </when>
        </choose>
        <rewrite-uri template="@("/" + (string)context.Variables["hashpan"])" />
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
            <set-status code="500" reason="Hashing Service Error" />
        </return-response>
    </on-error>
</policies>