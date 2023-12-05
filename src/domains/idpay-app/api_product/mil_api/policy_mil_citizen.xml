<policies>
    <inbound>
        <include-fragment fragment-id="idpay-validate-token-mil" />
        <choose>
            <when condition="@(context.Variables["fiscalCode"] != null)">
                <!-- Use the fiscalCode from the fragment for the PDV call -->
                <set-variable name="pii" value="@((string)context.Variables["fiscalCode"])" />
                <include-fragment fragment-id="idpay-pdv-tokenizer" />
                <choose>
                    <when condition="@(context.Variables["pdv_token"] != null)">
                        <set-variable name="tokenPDV" value="@((string)context.Variables["pdv_token"])" />
                    </when>
                    <otherwise>
                        <return-response>
                            <set-status code="401" reason="Unauthorized" />
                        </return-response>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <return-response>
                    <set-status code="401" reason="Unauthorized" />
                </return-response>
            </otherwise>
        </choose>
        <set-header name="x-user-id" exists-action="override">
            <value>@((string)context.Variables["tokenPDV"])</value>
        </set-header>
        <base />
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
