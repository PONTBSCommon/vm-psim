# PSIM Manage | A Powershell Module for managing PSIM Installations.

## BuildDeploy | Developer Application Building and Deployment Tool
The PSIM Manage module provides a series of functions under the header: **BuildDeploy**

| Function            | Parameters      | Description                                                                               |
|---------------------|-----------------|-------------------------------------------------------------------------------------------|
| BuildDeploy-CPS     |                 | This function builds CPS, and then deploys the war to your vagrant machine.
|                     | -CpsFolder      | This is the top level git folder for cps. eg: `C:\git\cps`
|                     | -MachineFolder  | This is the top level folder for your vagrant machine. eg: `C:\vagrant\vm-psim`
|                     | -Help           | This will display the help info for BuildDeploy-CPS
|                     | -NoBuild        | This flag skips the build step (handy if you want to redeploy the previous war).
|                     | -NoDeploy       | This flag skips the deployment step, and acts as a `mvn clean install -DskipTests`.
|                     | -WebOnly        | When specified, only the cps-web module will be compiled. Faster if your changes are cps-web only.
|                     | -Test           | For speed, tests are skipped by default. This will run the maven tests as part of the build-deploy.
|                     | -Backup         | This will back up the previous deployment, as it deploys the new war.
|                     | -Verbose        | By default, only partial output is shown. Use this if there is an error in your build-deploy.
|                     |                 |                                                                                           |
| BuildDeploy-IMCAS   |
| BuildDeploy-PonConf |
| BuildDeploy-PDG     |

## Service Management