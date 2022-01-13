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
<!-- Ref: The policy defined in this file shows how to generate Shared Access Signature (https://docs.microsoft.com/en-us/azure/storage/storage-dotnet-shared-access-signature-part-1) using expressions. -->


<policies>
    <inbound>
        <base />
         <!-- String To Sign for a Service SAS (version  2020-12-06)
            StringToSign = signedPermissions + "\n" +  
               signedStart + "\n" +  
               signedExpiry + "\n" +  
               canonicalizedResource + "\n" +  
               signedIdentifier + "\n" +  
               signedIP + "\n" +  
               signedProtocol + "\n" +  
               signedVersion + "\n" +  
               signedResource + "\n" +
               signedSnapshotTime + "\n" +
               signedEncryptionScope + "\n" +
               rscc + "\n" +  
               rscd + "\n" +  
               rsce + "\n" +  
               rscl + "\n" +
        -->

        <set-variable name="accessKey" value="${blob-storage-access-key}" />
        <set-variable name="storageAccount" value="${blob-storage-account-name}" />
        <set-variable name="containerName" value="ade-transactions" />


        <set-variable name="signedPermissions" value="rw" /> <!-- sp, required -->
        <set-variable name="signedStart" value="@(DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mmZ"))" /> <!-- st, optional -->
        <set-variable name="signedExpiry" value="@(DateTime.UtcNow.AddHours(1).ToString("yyyy-MM-ddTHH:mmZ"))" /> <!-- se, required -->
        <set-variable name="canonicalizedResource" value="@{ 
            // /{storageAccount}/{resourcePath}
            return string.Format("/{0}/{1}",
                (string)context.Variables["storageAccount"],
                (string)context.Variables["containerName"]);
            }"
        /> <!-- not returned, required -->
        <set-variable name="signedIdentifier" value="" /> <!-- si, optional -->
        <set-variable name="signedIP" value="" /> <!-- sip, optional -->
        <set-variable name="signedProtocol" value="http" /> <!-- spr, optional -->
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
                (string)context.Variables["sharedKey"],
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
            <set-body>@{
                return new JObject(
                    new JProperty("sas", context.Variables["sas"])
                ).ToString();
             }
            </set-body>
        </return-response>

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