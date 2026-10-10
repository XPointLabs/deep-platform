$ErrorActionPreference = 'Stop'
$verifier = Join-Path $PSScriptRoot 'Test-RepositoryTestResults.ps1'
Import-Module (Join-Path $PSScriptRoot 'TestGate.psm1') -Force
$root = Join-Path (Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'Temp') ('deep-test-gate-contracts-' + [Guid]::NewGuid().ToString('N'))
$null = New-Item -ItemType Directory -Path $root
$currentPath = Join-Path $root 'current.trx'
$referencePath = Join-Path $root 'reference.trx'
$secondPath = Join-Path $root 'second.trx'
$checks = 0
$inventoryRoot = Join-Path $root 'inputs'

function Receipt([string]$Name = 'Example.Case', [string]$Outcome = 'Passed',
    [int]$Executed = 1, [int]$Passed = 1, [int]$Failed = 0,
    [string]$DefinedName = $Name, [string]$EntryId = 'e1') {
    $methodName = ($DefinedName -split '\(', 2)[0]
    $methodName = $methodName.Substring($methodName.LastIndexOf('.') + 1)
    @"
<TestRun xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010">
  <Results><UnitTestResult testName="$Name" testId="t1" executionId="e1" outcome="$Outcome" /></Results>
  <TestDefinitions><UnitTest id="t1" name="$DefinedName"><Execution id="e1" /><TestMethod className="Example" name="$methodName" /></UnitTest></TestDefinitions>
  <TestEntries><TestEntry testId="t1" executionId="$EntryId" /></TestEntries>
  <ResultSummary><Counters total="1" executed="$Executed" passed="$Passed" failed="$Failed" notExecuted="0" /></ResultSummary>
</TestRun>
"@
}

function Require-Rejection([scriptblock]$Action, [string]$ExpectedMessage) {
    $rejected = $false
    try { & $Action | Out-Null }
    catch {
        if ($ExpectedMessage -and !$_.Exception.Message.Contains($ExpectedMessage)) { throw }
        $rejected = $true
    }
    if (!$rejected) { throw 'A hostile result fixture was accepted.' }
    $script:checks++
}

