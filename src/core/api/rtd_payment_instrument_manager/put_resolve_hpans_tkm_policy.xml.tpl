<policies>
    <inbound>
        <base />
        <set-variable name="storageFqdn" value="${tkm-storage-fqdn}" />
        <set-variable name="containerName" value="${tkm-container-name}"/>
        <set-variable name="fileName" value="@(context.Request.MatchedParameters["fileName"])"/>
        <set-variable name="tmkSasToken" value="{{tkm-sas-token}}"/>

        <set-header name="X-Ms-Blob-type" exists-action="override">
            <value>BlockBlob</value>
        </set-header>
        <set-header name="Ocp-Apim-Subscription-Key" exists-action="delete" />

        <rewrite-uri template="@{
            return string.Format("{0}/{1}?{2}",
                context.Variables["containerName"],
                context.Variables["fileName"],
                context.Variables["tmkSasToken"]
            );
        }"/>
        <set-backend-service base-url="@(string.Format("https://{0}/", context.Variables["storageFqdn"]))"/>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
        <set-header name="ETag" exists-action="delete" />
        <set-header name="x-ms-request-id" exists-action="delete" />
        <set-header name="x-ms-version" exists-action="delete" />
        <set-header name="x-ms-resource-type" exists-action="delete" />
        <set-header name="x-ms-creation-time" exists-action="delete" />
        <set-header name="x-ms-lease-status" exists-action="delete" />
        <set-header name="x-ms-lease-state" exists-action="delete" />
        <set-header name="x-ms-blob-type" exists-action="delete" />
        <set-header name="x-ms-server-encrypted" exists-action="delete" />
        <set-header name="x-ms-owner" exists-action="delete" />
        <set-header name="x-ms-group" exists-action="delete" />
        <set-header name="x-ms-permissions" exists-action="delete" />
        <set-header name="Request-Context" exists-action="delete" />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>