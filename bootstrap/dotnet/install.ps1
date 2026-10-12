$ErrorActionPreference = 'Stop'
Write-Host '--- .NET SDK 6 + 10 ---' -ForegroundColor Cyan
winget install --id Microsoft.DotNet.SDK.6 -e --silent --accept-source-agreements --accept-package-agreements
winget install --id Microsoft.DotNet.SDK.10 -e --silent --accept-source-agreements --accept-package-agreements
