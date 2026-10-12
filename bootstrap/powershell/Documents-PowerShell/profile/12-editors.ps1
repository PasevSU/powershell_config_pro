# Среда и бързи помощници
if (-not $env:VSCODE_HOME) { $env:VSCODE_HOME = "$env:USERPROFILE\.vscode" }
if (-not $env:GIT_HOME)    { $env:GIT_HOME    = "$env:USERPROFILE\.git" }

# Бързо отваряне на VS Code настройките
function Edit-VSCodeSettings { code $env:APPDATA\Code\User\settings.json }
Set-Alias -Name vscode-settings -Value Edit-VSCodeSettings

# Бързо отваряне на PowerShell папката (loader + profile\)
function Edit-Profile { code (Split-Path $PROFILE -Parent) }
Set-Alias -Name edit-profile -Value Edit-Profile

# Home Assistant токен (ако ви трябва като променлива):
# 1. HA UI -> Профил -> Long-Lived Access Tokens -> Create Token
# 2. Разкоментирайте и сложете токена:
# $env:HASS_TOKEN = "ВАШИЯТ_ТОКЕН_ТУК"
