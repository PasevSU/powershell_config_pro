# Работа с архиви през 7-Zip CLI (7z, zip, rar*, tar, gzip, bzip2, xz, cab*, iso*, wim*)
# (* = само извличане/преглед, както позволява 7-Zip)
$script:__7Z = (Get-Command 7z -ErrorAction SilentlyContinue).Source
if (-not $script:__7Z -and (Test-Path 'C:\Program Files\7-Zip\7z.exe')) { $script:__7Z = 'C:\Program Files\7-Zip\7z.exe' }

# Компресиране: zip7 <път> [-Format 7z|zip|tar|gzip|bzip2|xz]  (по подразбиране 7z)
function zip7 {
    param(
        [Parameter(Mandatory = $true)] [string] $Path,
        [ValidateSet('7z', 'zip', 'tar', 'gzip', 'bzip2', 'xz')] [string] $Format = '7z'
    )
    if (-not $script:__7Z) { throw '7-Zip не е намерен: winget install 7zip.7zip' }
    $src = (Resolve-Path $Path).Path
    $extMap = @{ '7z' = '7z'; 'zip' = 'zip'; 'tar' = 'tar'; 'gzip' = 'tar.gz'; 'bzip2' = 'tar.bz2'; 'xz' = 'tar.xz' }
    $out = "$src.$($extMap[$Format])"
    $t = "-t$Format"
    & $script:__7Z a $t $out $src | Where-Object { $_ -match 'Everything is Ok|ERROR' }
    if ($LASTEXITCODE -eq 0) { Write-Host "Създаден: $out" -ForegroundColor Green }
}

# Извличане: unzip7 <архив> [целева-папка]  (7z/zip/rar/tar/gz/bz2/xz/cab/iso/wim…)
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
