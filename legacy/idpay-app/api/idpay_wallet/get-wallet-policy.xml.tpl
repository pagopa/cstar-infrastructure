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
		<rewrite-uri template="@("idpay/wallet/"+ (string)context.Variables["tokenPDV"])" />
	</inbound>
	<backend>
		<base />
	</backend>
	<outbound>
		<base />
		<!-- Check the response and get the initiativeList  -->
		<set-variable name="initiativeList" value="@{
            var jsonResponse = context.Response.Body.As<JObject>();

            // If the response does not contain 'initiativeList', return an empty array
            var initiativeList = jsonResponse["initiativeList"] as JArray;
            if (initiativeList == null)
            {
                return new JArray();
            }

            return initiativeList;
        }" />
		<set-variable name="modifiedInitiativeList" value="@{
            var initiativeList = context.Variables["initiativeList"] as JArray;

            // Check if 'initiativeList' is present
            if (initiativeList != null)
            {
                foreach (var initiative in initiativeList)
                {
                    var organizationName = initiative["organizationName"]?.ToString();
                    var initiativeName   = initiative["initiativeName"]?.ToString();
                    if (organizationName != null && organizationName.ToLowerInvariant().Contains("comune di guidonia montecelio") && initiativeName.ToLowerInvariant().Contains("bonus"))
                    {
                        // Changes the 'initiativeRewardType' for the specified organization
                        initiative["initiativeRewardType"] = "EXPENSE";
                        initiative["webViewUrl"]="${webViewUrl}";
                    }
                }
            }
            return initiativeList;
        }" />
		<set-body>@{
            var modifiedInitiativeList = context.Variables["modifiedInitiativeList"] as JArray;

            // Create an object with 'initiativeList' as a property
            var responseObject = new JObject();
            responseObject["initiativeList"] = modifiedInitiativeList;

            return responseObject.ToString();
        }</set-body>
	</outbound>
	<on-error>
		<base />
	</on-error>
</policies>
