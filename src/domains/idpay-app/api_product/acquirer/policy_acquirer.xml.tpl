<policies>
    <inbound>
      <base />
      <set-header name="x-acquirer-id" exists-action="override">
        <value>@(context.User?.Id)</value>
      </set-header>
      <set-header name="x-merchant-id" exists-action="override">
        <!-- TODO merchantId retrieve logic -->
        <value>@(context.Request.Headers.GetValueOrDefault("Merchant-FiscalCode", "DUMMYMERCHANTID"))</value>
      </set-header>
      <set-header name="x-apim-request-id" exists-action="override">
        <value>@(context.RequestId.ToString())</value>
      </set-header>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
        <return-response>
            <set-status code="500" reason="Policy Error" />
        </return-response>
    </on-error>
</policies>
