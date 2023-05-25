<!--
    IMPORTANT:
    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.
    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.
    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.
    - To add a policy, place the cursor at the desired insertion point and select a policy from the sidebar.
    - To remove a policy, delete the corresponding policy statement from the policy document.
    - Position the <base> element within a section element to inherit all policies from the corresponding section element in the enclosing scope.
    - Remove the <base> element to prevent inheriting policies from the corresponding section element in the enclosing scope.
    - Policies are applied in the order of their appearance, from the top down.
    - Comments within policy elements are not supported and may disappear. Place your comments between policy elements or at a higher level scope.
-->
<policies>
    <inbound>
        <base />
        <set-backend-service base-url="https://${ingress_load_balancer_hostname}/idpayrewardnotification" />
        <rewrite-uri template="@("/idpay/organization/{organizationId}/initiative/{initiativeId}/reward/notification/byExternalId/{eventId}")" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <choose>
            <when condition="@(context.Response.StatusCode >= 200 &&  context.Response.StatusCode < 300)">
                <retry condition="@((context.Variables["responsePDV"] == null)  || (((IResponse)context.Variables["responsePDV"]).StatusCode == 429))"
                                       count="${pdv_retry_count}" interval="${pdv_retry_interval}"
                                       max-interval="${pdv_retry_max_interval}"
                                       delta="${pdv_retry_delta}"
                                       first-fast-retry="false">
                    <send-request mode="new" response-variable-name="responsePDV" timeout="${pdv_timeout_sec}" ignore-error="true">
                    <set-url>@("${pdv_tokenizer_url}/tokens/"+context.Response.Body.As<JObject>(preserveContent: true)["userId"]+"/pii")</set-url>
                    <set-method>GET</set-method>
                    <set-header name="x-api-key" exists-action="override">
                        <value>{{pdv-api-key}}</value>
                    </set-header>
                    </send-request>
                </retry>
                <choose>
                    <when condition="@(context.Variables["responsePDV"] == null)">
                        <return-response>
                            <set-status code="408" reason="PDV Timeout" />
                        </return-response>
                    </when>
                    <when condition="@(((IResponse)context.Variables["responsePDV"]).StatusCode == 200)">
                        <return-response>
                            <set-header name="Content-Type" exists-action="override">
                                <value>application/json</value>
                            </set-header>
                            <set-body>
                                @{ 
                                    JObject body = context.Response.Body.As<JObject>();
                                    body.Add(new JProperty("fiscalCode", (string)((IResponse)context.Variables["responsePDV"]).Body.As<JObject>()["pii"]));
                                    body.Add(new JProperty("eventId", body.Property("externalId").Value));
                                    body.Property("userId").Remove();
                                    body.Property("id").Remove();
                                    body.Property("externalId").Remove();
                                    return body.ToString(); 
                                }
                            </set-body>
                        </return-response>
                    </when>
                    <otherwise>
                        <return-response>
                            <set-status code="401" reason="Unauthorized" />
                        </return-response>
                    </otherwise>
                </choose>
                
            </when>
        </choose>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
