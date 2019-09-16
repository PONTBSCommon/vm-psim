
. 'C:\vagrant\scripts\Globals.ps1'

#### DEFINE OPTIONS ####
$PsimOptions = [ordered]@{
  Mode       = 'Auto';
  UserName   = "$($env:COMPUTERNAME)\\vagrant";
  Password   = "vagrant";
  ConfigFile = $LicenseFile;
  InstallType = 'Install';
}



#### ENSURE LICENSE AND PSIM.EXE ARE PRESENT ####
if (!(Test-Path $PsimInstaller) -or !(Test-Path $LicenseFile)) {
  Write-Error "Either PSIM Installer or License file is missing. Skipping PSIM Installation...`n`t-Expecting PSIM at: $PsimInstaller`n`t-Expecting license at: $LicenseFile"; return 1
}

### Custom Install Still In Progress.
# if (Test-Path $FullInstall) {
#   $PsimOptions.Add('Features', 
#     ('Sun Java SDK', 'Docs&Utilities', 'Sql Server', 'PrintAnywhere Servlet Plugin', 'Apache Tomcat', 'PrintAnywhere', 'Ponconf', 'PDS', 'Dummy', 'ReadMe', 'CPS', 'IMCAS', 'PonUsers', 'PDG', 
#       'S3Ninja', 'SqlAgent', 'PasAgent', 'PonDevices', 'Sun Java SDK', 'Docs&Utilities', 'Sql Server', 'PrintAnywhere Servlet Plugin', 'Apache Tomcat', 'PrintAnywhere', 'Ponconf', 'PDS', 
#       'Dummy', 'ReadMe', 'CPS', 'IMCAS', 'PonUsers', 'PDG', 'S3Ninja', 'SqlAgent', 'PasAgent', 'PonDevices') -join ','
#   )
# }

#### START PSIM INSTALLATION ####
$PsimOptionString = $(($PsimOptions.GetEnumerator() | % { $_.Key + ":" + $_.Value }) -join '|')
$cmdPromptCommand = "start /wait $PsimInstaller `"$PsimOptionString`""

Write-Host -ForegroundColor Yellow "Expecting Logfile at: `n`t$InstallationLogfile"
Write-Output "PSIM Installer Location: `n`t$PsimInstaller"
Write-Host -ForegroundColor Yellow "Using Options:"
Write-Host -ForegroundColor Green "`t$PsimOptionString"
Write-Host -ForegroundColor Yellow "Using run command:`n`t$cmdPromptCommand"
Write-Host -ForegroundColor Green "Starting PSIM Installer"
  
#### START THE PSIM INSTALLER ####
$InstallJob = Start-Job -ScriptBlock { cmd /c "$($args[0])"; return 0 } -ArgumentList $cmdPromptCommand

$InstallTimer = [system.diagnostics.stopwatch]::StartNew()

# wait for logfile
while (!(Test-Path $InstallationLogfile)) { Start-Sleep -Seconds 1 }

#### WATCH THE INSTALLER LOG FILE AND PRINT IT TO STD OUT ####
$lines = 0
while (@('Completed', 'Failed') -notcontains $InstallJob.State) {
  $newLines = ((Get-Content $InstallationLogfile).length) - $lines
  $lines += $newLines
  if ($newLines -gt 0) { Get-Content $InstallationLogfile -Tail $newLines | % { Write-Output "$($InstallTimer.elapsed) :: $_" } }
}

#### ON INSTALLER COMPLETION ####
if ($InstallJob.State -eq 'Failed') { 
  Write-Host -ForegroundColor Red "PSIM Installer Failed..."; return 1
} else { 
  Write-Host -ForegroundColor Green "PSIM Installer Completed Successfully..."
  $PonConfPassword = $(Get-Content $LicenseFile | ? { $_ -like '*auth*' } | % { $_ -replace 'APIsiteAuth = ' })

  Write-Host -ForegroundColor Yellow "`n`n`tYour initial PonConf Password is:" -NoNewline
  Write-Host -ForegroundColor Magenta "`t$PonConfPassword"
  Write-Output $PonConfPassword | Out-File C:/Users/Vagrant/Desktop/ponconf-password.txt
}
$InstallTimer.Stop()

#### ONCE THE INSTALLATION IS COMPLETED SUCCESSFULLY, RUN THE FIRST SETUP. ####
Write-Host -ForegroundColor Green "Your PSIM Installation is complete. Elapsed: $($InstallTimer.Elapsed)"
Write-Host -ForegroundColor Yellow 'Running first setup on the remote machine ... '