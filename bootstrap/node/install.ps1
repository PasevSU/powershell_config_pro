$ErrorActionPreference = 'Stop'
Write-Host '--- Node.js + npm глобални пакети ---' -ForegroundColor Cyan
winget install --id OpenJS.NodeJS.LTS -e --silent --accept-source-agreements --accept-package-agreements
Get-Content "$PSScriptRoot\npm-globals.txt" | Where-Object { $_ -and $_ -notmatch '^#' } | ForEach-Object {
  Write-Host "npm install -g $_"
  npm install -g $_
}
