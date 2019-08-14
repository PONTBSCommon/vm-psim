#####################################################
#### THIS SCRIPT ADDS A CONTEXT MENU FOR VAGRANT ####
#####################################################

$DirectoryRightClickContextMenuRegistry = 'HKCR:\Directory\Background\shell'
$ContextMenuSubCommandRegistry = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\Shell'

$ExitIfNoVagrantFile = "if (!(Test-Path ./Vagrantfile)) { exit };"
$PressEnterToExit = "Read-Host 'Press Enter to Exit'; exit;"
$PressEnterToContinue = "Read-Host 'Press Enter to Continue';"
$PowershellCommandBase = "powershell.exe -noexit -noprofile -command Set-Location -literalPath '%V';$ExitIfNoVagrantFile;Write-Host 'Running command in:' (Get-Location);"

$ExecutionLevel = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$ShellIsElevated = $ExecutionLevel.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$VagrantMenuDisplayName = "Vagrant Menu"
$EntriesToCreate = [ordered]@{
  'Remote Desktop'   = "$PowershellCommandBase vagrant rdp;";
  'Start | Create'   = "$PowershellCommandBase vagrant up;$PressEnterToExit";
  'Shut Down'        = "$PowershellCommandBase vagrant halt -f;";
  'Restart | Reload' = "$PowershellCommandBase vagrant reload;";
  'Powershell'       = "$PowershellCommandBase vagrant powershell;";
  'DELETE VM'        = "$PowershellCommandBase $PressEnterToContinue vagrant destroy -f;";
}

$Icons = @{
  'Vagrant Menu'     = "C:\HashiCorp\Vagrant\embedded\mingw64\bin\ruby.exe" 
  'Remote Desktop'   = "mstsc.exe";
  'Start | Create'   = "C:\windows\system32\VBoxService.exe";
  'Shut Down'        = 'slui.exe';
  'Restart | Reload' = 'mmc.exe';
  'Powershell'       = 'powershell.exe';
  'DELETE VM'        = 'dfdwiz.exe';
}

# If the user is not running powershell as an admin, request an admin console.
if (!($ShellIsElevated)) {
  Write-Host -ForegroundColor Yellow 'User is not in admin console. Requesting an admin console.'
  Start-Process powershell.exe -Verb runAs -ArgumentList @('-NoProfile', "${PSScriptRoot}\$($MyInvocation.MyCommand.Name)")
  sleep 5
  return
}
Write-Host -ForegroundColor Yellow 'User is an administrator, continuing setup.'

# create a drive to get to the registry easily.
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT

# go to the context menu container
Set-Location $DirectoryRightClickContextMenuRegistry

# Create Vagrant Menu Parent
if (Test-Path $VagrantMenuDisplayName) {
  Write-Host -ForegroundColor Yellow 'Deleting old menu entry...'
  Remove-Item -Recurse -Force $VagrantMenuDisplayName
}

Write-Host -ForegroundColor Yellow 'Adding new Context Menu'
New-Item $VagrantMenuDisplayName
Set-ItemProperty $VagrantMenuDisplayName -Name 'MUIVerb' -Value $VagrantMenuDisplayName
Set-ItemProperty $VagrantMenuDisplayName -Name 'Icon' -Value $Icons[$VagrantMenuDisplayName]
Set-ItemProperty $VagrantMenuDisplayName -Name 'SubCommands' -Value ($EntriesToCreate.Keys -join ';')

# subcommands
Set-Location $ContextMenuSubCommandRegistry

# remove existing entries for vagrant if they exist
$EntriesToCreate.GetEnumerator() | % {
  Write-Host -ForegroundColor Yellow "Deleting previous subcommand entry for: $($_.Name)"
  if (Test-Path $_.Name) {
    Remove-Item -Recurse -Force $_.Name
  } else {
    Write-Host -ForegroundColor Yellow 'Not found, skipping ...'
  }
}

# create the Context Entries
$EntriesToCreate.GetEnumerator() | % {
  try {
    Write-Host -ForegroundColor Yellow "Creating subcommand entry for: $($_.Name)"
    # create the context menu entries
    New-Item $_.Name

    # The name to show in the context menu.
    Set-ItemProperty $_.Name -Name '(Default)' -Value $_.Name
    # The icon to show beside the text in the context menu.
    Set-ItemProperty $_.Name -Name 'Icon' -Value ($Icons[$_.Name])

    # set the command to execute on click
    Write-Host -ForegroundColor Yellow "Setting execute command for: $($_.Name)"
    cd $_.Name; New-Item 'command'
    Set-ItemProperty 'command' -Name '(Default)' -Value $_.Value
    cd ..

  } catch {
    Write-Host -ForegroundColor Red "Failed to create subcommand entry for: $($_.Name)"
  }
}