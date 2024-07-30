param (
    [string]$clientId,
    [string]$clientSecret,
    [string]$tenantId,
    [string]$aiSearch,
    [string]$indexerName,
    [string]$json
)

$SecureStringPwd = $clientSecret | ConvertTo-SecureString -AsPlainText -Force

$pscredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $clientId, $SecureStringPwd
Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant $tenantId

$Token = "Bearer {0}" -f (az account get-access-token --scope https://search.azure.com/.default | ConvertFrom-Json | select -ExpandProperty accessToken)

$Uri = "${aiSearch}/indexers('${indexerName}')?api-version=2024-07-01"

$Headers = @{
    'Authorization' = $Token
    "Content-Type"  = 'application/json'
}

Invoke-RestMethod -Headers $Headers -Uri $Uri -Method PUT -Body $json