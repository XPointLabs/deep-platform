#Requires -Version 5.1
param(
    [Parameter(Mandatory = $true)][ValidateSet('deep-client-shared', 'xnode', 'deep-protocol', 'deep-registry-api')][string]$Repository,
    [Parameter(Mandatory = $true)][string]$RunDirectory,
    [string[]]$ReferencePaths = @(),
    [ValidateSet('Release', 'Debug')][string]$Configuration = 'Release',
    [ValidateSet('WindowsPowerShell51', 'PowerShell7')][string]$Interpreter = 'WindowsPowerShell51',
    [string[]]$AllowedSkippedCases = @(),
    [string[]]$AllowedFailedCases = @(),
    [string]$WitnessPowerShellPath = '',
    [switch]$PreflightOnly
)
$ErrorActionPreference = 'Stop'
$workspace = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
Import-Module (Join-Path $PSScriptRoot 'TestGate.psm1') -Force
$profiles = @{
    'deep-client-shared' = @{ Solution = 'Deep.Client.Shared.Production.slnx'; Properties = @(); Inputs = @('deep-client-shared', 'deep-protocol') }
    'xnode' = @{ Solution = 'XNode.slnx'; Properties = @('-p:DeepProtocolSourceCutover=true'); Inputs = @('xnode', 'deep-protocol') }
    'deep-protocol' = @{ Solution = 'Deep.Protocol.slnx'; Properties = @(); Inputs = @('deep-protocol') }
    'deep-registry-api' = @{ Solution = 'Deep.Registry.Api.slnx'; Properties = @('-p:DeepProtocolLocalCutover=true', '-p:DeepProtocolSourceCutover=true'); Inputs = @('deep-registry-api', 'xnode', 'deep-client-shared', 'deep-protocol') }
}
$profile = $profiles[$Repository]
$exit = Invoke-RepositoryTestGate -WorkspaceRoot $workspace -Repository $Repository -Solution $profile.Solution `
    -BuildProperties $profile.Properties -InputRepositories $profile.Inputs -RunDirectory $RunDirectory `
    -ReferencePaths $ReferencePaths -Configuration $Configuration -Interpreter $Interpreter `
    -AllowedSkippedCases $AllowedSkippedCases -AllowedFailedCases $AllowedFailedCases -PreflightOnly:$PreflightOnly `
    -WitnessPowerShellPath $WitnessPowerShellPath
exit $exit
