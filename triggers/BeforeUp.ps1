& "$PSScriptRoot\..\scripts\Globals.ps1"

if (@(Get-ChildItem $VagrantVirtualboxProviderFolder).Length -ne 0) {
  Write-Host -ForegroundColor Green 'Machine already provisioned. skipping init.'; return
}

$StartLocation = (Get-Location); Set-Location $VagrantMachineRootFolder

if (Test-Path "$VagrantMachineRootFolder\psim-manage") {
  Write-Output "psim-manage module is already present. removing..."
  Remove-Item -recurse -Force "$VagrantMachineRootFolder\psim-manage"
}

Write-Output 'Cloning the psim-manage module.'
git clone git@github.azc.ext.hp.com:PON/psim-manage.git 

Write-Output 'Loading the psim-manage module into the host machine.'
Copy-Item -Recurse -Force "$VagrantMachineRootFolder\psim-manage" "$PSModulesPath\psim-manage"
Set-Location $StartLocation

Write-Host -ForegroundColor Green 'Done.'