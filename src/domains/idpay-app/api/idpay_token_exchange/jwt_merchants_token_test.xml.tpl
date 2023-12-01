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
        <!--base: Begin Global scope-->
        <cors allow-credentials="true">
            <allowed-origins>
              %{ for origin in origins ~}
              <origin>${origin}</origin>
              %{ endfor ~}
            </allowed-origins>
            <allowed-methods preflight-result-max-age="300">
                <method>*</method>
            </allowed-methods>
            <allowed-headers>
                <header>*</header>
            </allowed-headers>
            <expose-headers>
                <header>*</header>
            </expose-headers>
        </cors>
        <!--base: End Global scope-->
        <set-variable name="idpayPortalTestToken" value="@{
			var JOSEProtectedHeader = Convert.ToBase64String(Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(
				new {
					typ = "JWT",
					alg = "RS256"
				}))).Split('=')[0].Replace('+', '-').Replace('/', '_');

			var iat = DateTimeOffset.Now.ToUnixTimeSeconds();
			var exp = new DateTimeOffset(DateTime.Now.AddHours(8)).ToUnixTimeSeconds();  // sets the expiration of the token to be 8 hours from now
			var aud = context.Request.Body.As<JObject>(preserveContent: true)["aud"];
			var iss = context.Request.Body.As<JObject>(preserveContent: true)["iss"];
			var uid = context.Request.Body.As<JObject>(preserveContent: true)["uid"];
			var name = context.Request.Body.As<JObject>(preserveContent: true)["name"];
			var family_name = context.Request.Body.As<JObject>(preserveContent: true)["familyName"];
			var email = context.Request.Body.As<JObject>(preserveContent: true)["email"];
			var acquirer_id = context.Request.Body.As<JObject>(preserveContent: true)["acquirerId"];
			var merchant_id = context.Request.Body.As<JObject>(preserveContent: true)["merchantId"];
			var org_id = context.Request.Body.As<JObject>(preserveContent: true)["orgId"];
			var org_vat = context.Request.Body.As<JObject>(preserveContent: true)["orgVAT"];
			var org_name = context.Request.Body.As<JObject>(preserveContent: true)["orgName"];
			var org_party_role = context.Request.Body.As<JObject>(preserveContent: true)["orgPartyRole"];
			var org_role = context.Request.Body.As<JObject>(preserveContent: true)["orgRole"];
			var payload = Convert.ToBase64String(Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(
			new {
				iat,
				exp,
				aud,
				iss,
				uid,
				name,
				family_name,
				email,
				acquirer_id,
				merchant_id,
				org_id,
				org_vat,
				org_name,
				org_party_role,
				org_role
			}
			))).Split('=')[0].Replace('+', '-').Replace('/', '_');

			var message = ($"{JOSEProtectedHeader}.{payload}");

			using (RSA rsa = context.Deployment.Certificates["${jwt_cert_signing_thumbprint}"].GetRSAPrivateKey())
			{
				var signature = rsa.SignData(Encoding.UTF8.GetBytes(message), HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
				return message + "." + Convert.ToBase64String(signature).Split('=')[0].Replace('+', '-').Replace('/', '_');
			}

			return message;
			}" />
        <return-response>
            <set-body>@((string)context.Variables["idpayPortalTestToken"])</set-body>
        </return-response>
    </inbound>
    <backend>
        <!--base: Begin Global scope-->
        <forward-request />
        <!--base: End Global scope-->
    </backend>
    <outbound />
    <on-error />
</policies>
