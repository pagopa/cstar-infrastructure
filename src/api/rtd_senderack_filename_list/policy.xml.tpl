<policies>
  <inbound>
    <base />
    <return-response>
      <set-status code="200" reason="Sender Ade Ack filename list"/>
      <set-header name="Content-Type" exists-action="override">
        <value>application/json</value>
      </set-header>
      <set-body>@{
        
        var fileList = new JArray();
        fileList.Add("CSTAR.STPAY.ADEACK.20220929.211940.001.csv");
        fileList.Add("CSTAR.STPAY.ADEACK.20220929.211941.001.csv");
        
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