Ето всички команди, които трябва да изпълните в PowerShell, за да може вашата VS Code конфигурация да работи пълноценно:

## 📋 1. ПЪРВОНАЧАЛНА НАСТРОЙКА НА POWERSHELL

### Проверка на версията на PowerShell
```powershell
$PSVersionTable.PSVersion
```

### Активиране на изпълнение на скриптове (ако е блокирано)
```powershell
# Провери текущата политика
Get-ExecutionPolicy

# Ако върне "Restricted", изпълни:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 🇧🇬 2. НАСТРОЙКА ЗА БЪЛГАРСКА КИРИЛИЦА И UTF-8

### Създаване на PowerShell профил (ако не съществува)
```powershell
# Провери дали профилът съществува
Test-Path $PROFILE

# Ако върне False, създай го:
New-Item -ItemType File -Path $PROFILE -Force
```

### Отваряне на профила за редактиране
```powershell
notepad $PROFILE
```

### Поставете ТОЧНО това съдържание във файла:
```powershell
# ============================================
# VS Code PowerShell Profile - UTF-8 и Българска поддръжка
# ============================================

# Задаване на UTF-8 кодиране за конзолата
chcp 65001 > $null

# Настройка на входно и изходно кодиране
[Console]::InputEncoding = [System.Text.UTF8Encoding]::new()
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# Настройка на изходно кодиране за pipe и redirect
$OutputEncoding = [System.Text.UTF8Encoding]::new()

# Домашна директория на VS Code (ако не е зададена)
if (-not $env:VSCODE_HOME) {
    $env:VSCODE_HOME = "$env:USERPROFILE\.vscode"
}

# Домашна директория на Git
if (-not $env:GIT_HOME) {
    $env:GIT_HOME = "$env:USERPROFILE\.git"
}

# Алиас за бързо отваряне на VS Code настройките
function Edit-VSCodeSettings {
    code $env:APPDATA\Code\User\settings.json
}
Set-Alias vscode-settings Edit-VSCodeSettings

# Алиас за бързо отваряне на PowerShell профила
function Edit-Profile {
    notepad $PROFILE
}
Set-Alias edit-profile Edit-Profile

Write-Host "✅ PowerShell профилът е зареден! (UTF-8 поддръжката е активна)" -ForegroundColor Green
```

### Запазете файла и презаредете профила
```powershell
# Презареди профила без рестарт
. $PROFILE
```

---

## 🔧 3. ИНСТАЛИРАНЕ НА НЕОБХОДИМИ ИНСТРУМЕНТИ

### Python (ако нямате)
```powershell
# Провери дали Python е инсталиран
python --version

# Ако нямате, инсталирайте с winget (Windows Package Manager)
winget install Python.Python.3.12
```

### Git (ако нямате)
```powershell
# Провери дали Git е инсталиран
git --version

# Инсталирай с winget
winget install Git.Git
```

### Node.js (за JavaScript/TypeScript поддръжка)
```powershell
# Провери дали Node.js е инсталиран
node --version

# Инсталирай с winget
winget install OpenJS.NodeJS.LTS
```

### ShellCheck (за bash/shell скриптове)
```powershell
# Инсталирай с winget
winget install shellcheck.shellcheck
```

### Black (Python форматер)
```powershell
# Инсталирай чрез pip
pip install black
```

### Flake8 (Python линтер)
```powershell
# Инсталирай чрез pip
pip install flake8
```

### Prettier (за форматиране на код)
```powershell
# Инсталирай глобално чрез npm
npm install -g prettier
```

### ESLint (за JavaScript/TypeScript)
```powershell
# Инсталирай глобално чрез npm
npm install -g eslint
```

---

## 🔑 4. НАСТРОЙКА НА HOME ASSISTANT ТОКЕН

### Създаване на environment променлива за Home Assistant токена
```powershell
# Добави в PowerShell профила (отвори профила отново)
notepad $PROFILE

