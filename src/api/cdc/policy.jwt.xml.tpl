<policies>
  <inbound>
    <base />
    %{ if env_short == "u" ~}
    <set-header name="x-ibm-client-secret" exists-action="override">
      <value>{{x-ibm-client-secret}}</value>
    </set-header>
    %{ endif ~}
    <set-header name="x-ibm-client-id" exists-action="override">
      <value>{{x-ibm-client-id}}</value>
    </set-header>
    <set-header name="Ocp-Apim-Subscription-Key" exists-action="delete" />
    <set-header name="x-bpd-token" exists-action="override">
      <value>@{
        return context.Request.Headers.GetValueOrDefault("Authorization","scheme param").Split(' ').Last();
      }
      </value>
    </set-header>
    <set-header name="Authorization" exists-action="override">
      <value>@{
      var JOSEProtectedHeader = Convert.ToBase64String(Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(
        new { 
          typ = "JWT", 
          alg = "RS256" 
        }))).Split('=')[0].Replace('+', '-').Replace('/', '_');
        
        var iat = DateTimeOffset.Now.ToUnixTimeSeconds();
        var exp = new DateTimeOffset(DateTime.Now.AddMinutes(15)).ToUnixTimeSeconds();  // sets the expiration of the token to be 15 minutes from now
        var aud = "{{jwt-aud-sogei-cdc}}";
        var iss = "api.cstar.pagopa.it";
        var sub = (string)context.Request.Headers.GetValueOrDefault("x-fiscal-code");
        var payload = Convert.ToBase64String(Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(
          new { iat, exp, aud, iss, sub }
        ))).Split('=')[0].Replace('+', '-').Replace('/', '_');

      var message = ($"{JOSEProtectedHeader}.{payload}");
      
      using (RSA rsa = context.Deployment.Certificates["${jwt_cert_signing_thumbprint}"].GetRSAPrivateKey())
      {
        var signature = rsa.SignData(Encoding.UTF8.GetBytes(message), HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
        return "Bearer " + message + "." + Convert.ToBase64String(signature).Split('=')[0].Replace('+', '-').Replace('/', '_');
      }
    }</value>
    </set-header>
    <set-header name="x-fiscal-code" exists-action="delete" />
    <set-header name="x-user-id" exists-action="delete" />
    <set-header name="x-bpd-token" exists-action="delete" />
    <set-header name="X-Forwarded-For" exists-action="delete" />
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