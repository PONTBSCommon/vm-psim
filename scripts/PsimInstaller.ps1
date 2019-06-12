
#### DEFINE OPTIONS ####
$PSIM = "C:/vagrant/installer/psim.exe"
$LICENSE = "C:/vagrant/installer/license.txt"
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

  Write-Output "Expecting Logfile at: `n`t$LOGFILE"
  Write-Output "PSIM Installer Location: `n`t$PSIM"
  Write-Output "Using Options:"
  Write-Output $OPTIONS
  Write-Output "Using run command:`n`t$RUNCMD"
  Write-Output "Starting PSIM Installer"
    
  #### START THE PSIM INSTALLER ####
  $InstallJob = Start-Job -ScriptBlock { cmd /c "$($args[0])"; return 0 } -ArgumentList $RUNCMD
      
  Write-Output "PSIM InstallJob state is:`n=> $($InstallJob.State)"
  while (!(Test-Path $LOGFILE)) { Start-Sleep -Seconds 1 }

  #### WATCH THE INSTALLER LOG FILE AND PRINT IT TO STD OUT ####
  $lines = 0
  while (@('Completed', 'Failed') -notcontains $InstallJob.State) {
    $newLines = ((Get-Content $LOGFILE).length) - $lines
    $lines += $newLines
    if ($newLines -gt 0) { Get-Content $LOGFILE -Tail $newLines | % { Write-Output $_ } }
  }

  if ($InstallJob.State -eq 'Failed') { 
    Write-Output "PSIM Installer Failed..." 
  } else { 
    Write-Output "PSIM Installer Completed Successfully..."
    $PonConfPassword = $(Get-Content $LICENSE | ? { $_ -like '*auth*' } | % { $_ -replace 'APIsiteAuth = ' })

    Write-Host -ForegroundColor Green "`n`n`tYour initial PonConf Password is:" -NoNewline
    Write-Host -ForegroundColor Yellow "`t$PonConfPassword"
    Write-Output $PonConfPassword > ../ponconf-password.txt
  }

} else { Write-Error "Either PSIM Installer or License file is missing. Skipping PSIM Installation...`n`t-Expecting PSIM at: $PSIM`n`t-Expecting license at: $LICENSE" }