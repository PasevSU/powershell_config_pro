$ErrorActionPreference = 'Stop'
Write-Host '--- Chocolatey + пакети ---' -ForegroundColor Cyan
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
  Set-ExecutionPolicy Bypass -Scope Process -Force
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
Get-Content "$PSScriptRoot\packages.txt" | Where-Object { $_ -and $_ -notmatch '^#' } | ForEach-Object {
  Write-Host "choco install $_"
  choco install $_ -y
}
