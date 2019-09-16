param(
  [string]$CPSFolder, # the cps repo folder.
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

validateFolderPath $CPSFolder "-CPSFolder param must be a valid path."
validateFolderPath $VagrantFolder "-VagrantFolder path must be a valid path."

if (!$NoBuild) {
  Recurse-RemoveTargetFolders $CPSFolder 3

  writeYellow "Starting the maven build."
  Invoke-MavenBuild -ProjectFolder $CPSFolder -MavenOptions "clean install $(if (!$Test) {'-DskipTests'})" -Verbose:$Verbose

} else {
  writeYellow 'Skipping build ... checking for target file.'
  validateFilePath "$CPSFolder/cpsweb/target/cps.war" '-NoBuild was specified, but a build artifact was not found. aborting'
}

writeYellow "Starting the deploy process, to vagrant machine at: $VagrantFolder"

Stop-CPS
writeYellow "Backing up old deployment artifacts."
Copy-VagrantArtifact "$TomcatWebappDir/cps.war" 'C:/vagrant/deploy/cps.old.war'
Remove-VagrantArtifact "$TomcatWebappDir/cps"

writeYellow "Deploying new deployment artifacts."
Copy-Item "$CPSFolder/cpsweb/target/cps.war" "$VagrantFolder/deploy/cps.new.war" -Force
Copy-VagrantArtifact "C:/vagrant/deploy/cps.new.war" "$TomcatWebappDir/cps.war"
Start-CPS
writeYellow "Deploy of CPS complete."