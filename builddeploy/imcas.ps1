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

if (!$IMCASFolder -or !(Test-Path $IMCASFolder)) {
  writeRed "A valid value for IMCASFolder must be provided."
  return $false
}

try {
  $VagrantFolder = (Resolve-Path $VagrantFolder)
} catch {
  writeRed "VagrantFolder value: [$VagrantFolder] provided was invalid."
  return $false
}

if (!$NoBuild) {
  writeYellow "Attempting to clean target folders."
  Get-ChildItem -Recurse -Depth 3 -Path $IMCASFolder -Directory -Filter 'target' | % { 
    Remove-Item -Recurse -Force $_.FullName
  }

  writeYellow "Starting the maven build."
  $BuildSucceeded = Invoke-MavenBuild -ProjectFolder $IMCASFolder `
    -MavenOptions "clean install $(if (!$Test) {'-DskipTests'}) -Punit-tests" `
    -Verbose:$Verbose -Test:$Test
} else {
  $BuildSucceeded = $true
  writeYellow 'Skipping build ... checking for target file.'
  if (!(Test-Path "$IMCASFolder/imcas-war/target/imcas.war")) {
    writeRed '-NoBuild was specified, but a build artifact was not found. aborting'
    return $false
  }
}

if (!$BuildSucceeded) {
  writeRed "maven build failed... aborting."
  return $false
}

writeYellow "Starting the deploy process, to vagrant machine at: $VagrantFolder"
Stop-IMCAS
Copy-VagrantArtifact "$TomcatWebappDir/imcas.war" 'C:/vagrant/deploy/imcas.old.war'
Remove-VagrantArtifact "$TomcatWebappDir/imcas"
Copy-Item "$IMCASFolder/imcas-war/target/imcas.war" "$VagrantFolder/deploy/imcas.new.war" -Force
Copy-VagrantArtifact "C:/vagrant/deploy/imcas.new.war" "$TomcatWebappDir/imcas.war"
Start-IMCAS
writeYellow "Deploy of IMCAS complete."