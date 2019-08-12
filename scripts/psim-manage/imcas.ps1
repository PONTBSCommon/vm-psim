function BuildDeploy-IMCAS (
    [string]$ImcasFolder,
    [string]$MachineFolder,
    [switch]$NoBuild,
    [switch]$NoDeploy,
    [switch]$Test,
    [switch]$Verbose,
    [switch]$Backup,
    [switch]$WarOnly
) {
    if (!$ImcasFolder -or !$MachineFolder) { Write-Error 'IMCAS location or Vagrant machine location missing.'; return }
    
    if (!$NoBuild) {
        $BuildSuccess = MavenBuild `
            -ProjectFolder "$ImcasFolder\$(if($WarOnly){'imcas-war\'})" `
            -MavenOptions "clean install $(if(!$Test){'-DskipTests'})" `
            -Verbose:$Verbose
    } else { $BuildSuccess = $true }
    if (!$NoDeploy -and $BuildSuccess) {
        DeployWar `
            -VagrantMachine $MachineFolder `
            -Backup:$([bool]$Backup) `
            -War "$ImcasFolder\imcas-war\target\imcas.war" `
            -Destination "C:\Program Files (x86)\PrinterOn Corporation\Apache Tomcat\webapps" `
            -StartCommand "Start-IMCAS" `
            -StopCommand "Stop-IMCAS" `
            -VagrantDeploy
    }
}