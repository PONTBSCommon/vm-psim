#### INSIDE VM LOCATIONS ####
$FirstRunRemoteSetupScript = 'C:\vagrant\scripts\FirstRunRemoteSetup.ps1'
$SetupMarker = 'C:\Program Files\PrinterOn Corporation\initial-vagrant-setup-marker.txt'


#### STANDARD PATHS ####
$PsimManagePath = "$PSScriptRoot\..\psim-manage"
$VagrantVirtualboxProviderFolder = '.\.vagrant\machines\default\virtualbox\'
$VagrantMachineRootFolder = "$PSScriptRoot\.."
$PSModulesPath = ($env:PSModulePath -split ';' | ? { $_ -like '*Documents\WindowsPowerShell\Modules' })

#### PSIM INSTALLER CONSTANTS ####
$PsimInstaller = 'C:\\vagrant\\installer\\psim.exe'
$LicenseFile = 'C:\\vagrant\\installer\\license.txt'
$InstallationLogfile = 'C:\\Program Files (x86)\\PrinterOn Corporation\\PrinterOn Server Install Manager\\Installation History.txt'