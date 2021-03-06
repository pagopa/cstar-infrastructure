<policies>
  <inbound>
    <base />
    <return-response>
      <set-status code="200" reason="Abi to fiscal code map"/>
      <set-header name="Content-Type" exists-action="override">
        <value>application/json</value>
      </set-header>
      <set-body>@{
        return new JObject(
          new JProperty("EVODE", "IE9813461A"),
          new JProperty("STPAY", "LU30726739"),
          new JProperty("BPAY1", "04949971008")
        ).ToString();
        }
      </set-body>
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