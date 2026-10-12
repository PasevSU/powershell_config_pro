# Главен инсталатор: всички езици и инструменти след преинсталация на Windows
# Стартирайте от PowerShell 5.1+ (администратор не е задължителен за winget).
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$winargs = '--silent --accept-source-agreements --accept-package-agreements'

Write-Host '=== Базови инструменти (winget) ===' -ForegroundColor Cyan
foreach ($pkg in @('Microsoft.PowerShell','Git.Git','GitHub.cli','Ollama.Ollama','Microsoft.VisualStudioCode','Microsoft.WindowsTerminal','ajeetdsouza.zoxide','7zip.7zip')) {
  Write-Host "winget install $pkg"
  winget install --id $pkg -e $winargs
}

Write-Host '=== Езици и зависимости ===' -ForegroundColor Cyan
& "$root\node\install.ps1"
& "$root\python\install.ps1"
& "$root\dotnet\install.ps1"
& "$root\java\install.ps1"
& "$root\powershell\install.ps1"
& "$root\choco\install.ps1"
& "$root\vscode\install.ps1"

Write-Host '=== ГОТОВО ===' -ForegroundColor Green


