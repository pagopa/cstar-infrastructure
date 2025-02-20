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
        <set-backend-service base-url="https://${ingress_load_balancer_hostname}/idpaywallet" />
        <rewrite-uri template="@("idpay/wallet/{initiativeId}/"+(string)context.Variables["tokenPDV"])" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />

        <!-- Check the answer and get the initiative item -->
        <set-variable name="initiative" value="@{
            var jsonResponse = context.Response.Body.As<JObject>();

            //Checks whether the response contains an initiative object, otherwise returns null
            var initiative = jsonResponse;
            if (initiative == null)
            {
                return null;
            }

            return initiative;
        }" />

        <set-variable name="modifiedInitiative" value="@{
            var initiative = context.Variables["initiative"] as JObject;

            // If the initiative is present, we modify the 'initiativeRewardType' field for the specified organization
            if (initiative != null)
            {
                var organizationName = initiative["organizationName"]?.ToString();
                var initiativeName = initiative["initiativeName"]?.ToString();
                if (organizationName != null && organizationName.ToLowerInvariant().Contains("comune di guidonia montecelio") && initiativeName.ToLowerInvariant().Contains("bonus"))
                {
                    // Update the 'initiativeRewardType' for the specified organization
                    initiative["initiativeRewardType"] = "EXPENSE";
                    initiative["webViewUrl"]= "${webViewUrl}";
                }
            }

            return initiative;
        }" />

        <set-body>@{
            var modifiedInitiative = context.Variables["modifiedInitiative"] as JObject;

            // Create an object with the modified answer
            return modifiedInitiative?.ToString() ?? "{}";  // Returns an empty object if nothing is present
        }</set-body>
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
