$ErrorActionPreference = 'Stop'
Write-Host '--- PowerShell 7 + модули + профил ---' -ForegroundColor Cyan
winget install --id Microsoft.PowerShell -e --silent --accept-source-agreements --accept-package-agreements
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Get-Content "$PSScriptRoot\modules.txt" | Where-Object { $_ -and $_ -notmatch '^#' } | ForEach-Object {
  $name, $ver = $_ -split ':'
  Write-Host "Install-Module $name ($ver)"
  Install-Module -Name $name -RequiredVersion $ver -Scope CurrentUser -Force
}
# Възстановяване на профила (loader + profile\ скриптове)
$docPs = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PowerShell'
New-Item -ItemType Directory -Path $docPs -Force | Out-Null
Copy-Item "$PSScriptRoot\Documents-PowerShell\*" $docPs -Recurse -Force
Write-Host "профил възстановен в: $docPs"
# oh-my-posh тема
winget install --id JanDeDobbeleer.OhMyPosh -e --silent --accept-source-agreements --accept-package-agreements
Copy-Item "$PSScriptRoot\cobalt2.omp.json" $HOME -Force
Write-Host "тема cobalt2 възстановена в: $HOME"
