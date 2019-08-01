@{
  RootModule           = 'psim-manage.psm1'
  ModuleVersion        = '1.0'
  GUID                 = 'fad36c0a-d377-464e-a11b-dbaac6e81ea7'
  Author               = 'bangma'
  CompanyName          = 'Unknown'
  Copyright            = '(c) 2019 bangma. All rights reserved.'
  Description          = ''

  FunctionsToExport    = @(
    <# Build & Deploy Commands for the projects. #>    
    'BuildDeploy-CPS',
    'BuildDeploy-PonConf',
    'BuildDeploy-IMCAS',
    'BuildDeploy-PDG',

    <# Utility Functions, and useful globals. #>
    'MavenBuild',
    'CopyBuildArtifact',
    'BackupObject',
    'DeployWar',
    'RecurseCopy',
    'Deploy-PonConf',

    <# Service Calls For the PSIM Components in the machine. #>
    'Start-CPS',
    'Stop-CPS',
    'Restart-CPS',
    'Start-IMCAS',
    'Stop-IMCAS',
    'Restart-IMCAS',
    'Start-PonConf',
    'Stop-PonConf',
    'Restart-PonConf',
    'Start-PDG',
    'Stop-PDG',
    'Restart-PDG'
  )
  CmdletsToExport      = @()
  VariablesToExport    = @()
  AliasesToExport      = @()
  DefaultCommandPrefix = ''
}

