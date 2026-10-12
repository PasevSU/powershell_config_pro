# ============================================================
#  PasevSU VS Code Profile Installer
#  Създава ЧИСТ НОВ профил "PasevSU" във VS Code и инсталира всичко:
#  настройки, 46+ разширения, PowerShell профил, тема, модули.
#
#  Извикване директно от GitHub (една команда):
#  powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/PasevSU/powershell_config_pro/main/setup-profile.ps1 | iex"
#
#  Опции: -IncludeTools  (инсталира и инструментите: winget/pip пакети)
# ============================================================
param([switch]$IncludeTools)
$ErrorActionPreference = 'Stop'
$raw = 'https://raw.githubusercontent.com/PasevSU/powershell_config_pro/main'
$tmp = Join-Path $env:TEMP 'pasevsu-setup'
Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $tmp -Force | Out-Null

Write-Host '==> Сваляне на конфигурацията от GitHub...' -ForegroundColor Cyan
$files = @(
  'vscode/settings.json', 'vscode/chatLanguageModels.json', 'vscode/mcp.json', 'vscode/extensions.txt',
  'PowerShell/Microsoft.PowerShell_profile.ps1', 'PowerShell/cobalt2.omp.json', 'PowerShell/modules.txt'
)
foreach ($file in $files) {
  $dest = Join-Path $tmp ($file -replace '/', '\')
  New-Item -ItemType Directory -Path (Split-Path $dest) -Force | Out-Null
  Invoke-WebRequest "$raw/$file" -OutFile $dest -UseBasicParsing
}
New-Item -ItemType Directory -Path "$tmp\PowerShell\profile" -Force | Out-Null
foreach ($p in @('05-utf8','10-base','12-editors','15-psreadline-extra','20-checksums','22-archives','23-hex','90-custom')) {
  Invoke-WebRequest "$raw/PowerShell/profile/$p.ps1" -OutFile "$tmp\PowerShell\profile\$p.ps1" -UseBasicParsing
}

Write-Host '==> Създаване на VS Code профил "PasevSU"...' -ForegroundColor Cyan
$storage = Join-Path $env:APPDATA 'Code\User\globalStorage\storage.json'
$st = Get-Content $storage -Raw | ConvertFrom-Json
$loc = ($st.userDataProfiles | Where-Object { $_.name -eq 'PasevSU' }).location
if (-not $loc) {
  cmd /c "code --profile PasevSU >nul 2>&1"
  Start-Sleep 4
  $st = Get-Content $storage -Raw | ConvertFrom-Json
  $loc = ($st.userDataProfiles | Where-Object { $_.name -eq 'PasevSU' }).location
}
if (-not $loc) { throw 'Профилът не беше регистриран от VS Code' }
$profileDir = Join-Path $env:APPDATA "Code\User\profiles\$loc"
Write-Host "Профилна папка: $profileDir"

Write-Host '==> Настройки в профила...' -ForegroundColor Cyan
Copy-Item "$tmp\vscode\settings.json" $profileDir -Force
Copy-Item "$tmp\vscode\chatLanguageModels.json" $profileDir -Force
Copy-Item "$tmp\vscode\mcp.json" $profileDir -Force

Write-Host '==> Инсталиране на разширенията в профила...' -ForegroundColor Cyan
$exts = @(Get-Content "$tmp\vscode\extensions.txt" | ForEach-Object { [string]$_ } | Where-Object { $_ -and $_ -notmatch '^#' })
$extJson = @($exts | ForEach-Object { @{ identifier = @{ id = [string]$_ } } })
$extJson | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $profileDir 'extensions.json') -Encoding utf8
$i = 0
foreach ($e in $exts) {
  $i++
  Write-Host "[$i/$($exts.Count)] $e"
  cmd /c "code --profile PasevSU --install-extension $e --force >nul 2>&1"
}

Write-Host '==> PowerShell профил + тема + модули...' -ForegroundColor Cyan
$docPs = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PowerShell'
New-Item -ItemType Directory -Path "$docPs\profile" -Force | Out-Null
Copy-Item "$tmp\PowerShell\Microsoft.PowerShell_profile.ps1" $docPs -Force
Copy-Item "$tmp\PowerShell\profile\*" "$docPs\profile\" -Force
Copy-Item "$tmp\PowerShell\cobalt2.omp.json" $HOME -Force
Get-Content "$tmp\PowerShell\modules.txt" | Where-Object { $_ } | ForEach-Object {
  $n, $v = $_ -split ':'
  if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    pwsh -NoProfile -Command "if (-not (Get-Module -ListAvailable -Name '$n')) { exit 1 }" | Out-Null
    $installed = ($LASTEXITCODE -eq 0)
  } else {
    $installed = [bool](Get-Module -ListAvailable -Name $n)
  }
  if (-not $installed) {
    Write-Host "Модул: $n ($v)"
    if (Get-Command pwsh -ErrorAction SilentlyContinue) {
      pwsh -NoProfile -Command "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted; Install-Module -Name '$n' -RequiredVersion '$v' -Scope CurrentUser -Force" | Out-Null
    } else {
      Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
      Install-Module -Name $n -RequiredVersion $v -Scope CurrentUser -Force
    }
  }
}

if ($IncludeTools) {
  Write-Host '==> Инструменти (winget + pip)...' -ForegroundColor Cyan
  foreach ($pkg in @('Microsoft.PowerShell','Git.Git','GitHub.cli','Ollama.Ollama','Microsoft.VisualStudioCode','Microsoft.WindowsTerminal','ajeetdsouza.zoxide','7zip.7zip','koalaman.shellcheck','JanDeDobbeleer.OhMyPosh')) {
    Write-Host "winget: $pkg"
    winget install --id $pkg -e --silent --accept-source-agreements --accept-package-agreements | Out-Null
  }
  if (Get-Command python -ErrorAction SilentlyContinue) {
    python -m pip install --upgrade pip 2>&1 | Out-Null
    Invoke-WebRequest "$raw/bootstrap/python/requirements.txt" -OutFile "$tmp\requirements.txt" -UseBasicParsing
    python -m pip install -r "$tmp\requirements.txt" 2>&1 | Out-Null
  }
}

Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
Write-Host ''
Write-Host 'ГОТОВО! Отворете профила с:' -ForegroundColor Green
Write-Host '  code --profile PasevSU' -ForegroundColor Yellow
