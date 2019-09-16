# utility functions used by one or more service, things like validators.

<#
  checks if the current folder has a Vagrantfile.
#>
function hasVagrantFile() { validateFilePath ./Vagrantfile "Vagrant command cannot be run, no Vagrantfile present."; return $true }

<#
  Checks if a given folder path is valid and not null.
  Throws an error if null or invalid, with the given error message.
#>
function validateFolderPath($FolderPath, $MessageToThrow) {
  if (!$FolderPath) {
    throw  "Folder Path Null: $MessageToThrow"
  }
  try {
    Resolve-Path $FolderPath
  } catch {
    throw "Folder Path Invalid: $MessageToThrow"
  }
}

<#
  Validates that a given file path exists.
  If not throws the provided message.
#>
function validateFilePath($FilePath, $MessageToThrow) {
  if (!$FilePath) {
    throw  "File Path Null: $MessageToThrow"
  }
  try {
    $FilePath = (Resolve-Path $FilePath)

    $FileObject = (Get-Item $FilePath)
    if (!($FileObject.Exists)) {
      throw "File Doesn't Exist: $MessageToThrow"
    }
  } catch {
    throw "File Path Invalid: $MessageToThrow"
  }
}

function writeGreen($Value) { Write-Host -ForegroundColor Green $Value }
function writeYellow($Value) { Write-Host -ForegroundColor Yellow $Value }