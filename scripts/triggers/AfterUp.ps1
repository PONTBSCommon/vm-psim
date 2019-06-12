
Write-Host -ForegroundColor Yellow 'Running PSIM Installer Now'
& ../PsimInstaller.ps1

Write-Host -ForegroundColor Green 'Your PSIM Installation is complete.'
vagrant powershell -e '/vagrant/scripts/FirstRunRemoteSetup.ps1'

Write-Host -ForegroundColor Yellow 'Your Initial Setup is complete. Your vagrant machine will be restarted.'
Start-Sleep -Seconds 3
vagrant reload