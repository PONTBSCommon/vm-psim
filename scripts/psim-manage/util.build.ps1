<#
    This command moves into the directory $ProjectFolder.
    It then runs mvn with the commands specified in $MavenOptions
    ie:
        - test
        - clean install
        - install -DskipTests
        - etc.
    Return [Boolean]
        - $true     if build was successful.
        - $false    if the build failed.
#>
function MavenBuild(
    [String]$ProjectFolder,
    [String]$MavenOptions,
    [Switch]$Verbose
) {
    if (!$ProjectFolder) {
        Write-Error 'Value not supplied for ProjectFolder parameter.'; return
    } 
    if (!$MavenOptions) {
        Write-Error 'Value not supplied for Command parameter.'; return
    }

    # save location so we can return the user to their starting location once the command is complete.
    $StartLocation = (Get-Location)

    Set-Location $ProjectFolder

    # iex executes the statement that resolves from "mvn $MavenOptions"
    # it is then piped through:
    #   - ? (where) block to filter it
    #   - % (foreach) block to watch for build failure
    "mvn $MavenOptions" | iex | ? {

        # if the $Verbose flag is present, this will skip filtering the build messages.
        $_ -like $(if ($Verbose) { '*' } else { '*INFO*BUILD*' })

    } | % {

        # this command watches the output from maven, to look for the failure status message.
        if ($_ -like '*INFO*BUILD*FAILURE*') { $BuildStatus = 'failure' }
        Write-Host $_
    }

    if ($BuildStatus -eq 'failure') {
        Write-Host -ForegroundColor Red 'Build Failure.'
    } else {
        Write-Host -ForegroundColor Green 'Build Success'
    }

    Set-Location $StartLocation
    return [Boolean]($BuildStatus -ne 'failure')
}

<#
    This command copies the object at $ArtifactPath to the $DestinationFolder.
    It has the option of backing up the previous object, if the $Backup flag is set.
#>
function CopyBuildArtifact(
    [String]$ArtifactPath,
    [String]$DestinationFolder,
    [Switch]$Backup
) {
    [System.IO.FileInfo]$NewDeploymentObject = (Get-Item $ArtifactPath)
    [String]$ArtifactName = $NewDeploymentObject.Name
    [String]$PreviousDeploymentObjectName = "$DestinationFolder\$ArtifactName"
    
    Write-Host "Looking for previous deployment at [$PreviousDeploymentObjectName]"
    if ((Test-Path $PreviousDeploymentObjectName) -and $Backup) {
        Write-Host "Found a previous deployment, backing up."
        BackupObject $PreviousDeploymentObjectName
    } else {
        if (!$Backup) {
            Write-Host "No backup requested, skipping."
        } else {
            Write-Host 'Could not find previous deployment object.'
        }
    }
    if (Test-Path "$DestinationFolder\$ArtifactName") {
        Write-Host -ForegroundColor Red "Deleting old deployment object."
        Remove-Item -Force "$DestinationFolder\$ArtifactName"
    }
    Write-Host -ForegroundColor Yellow "Copying [$ArtifactName] to [$DestinationFolder]."
    Copy-Item $ArtifactPath $DestinationFolder
}

<#
    This command backs up the specified file.
    When backing up the previous object, the last edited date will be appended to the file name.
    in the format <name>.YYMMDD.HHMMSS.<extension>
    ie:
        - cps.war with a last edit date of January 01, 2019 at 1:45:01pm 
        - becomes: cps.190101.134501.war
#>
function BackupObject($ObjectPath) {
    [System.IO.FileInfo]$Object = (Get-Item $ObjectPath)

    [String]$LastWriteTimeStamp = (Get-Date $Object.LastWriteTime -UFormat '%y%m%d.%H%M%S')
    [String]$ObjectBackupName = "$( $Object.Name -replace $PreviousDeploymentObject.Extension ).$LastWriteTimeStamp$( $PreviousDeploymentObject.Extension )"

    Write-Host -ForegroundColor Green "Backing up [$( $Object.FullName )] as [$ObjectBackupName]."
    Move-Item ($Object.FullName) "$( $Object.DirectoryName )\$ObjectBackupName" -Force
}
