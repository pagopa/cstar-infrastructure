<policies>
  <inbound>
    <base/>
    <set-variable name="keyHash" value="@{
                    System.Security.Cryptography.SHA256 hasher = System.Security.Cryptography.SHA256.Create();
                    return BitConverter.ToString(hasher.ComputeHash(System.Text.Encoding.UTF8.GetBytes(context.Request.Headers.GetValueOrDefault("Ocp-Apim-Subscription-Key","")))).Replace("-", "").ToLowerInvariant();
    }"
    />

    <send-request mode="new" response-variable-name="senderCode" timeout="60" ignore-error="true">
      <set-url>@("${rtd-ingress}/rtdmssenderauth/sender-code?internalId="+(string)context.Variables["keyHash"])</set-url>
      <set-method>GET</set-method>
    </send-request>

    <choose>
      <when condition="@(((IResponse)context.Variables["senderCode"]).StatusCode == 200)">
      <!-- join sender codes using "," to obtain sendercode1,sendercode,etc... -->
        <set-backend-service base-url="${rtd-ingress}/rtdmsfilereporter" />
        <set-query-parameter name="senderCodes" exists-action="override">
          <value>@(string.Join(",", ((IResponse)context.Variables["senderCode"]).Body.As<JArray>()))</value>
        </set-query-parameter>
      </when>
      <otherwise>
        <return-response>
          <set-status code="@(((IResponse)context.Variables["senderCode"]).StatusCode)" reason="@(((IResponse)context.Variables["senderCode"]).StatusReason)" />
          <set-body />
        </return-response>
      </otherwise>
    </choose>
  </inbound>
  <backend>
    <base/>
  </backend>
  <outbound>
    <base/>
  </outbound>
  <on-error>
    <base/>
  </on-error>
</policies>
