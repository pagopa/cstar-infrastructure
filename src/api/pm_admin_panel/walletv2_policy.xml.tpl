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
        <ip-filter action="allow">
            <address-range from="${PM-Ip-Filter-From}" to="${PM-Ip-Filter-To}" />
        </ip-filter>
        <set-variable name="fiscalcode" value="@(context.Request.Headers.GetValueOrDefault("Fiscal-Code",""))" />
        <set-variable name="basicAuthDetails" value="@{
var username = context.Variables.GetValueOrDefault<string>("userDenominato");

var password = context.Variables.GetValueOrDefault<string>("passDenominato");

return "Basic " + System.Convert.ToBase64String(System.Text.Encoding.GetEncoding("ISO-8859-1").GetBytes("cruscotto" + ":" + "${CRUSCOTTO-Basic-Auth-Pwd}"));

}" />
        <send-request mode="new" response-variable-name="walletresponse" timeout="${PM-Timeout-Sec}" ignore-error="true">
            <set-url>@("${pm-backend-url}/pp-admin-panel/v1/external/walletv2")</set-url>
            <set-method>GET</set-method>
            <set-header name="Authorization" exists-action="override">
                <value>@(context.Variables.GetValueOrDefault<string>("basicAuthDetails"))</value>
            </set-header>
            <set-header name="Fiscal-Code" exists-action="override">
                <value>@(context.Variables.GetValueOrDefault<string>("fiscalcode"))</value>
            </set-header>
            %{ if env_short != "d" ~}
            <authentication-certificate thumbprint="${bpd-pm-client-certificate-thumbprint}" />
            %{ endif ~}
        </send-request>
        <return-response response-variable-name="walletresponse" />
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
