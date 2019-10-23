. 'C:\vagrant\scripts\Globals.ps1'

# Modify CPS URL if license.txt is exist
if (Test-Path $LicenseFile -PathType Leaf) {
  (Get-Content -Path $LicenseFile -Raw) -replace '127.0.0.1', $CertName | Set-Content -Path $LicenseFile
}