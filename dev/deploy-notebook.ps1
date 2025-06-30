param (
    [string]$Environment,
    [string]$ConfigFilePath
)

function Get-ConfigValue {
    param ([string]$configFilePath)
    $json = Get-Content -Path $configFilePath -Raw | ConvertFrom-Json
    return $json
}

function Get-AccessToken {
    param (
        [string]$resource,
        [string]$clientId,
        [string]$clientSecret,
        [string]$tenantId
    )
    $body = @{
        resource      = $resource
        client_id     = $clientId
        client_secret = $clientSecret
        grant_type    = "client_credentials"
    }
    $response = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/oauth2/token" -Body $body
    return $response.access_token
}

function Get-Language {
    param ([string]$fileName)
    switch -Wildcard ($fileName) {
        "*.py"     { return "PYTHON" }
        "*.ipynb"  { return "PYTHON" }
        "*.sql"    { return "SQL" }
        "*.scala"  { return "SCALA" }
        "*.r"      { return "R" }
        default    { return $null }
    }
}

# Load config
$config = Get-ConfigValue -configFilePath $ConfigFilePath
$resourceId            = $config.resource_id
$workspaceUrl          = $config.workspace_url
$notebookPath          = $config.notebook_path
$databricksResourceId  = $config.databricks_resource_id

# Use environment variables for sensitive values
$clientId     = $env:AZURE_CLIENT_ID
$clientSecret = $env:AZURE_CLIENT_SECRET
$tenantId     = $env:AZURE_TENANT_ID

# Get tokens
$accessToken     = Get-AccessToken -resource $databricksResourceId -clientId $clientId -clientSecret $clientSecret -tenantId $tenantId
$managementToken = Get-AccessToken -resource "https://management.core.windows.net/" -clientId $clientId -clientSecret $clientSecret -tenantId $tenantId

# Upload notebooks
$notebookFiles = Get-ChildItem -Recurse -File -Include *.py, *.ipynb, *.sql, *.scala, *.r | Where-Object {
    $_.FullName -notmatch "\\.git\\" -and $_.FullName -notmatch "\\.github\\"
}

foreach ($file in $notebookFiles) {
    $relPath      = $file.FullName.Substring((Get-Location).Path.Length + 1).Replace("\", "/")
    $databricksPath = "$notebookPath/$relPath"
    $language     = Get-Language -fileName $file.Name

    if (-not $language) {
        Write-Output "Skipping unsupported file: $($file.FullName)"
        continue
    }

    $parentDir = [System.IO.Path]::GetDirectoryName($databricksPath).Replace("\", "/")

    try {
        Invoke-RestMethod -Method Post -Uri "https://$workspaceUrl/api/2.0/workspace/mkdirs" -Headers @{
            Authorization                             = "Bearer $accessToken"
            "X-Databricks-Azure-SP-Management-Token"  = $managementToken
            "X-Databricks-Azure-Workspace-Resource-Id" = $resourceId
            "Content-Type"                             = "application/json"
        } -Body (@{ path = $parentDir } | ConvertTo-Json -Depth 2)

        $base64Content = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($file.FullName))
        $body = @{
            path      = $databricksPath
            language  = $language
            content   = $base64Content
            format    = "SOURCE"
            overwrite = $true
        } | ConvertTo-Json -Depth 3

        Invoke-RestMethod -Method Post -Uri "https://$workspaceUrl/api/2.0/workspace/import" -Headers @{
            Authorization                             = "Bearer $accessToken"
            "X-Databricks-Azure-SP-Management-Token"  = $managementToken
            "X-Databricks-Azure-Workspace-Resource-Id" = $resourceId
            "Content-Type"                             = "application/json"
        } -Body $body

        Write-Output "Uploaded: $relPath"
    } catch {
        Write-Warning "Failed to upload: $relPath"
        Write-Warning $_
    }
}

Write-Output "Deployment completed for environment: $Environment"
