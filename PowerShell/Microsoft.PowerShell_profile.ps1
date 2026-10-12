# ============================================================================
#  PowerShell профил — Microsoft.PowerShell_profile.ps1
# ============================================================================
#  Този файл е САМО loader. Истинското съдържание е разпределено в папката
#  "profile\" (в същата директория) и се зарежда автоматично при всеки старт.
#
#  В момента се зареждат (по азбучен ред):
#    profile\10-base.ps1           — Chris Titus Tech профил: функции (ll, touch,
#                                    mkcd, git шорткъти, winutil...), PSReadLine
#                                    цветове и клавиши, Terminal-Icons, coreutils
#                                    шим, oh-my-posh и zoxide инициализация
#    profile\15-psreadline-extra.ps1 — допълнителна PSReadLine настройка:
#                                    прогнозиране, история без дубликати, 32k реда
#    profile\20-checksums.ps1      — New-Sha256Files / Test-Sha256Files
#                                    (генерира и проверява .sha256/.sha1/.md5)
#    profile\90-custom.ps1         — ВАШИ собствени функции и скриптове
#
#  Добавяне на нов скрипт: просто пуснете .ps1 файл в profile\ — ще се зареди
#  автоматично. Редът на зареждане = азбучният ред на имената.
#
#  Диагностика: ако даден файл хвърли грешка, тук ще се покаже предупреждение
#  с името му, без да спира останалите.
# ============================================================================

$profileFolder = Join-Path (Split-Path $PROFILE -Parent) 'profile'
if (Test-Path $profileFolder) {
    Get-ChildItem $profileFolder -Filter '*.ps1' -File | Sort-Object Name | ForEach-Object {
        $file = $_.FullName
        try {
            . $file
        } catch {
            Write-Warning "profile\$(Split-Path $file -Leaf): $($_.Exception.Message)"
        }
    }
}
