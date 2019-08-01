

<# These are locations on the vagrant machine, do not change #>
$VM_DEPLOY_FOLDER = "C:\vagrant\deploy"
$CPS_WAR = "$VM_DEPLOY_FOLDER\cps.war"
$CPS_WAR_BACKUP = "$VM_DEPLOY_FOLDER\cps.war.bak"
$WARS_DIR = "C:\Program Files (x86)\PrinterOn Corporation\Apache Tomcat\webapps"

<# PUBLIC
    The public deploy command accessible via the command line.
#>
function BuildDeploy-CPS(
    [String]$CpsFolder, 
    [String]$MachineFolder, 

    [Switch]$Help,
    [Switch]$NoBuild,
    [Switch]$NoDeploy,
    [Switch]$WebOnly,
    [Switch]$Test,
    [Switch]$Backup,
    [Switch]$Verbose
) {
    # if the help command was specified, or no args were given.
    if ((!$CpsFolder -and !$MachineFolder) -or ($Help)) { CPS-HelpMessage; return }

    if (!$NoBuild) {
        $BuildSuccess = MavenBuild `
            -ProjectFolder "$CpsFolder\$(if ($WebOnly){'cpsweb'})" `
            -MavenOptions "clean install $(if (!$Test){'-DskipTests'})" `
            -Verbose:$Verbose
    }
    if (!$NoDeploy -and ($BuildSuccess -or $NoBuild)) {
        DeployWar `
            -VagrantMachine $MachineFolder `
            -Backup:$([bool]$Backup) `
            -War "$CpsFolder\cpsweb\target\cps.war" `
            -Destination "C:\Program Files (x86)\PrinterOn Corporation\Apache Tomcat\webapps" `
            -StartCommand "Start-CPS" `
            -StopCommand "Stop-CPS" `
            -VagrantDeploy
    }
}

function CPS-HelpMessage {
    out "BuildDeploy CPS Help"
    out "Usage:"
    Write-Output "`tBuildDeploy.CPS [CPS Project Folder] [Vagrant VM Folder]"
    out "Options:"
    out "`tCOMMAND`t`tDESCRIPTION"
    Write-Output "`t-NoBuild  `tDo not build CPS, only deploy existing war. (Fails if war doesn't exist)"
    Write-Output "`t-NoDeploy `tBuilds the CPS project, but does not deploy it to the vagrant vm."
    Write-Output "`t-WebOnly  `tBuilds on the cpsweb module, and the war. For when changes have only been made in cpsweb."
    Write-Output "`t-Test     `tRuns the tests in maven. By default tests are disabled to save on build time."
    out ''
    Write-Host -ForegroundColor Red 'nocopy is intended to be used with nobuild. Using only nocopy will build the project and then deploy whatever was in the deploy folder before the build.'
}