#Requires -Version 5.1
param(
    [Parameter(Mandatory = $true)][string[]]$ReceiptPaths,
    [Parameter(Mandatory = $true)][string[]]$ReferencePaths,
    [Parameter(Mandatory = $true)][ValidateNotNull()][Nullable[int]]$NativeExitCode,
    [string[]]$AllowedSkippedCases = @(),
    [string[]]$AllowedFailedCases = @()
)
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'TestGate.psm1') -Force
Test-TestGateResults @PSBoundParameters
