# utility functions used by one or more service, things like validators.

<#
  checks if the current folder has a Vagrantfile.
#>
function hasVagrantFile() { return (Test-Path ./Vagrantfile) }

<#
  Write to output in red (good for errors without traces).
#>
function writeRed($Value) { Write-Host -ForegroundColor Red $Value }

function writeGreen($Value) { Write-Host -ForegroundColor Green $Value }
function writeYellow($Value) { Write-Host -ForegroundColor Yellow $Value }