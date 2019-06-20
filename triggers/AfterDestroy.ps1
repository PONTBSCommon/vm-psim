& "$PSScriptRoot\..\scripts\Globals.ps1"

Write-Host -ForegroundColor Yellow 'Removing psim-manage module.'
if (Test-Path $PsimManagePath) {
  Remove-Item -Force -Recurse $PsimManagePath
} else {
  Write-Host -ForegroundColor Red 'Skipping removal of psim-manage. Could not find folder.'; return
}
