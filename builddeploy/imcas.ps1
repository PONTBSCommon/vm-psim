param(
  [string]$IMCASFolder, # the imcas repo folder.
  [string]$VagrantFolder = ".", # the vagrant folder (vm-psim) location. (defaults to the current directory)

  # optional flags
  [switch]$Verbose, # makes maven print all output
  [switch]$Test, # tells maven to run the tests
  [switch]$NoBuild  # skips the maven build step
)

. "$PSScriptRoot/lib/file-move.ps1"
. "$PSScriptRoot/lib/maven.ps1"
. "$PSScriptRoot/lib/services.ps1"
. "$PSScriptRoot/lib/util.ps1"
. "$PSScriptRoot/lib/constants.ps1"

validateFolderPath $IMCASFolder "-IMCASFolder param must be a valid path."
validateFolderPath $VagrantFolder "-VagrantFolder path must be a valid path."

if (!$NoBuild) {
  Recurse-RemoveTargetFolders $IMCASFolder 3

  writeYellow "Starting the maven build."
  Invoke-MavenBuild -ProjectFolder $IMCASFolder -MavenOptions "clean install $(if (!$Test) {'-DskipTests'})" -Verbose:$Verbose

} else {
  writeYellow 'Skipping build ... checking for target file.'
  validateFilePath "$IMCASFolder/imcas-war/target/imcas.war" '-NoBuild was specified, but a build artifact was not found. aborting'
}

writeYellow "Starting the deploy process, to vagrant machine at: $VagrantFolder"

Stop-IMCAS
writeYellow "Backing up old deployment artifacts."
Copy-VagrantArtifact "$TomcatWebappDir/imcas.war" 'C:/vagrant/deploy/imcas.old.war'
Remove-VagrantArtifact "$TomcatWebappDir/imcas"

writeYellow "Deploying new deployment artifacts."
Copy-Item "$IMCASFolder/imcas-war/target/imcas.war" "$VagrantFolder/deploy/imcas.new.war" -Force
Copy-VagrantArtifact "C:/vagrant/deploy/imcas.new.war" "$TomcatWebappDir/imcas.war"
Start-IMCAS
writeYellow "Deploy of IMCAS complete."