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
        <!--
            This policy grants temporary upload grants to clients by issuing SAS tokens.

            Access is limited to a single container derived from client's APIM Subscription Key.
            The container, if not already present, is created on the fly from the policy itself.
        -->

        <!-- Storage related variables -->
        <set-variable name="accessKey" value="${blob-storage-access-key}" />
        <set-variable name="storageAccount" value="${blob-storage-account-name}" />
        <set-variable name="containerPrefix" value="${blob-storage-container-prefix}" />

        <!-- SAS Token variables -->
        <set-variable name="sasTokenExpiresInMinutes" value="60" />
        
        <!--
            START - Derive the client's own container from the APIM Subscription Key

            The container name is computed by combining a static prefix (containerPrefix) and the first 44 characters
            of the SHA256 checksum of the APIM Subscription Key.
        -->
        
        <!--
            The following block computes the SHA256 checksum of the API Subscription Key using C# cryptographic library.

            To compute the same hash in Python (tested with Python 3.9.9):

            import hashlib
            import sys
            print(hashlib.sha256(sys.argv[1].encode()).hexdigest())

            To compute the same hash with Coreutils sha256sum from command line:

            echo -n <APIM_SUBSCRIPTION_KEY> | sha256sum

            See: https://stackoverflow.com/questions/38474362/get-a-file-sha256-hash-code-and-checksum
        -->
        <set-variable name="apimSubscriptionKeyHash" value="@{
                System.Security.Cryptography.SHA256 hasher = System.Security.Cryptography.SHA256.Create();
                return BitConverter.ToString(hasher.ComputeHash(System.Text.Encoding.UTF8.GetBytes(context.Request.Headers.GetValueOrDefault("Ocp-Apim-Subscription-Key", "")))).Replace("-", "").ToLowerInvariant();
            }"
        />
        
        <set-variable name="containerName" value="@{
            return string.Format("{0}-{1}",
                (string)context.Variables["containerPrefix"],
                ((string)context.Variables["apimSubscriptionKeyHash"]).Substring(0, 44));
            }"
        />
        <!--
            END - Derive the client's own container from the APIM Subscription Key
        -->

        <!--
            START - Create a Shared Key to authorize APIM to create a container into a storage account

            see: https://docs.microsoft.com/en-us/rest/api/storageservices/authorize-with-shared-key
        -->
        <set-variable name="createContainerDate" value="@(DateTime.UtcNow.ToString("R"))" />
        <set-variable name="createContainerXmsVersion" value="2020-12-06" />

        <set-variable name="createContainercanonicalizedHeaders" value="@{
            return string.Format("x-ms-version:{0}",
                (string)context.Variables["createContainerXmsVersion"]);
            }"
        />

        <set-variable name="createContainercanonicalizedResource" value="@{
            return string.Format("/{0}/{1}\nrestype:container",
                (string)context.Variables["storageAccount"],
                (string)context.Variables["containerName"]);
            }"
        />

        <set-variable name="StringToSign" value="@{
            return string.Format(
                "PUT\n\n\n\n\n\n{0}\n\n\n\n\n\n{1}\n{2}",
                (string)context.Variables["createContainerDate"],
                (string)context.Variables["createContainercanonicalizedHeaders"],
                (string)context.Variables["createContainercanonicalizedResource"]);
            }"
        />

        <set-variable name="sharedKey" value="@{
                // https://docs.microsoft.com/en-us/rest/api/storageservices/fileservices/authentication-for-the-azure-storage-services
                // Hash-based Message Authentication Code (HMAC) using SHA256 hash
                System.Security.Cryptography.HMACSHA256 hasher = new System.Security.Cryptography.HMACSHA256(Convert.FromBase64String((string)context.Variables["accessKey"]));
                return Convert.ToBase64String(hasher.ComputeHash(System.Text.Encoding.UTF8.GetBytes((string)context.Variables["StringToSign"])));
            }"
        />

        <set-variable name="createContainerAuthorizationHeader" value="@{
            return string.Format(
                "SharedKey {0}:{1}",
                (string)context.Variables["storageAccount"],
                (string)context.Variables["sharedKey"]);
            }"
        />
        <!--
            END - Create a Shared Key to authorize APIM to create a container into a storage account
        -->

        <!--
            START - Perform a PUT operation on the storage REST endpoint
        -->
        <set-variable name="createContainerUrl" value="@{
                return "https://" + context.Variables["storageAccount"] + ".blob.core.windows.net/" + context.Variables["containerName"] + "?restype=container";
            }"
        />

        <send-request mode="new" response-variable-name="createContainerResult" timeout="5" ignore-error="false">
            <set-url>@{ return (string)context.Variables["createContainerUrl"]; }</set-url>
            <set-method>PUT</set-method>
            <set-header name="Authorization" exists-action="override">
                <value>@((string)context.Variables["createContainerAuthorizationHeader"])</value>
            </set-header>
            <set-header name="Date" exists-action="override">
                <value>@((string)context.Variables["createContainerDate"])</value>
            </set-header>
            <set-header name="x-ms-version" exists-action="override">
                <value>@((string)context.Variables["createContainerXmsVersion"])</value>
            </set-header>
        </send-request>

        <!-- Check if response is either 201 'Created' or 409 'Conflict' -->
        <choose>
            <when condition="@(((IResponse)context.Variables["createContainerResult"]).StatusCode == 201)">
                <set-variable name="blobContainerIsCreated" value="true" />
            </when>
            <when condition="@(((IResponse)context.Variables["createContainerResult"]).StatusCode == 409)">
                <set-variable name="blobContainerIsCreated" value="true" />
            </when>
            <otherwise>
                <set-variable name="blobContainerIsCreated" value="false" />
            </otherwise>
        </choose>

        <!-- If container's PUT failed return immediately an error -->
        <choose>
            <when condition="@((bool)((string)context.Variables["blobContainerIsCreated"]).Equals("false"))">
                <return-response response-variable-name="createContainerResult">
                    <set-status code="500" reason="Internal Server Error" />
                </return-response>
            </when>
        </choose>
        <!--
            END - Perform a PUT operation on the storage REST endpoint
        -->

        <!--
            START - Create a service-level shared access signature (SAS) and return it to the client
            
            'Create service SAS' reference here:
            https://docs.microsoft.com/it-it/rest/api/storageservices/create-service-sas
        -->
        <set-variable name="signedPermissions" value="rcw" /> <!-- sp, required -->
        <set-variable name="signedStart" value="@(DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mmZ"))" /> <!-- st, optional -->
        <set-variable name="signedExpiry" value="@(DateTime.UtcNow.AddMinutes(Convert.ToDouble((string)context.Variables["sasTokenExpiresInMinutes"])).ToString("yyyy-MM-ddTHH:mmZ"))" /> <!-- se, required -->
        <set-variable name="canonicalizedResource" value="@{
            // {resourceName}/{storageAccount}/{resourcePath}
            // must include resourceName from signedVersion 2015-02-21 onwards
            return string.Format("/blob/{0}/{1}",
                (string)context.Variables["storageAccount"],
                (string)context.Variables["containerName"]);
            }"
        /> <!-- not returned, required -->
        <set-variable name="signedIdentifier" value="" /> <!-- si, optional -->
        <set-variable name="signedIP" value="" /> <!-- sip, optional -->
        <set-variable name="signedProtocol" value="https" /> <!-- spr, optional -->
        <set-variable name="signedVersion" value="2020-12-06" /> <!-- sv, required -->
        <set-variable name="signedResource" value="c" /> <!-- sr, required -->
        <set-variable name="signedSnapshotTime" value="" /> <!-- sst, optional -->
        <set-variable name="signedEncryptionScope" value="" /> <!-- ses, optional -->
        <!-- Response Cache Control -->
        <set-variable name="rscc" value="" /> <!-- rscc, optional -->
        <!-- Response Content Disposition -->
        <set-variable name="rscd" value="" /> <!-- rscd, optional -->
        <!-- Response Content Encoding -->
        <set-variable name="rsce" value="" /> <!-- rsce, optional -->
        <!-- Response Content Language -->
        <set-variable name="rscl" value="" /> <!-- rscl, optional -->

        <set-variable name="StringToSign" value="@{
            return string.Format(
                "{0}\n{1}\n{2}\n{3}\n{4}\n{5}\n{6}\n{7}\n{8}\n{9}\n{10}\n{11}\n{12}\n{13}\n{14}\n",
                (string)context.Variables["signedPermissions"],
                (string)context.Variables["signedStart"],
                (string)context.Variables["signedExpiry"],
                (string)context.Variables["canonicalizedResource"],
                (string)context.Variables["signedIdentifier"],
                (string)context.Variables["signedIP"],
                (string)context.Variables["signedProtocol"],
                (string)context.Variables["signedVersion"],
                (string)context.Variables["signedResource"],
                (string)context.Variables["signedSnapshotTime"],
                (string)context.Variables["signedEncryptionScope"],
                (string)context.Variables["rscc"],
                (string)context.Variables["rscd"],
                (string)context.Variables["rsce"],
                (string)context.Variables["rscl"]
            );
            }"
        />

        <set-variable name="sharedKey" value="@{
                // https://docs.microsoft.com/en-us/rest/api/storageservices/fileservices/authentication-for-the-azure-storage-services
                // Hash-based Message Authentication Code (HMAC) using SHA256 hash
                System.Security.Cryptography.HMACSHA256 hasher = new System.Security.Cryptography.HMACSHA256(Convert.FromBase64String((string)context.Variables["accessKey"]));
                return Convert.ToBase64String(hasher.ComputeHash(System.Text.Encoding.UTF8.GetBytes((string)context.Variables["StringToSign"])));
            }"
        />

        <set-variable name="sas" value="@{
            return string.Format(
                "sig={0}&st={1}&se={2}&spr={3}&sp={4}&sr={5}&sv={6}",
                System.Net.WebUtility.UrlEncode((string)context.Variables["sharedKey"]),
                (string)context.Variables["signedStart"],
                (string)context.Variables["signedExpiry"],
                (string)context.Variables["signedProtocol"],
                (string)context.Variables["signedPermissions"],
                (string)context.Variables["signedResource"],
                (string)context.Variables["signedVersion"]
            );
            }"
        />

        <return-response>
            <set-status code="201" reason="Created"/>
            <set-header name="Content-Type" exists-action="override">
                <value>application/json</value>
            </set-header>
            <set-body>@{
                return new JObject(
                    new JProperty("sas", context.Variables["sas"]),
                    new JProperty("authorizedContainer", context.Variables["containerName"])
                ).ToString();
             }
            </set-body>
        </return-response>
        <!--
            END - Create a service-level shared access signature (SAS) and return it to the client
        -->
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base/>
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>