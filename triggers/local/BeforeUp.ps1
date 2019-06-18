if (@(Get-ChildItem .\.vagrant\machines\default\virtualbox\).Length -ne 0) {
  Write-Host -ForegroundColor Green 'Machine already provisioned. skipping init.'; return
}

$StartLocation = (Get-Location)

Set-Location (Resolve-Path "$PSScriptRoot\..\..")
if (Test-Path psim-manage) {
  Write-Output "psim-manage module is already present. removing..."
  Remove-Item -recurse -Force psim-manage
}

Write-Output 'Cloning the psim-manage module.'
git clone git@github.azc.ext.hp.com:PON/psim-manage.git 
Set-Location $StartLocation

Write-Host -ForegroundColor Green 'Done.'