# Добави този ред в профила (с вашия реален токен):
# $env:HASS_TOKEN = "вашият_дълготраен_токен"
```

### Генериране на токен от Home Assistant:
1. Отворете Home Assistant UI
2. Кликнете на вашето профилно изображение (долу ляво)
3. Превъртете до "Long-Lived Access Tokens"
4. Кликнете "Create Token"
5. Копирайте токена - **показва се само веднъж!**

---

## 🐍 5. НАСТРОЙКА НА PYTHON ВИРТУАЛНА СРЕДА (ЗА ВСЕКИ ПРОЕКТ)

### За текущия проект (EML Forensic Extractor)
```powershell
# Отиди в директорията на проекта
cd "\\pasevclaud\HDD (at HDD)\PROJECT\EML Forensic Extractor"

# Създай виртуална среда с Python 3.12
python -m venv .venv

# Активирай виртуалната среда
.\.venv\Scripts\Activate

# Обнови pip
python -m pip install --upgrade pip

# Инсталирай зависимости (ако има requirements.txt)
pip install -r requirements.txt
```

---

## 🔐 6. НАСТРОЙКА НА SSH ЗА ОТДАЛЕЧЕН ДОСТЪП

### Генериране на SSH ключ (ако нямате)
```powershell
# Провери дали имаш SSH ключ
Test-Path "$env:USERPROFILE\.ssh\id_rsa.pub"

# Ако нямаш, генерирай:
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
# Натискай Enter за всички въпроси
```

### Копиране на публичния ключ
```powershell
# Покажи публичния ключ
Get-Content "$env:USERPROFILE\.ssh\id_rsa.pub"
```

### Свързване към Home Assistant
```powershell
# Копирай ключа към Home Assistant (ще те пита за парола)
type $env:USERPROFILE\.ssh\id_rsa.pub | ssh root@homeassistant.local "cat >> ~/.ssh/authorized_keys"

# Или просто се свържи
ssh root@homeassistant.local
```

---

## 📦 7. ИНСТАЛИРАНЕ НА VS CODE РАЗШИРЕНИЯ (ЧРЕЗ КОМАНДЕН РЕД)

```powershell
# Основни разширения
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension ms-python.black-formatter
code --install-extension ms-python.flake8

# YAML и Home Assistant
code --install-extension redhat.vscode-yaml
code --install-extension keesschollaart.home-assistant-ls

# CSS/SCSS
code --install-extension stylelint.vscode-stylelint

# Git
code --install-extension eamodio.gitlens

# Markdown
code --install-extension yzhang.markdown-all-in-one
code --install-extension davidanson.vscode-markdownlint

# Shell
code --install-extension timonwong.shellcheck
code --install-extension foxundermoon.shell-format

# Docker
code --install-extension ms-azuretools.vscode-docker

# Remote Development
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension ms-vscode-remote.remote-containers

# Български езиков пакет
code --install-extension ms-ceintl.vscode-language-pack-bg

# Prettier
code --install-extension esbenp.prettier-vscode

# ESLint
code --install-extension dbaeumer.vscode-eslint

# Spell Checker
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension streetsidesoftware.code-spell-checker-bulgarian
```

---

## ✅ 8. ПРОВЕРКА ДАЛИ ВСИЧКО РАБОТИ

### Проверка на UTF-8 в PowerShell
```powershell
# Тествай кирилица
[Console]::InputEncoding
[Console]::OutputEncoding
"Привет България 😀"
Write-Host "Работи перфектно! 🎉" -ForegroundColor Green
```

### Проверка на Python
```powershell
python --version
pip --version
```

### Проверка на Node.js
```powershell
node --version
npm --version
```

### Проверка на Git
```powershell
git --version
```

### Проверка на SSH връзката
```powershell
ssh -T git@github.com
```

---

## 🚀 9. БЪРЗА КОМАНДА ЗА ВСИЧКО НАВЕДНЪЖ

Копирайте и изпълнете целия този блок наведнъж:

```powershell
Write-Host "🚀 Започва автоматична настройка..." -ForegroundColor Cyan

