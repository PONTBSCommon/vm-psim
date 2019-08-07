function Stop-CPS { taskkill /im tomcat8.exe /f }
function Start-CPS { net start 'Central Print Services' }
function Restart-CPS { Stop-CPS; Start-CPS }

function Stop-IMCAS { Stop-CPS }
function Start-IMCAS { Start-CPS }
function Restart-IMCAS { Restart-CPS }

function Stop-PonConf { taskkill /im PonConfigurationManager.exe /f }
function Start-PonConf { net start "Pon Configuration Manager" }
function Restart-PonConf { Stop-PonConf; Start-PonConf }

function Stop-PDG { taskkill /im GatewayService.exe /f }
function Start-PDG { net start "Print Delivery Gateway" }
function Restart-PDG { Stop-PDG; Start-PDG }