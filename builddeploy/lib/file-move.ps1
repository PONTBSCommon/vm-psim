# this file is for functions that move files around, and backing up artifacts.

. "$PSScriptRoot/util.ps1"

<#
  Copies an artifact inside of the vagrant machine.
#>
function Copy-VagrantArtifact($From, $To) {
  if (hasVagrantfile) { vagrant powershell -c "Copy-Item '$From' '$To' -Force" }
}

<#
  Moves an artifact inside of the vagrant machine.
#>
function Move-VagrantArtifact($From, $To) {
  if (hasVagrantfile) { vagrant powershell -c "Move-Item '$From' '$To' -Force" }
}

<#
  Removes an item inside of the vagrant machine.
  If the item is a directory, recurse deletes it.
#>
function Remove-VagrantArtifact($Path) {
  if (hasVagrantfile) {
    vagrant powershell -c "
      if (Test-Path '$Path') {  
        if ((Get-Item '$Path').Extension) {
          Remove-Item -Force '$Path'
        } else {
          Remove-Item -Force -Recurse '$Path'
        }
      } else {
        Write-Host '$Path not found. skipping...'
      }
    "
  }
}

<#
  Compresses the given folder, into an archive on the vagrant machine.
  Places the archive at the given path.
#>
function Compress-VagrantFolder($FolderPath, $ArchivePath) {
  if (hasVagrantfile) {
    vagrant powershell -c "Compress-Archive -CompressionLevel Fastest -Path '$FolderPath' -DestinationPath '$ArchivePath'"
  }
}

<#
  Expands an archive into a given location on the vagrant machine..
#>
function Expand-VagrantArchive($ArchivePath, $DestinationFolder) {
  if (hasVagrantfile) {
    vagrant powershell -c "Expand-Archive '$ArchivePath' '$DestinationFolder' -Force"
  }
}