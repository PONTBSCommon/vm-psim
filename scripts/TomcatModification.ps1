. 'C:\vagrant\scripts\Globals.ps1'

if (!(Test-Path $ServerCertFolder -PathType Container)) {
  New-Item -Path $ServerCertFolder -ItemType Directory
}
# Get hostname from vagrant machine
$hostname = hostname
# Create a server certificate name based on hostname
$certName = $hostname.ToLower() + '.printeron.local.p12'

# Update server.xml file to use self-signed certificate
$xmlContent = [xml] (Get-Content $TomcatServerFile)
$sslSection = $xmlContent.SelectSingleNode("//Connector[@port='443']")
$sslSection.setattribute("keystoreType", "PKCS12")
$sslSection.setattribute("keystoreFile", "$ServerCertFolder\$certName")
$sslSection.setattribute("keystorePass", "221printeron")
$xmlContent.Save($TomcatServerFile)