<policies>
  <inbound>
    <return-response>
      <set-status code="200" />
      <set-body>@{
        return new JObject(
          new JProperty("EVODE", "IE9813461A"),
          new JProperty("STPAY", "LU30726739"),
          new JProperty("BPAY1", "04949971008")
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