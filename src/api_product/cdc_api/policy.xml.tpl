<policies>
  <inbound>
    <base />
   <set-header name="x-ibm-client-secret" exists-action="override">
      <value>{{x-ibm-client-secret}}</value>
    </set-header>
    <!-- Extract Token from Authorization header parameter -->
    <set-variable name="iotoken" value="@(context.Request.Headers.GetValueOrDefault("Authorization","scheme param").Split(' ').Last())" />
    <!-- Introspect IO Token -->
    <send-request mode="new" response-variable-name="iotokenstate" timeout="${appio_timeout_sec}" ignore-error="true">
      %{ if env_short != "p" ~}
      <!-- In DEV and UAT use the mock service -->
      <set-url>@("http://${reverse_proxy_ip}/cstariobackendtest/bpd/pagopa/api/v1/user?token="+(string)context.Variables["token"])</set-url>
      <set-method>GET</set-method>
      %{ else ~}
      <!-- In prod, make a real call to io backend  -->
      <set-url>https://app-backend.io.italia.it/bpd/api/v1/user</set-url>
      <set-method>GET</set-method>
      <set-header name="Authorization" exists-action="override">
        <value>@("Bearer " +(string)context.Variables["iotoken"])</value>
      </set-header>
      %{ endif ~}
    </send-request>
    <choose>
      <when condition="@(context.Variables["iotokenstate"] == null)">
        <return-response>
          <set-status code="401" reason="Unauthorized" />
        </return-response>
      </when>
      <when condition="@(((IResponse)context.Variables["iotokenstate"]).StatusCode == 200)">
        <set-variable name="fiscalCode" value="@((string)((IResponse)context.Variables["iotokenstate"]).Body.As
          <JObject>()["fiscal_code"])" />
       <!-- <set-header name="Authorization" exists-action="override">
          <value>
              @{ 
                string fiscalCode = context.Variables["fiscalCode"]).As
              <string>(preserveContent: true);
                string jwt = "pippo";
                return "Bearer " + jwt;
              }
          </value>
        </set-header> -->
      </when>
    </choose>
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