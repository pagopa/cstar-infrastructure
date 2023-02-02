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
        <return-response>
            <set-status code="200" reason="OK" />
            <set-header name="Content-Type" exists-action="override">
                <value>application/json</value>
            </set-header>
            <set-body>@{
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            Random random = new Random();
            string serviceId = new string(Enumerable.Repeat(chars, 26).Select(s => s[random.Next(s.Length)]).ToArray());
            string primaryKey = new string(Enumerable.Repeat(chars, 26).Select(s => s[random.Next(s.Length)]).ToArray());
            string secondaryKey = new string(Enumerable.Repeat(chars, 26).Select(s => s[random.Next(s.Length)]).ToArray());
            return new JObject(
                    new JProperty("service_id", "MOCK"+"${env}"+serviceId),
                    new JProperty("primary_key", "MOCK"+"${env}"+primaryKey),
                    new JProperty("secondary_key", "MOCK"+"${env}"+secondaryKey)
            ).ToString();
          }</set-body>
        </return-response>
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
