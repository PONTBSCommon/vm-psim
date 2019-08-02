function BuildDeploy-PonConf (
    [string]$PonconfFolder,
    [string]$MachineFolder,
    [switch]$Backup,
    [switch]$Test,
    [switch]$NoBuild,
    [switch]$NoDeploy,
    [switch]$Verbose
) {
    $OriginalLocation = (Get-Location)
    if (!$NoBuild) {
        $BuildSuccess = MavenBuild `
            -ProjectFolder $PonconfFolder `
            -MavenOptions $(if ($Test) {'clean install'} else {'clean install -DskipTests'}) `
            -Verbose:$Verbose
    } else { $BuildSuccess = $true }

    if ($BuildSuccess -and !$NoDeploy) {
        # create the deploy folder if it doesn't exist.
        if (!(Test-Path "$MachineFolder\deploy")) { New-Item -ItemType Directory "$MachineFolder\deploy" }
        # backup
        if (Test-Path "$MachineFolder\deploy\printeron-web.zip") { 
            # if a previous deployment exists, back it up, or delete it.
            if ($Backup) { 
                BackupObject "$MachineFolder\deploy\printeron-web.zip" 
            } else { 
                Remove-Item "$MachineFolder\deploy\printeron-web.zip" -Force
            } 
        }
        # copy the build to the shared folder.
        Copy-Item "$PonconfFolder\target\printeron-web.war" "$MachineFolder\deploy\printeron-web.zip" -Force

        Set-Location $MachineFolder
        vagrant powershell -c "Deploy-PonConf C:\vagrant\deploy\printeron-web.zip"
    }
    

    Set-Location $OriginalLocation
}

function Deploy-PonConf ($SourceZip) {
    Stop-PonConf

    $PsimDir = 'C:\Program Files (x86)\PrinterOn Corporation\PrinterOn Server Install Manager\'
    New-Item -Force "$PsimDir\last-deploy" -ItemType Directory

    if ($Backup) { Compress-Archive "$PsimDir\printeron-web" "$PsimDir\last-deploy\printeron-web.zip" -Update }
    # save the properties files.
    Copy-Item "$PsimDir\printeron-web\WEB-INF\classes\persistence.properties" "$PsimDir\last-deploy\persistence.properties" -Force
    Copy-Item "$PsimDir\printeron-web\WEB-INF\classes\ponconf.properties" "$PsimDir\last-deploy\ponconf.properties" -Force
        
    Remove-Item "$PsimDir\printeron-web" -Recurse -Force

    Expand-Archive "$SourceZip" "$PsimDir\printeron-web"
    
    Copy-Item "$PsimDir\last-deploy\persistence.properties" "$PsimDir\printeron-web\WEB-INF\classes\persistence.properties" -Force
    Copy-Item "$PsimDir\last-deploy\ponconf.properties" "$PsimDir\printeron-web\WEB-INF\classes\ponconf.properties" -Force

    Start-PonConf
}