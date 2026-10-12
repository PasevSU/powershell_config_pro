$ErrorActionPreference = 'Stop'
Write-Host '--- VS Code + разширения + конфигурация ---' -ForegroundColor Cyan
winget install --id Microsoft.VisualStudioCode -e --silent --accept-source-agreements --accept-package-agreements
Get-Content "$PSScriptRoot\extensions.txt" | Where-Object { $_ -and $_ -notmatch '^#' } | ForEach-Object {
  Write-Host "code --install-extension $_"
  code --install-extension $_ --force
}
# Възстановяване на потребителската конфигурация
$userDir = Join-Path $env:APPDATA 'Code\User'
New-Item -ItemType Directory -Path $userDir -Force | Out-Null
foreach ($f in @('settings.json','chatLanguageModels.json','mcp.json','agent-sessions.code-workspace')) {
  if (Test-Path "$PSScriptRoot\$f") {
    Copy-Item "$PSScriptRoot\$f" (Join-Path $userDir $f) -Force
    Write-Host "възстановен: $f"
  }
}
Write-Host 'VS Code готов (workspace цветовете са в workspace-hapi.settings.json — копирайте ръчно в .vscode\ на проекта).'
