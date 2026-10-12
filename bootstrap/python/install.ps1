$ErrorActionPreference = 'Stop'
Write-Host '--- Python 3.12 + pip пакети ---' -ForegroundColor Cyan
winget install --id Python.Python.3.12 -e --silent --accept-source-agreements --accept-package-agreements
python -m pip install --upgrade pip
python -m pip install -r "$PSScriptRoot\requirements.txt"
