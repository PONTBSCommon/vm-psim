. 'C:\vagrant\scripts\Globals.ps1'

if (Test-Path $SetupMarker) {
  Write-Host -ForegroundColor Green 'Skipping First Run setup. setup marker is present.'; return
}

Write-Host -ForegroundColor Yellow 'Add file that indicated this initial setup has been done before.'
New-Item -Force $SetupMarker; echo 'DO NOT REMOVE' > $SetupMarker

Write-Host -ForegroundColor Yellow "Installing zip tools."
choco install zip unzip

Write-Host -ForegroundColor Yellow "Copying In psim-manage module."
Copy-Item -Recurse -Force /vagrant/psim-manage $env:USERPROFILE\Documents\WindowsPowerShell\Modules\psim-manage