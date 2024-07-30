param (
    [string]$clientId,
    [string]$clientSecret,
    [string]$tenantId,
    [string]$subscriptionId,
    [string]$resourceGroupName,
    [string]$openAiAccount,
    [string]$deploymentName,
    [string]$json
)

$SecureStringPwd = $clientSecret | ConvertTo-SecureString -AsPlainText -Force

$pscredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $clientId, $SecureStringPwd
Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant $tenantId

$Token = "Bearer {0}" -f (az account get-access-token | ConvertFrom-Json | select -ExpandProperty accessToken)

[string]$subscriptionId,
[string]$resourceGroup
$Uri = "https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/${openAiAccount}/deployments/${deploymentName}?api-version=2023-05-01"

$Headers = @{
    'Authorization' = $Token
    "Content-Type"  = 'application/json'
}

Invoke-RestMethod -Headers $Headers -Uri $Uri -Method PUT -Body $json