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
    This policy grants temporary download grants to clients by issuing SAS tokens.

    Access is limited to a single container derived from client's APIM Subscription Key.
    The container, if not already present, is created on the fly from the policy itself.
-->
    <!-- Storage related variables -->
    <set-variable name="accessKey" value="${blob-storage-access-key}" />
    <set-variable name="storageAccount" value="${blob-storage-account-name}" />
    <set-variable name="storagePrivateFqdn" value="${blob-storage-private-fqdn}" />
    <set-variable name="containerName" value="${blob-storage-container-prefix}" />
    <!-- build name part filename based on filePart query params e.g. hashedPans_1 or hashedPans -->
    <set-variable name="hashedPanFilePart" value="@(context.Request.OriginalUrl.Query.ContainsKey("filePart") ? string.Format("_{0}", context.Request.OriginalUrl.Query.GetValueOrDefault("filePart")) : "")" />
    <set-variable name="hashedPanFilename" value="@(string.Format("hashedPans{0}.zip", context.Variables["hashedPanFilePart"]))" />

    <!-- SAS Token variables -->
    <set-variable name="sasTokenExpiresInMinutes" value="60" />
    <!-- Extract container name -->
    <set-variable name="containerName" value="@((string)context.Variables["containerName"])" />
    <!-- Genere a service-level SAS token -->
    <set-variable name="signedPermissions" value="rcw" />
    <set-variable name="signedStart" value="@(DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mmZ"))" />
    <set-variable name="signedExpiry" value="@(DateTime.UtcNow.AddMinutes(Convert.ToDouble((string)context.Variables["sasTokenExpiresInMinutes"])).ToString("yyyy-MM-ddTHH:mmZ"))" />
    <!-- se, required -->
    <set-variable name="canonicalizedResource" value="@{
          // {resourceName}/{storageAccount}/{resourcePath}
          // must include resourceName from signedVersion 2015-02-21 onwards
          return string.Format("/blob/{0}/{1}", (string)context.Variables["storageAccount"], (string)context.Variables["containerName"]);
    }" />
    <set-variable name="signedIdentifier" value="" />
    <!-- si, optional -->
    <set-variable name="signedIP" value="" />
    <!-- sip, optional -->
    <set-variable name="signedProtocol" value="https" />
    <!-- spr, optional -->
    <set-variable name="signedVersion" value="2020-12-06" />
    <!-- sv, required -->
    <set-variable name="signedResource" value="c" />
    <!-- sr, required -->
    <set-variable name="signedSnapshotTime" value="" />
    <!-- sst, optional -->
    <set-variable name="signedEncryptionScope" value="" />
    <!-- ses, optional -->
    <!-- Response Cache Control -->
    <set-variable name="rscc" value="" />
    <!-- rscc, optional -->
    <!-- Response Content Disposition -->
    <set-variable name="rscd" value="" />
    <!-- rscd, optional -->
    <!-- Response Content Encoding -->
    <set-variable name="rsce" value="" />
    <!-- rsce, optional -->
    <!-- Response Content Language -->
    <set-variable name="rscl" value="" />
    <!-- rscl, optional -->
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
    }" />
    <set-variable name="sharedKey" value="@{
              // https://docs.microsoft.com/en-us/rest/api/storageservices/fileservices/authentication-for-the-azure-storage-services
              // Hash-based Message Authentication Code (HMAC) using SHA256 hash
              System.Security.Cryptography.HMACSHA256 hasher = new System.Security.Cryptography.HMACSHA256(Convert.FromBase64String((string)context.Variables["accessKey"]));
              return Convert.ToBase64String(hasher.ComputeHash(System.Text.Encoding.UTF8.GetBytes((string)context.Variables["StringToSign"])));
          }" />
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
    }" />
    <!-- section: rewrite request to backend -->
    <!-- change base backend url -->
    <set-backend-service base-url="@{
            return "https://" + context.Variables["storagePrivateFqdn"] + "/" + context.Variables["containerName"];
    }" />
    <set-method>GET</set-method>
    <!-- remove filePart query parameter -->
    <set-query-parameter name="filePart" exists-action="delete" />
    <!-- rewrite request to backend specfying sas -->
    <rewrite-uri template="@{
            return string.Format("/{0}?{1}",
                context.Variables["hashedPanFilename"],
                context.Variables["sas"]
            );
    }" />
  </inbound>
  <backend>
    <base />
  </backend>
    <outbound>
        <base />
        <set-header name="x-ms-error-code" exists-action="delete" />
        <set-header name="x-ms-version" exists-action="delete" />
        <set-header name="x-ms-request-id" exists-action="delete" />
        <set-header name="x-ms-creation-time" exists-action="delete" />
        <set-header name="x-ms-lease-status" exists-action="delete" />
        <set-header name="x-ms-lease-state" exists-action="delete" />
        <set-header name="x-ms-blob-type" exists-action="delete" />
        <set-header name="x-ms-server-encrypted" exists-action="delete" />
        <set-header name="ETag" exists-action="delete" />
        <choose>
            <when condition="@(context.Response.StatusCode != 200)">
                <return-response>
                    <set-status code="@(context.Response.StatusCode)" reason="@(context.Response.StatusReason)" />
                    <set-body />
                </return-response>
            </when>
        </choose>
    </outbound>
  <on-error>
    <base />
  </on-error>
</policies>