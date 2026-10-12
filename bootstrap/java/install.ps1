$ErrorActionPreference = 'Stop'
Write-Host '--- Java (Temurin 22 JDK) ---' -ForegroundColor Cyan
winget install --id EclipseAdoptium.Temurin.22.JDK -e --silent --accept-source-agreements --accept-package-agreements
