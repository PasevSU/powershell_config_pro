# Генерира и проверява sha256sum-съвместими контролни файлове (.sha256 / .sha1 / .md5)
# Формат на всеки ред: <hash> *<име-на-файл>   (като GNU sha256sum, binary mode)

function New-Sha256Files {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [string[]] $Path,
        [switch] $Recurse,
        [switch] $Combined,
        [ValidateSet('SHA256', 'SHA1', 'MD5', 'SHA384', 'SHA512')] [string] $Algorithm = 'SHA256'
    )
    begin {
        $ext = @{ SHA256 = 'sha256'; SHA1 = 'sha1'; MD5 = 'md5'; SHA384 = 'sha384'; SHA512 = 'sha512' }[$Algorithm]
        $files = [System.Collections.Generic.List[string]]::new()
        $suffixName = ($Algorithm -eq 'SHA256') ? 'SHA256SUMS' : ($Algorithm + 'SUMS')
    }
    process {
        foreach ($p in $Path) {
            if (Test-Path $p -PathType Leaf) { $files.Add((Resolve-Path $p).Path) }
            elseif (Test-Path $p -PathType Container) {
                $get = if ($Recurse) { Get-ChildItem $p -File -Recurse } else { Get-ChildItem $p -File }
                foreach ($f in $get) { $files.Add($f.FullName) }
            } else { Write-Warning "Не е намерено: $p" }
        }
    }
    end {
        $files = $files | Sort-Object -Unique
        if (-not $files) { Write-Warning 'Няма файлове за обработка.'; return }
        $created = 0
        foreach ($f in $files) {
            $hash = (Get-FileHash -Algorithm $Algorithm -LiteralPath $f).Hash.ToLower()
            $line = "$hash *$(Split-Path $f -Leaf)"
            if ($Combined) {
                $dir = Split-Path $f -Parent
                Add-Content -LiteralPath (Join-Path $dir $suffixName) -Value $line -Encoding ascii
            } else {
                Set-Content -LiteralPath "$f.$ext" -Value $line -Encoding ascii
            }
            Write-Host "$line"
            $created++
        }
        Write-Host "Готово: $created файла | алгоритъм: $Algorithm | изход: $(if ($Combined) { "$suffixName във всяка папка" } else { "<файл>.$ext до всеки файл" })" -ForegroundColor Green
    }
}

function Test-Sha256Files {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [string[]] $Path,
        [switch] $Recurse
    )
    begin { $list = [System.Collections.Generic.List[string]]::new() }
    process {
        foreach ($p in $Path) {
            if (Test-Path $p -PathType Container) {
                $get = if ($Recurse) { Get-ChildItem $p -Recurse -File } else { Get-ChildItem $p -File }
                foreach ($f in $get) { if ($f.Extension -in '.sha256', '.sha1', '.md5', '.sha384', '.sha512') { $list.Add($f.FullName) } }
            } elseif (Test-Path $p -PathType Leaf) { $list.Add((Resolve-Path $p).Path) }
            else { Write-Warning "Не е намерено: $p" }
        }
    }
    end {
        $ok = 0; $bad = 0
        foreach ($sumFile in $list) {
            $dir = Split-Path $sumFile -Parent
            foreach ($line in Get-Content $sumFile) {
                if ($line -notmatch '^([0-9a-fA-F]+)\s+\*?(.+)$') { continue }
                $expected = $Matches[1].ToLower(); $name = $Matches[2]
                $target = Join-Path $dir $name
                $alg = @{ sha256 = 'SHA256'; sha1 = 'SHA1'; md5 = 'MD5'; sha384 = 'SHA384'; sha512 = 'SHA512' }[$sumFile.Split('.')[-1]]
                if (-not (Test-Path $target -PathType Leaf)) { Write-Host "НЯМА ФАЙЛ: $name" -ForegroundColor Yellow; $bad++; continue }
                $actual = (Get-FileHash -Algorithm $alg -LiteralPath $target).Hash.ToLower()
                if ($actual -eq $expected) { Write-Host "OK  $name" -ForegroundColor Green; $ok++ }
                else { Write-Host "FAIL $name (очакван: $expected, реален: $actual)" -ForegroundColor Red; $bad++ }
            }
        }
        Write-Host "Проверени: $($ok + $bad) | OK: $ok | FAIL: $bad" -ForegroundColor $(if ($bad) { 'Red' } else { 'Green' })
    }
}


