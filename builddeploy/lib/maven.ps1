<#
  Invoke a maven build on the given project folder, with the provided maven options.
  If no maven options are provided, it defaults to a clean install with no tests.

  If the build fails, this function throws a terminating error.
#>

. "$PSScriptRoot/util.ps1"

function Invoke-MavenBuild($ProjectFolder, $MavenOptions = 'clean install -DskipTests', [switch]$Verbose) {
  $StartLocation = (Get-Location)
  try {
    Set-Location $ProjectFolder
    validateFilePath ./pom.xml "There is no pom file in $ProjectFolder. No build processed."

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
      throw "Building the project at $ProjectFolder failed."
    }
    
    writeGreen "Building project at $ProjectFolder succeeded."
    return $true

  } catch {
    Set-Location $StartLocation
    throw "Project folder path: $ProjectFolder does not exist."
  }
}

<#
  Recurses into a folder and removes all sub folders with the name target.
  Prevents builds from failing due to an inability to delete the targets.
#>
function Recurse-RemoveTargetFolders($ProjectFolder, $SearchDepth) {
  writeYellow "Attempting to clean target folders."
  Get-ChildItem -Recurse -Depth $SearchDepth -Path $ProjectFolder -Directory -Filter 'target' | % { 
    Remove-Item -Recurse -Force $_.FullName
  }
}