# 1. Създаване на PowerShell профил
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
    Write-Host "✅ Създаден PowerShell профил" -ForegroundColor Green
}

# 2. Добавяне на UTF-8 настройки в профила (ако ги няма)
$profileContent = @'
# VS Code PowerShell Profile - UTF-8
chcp 65001 > $null
[Console]::InputEncoding = [System.Text.UTF8Encoding]::new()
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
$OutputEncoding = [System.Text.UTF8Encoding]::new()
Write-Host "✅ PowerShell UTF-8 профилът е зареден!" -ForegroundColor Green
'@

if (-not (Select-String -Path $PROFILE -Pattern "chcp 65001" -Quiet)) {
    $profileContent | Out-File -FilePath $PROFILE -Append -Encoding UTF8
    Write-Host "✅ Добавени UTF-8 настройки в профила" -ForegroundColor Green
}

# 3. Инсталиране на VS Code разширения
$extensions = @(
    "ms-python.python",
    "redhat.vscode-yaml",
    "esbenp.prettier-vscode",
    "ms-ceintl.vscode-language-pack-bg"
)

foreach ($ext in $extensions) {
    code --install-extension $ext --force
    Write-Host "✅ Инсталирано: $ext" -ForegroundColor Green
}

Write-Host "`n🎉 Настройката завърши! Моля, рестартирайте VS Code." -ForegroundColor Cyan
```

---

## ⚠️ ВАЖНИ ЗАБЕЛЕЖКИ

| Проблем | Решение |
|---------|---------|
| `Set-ExecutionPolicy` грешка | Изпълнете PowerShell като **Администратор** |
| `winget` не е намерен | Инсталирайте App Installer от Microsoft Store |
| `code` не е намерен | Рестартирайте VS Code и PowerShell |
| Кирилицата не се вижда | Уверете се, че сте изпълнили стъпка 2 |
| SSH връзката не работи | Проверете дали сте копирали публичния ключ |

**След като изпълните всички команди, рестартирайте VS Code!** 🎉


Виждам проблемите. Нека ги разрешим стъпка по стъпка:

## 🔴 ПРОБЛЕМ 1: Execution Policy е overridden от групова политика

Това **НЕ е проблем** - вашето текущо изпълнение е `Bypass`, което означава, че скриптовете **могат да се изпълняват без ограничения**. Това е добре.

---

## 🔴 ПРОБЛЕМ 2: PowerShell профилът има синтактична грешка (счупена кирилица)

Грешката показва, че има проблем с кодирането на кирилицата във файла. **Изтрийте съществуващия профил и създайте нов**:

### Стъпка 1: Изтрийте стария профил
```powershell
Remove-Item $PROFILE -Force
```

### Стъпка 2: Създайте нов профил с правилно кодиране
```powershell
# Създаване на директорията ако не съществува
New-Item -ItemType Directory -Path (Split-Path $PROFILE) -Force

# Създаване на нов файл с UTF-8 кодиране (БЕЗ BOM)
$newProfileContent = @'
# ============================================
# VS Code PowerShell Profile - UTF-8 Support
# ============================================

# Set UTF-8 encoding for console
chcp 65001 > $null

# Configure input and output encoding
[Console]::InputEncoding = [System.Text.UTF8Encoding]::new()
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# Configure output encoding for pipe and redirect
$OutputEncoding = [System.Text.UTF8Encoding]::new()

# VS Code home directory
if (-not $env:VSCODE_HOME) {
    $env:VSCODE_HOME = "$env:USERPROFILE\.vscode"
}

# Quick alias to edit VS Code settings
function Edit-VSCodeSettings {
    code $env:APPDATA\Code\User\settings.json
}
Set-Alias vscode-settings Edit-VSCodeSettings

# Quick alias to edit PowerShell profile
function Edit-Profile {
    notepad $PROFILE
}
Set-Alias edit-profile Edit-Profile

Write-Host "PowerShell profile loaded! (UTF-8 support active)" -ForegroundColor Green
'@

