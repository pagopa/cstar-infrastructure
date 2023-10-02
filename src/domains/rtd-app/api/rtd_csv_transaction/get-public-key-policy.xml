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

        <!-- add deprecation check on batch service version -->
        <set-variable name="userAgentHeader" value="@(context.Request.Headers.GetValueOrDefault("User-Agent",""))"/>
        <choose>
            <when condition="@(context.Variables.GetValueOrDefault<string>("userAgentHeader").StartsWith("BatchService/"))">
                <set-variable name="batchServiceVersion" value="@( context.Variables.GetValueOrDefault<string>("userAgentHeader").Split('/').Last() )"/>
                <set-variable name="majorVersionHeader" value="@( Int32.Parse(context.Variables.GetValueOrDefault<string>("batchServiceVersion").Split('.')[0]) )"/>
                <set-variable name="minorVersionHeader" value="@( Int32.Parse(context.Variables.GetValueOrDefault<string>("batchServiceVersion").Split('.')[1]) )"/>
                <set-variable name="patchVersionHeader" value="@( Int32.Parse(context.Variables.GetValueOrDefault<string>("batchServiceVersion").Split('.')[2]) )"/>
                <set-variable name="supportedVersion" value="${last-version-supported}" />
                <set-variable name="supportedMajorVersion" value="@( Int32.Parse(context.Variables.GetValueOrDefault<string>("supportedVersion").Split('.')[0]) )"/>
                <set-variable name="supportedMinorVersion" value="@( Int32.Parse(context.Variables.GetValueOrDefault<string>("supportedVersion").Split('.')[1]) )"/>
                <set-variable name="supportedPatchVersion" value="@( Int32.Parse(context.Variables.GetValueOrDefault<string>("supportedVersion").Split('.')[2]) )"/>
                <choose>
                    <when condition="@(context.Variables.GetValueOrDefault<Int32>("majorVersionHeader") < context.Variables.GetValueOrDefault<Int32>("supportedMajorVersion") ||
                        (context.Variables.GetValueOrDefault<Int32>("majorVersionHeader") == context.Variables.GetValueOrDefault<Int32>("supportedMajorVersion") && context.Variables.GetValueOrDefault<Int32>("minorVersionHeader") < context.Variables.GetValueOrDefault<Int32>("supportedMinorVersion")) ||
                        (context.Variables.GetValueOrDefault<Int32>("majorVersionHeader") == context.Variables.GetValueOrDefault<Int32>("supportedMajorVersion") && context.Variables.GetValueOrDefault<Int32>("minorVersionHeader") == context.Variables.GetValueOrDefault<Int32>("supportedMinorVersion")
                            && context.Variables.GetValueOrDefault<Int32>("patchVersionHeader") < context.Variables.GetValueOrDefault<Int32>("supportedPatchVersion"))
                        )">
                        <return-response>
                            <set-status code="403" reason="Batch Service version is deprecated" />
                            <set-body>Batch Service current version is deprecated, please update to latest version!</set-body>
                        </return-response>
                    </when>
                </choose>
            </when>
        </choose>

        <set-variable name="publicKey" value="${public-key-asc}" />
        <return-response>
            <set-header name="Content-Type" exists-action="override">
                <value>text/plain</value>
            </set-header>
            <set-body>@{ return Encoding.UTF8.GetString(Convert.FromBase64String((string)context.Variables["publicKey"])); }</set-body>
        </return-response>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base/>
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
