<policies>
  <inbound>
    <base />
    <return-response>
      <set-status code="200" reason="Abi to fiscal code map"/>
      <set-header name="Content-Type" exists-action="override">
        <value>application/json</value>
      </set-header>
      <set-body>@{
        
        var fileList = new JArray();
        fileList.Add(new JProperty("name", "CSTAR.STPAY.ADEACK.20220929.211940.001.csv"));
        fileList.Add(new JProperty("name", "CSTAR.STPAY.ADEACK.20220929.211941.001.csv"));
        
        return new JObject(
          new JProperty("fileNameList", fileList)
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