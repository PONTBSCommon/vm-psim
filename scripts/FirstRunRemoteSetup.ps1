. 'C:\vagrant\scripts\Globals.ps1'

if (Test-Path $SetupMarker) {
  echo 'Skipping First Run setup. setup marker is present.'; return
}

echo 'Add file that indicated this initial setup has been done before.'
New-Item -Force $SetupMarker; echo 'DO NOT REMOVE' > $SetupMarker

echo "Installing zip tools."
choco install zip unzip

echo "Installing baretail log viewer."
choco install baretail