
# load tools.
Get-ChildItem $PSScriptRoot -Filter 'util.*.ps1' | % { . $_.FullName }
Get-ChildItem $PSScriptRoot -Filter '*.ps1' | % { . $_.FullName }
