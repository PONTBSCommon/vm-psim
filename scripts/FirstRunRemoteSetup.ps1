$SetupMarker = 'C:\Program Files\PrinterOn Corporation\initial-vagrant-setup-marker.txt'
if (Test-Path $SetupMarker) {
  Write-Host -ForegroundColor Green 'Skipping First Run setup. setup marker is present.'; return
}

Write-Host -ForegroundColor Yellow 'Save PonConf Initial Password To Desktop'
if (Test-Path /vagrant/ponconf-password.txt) {
  Copy-Item /vagrant/ponconf-password.txt /users/vagrant/desktop/ponconf-password.txt
} else {
  Write-Host -ForegroundColor Red 'Skipping Copy of PonConf password file, could not find.'
}

Write-Host -ForegroundColor Yellow 'Add Import For psim-manage module to powershell profile'
echo 'Import-Module /vagrant/scripts/psim-manage/psim-manage.psd1' > $PROFILE

Write-Host -ForegroundColor Yellow 'Add file that indicated this initial setup has been done before.'
echo 'DO NOT REMOVE' > $SetupMarker