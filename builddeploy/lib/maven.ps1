<#
  Invoke a maven build on the given project folder, with the provided maven options.
  If no maven options are provided, it defaults to a clean install with no tests.
#>

. "$PSScriptRoot/util.ps1"

function Invoke-MavenBuild($ProjectFolder, $MavenOptions = 'clean install -DskipTests', [switch]$Verbose, [switch]$Test) {
  $StartLocation = (Get-Location)
  try {
    Set-Location $ProjectFolder
    if (!(Test-Path ./pom.xml)) {
      writeRed "There is no pom file in $ProjectFolder. No build processed."
      return $false
    }

    # run the maven build
    "mvn $MavenOptions" | iex | ? {
      # filter out unnecessary output, unless verbose is specified.
      $_ -like $(if ($Verbose) { '*' } else { '*info*build*' })
    } | % { 
      # watch the build output for a failure message
      if ($_ -like '*info*build*failure*') {
        $BuildFailed = $true
      }
      # write the messages out.
      Write-Host "Maven Output :: $_"
    }
    
    Set-Location $StartLocation

    if ($BuildFailed) {
      writeRed "Building the project at $ProjectFolder failed."
      return $false
    }
    writeGreen "Building project at $ProjectFolder succeeded."
    return $true

  } catch {
    Set-Location $StartLocation
    writeRed "Project folder path: $ProjectFolder does not exist."
    return $false
  }
}