param(
  $PonConfFolder, # the git repo for ponconf.
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

validateFolderPath $PonConfFolder "-PonConfFolder must be a valid path."
validateFolderPath $VagrantFolder "-VagrantFolder must be a valid path."

if (!$NoBuild) {
  Recurse-RemoveTargetFolders $PonConfFolder 2

  writeYellow "Starting the maven build."
  Invoke-MavenBuild -ProjectFolder $PonConfFolder -MavenOptions "clean install $(if (!$Test) {'-DskipTests'})" -Verbose:$Verbose
} else {
  writeYellow 'Skipping build ... checking for target file.'
  validateFilePath "$IMCASFolder/target/printeron-web.war" '-NoBuild was specified, but a build artifact was not found. aborting'
}

writeYellow "Starting the deploy process, to vagrant machine at: $VagrantFolder"

Stop-PonConf
writeYellow "Backing up old deployment artifacts."
Compress-VagrantFolder "$PSIMParentDir/printeron-web" "C:/vagrant/deploy/printeron-web.old.zip"
Copy-VagrantArtifact "$PonConfPropertiesDir/persistence.properties" "C:/vagrant/deploy/persistence.old.properties"
Copy-VagrantArtifact "$PonConfPropertiesDir/ponconf.properties" "C:/vagrant/deploy/ponconf.old.properties"

writeYellow "Deploying new deployment artifacts."
Copy-Item -Force "$PonConfFolder/target/printeron-web.war" "$VagrantFolder/deploy/printeron-web.new.zip"
Expand-VagrantArtifact "C:/vagrant/deploy/printeron-web.new.zip" "$PSIMParentDir/printeron-web"
Copy-VagrantArtifact "C:/vagrant/deploy/persistence.old.properties" "$PonConfPropertiesDir/persistence.properties"
Copy-VagrantArtifact "C:/vagrant/deploy/ponconf.old.properties" "$PonConfPropertiesDir/ponconf.properties"
Start-PonConf