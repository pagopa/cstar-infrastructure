<policies>
    <inbound>
        <cors allow-credentials="true" terminate-unmatched-request="${cors-global-only}">
            <allowed-origins>
        %{ for origin in allowed_origins ~}
        <origin>${origin}</origin>
        %{ endfor ~}
    </allowed-origins>
            <allowed-methods preflight-result-max-age="300">
                <method>*</method>
            </allowed-methods>
            <allowed-headers>
                <header>*</header>
            </allowed-headers>
            <expose-headers>
                <header>*</header>
            </expose-headers>
        </cors>
    </inbound>
    <backend>
        <forward-request />
    </backend>
    <outbound />
    <on-error />
</policies>
