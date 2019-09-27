# This file is for managing the state of services. eg: starting / stopping tomcat and others.

. "$PSScriptRoot/util.ps1"

# for starting services
$Script:StopService = @{ 
  CPS     = 'tomcat8.exe'
  IMCAS   = 'tomcat8.exe' # imcas and cps are on the same tomcat service.
  PonConf = 'PonConfigurationManager.exe'
  PDS = 'DirectorService.exe'
}

# for stopping services
$Script:StartService = @{ 
  CPS     = 'Central Print Services'
  IMCAS   = 'Central Print Services' # imcas and cps are on the same tomcat service.
  PonConf = 'Pon Configuration Manager'
  PDS = 'Print Delivery Station'
}

<#
  Invokes a taskkill on the vagrant machine in the current folder.
#>
function Invoke-ServiceStop($Name) {
  if (hasVagrantFile -and $Script:StopService[$Name]) { vagrant powershell -c "taskkill /im '$($Script:StopService[$Name])' /f" }
}

<#
  Invokes a net start on the vagrant machine in the current folder.
#>
function Invoke-ServiceStart($Name) {
  if (hasVagrantFile -and $Script:StartService[$Name]) { vagrant powershell -c "net start '$($Script:StartService[$Name])'" }
}

# starting services
function Start-CPS() { Invoke-ServiceStart CPS }
function Start-IMCAS() { Invoke-ServiceStart IMCAS }
function Start-PonConf() { Invoke-ServiceStart PonConf }

function Start-PDS() { Invoke-ServiceStart PDS }

# stopping services
function Stop-CPS() { Invoke-ServiceStop CPS }
function Stop-IMCAS() { Invoke-ServiceStop IMCAS }
function Stop-PonConf() { Invoke-ServiceStop PonConf }
function Stop-PDS() { Invoke-ServiceStop PDS }

# restart services
function Restart-CPS() { Stop-CPS; Start-CPS }
function Restart-IMCAS() { Stop-IMCAS; Start-IMCAS }
function Restart-PonConf() { Stop-PonConf; Start-PonConf }
function Restart-PDS() { Stop-PDS; Start-PDS }
