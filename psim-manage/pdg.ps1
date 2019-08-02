$GatewayDir = 'C:\Program Files (x86)\PrinterOn Corporation\PDG\gateway'

function BuildDeploy-PDG (
    [string]$PdgFolder,
    [string]$MachineFolder,

    [switch]$NoBuild,
    [switch]$NoDeploy,

    [switch]$Test,
    [switch]$Verbose,
    [switch]$Backup
) {
    if (!$NoBuild) {
        $BuildSuccess = MavenBuild `
            -ProjectFolder $PdgFolder `
            -MavenOptions "clean install $(if (!$Test) { '-DskipTests' })" `
            -Verbose:$Verbose

    } else { $BuildSuccess = $true }

    if (!$NoDeploy -and $BuildSuccess) {
        # for testing and debugging we would want to use the unmodified source jar. instead of the obfuscated public jar.
        if (!$NoBuild) {
            Move-Item "$PdgFolder\target\gateway.jar" "$PdgFolder\target\gateway-obfuscated.jar" -Force
            Move-Item "$PdgFolder\target\PDG-jar-with-dependencies.jar" "$PdgFolder\target\gateway.jar" -Force
        }
        
        DeployWar `
            -VagrantMachine $MachineFolder `
            -Backup:$Backup `
            -War "$PdgFolder\target\gateway.jar" `
            -Destination $GatewayDir `
            -StartCommand "Start-PDG" `
            -StopCommand "Stop-PDG" `
            -VagrantDeploy
    }
}