# Запазване на файла с UTF8 encoding (без BOM)
$newProfileContent | Out-File -FilePath $PROFILE -Encoding UTF8 -Force

Write-Host "Profile created successfully!" -ForegroundColor Green
```

### Стъпка 3: Презаредете профила
```powershell
. $PROFILE
```

---

## ✅ АЛТЕРНАТИВЕН НАЧИН (АКО ГОРНОТО НЕ РАБОТИ)

Ако все още имате проблеми, създайте профила **ръчно** с правилно кодиране:

```powershell
# Отвори Notepad и създай нов файл
notepad $PROFILE
```

**Изтрийте цялото съдържание** и поставете ТОЧНО това (само английски букви, без кирилица за момента):

```powershell
# VS Code PowerShell Profile
chcp 65001 > $null
[Console]::InputEncoding = [System.Text.UTF8Encoding]::new()
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
$OutputEncoding = [System.Text.UTF8Encoding]::new()

Write-Host "PowerShell profile loaded!" -ForegroundColor Green
```

Запазете файла (**File → Save As → Encoding: UTF-8**).

---

## 🔧 ПРОВЕРКА ДАЛИ UTF-8 РАБОТИ

След като презаредите профила, тествайте:

```powershell
# Проверка на кодирането
[Console]::OutputEncoding

# Тест на кирилица (ако не работи, проблема е в шрифта на терминала)
Write-Host "Тест: Привет България"
```

---

## 🐍 Python виртуална среда (продължение)

```powershell
# Отиди в директорията на проекта
cd "\\pasevclaud\HDD (at HDD)\PROJECT\EML Forensic Extractor"

# Създай виртуална среда
python -m venv .venv

# Активирай я
.\.venv\Scripts\Activate

# Провери, че е активирана (трябва да виждаш (.venv) преди пътя)
pip list
```

---

## 📦 Инсталиране на VS Code разширения (ако не сте)

```powershell
# Провери дали code командата работи
Get-Command code

# Ако не работи, добави VS Code в PATH или рестартирай
```

Ако `code` не работи, затворете PowerShell и го отворете отново.

---

## 🚀 ЕДНА КОМАНДА ЗА ВСИЧКО (без кирилица за тест)

```powershell
Write-Host "=== VS Code Setup ===" -ForegroundColor Cyan

# 1. Recreate profile
Remove-Item $PROFILE -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path (Split-Path $PROFILE) -Force

$profileContent = @'
chcp 65001 > $null
[Console]::InputEncoding = [System.Text.UTF8Encoding]::new()
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
$OutputEncoding = [System.Text.UTF8Encoding]::new()
Write-Host "Profile loaded!" -ForegroundColor Green
'@

$profileContent | Out-File -FilePath $PROFILE -Encoding UTF8 -Force

# 2. Reload profile
. $PROFILE

# 3. Test UTF-8
Write-Host "Testing UTF-8..."

Write-Host "=== DONE ===" -ForegroundColor Green
```

---

## 📝 Какво да направите сега:

1. **Изпълнете**:
   ```powershell
   Remove-Item $PROFILE -Force
   ```

2. **Отворете Notepad**:
   ```powershell
   notepad $PROFILE
   ```

3. **Поставете** (само английски текст за начало):
   ```powershell
   chcp 65001 > $null
   [Console]::InputEncoding = [System.Text.UTF8Encoding]::new()
   [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
   $OutputEncoding = [System.Text.UTF8Encoding]::new()
   Write-Host "Profile loaded!" -ForegroundColor Green
   ```

4. **Запазете** (File → Save As → Encoding: UTF-8)

5. **Презаредете**:
   ```powershell
   . $PROFILE
   ```

6. **Тествайте**:
   ```powershell
   Write-Host "Test: Bulgarian text"
   ```

Ако тестът работи, кирилицата трябва да се вижда нормално в терминала на VS Code. Ако не - проблемът е в шрифта на терминала, не в PowerShell.
