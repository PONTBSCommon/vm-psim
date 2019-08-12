#### INSIDE VM LOCATIONS ####
$FirstRunRemoteSetupScript = 'C:\vagrant\scripts\FirstRunRemoteSetup.ps1'
$SetupMarker = 'C:\Program Files\PrinterOn Corporation\initial-vagrant-setup-marker.txt'
$MobileCertificateSaveLocation = 'C:\Users\vagrant\Downloads\atca.cer'

#### PSIM INSTALLER CONSTANTS ####
# \\ is used because of the legacy installer.
$InstallationLogfile = 'C:\\Program Files (x86)\\PrinterOn Corporation\\PrinterOn Server Install Manager\\Installation History.txt' 
$PsimInstaller = 'C:\\vagrant\\installer\\psim.exe'
$LicenseFile = 'C:\\vagrant\\installer\\license.txt'
$FullInstallIndicator = 'C:\\vagrant\\installer\\full_install.txt'

#### STANDARD VM-PSIM PATHS ####
$PsimManagePath = "$PSScriptRoot\..\psim-manage"
$VagrantVirtualboxProviderFolder = '.\.vagrant\machines\default\virtualbox\'
$VagrantMachineRootFolder = "$PSScriptRoot\.."
$PSModulesPath = ($env:PSModulePath -split ';' | ? { $_ -like '*Documents\WindowsPowerShell\Modules' })

#### EXTERNAL RESOURCES ####
$ATCACertWebLocation = 'http://webdepot.printeron.local/atca.cer'