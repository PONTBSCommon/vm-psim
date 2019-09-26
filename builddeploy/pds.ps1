param(
 
    [string] $PdsFolder,
    [string]$VagrantFolder = ".", # the vagrant folder (vm-psim) location. (defaults to the current directory)

    # optional flags
    [switch]$Verbose, # makes maven print all output
    [switch]$Test, # tells maven to run the tests
    [switch]$NoBuild  # skips the maven build step
    )

    . "$PSScriptRoot/lib/file-move.ps1"
    . "$PSScriptRoot/lib/maven.ps1"
    . "$PSScriptRoot/lib/services.ps1"
    . "$PSScriptRoot/lib/util.ps1"
    . "$PSScriptRoot/lib/constants.ps1"

    validateFolderPath $PdsFolder "-PdsFolder param must be a valid path."
    validateFolderPath $VagrantFolder "-VagrantFolder path must be a valid path."

    if(!$NoBuild){

        Recurse-RemoveTargetFolders $PdsFolder 2

        writeYellow "Starting the maven build."

        Invoke-MavenBuild -ProjectFolder $PdsFolder -MavenOptions "clean install $(if (!$Test) {'-DskipTests'})" -Verbose:$Verbose
          
        
    }else { 
        writeYellow 'Skipping build ... checking for target file.'
        validateFilePath "$PdsFolder/target/PDS-jar-with-dependencies.jar" '-NoBuild was specified, but a build artifact was not found. aborting'
    }

    #Let's deploy PDS
    
        writeYellow "Starting the deploy process, to vagrant machine at: $VagrantFolder"
        Stop-PDS
        Copy-VagrantArtifact "$PDSDir/director.jar" 'C:/vagrant/deploy/director.old.jar'
        Remove-VagrantArtifact "$PDSDir/director.jar"
        Copy-Item "$PdsFolder/target/PDS-jar-with-dependencies.jar" "$VagrantFolder/deploy/director.new.jar" -Force
        Copy-VagrantArtifact "C:/vagrant/deploy/director.new.jar" "$PDSDir/director.jar"
        Start-PDS
        writeYellow "Deploy of PDS complete."

    


  
    
