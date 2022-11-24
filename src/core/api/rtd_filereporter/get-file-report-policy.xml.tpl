<policies>
  <inbound>
    <base/>
    <return-response>
          <set-status code="200" reason="Abi to fiscal code map"/>
          <set-header name="Content-Type" exists-action="override">
            <value>application/json</value>
          </set-header>
          <set-body>@{
            return new JObject(
              new JProperty("filesRecentlyUploaded",
                new JArray(
                  new JObject(
                    new JProperty("name", "ADE.12345.TRNLOG.20220129.130704.001.01.csv.pgp"),
                    new JProperty("size", 2048),
                    new JProperty("transmissionDate", "2022-01-29T13:08Z"),
                    new JProperty("status", "RECEIVED_BY_PAGOPA")
                  ),
                  new JObject(
                    new JProperty("name", "ADE.12345.TRNLOG.20220130.140805.001.01.csv.pgp"),
                    new JProperty("size", 2049),
                    new JProperty("transmissionDate", "2022-01-30T14:08Z"),
                    new JProperty("status", "RECEIVED_BY_PAGOPA")
                  )
                )
              )
            ).ToString();
            }
          </set-body>
        </return-response>
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
