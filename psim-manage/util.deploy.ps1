function DeployWar(
    [Switch]$VagrantDeploy,
    [Switch]$Backup,

    [String]$War,
    [String]$Destination,

    [String]$StopCommand,
    [String]$StartCommand,

    [String]$VagrantMachine
) {
    if ($VagrantDeploy -and !$VagrantMachine) { Write-Error 'For a vagrant deploy, the VagrantMachine param must be specified.'; return }
    if (!$War -or !$Destination -or !$StopCommand -or !$StartCommand) { Write-Error 'War, Destination, StopCommand, StartCommand must all be specified.'; return }

    if ($VagrantDeploy) {
        $StartLocation = (Get-Location)
        Set-Location $VagrantMachine
        
        # copy item from build directory to shared folder
        if (!(Test-Path ./deploy)) { New-Item -ItemType Directory ./deploy }
        Copy-Item $War ./deploy
        
        $WarObject = (Get-Item $War)

        #copy item from shared folder to destination.
        vagrant powershell -c "
            $StopCommand
            CopyBuildArtifact 'C:\vagrant\deploy\$($WarObject.Name)' '$Destination' -Backup:`$$Backup
            $StartCommand
        "
        Set-Location $StartLocation
    } else {
        $StopCommand | iex
        CopyBuildArtifact $War $Destination
        $StartCommand | iex
    }
}