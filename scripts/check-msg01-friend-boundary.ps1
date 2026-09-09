[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$sharedProject = Join-Path $repositoryRoot 'deep-client-shared\src\Deep.Client.Shared\Deep.Client.Shared.csproj'
$sourceRoot = Join-Path $repositoryRoot 'deep-client-shared\src\Deep.Client.Shared'
$mauiSourceRoot = Join-Path $repositoryRoot 'deep-client-maui\src'
$probeRoot = Join-Path ([IO.Path]::GetTempPath()) ("deep-msg01-boundary-" + [Guid]::NewGuid().ToString('N'))

$forbiddenProductionText = @(
    'SealAuthenticatedEvidence',
    'GetDispatchEvidenceAsync',
    'new E2eeClientTransport'
)
foreach ($text in $forbiddenProductionText) {
    $match = Get-ChildItem -LiteralPath $sourceRoot -Recurse -Filter '*.cs' |
        Select-String -SimpleMatch $text | Select-Object -First 1
    if ($null -ne $match) {
        throw "MSG-01 production source still contains forbidden local-authority/DPE1 path '$text': $($match.Path):$($match.LineNumber)"
    }
}

$forbiddenMauiAuthorityText = @(
    'IMsg01AuthenticatedEvidenceSource',
    'MessagingWireVerification',
    'AcceptAuthenticatedPlaintext',
    'new E2eeClientTransport'
)
foreach ($text in $forbiddenMauiAuthorityText) {
    $match = Get-ChildItem -LiteralPath $mauiSourceRoot -Recurse -Filter '*.cs' |
        Select-String -SimpleMatch $text | Select-Object -First 1
    if ($null -ne $match) {
        throw "MSG-01 production MAUI source contains forbidden caller-controlled authority/fallback '$text': $($match.Path):$($match.LineNumber)"
    }
}

try {
    New-Item -ItemType Directory -Path $probeRoot | Out-Null
    $escapedProject = [Security.SecurityElement]::Escape($sharedProject)
    $probeSource = @'
using Deep.Client.Shared.Persistence.MessagingV1;

public sealed class Msg01ForgeryProbe
{
    private MessageStoreAuthorityBinding? authority;
    private IMessageVerifiedTransportHandoff? handoff;
    private MessageCapabilityTrustedContext? context;
    private IMsg01AuthenticatedEvidenceSource? evidenceSource;
    private SharedMessagingV1Composition? composition;

    public object AttemptDirectMint() => authority!.ClaimHandoff();
}
'@

    foreach ($assemblyName in @(
        'Deep.Client.Maui',
        'Deep.Client.Shared.Tests',
        'Deep.Client.Maui.ViewModels.Tests',
        'Deep.ReleaseCompositionVerifier')) {
        $assemblyRoot = Join-Path $probeRoot $assemblyName
        New-Item -ItemType Directory -Path $assemblyRoot | Out-Null
        $projectPath = Join-Path $assemblyRoot "$assemblyName.csproj"
        @"
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net10.0</TargetFramework>
    <AssemblyName>$assemblyName</AssemblyName>
    <Nullable>enable</Nullable>
  </PropertyGroup>
  <ItemGroup>
    <ProjectReference Include="$escapedProject" AdditionalProperties="EnableDeepTestInternals=false" />
  </ItemGroup>
</Project>
"@ | Set-Content -LiteralPath $projectPath -Encoding utf8
        $probeSource | Set-Content -LiteralPath (Join-Path $assemblyRoot 'Msg01ForgeryProbe.cs') -Encoding utf8

        $buildOutput = (& dotnet build $projectPath --nologo -c Release -p:EnableDeepTestInternals=false 2>&1 | Out-String)
        if ($LASTEXITCODE -eq 0) {
            throw "MSG-01 boundary failed: spoofed assembly '$assemblyName' compiled direct authority access."
        }
        foreach ($symbol in @('MessageStoreAuthorityBinding','IMessageVerifiedTransportHandoff',
            'MessageCapabilityTrustedContext','IMsg01AuthenticatedEvidenceSource','SharedMessagingV1Composition')) {
            if ($buildOutput -notmatch 'CS0122' -or $buildOutput -notmatch [Regex]::Escape($symbol)) {
                throw "MSG-01 probe '$assemblyName' did not prove direct access denial for $symbol.`n$buildOutput"
            }
        }
    }

    Write-Output 'PASS: production MSG-01 has no local mint/DPE1/caller-controlled DPE2 authority path and spoofed friend assembly names cannot access authority internals.'
}
finally {
    if (Test-Path -LiteralPath $probeRoot) {
        Remove-Item -LiteralPath $probeRoot -Recurse -Force
    }
}
