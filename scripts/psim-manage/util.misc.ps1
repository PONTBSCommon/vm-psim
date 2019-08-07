function RecurseCopy ($From, $To, [Switch]$Silent) {
    $From = Resolve-Path $From

    if (!(Test-Path $To)) { New-Item -ItemType Directory $To -Force | Out-Null }
    $To = Resolve-Path $To

    Get-ChildItem $From -recurse | % {
        $FromPath = $_.FullName
        $ToPath = $FromPath -replace [regex]::Escape($From), "$To\"
        $ToFolder = $ToPath -replace [regex]::Escape($_.Name)
        if (!(Test-Path $ToFolder)) { New-Item -Force -ItemType Directory $ToFolder | Out-Null }
        Copy-Item $FromPath $ToPath
    }
}
function out ($message) {
    Write-Host -ForegroundColor Yellow $message
}
function get ($message) {
    Write-Host -ForegroundColor Yellow $message -NoNewline
    return Read-Host ":"
}
function ydef ($message) {
    Write-Host -ForegroundColor Yellow $message -NoNewline
    return (Read-Host '[Y/n]:') -ne 'n'
}

function ndef ($message) {
    Write-Host -ForegroundColor Yellow $message -NoNewline
    return (Read-Host "[N/y]:") -eq 'y'
}

function getFolder ($message) {
    Write-Host -ForegroundColor Yellow $message -NoNewline
    $dir = Read-Host ":"

    while (!(Test-Path $dir)) {
        Write-Host -ForegroundColor Red "This folder does not exist [$dir]"
        Write-Host -ForegroundColor Yellow $message -NoNewline
        $dir = Read-Host ":"
    }
    return (resolve-path $dir)
}
