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

if (!$CPSFolder -or !(Test-Path $CPSFolder)) {
  writeRed "A valid value for CPSFolder must be provided."
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
  Get-ChildItem -Recurse -Depth 3 -Path $CPSFolder -Directory -Filter 'target' | % { 
    Remove-Item -Recurse -Force $_.FullName
  }

  writeYellow "Starting the maven build."
  $BuildSucceeded = Invoke-MavenBuild -ProjectFolder $CPSFolder `
    -MavenOptions "clean install $(if (!$Test) {'-DskipTests'})" `
    -Verbose:$Verbose -Test:$Test
} else {
  $BuildSucceeded = $true
  writeYellow 'Skipping build ... checking for target file.'
  if (!(Test-Path "$CPSFolder/cpsweb/target/cps.war")) {
    writeRed '-NoBuild was specified, but a build artifact was not found. aborting'
    return $false
  }
}

if (!$BuildSucceeded) {
  writeRed "maven build failed... aborting."
  return $false
}

writeYellow "Starting the deploy process, to vagrant machine at: $VagrantFolder"
Stop-CPS
Copy-VagrantArtifact "$TomcatWebappDir/cps.war" 'C:/vagrant/deploy/cps.old.war'
Remove-VagrantArtifact "$TomcatWebappDir/cps"
Copy-Item "$CPSFolder/cpsweb/target/cps.war" "$VagrantFolder/deploy/cps.new.war" -Force
Copy-VagrantArtifact "C:/vagrant/deploy/cps.new.war" "$TomcatWebappDir/cps.war"
Start-CPS
writeYellow "Deploy of CPS complete."