try {
    Receipt | Set-Content -LiteralPath $currentPath -Encoding UTF8
    Receipt | Set-Content -LiteralPath $referencePath -Encoding UTF8
    $result = & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 0
    if ($result.Passed -ne 1 -or !$result.ExactCaseMapping) { throw 'Valid receipt rejected.' }
    $checks++

    Receipt -Name 'Example.Case(value: 2)' -DefinedName 'Example.Case' |
        Set-Content -LiteralPath $currentPath -Encoding UTF8
    Copy-Item -LiteralPath $currentPath -Destination $referencePath
    $result = & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 0
    if ($result.Passed -ne 1) { throw 'Canonical theory mapping rejected.' }
    $checks++

    Receipt | Set-Content -LiteralPath $currentPath -Encoding UTF8
    Receipt | Set-Content -LiteralPath $referencePath -Encoding UTF8
    Require-Rejection { & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 1 } 'actual native test exit'
    Require-Rejection { & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode $null }
    (Receipt).Replace('<ResultSummary>', '<ResultSummary outcome="Aborted">') |
        Set-Content -LiteralPath $currentPath -Encoding UTF8
    Require-Rejection { & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 0 } 'erroneous terminal'
    Receipt -EntryId 'wrong' | Set-Content -LiteralPath $currentPath -Encoding UTF8
    Require-Rejection { & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 0 } 'lost its definition or execution entry'
    Receipt -DefinedName 'Another.Case' | Set-Content -LiteralPath $currentPath -Encoding UTF8
    Require-Rejection { & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 0 } 'mapping disagree'
    Receipt -Executed 0 | Set-Content -LiteralPath $currentPath -Encoding UTF8
    Require-Rejection { & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 0 } 'counters disagree'
    Receipt -Outcome Failed -Passed 0 -Failed 1 | Set-Content -LiteralPath $currentPath -Encoding UTF8
    Require-Rejection { & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 0 } 'unclassified execution to pass'
    Receipt -Outcome NotExecuted -Executed 0 -Passed 0 | Set-Content -LiteralPath $currentPath -Encoding UTF8
    Require-Rejection { & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 0 } 'unclassified execution to pass'
    Receipt -Name 'Example.NewCase' | Set-Content -LiteralPath $currentPath -Encoding UTF8
    Require-Rejection { & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 0 } 'predeclared full/focused case union'
    '<TestRun xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010" />' |
        Set-Content -LiteralPath $currentPath -Encoding UTF8
    Require-Rejection { & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 0 } 'counters are absent'

    Receipt | Set-Content -LiteralPath $currentPath -Encoding UTF8
    Receipt | Set-Content -LiteralPath $referencePath -Encoding UTF8
    Copy-Item -LiteralPath $currentPath -Destination $secondPath
    Require-Rejection { & $verifier -ReceiptPaths @($currentPath, $secondPath) -ReferencePaths $referencePath -NativeExitCode 0 } 'more than once'

    Receipt -Name 'Example.Other' | Set-Content -LiteralPath $secondPath -Encoding UTF8
    Require-Rejection { & $verifier -ReceiptPaths @($currentPath, $secondPath) -ReferencePaths @($referencePath, $secondPath) -NativeExitCode 0 } 'test identity is duplicated'
    (Receipt -Name 'Example.Other').Replace('testId="t1"', 'testId="t2"').Replace('id="t1"', 'id="t2"') |
        Set-Content -LiteralPath $secondPath -Encoding UTF8
    Require-Rejection { & $verifier -ReceiptPaths @($currentPath, $secondPath) -ReferencePaths @($referencePath, $secondPath) -NativeExitCode 0 } 'execution identity is duplicated'
    (Get-Content -LiteralPath $secondPath -Raw).Replace('executionId="e1"', 'executionId="e2"').Replace('id="e1"', 'id="e2"') |
        Set-Content -LiteralPath $secondPath -Encoding UTF8
    $result = & $verifier -ReceiptPaths @($currentPath, $secondPath) -ReferencePaths @($referencePath, $secondPath) -NativeExitCode 0
    if ($result.Passed -ne 2) { throw 'Distinct merged executions rejected.' }
    $checks++

    Receipt -Outcome NotExecuted -Executed 0 -Passed 0 |
        Set-Content -LiteralPath $referencePath -Encoding UTF8
    $result = & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 0
    if ($result.Passed -ne 1) { throw 'Preserved historical skipped-row convention rejected.' }
    $checks++
    Receipt -Outcome NotExecuted -Executed 0 -Passed 0 | Set-Content -LiteralPath $currentPath -Encoding UTF8
    $result = & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 0 -AllowedSkippedCases 'Example.Case'
    if ($result.Passed -ne 0 -or $result.Skipped -ne 1) { throw 'Named platform skip was not preserved.' }
    $checks++

    Receipt -Outcome Failed -Passed 0 -Failed 1 | Set-Content -LiteralPath $currentPath -Encoding UTF8
    Receipt | Set-Content -LiteralPath $referencePath -Encoding UTF8
    $result = & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 1 -AllowedFailedCases 'Example.Case'
    if (!$result.MatrixQualified -or $result.FullAccepted -or $result.Failed -ne 1) { throw 'Known FAIL became a passing full.' }
    $checks++
    Require-Rejection { & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode -1 -AllowedFailedCases 'Example.Case' } 'interrupted'

    $empty = '<TestRun xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010"><ResultSummary><Counters total="0" executed="0" passed="0" failed="0" notExecuted="0" /></ResultSummary></TestRun>'
    $empty | Set-Content -LiteralPath $secondPath -Encoding UTF8
    Receipt | Set-Content -LiteralPath $currentPath -Encoding UTF8
    $result = & $verifier -ReceiptPaths @($currentPath, $secondPath) -ReferencePaths $referencePath -NativeExitCode 0
    if ($result.Passed -ne 1 -or $result.EmptyReceipts -ne 1) { throw 'Legitimate empty filtered receipt was rejected.' }
    $checks++
    Require-Rejection { & $verifier -ReceiptPaths $secondPath -ReferencePaths $secondPath -NativeExitCode 0 } 'empty reference matrix'
    $empty.Replace('executed="0"', 'executed="1"') | Set-Content -LiteralPath $secondPath -Encoding UTF8
    Require-Rejection { & $verifier -ReceiptPaths @($currentPath, $secondPath) -ReferencePaths $referencePath -NativeExitCode 0 } 'counters disagree'

    $unicode = (Receipt -Name 'Example.Case(value: &#x416;)' -DefinedName 'Example.Case')
    [IO.File]::WriteAllText($currentPath, $unicode, (New-Object Text.UTF8Encoding($false)))
    [IO.File]::WriteAllText($referencePath, $unicode, (New-Object Text.UTF8Encoding($false)))
    $result = & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 0
    if ($result.Passed -ne 1) { throw 'UTF-8 theory without BOM was rejected.' }
    $checks++

    $theory = Receipt -Name 'Example.Case(value: 1)' -DefinedName 'Example.Case'
    $theory = $theory.Replace('</Results>', '<UnitTestResult testName="Example.Case(value: 2)" testId="t1" executionId="e2" outcome="Passed" /></Results>')
    $theory = $theory.Replace('</TestEntries>', '<TestEntry testId="t1" executionId="e2" /></TestEntries>')
    $theory = $theory.Replace('total="1"', 'total="2"').Replace('executed="1"', 'executed="2"').Replace('passed="1"', 'passed="2"')
    $theory | Set-Content -LiteralPath $currentPath -Encoding UTF8
    $theory | Set-Content -LiteralPath $referencePath -Encoding UTF8
    $result = & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 0
    if ($result.Passed -ne 2) { throw 'Runtime theory rows sharing one method definition were rejected.' }
    $checks++

    $collision = Receipt -Name 'Example.Case(value: 1)' -DefinedName 'Example.Case'
    $collision = $collision.Replace('</Results>', '<UnitTestResult testName="Example.Case(value: 1)" testId="t2" executionId="e2" outcome="Passed" /></Results>')
    $collision = $collision.Replace('</TestDefinitions>', '<UnitTest id="t2" name="Example.Case"><Execution id="e2" /><TestMethod className="Example" name="Case" /></UnitTest></TestDefinitions>')
    $collision = $collision.Replace('</TestEntries>', '<TestEntry testId="t2" executionId="e2" /></TestEntries>')
    $collision = $collision.Replace('total="1"', 'total="2"').Replace('executed="1"', 'executed="2"').Replace('passed="1"', 'passed="2"')
    $collision | Set-Content -LiteralPath $currentPath -Encoding UTF8
    $collision | Set-Content -LiteralPath $referencePath -Encoding UTF8
    $result = & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 0
    if ($result.Required -ne 2) { throw 'Distinct cases with the same display name were collapsed.' }
    $checks++
    $collision.Replace('outcome="Passed"', 'outcome="Failed"').Replace('passed="2"', 'passed="0"').Replace('failed="0"', 'failed="2"') |
        Set-Content -LiteralPath $currentPath -Encoding UTF8
    $result = & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 1 -AllowedFailedCases 'Example.Case(value: 1)'
    if ($result.Failed -ne 2 -or $result.FullAccepted) { throw 'Failed display-name collisions lost executions.' }
    $checks++
    $collision.Replace('outcome="Passed"', 'outcome="NotExecuted"').Replace('passed="2"', 'passed="0"').Replace('executed="2"', 'executed="0"') |
        Set-Content -LiteralPath $currentPath -Encoding UTF8
    $result = & $verifier -ReceiptPaths $currentPath -ReferencePaths $referencePath -NativeExitCode 0 -AllowedSkippedCases 'Example.Case(value: 1)'
    if ($result.Skipped -ne 2) { throw 'Skipped display-name collisions lost executions.' }
    $checks++

    $ownProcess = Get-Process -Id $PID
    $ownStarted = $ownProcess.StartTime.ToUniversalTime()
    [pscustomobject]@{ RunnerProcessId = $PID; RunnerProcessStartedAt = $ownStarted.ToString('o') } |
        ConvertTo-Json | Set-Content -LiteralPath (Join-Path $root 'running.json') -Encoding UTF8
    $status = Get-TestGateStatus $root
    if ($status.State -ne 'Running' -or $status.FullAccepted) { throw 'An exact live native start receipt was rejected.' }
    $checks++
    [pscustomobject]@{ RunnerProcessId = $PID; RunnerProcessStartedAt = $ownStarted.AddTicks(-1).ToString('o') } |
        ConvertTo-Json | Set-Content -LiteralPath (Join-Path $root 'running.json') -Encoding UTF8
    $status = Get-TestGateStatus $root
    if ($status.State -ne 'Interrupted' -or $status.FullAccepted) { throw 'A reused PID or different process start was accepted.' }
    $checks++
    [pscustomobject]@{ RunnerProcessId = $PID; RunnerProcessStartedAt = 'invalid-start' } |
        ConvertTo-Json | Set-Content -LiteralPath (Join-Path $root 'running.json') -Encoding UTF8
    $status = Get-TestGateStatus $root
    if ($status.State -ne 'Interrupted' -or $status.FullAccepted) { throw 'A malformed process start was accepted.' }
    $checks++
    [pscustomobject]@{ RunnerProcessId = 2147483647; RunnerProcessStartedAt = '2000-01-01T00:00:00Z' } |
        ConvertTo-Json | Set-Content -LiteralPath (Join-Path $root 'running.json') -Encoding UTF8
    $status = Get-TestGateStatus $root
    if ($status.State -ne 'Interrupted' -or $status.FullAccepted) { throw 'Missing native terminal was accepted.' }
    $checks++
    Remove-Item -LiteralPath (Join-Path $root 'running.json')
    $module = Get-Module TestGate
    $beforeGit = [Environment]::GetEnvironmentVariable('GIT_CONFIG_COUNT')
    $native = & $module {
        param($LogRoot)
        Invoke-TestGateNative -Executable (Get-Command powershell.exe -ErrorAction Stop).Source `
            -Arguments @('-NoProfile', '-Command', 'if($env:GIT_CONFIG_COUNT){exit 9};exit 0') `
            -WorkingDirectory $LogRoot -LogPath (Join-Path $LogRoot 'native.txt')
    } $root
    if ($native.ExitCode -ne 0 -or [Environment]::GetEnvironmentVariable('GIT_CONFIG_COUNT') -cne $beforeGit) {
        throw 'Native Git authority overrides were not isolated/restored.'
    }
    $checks++
    $inventoryRepo = Join-Path $inventoryRoot 'node'
    $fixtureOutput = Join-Path $inventoryRepo 'tests\Example.Tests\bin\Release\net10.0\Fixtures'
    $null = New-Item -ItemType Directory -Path $fixtureOutput -Force
    foreach ($relative in @('docs\architecture', 'docs\survival-program\decisions',
        'docs\survival-program\releases\v3.0.0\specs', 'scripts')) {
        $null = New-Item -ItemType Directory -Path (Join-Path $inventoryRoot $relative) -Force
    }
    & git -C $inventoryRepo init --quiet
    if ($LASTEXITCODE -ne 0) { throw 'Cannot initialize disposable input inventory fixture.' }
    '<Solution><Project Path="tests/Example.Tests/Example.Tests.csproj" /></Solution>' |
        Set-Content -LiteralPath (Join-Path $inventoryRepo 'Node.slnx') -Encoding UTF8
    $helper = Join-Path $fixtureOutput 'configured-ingress.cjs'
    'process.exit(0);' | Set-Content -LiteralPath $helper -Encoding UTF8
    $capture = Get-TestGateInputs -WorkspaceRoot $inventoryRoot -Repositories @('node') `
        -Configuration Release -BinaryRepository node -Solution Node.slnx
    $helperRelative = 'node/tests/Example.Tests/bin/Release/net10.0/Fixtures/configured-ingress.cjs'
    $helperInput = @($capture | Where-Object { $_.Path.Replace('\', '/') -ceq $helperRelative })
    if ($helperInput.Count -ne 1) { throw 'Copied executable HTTP/2 helper escaped frozen binary inventory.' }
    'process.exit(1);' | Set-Content -LiteralPath $helper -Encoding UTF8
    $changedCapture = Get-TestGateInputs -WorkspaceRoot $inventoryRoot -Repositories @('node') `
        -Configuration Release -BinaryRepository node -Solution Node.slnx
    if ((ConvertTo-Json -InputObject $capture -Compress) -ceq (ConvertTo-Json -InputObject $changedCapture -Compress)) {
        throw 'Executable helper byte substitution did not change captured inputs.'
    }
    $checks += 2
    Write-Output "Unified test-gate contracts passed: $checks"
} finally {
    if (Test-Path -LiteralPath $inventoryRoot) {
        $resolvedInventory = [IO.Path]::GetFullPath($inventoryRoot)
        $expectedInventory = [IO.Path]::GetFullPath((Join-Path $root 'inputs'))
        if ($resolvedInventory -cne $expectedInventory -or
            !$resolvedInventory.StartsWith([IO.Path]::GetFullPath($root) + [IO.Path]::DirectorySeparatorChar,
                [StringComparison]::OrdinalIgnoreCase)) { throw 'Unexpected inventory cleanup target.' }
        Remove-Item -LiteralPath $resolvedInventory -Recurse -Force
    }
    foreach ($path in @($currentPath, $referencePath, $secondPath, (Join-Path $root 'running.json'), (Join-Path $root 'terminal.json'),
        (Join-Path $root 'native.txt'), (Join-Path $root 'native.txt.stderr'))) {
        if (Test-Path -LiteralPath $path) { Remove-Item -LiteralPath $path }
    }
    if (Test-Path -LiteralPath (Join-Path $root 'native-temp')) { [IO.Directory]::Delete((Join-Path $root 'native-temp'), $false) }
    [IO.Directory]::Delete($root, $false)
}
