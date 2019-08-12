. 'C:\vagrant\scripts\Globals.ps1'

Write-Host -ForegroundColor Yellow 'Running first setup on the remote machine ... '

if (Test-Path $SetupMarker) {
  Write-Host -ForegroundColor Green 'Skipping First Run setup. setup marker is present.'; return
}

try {

  Write-Host -ForegroundColor Yellow "Copying In psim-manage module."
  Copy-Item -Recurse -Force /vagrant/scripts/psim-manage $env:USERPROFILE\Documents\WindowsPowerShell\Modules\psim-manage

  #### This code will be used for adding a mobile certificate. (Later) ####
  # Write-Host -ForegroundColor Yellow "Adding the mobile certificate."
  # Invoke-RestMethod -Method Get -Uri $ATCACertWebLocation -OutFile $MobileCertificateSaveLocation
  # Import-Certificate -CertStoreLocation Cert:\CurrentUser\CA -FilePath $MobileCertificateSaveLocation
  # Remove-Item $MobileCertificateSaveLocation

  Write-Host -ForegroundColor Yellow 'First time setup completed.'
  echo 'DO NOT REMOVE' > $SetupMarker
} catch {
  Write-Error 'The first time setup run failed.'
}