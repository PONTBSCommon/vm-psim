. 'C:\vagrant\scripts\Globals.ps1'

# Update server.xml file to use self-signed certificate
$xmlContent = [xml] (Get-Content $TomcatServerFile)
$sslSection = $xmlContent.SelectSingleNode("//Connector[@port='443']")
$sslSection.setattribute("keystoreType", "PKCS12")
$sslSection.setattribute("keystoreFile", "$ServerCertFolder\$CertName.p12")
$sslSection.setattribute("keystorePass", "221printeron")
$xmlContent.Save($TomcatServerFile)

# Restart Tomcat8 service
Restart-Service -PassThru -Force -Name "Tomcat8" 