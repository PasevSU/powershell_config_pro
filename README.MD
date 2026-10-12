# powershell_config_pro — PowerShell и VS Code конфигурации

Съхранени конфигурации на реалната среда (Pasev, 12.10.2026).

## Структура

```
PowerShell\
├── Microsoft.PowerShell_profile.ps1   главен loader — зарежда profile\*.ps1
├── profile\
│   ├── 10-base.ps1                    Chris Titus Tech профил (функции, PSReadLine, oh-my-posh, zoxide, coreutils)
│   ├── 15-psreadline-extra.ps1        прогнозиране, история 32k, без дубликати
│   ├── 20-checksums.ps1               New-Sha256Files / Test-Sha256Files (.sha256/.sha1/.md5)
│   └── 90-custom.ps1                  място за собствени функции
├── cobalt2.omp.json                   oh-my-posh тема
└── modules.txt                        PowerShell модули (Devolutions.PowerShell, Terminal-Icons)

vscode\
├── settings.json                      потребителски настройки (редактор, терминал, асоциации)
├── chatLanguageModels.json            избрани AI модели
├── mcp.json                           MCP конфигурация
├── agent-sessions.code-workspace      работни сесии на агента
├── extensions.txt                     списък на разширенията (за code --install-extension)
└── workspace-hapi.settings.json       цветова тема на hAPI workspace
```

## Възстановяване

```powershell
# PowerShell: копирайте в Documents\PowerShell
Copy-Item PowerShell\* "$([Environment]::GetFolderPath('MyDocuments'))\PowerShell" -Recurse -Force
Copy-Item PowerShell\cobalt2.omp.json $HOME

# VS Code: копирайте в %APPDATA%\Code\User
Copy-Item vscode\settings.json, vscode\chatLanguageModels.json, vscode\mcp.json, vscode\agent-sessions.code-workspace "$env:APPDATA\Code\User"

# Разширения
Get-Content vscode\extensions.txt | ForEach-Object { code --install-extension $_ --force }
```

## bootstrap/
Пълен пакет за преинсталация на цялата среда (езици, инструменти, VS Code, PowerShell): стартирайте setup.ps1 от папката.

## Създаване на VS Code профил PasevSU (една команда)

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/PasevSU/powershell_config_pro/main/setup-profile.ps1 | iex"
```

Създава ЧИСТ НОВ профил "PasevSU" във VS Code: настройки, всички разширения, PowerShell профил, тема, модули. Опция -IncludeTools инсталира и инструментите.
