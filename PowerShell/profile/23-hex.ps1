# Хексадецимален преглед на бинарен файл от терминала (Format-Hex)
# За интерактивна редакция ползвайте разширението ms-vscode.hexeditor в VS Code.
function hex {
    param(
        [Parameter(Mandatory = $true)] [string] $Path,
        [int] $Count = 512
    )
    Format-Hex -Path (Resolve-Path $Path).Path -Count $Count
}
