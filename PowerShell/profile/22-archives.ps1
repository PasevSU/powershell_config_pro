# Работа с архиви през 7-Zip CLI (zip, 7z, rar, tar, gzip и др.)
$script:__7Z = (Get-Command 7z -ErrorAction SilentlyContinue).Source
if (-not $script:__7Z -and (Test-Path 'C:\Program Files\7-Zip\7z.exe')) { $script:__7Z = 'C:\Program Files\7-Zip\7z.exe' }

# Компресиране: zip7 <папка-или-файл> [-Zip]
function zip7 {
    param(
        [Parameter(Mandatory = $true)] [string] $Path,
        [switch] $Zip
    )
    if (-not $script:__7Z) { throw '7-Zip не е намерен: winget install 7zip.7zip' }
    $src = (Resolve-Path $Path).Path
    $fmt = if ($Zip) { 'zip' } else { '7z' }
    $out = "$src.$fmt"
    $t = "-t$fmt"; & $script:__7Z a $t $out $src | Where-Object { $_ -match 'Everything is Ok|ERROR' }
    if ($LASTEXITCODE -eq 0) { Write-Host "Създаден: $out" -ForegroundColor Green }
}

# Извличане: unzip7 <архив> [целева-папка]
function unzip7 {
    param(
        [Parameter(Mandatory = $true)] [string] $Path,
        [string] $Destination
    )
    if (-not $script:__7Z) { throw '7-Zip не е намерен: winget install 7zip.7zip' }
    $arch = (Resolve-Path $Path).Path
    if (-not $Destination) { $Destination = Join-Path (Split-Path $arch -Parent) ([IO.Path]::GetFileNameWithoutExtension($arch)) }
    & $script:__7Z x $arch "-o$Destination" -y | Where-Object { $_ -match 'Everything is Ok|ERROR' }
    if ($LASTEXITCODE -eq 0) { Write-Host "Извлечено в: $Destination" -ForegroundColor Green }
}

# Съдържание на архив без извличане: lz7 <архив>
function lz7 {
    param([Parameter(Mandatory = $true)] [string] $Path)
    if (-not $script:__7Z) { throw '7-Zip не е намерен: winget install 7zip.7zip' }
    & $script:__7Z l (Resolve-Path $Path).Path
}

