#### INSIDE VM LOCATIONS ####
$SetupMarker = 'C:\Program Files\PrinterOn Corporation\initial-vagrant-setup-marker.txt'
$MobileCertificateSaveLocation = 'C:\Users\vagrant\Downloads\atca.cer'
$TomcatServerFile = 'C:\Program Files (x86)\PrinterOn Corporation\Apache Tomcat\Conf\server.xml'
$ServerCertFolder = 'C:\Certs'
# Get hostname from vagrant machine
$HOSTNAME = hostname
# Create a server certificate name based on hostname
$CertName = $HOSTNAME.ToLower() + '.printeron.local'

#### PSIM INSTALLER CONSTANTS ####
# \\ is used because of the legacy installer.
$InstallationLogfile = 'C:\\Program Files (x86)\\PrinterOn Corporation\\PrinterOn Server Install Manager\\Installation History.txt' 
$VagrantInstallerPath = 'C:\\vagrant\\installer'
$PsimInstaller = $VagrantInstallerPath + '\\psim.exe'
$LicenseFile = $VagrantInstallerPath + '\\license.txt'
$RootCertPath = 'C:\\vagrant\\certs'
$ATCACerFile = $RootCertPath + '\ATCA.cer'