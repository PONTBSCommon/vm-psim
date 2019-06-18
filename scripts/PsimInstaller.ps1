#### DEFINE OPTIONS ####
$PSIM = "C:\\vagrant\\installer\\psim.exe"
$LICENSE = "C:\\vagrant\\installer\\license.txt"
$LOGFILE = "C:\\Program Files (x86)\\PrinterOn Corporation\\PrinterOn Server Install Manager\\Installation History.txt"
$OPTIONS = @( 
  "Mode:Auto",
  "UserName:$($env:COMPUTERNAME)\\vagrant",
  "Password:vagrant", 
  "ConfigFile:$LICENSE"
)
# reset the evaluation time.
slmgr -rearm

#### ENSURE LICENSE AND PSIM.EXE ARE PRESENT ####
if ((Test-Path $PSIM) -and (Test-Path $LICENSE)) {
  $RUNCMD = "start /wait $PSIM `"$($OPTIONS -join '|')`""

  Write-Host -ForegroundColor Yellow "Expecting Logfile at: `n`t$LOGFILE"
  Write-Output "PSIM Installer Location: `n`t$PSIM"
  Write-Host -ForegroundColor Yellow "Using Options:"
  $OPTIONS | % { Write-Host -ForegroundColor Cyan "`t $_" }
  Write-Host -ForegroundColor Yellow "Using run command:`n`t$RUNCMD"
  Write-Host -ForegroundColor Green "Starting PSIM Installer"
    
  #### START THE PSIM INSTALLER ####
  $InstallJob = Start-Job -ScriptBlock { cmd /c "$($args[0])"; return 0 } -ArgumentList $RUNCMD
  
  $stopwatch = [system.diagnostics.stopwatch]::StartNew()
  
  Write-Host -ForegroundColor Yellow "PSIM InstallJob state is:`n=> $($InstallJob.State)"
  while (!(Test-Path $LOGFILE)) { Start-Sleep -Seconds 1 }
  Write-Output 'Found Logfile. Starting watch ...'
  
  #### WATCH THE INSTALLER LOG FILE AND PRINT IT TO STD OUT ####
  $lines = 0
  while (@('Completed', 'Failed') -notcontains $InstallJob.State) {
    $newLines = ((Get-Content $LOGFILE).length) - $lines
    $lines += $newLines
    if ($newLines -gt 0) { Get-Content $LOGFILE -Tail $newLines | % { Write-Output "$($stopwatch.elapsed) :: $_" } }
  }

  #### ON INSTALLER COMPLETION ####
  if ($InstallJob.State -eq 'Failed') { 
    Write-Host -ForegroundColor Red "PSIM Installer Failed..."; return 1
  } else { 
    Write-Host -ForegroundColor Green "PSIM Installer Completed Successfully..."
    $PonConfPassword = $(Get-Content $LICENSE | ? { $_ -like '*auth*' } | % { $_ -replace 'APIsiteAuth = ' })

    Write-Host -ForegroundColor Yellow "`n`n`tYour initial PonConf Password is:" -NoNewline
    Write-Host -ForegroundColor Magenta "`t$PonConfPassword"
    Write-Output $PonConfPassword | Out-File C:/Users/Vagrant/Desktop/ponconf-password.txt
  }
  $stopwatch.Stop()

  #### ONCE THE INSTALLATION IS COMPLETED SUCCESSFULLY, RUN THE FIRST SETUP. ####
  Write-Host -ForegroundColor Green "Your PSIM Installation is complete. Elapsed: $($stopwatch.Elapsed)"
  Write-Host -ForegroundColor Yellow 'Running first setup on the remote machine ... '
  & 'C:/vagrant/scripts/FirstRunRemoteSetup.ps1'

} else { Write-Error "Either PSIM Installer or License file is missing. Skipping PSIM Installation...`n`t-Expecting PSIM at: $PSIM`n`t-Expecting license at: $LICENSE"; return 1 }