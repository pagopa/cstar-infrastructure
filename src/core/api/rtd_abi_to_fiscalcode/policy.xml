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
          new JProperty("STPAY", "LU30726739"),
          new JProperty("BPAY1", "04949971008"),
          new JProperty("SUMUP", "IE9813461A"),
          new JProperty("ICARD", "BG175325806"),
          new JProperty("TPAY1", "09771701001"),
          new JProperty("AMAZN", "97898850157"),
          new JProperty("AMAZON", "97898850157"),
          new JProperty("EURON", "DE182769455"),
          new JProperty("UBER1", "NL858620285B01")
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
