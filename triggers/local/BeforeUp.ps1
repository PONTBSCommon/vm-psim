if (@(Get-ChildItem .\.vagrant\machines\default\virtualbox\).Length -ne 0) {
  Write-Host -ForegroundColor Green 'Machine already provisioned. skipping init.'; return
}

Write-Host -ForegroundColor Yellow '[01] Cloning the psim-manage module.'
$StartLocation = (Get-Location)
Set-Location (Resolve-Path "$PSScriptRoot\..")
git clone git@github.azc.ext.hp.com:PON/psim-manage.git 
Set-Location $StartLocation

Write-Host -ForegroundColor Green 'Done.'