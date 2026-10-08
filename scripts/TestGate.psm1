Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$script:TestGateModulePath = $PSCommandPath

function Assert-TestGateInterpreter {
    param([ValidateSet('WindowsPowerShell51', 'PowerShell7')][string]$Interpreter)
    if (($Interpreter -eq 'WindowsPowerShell51' -and
            ($PSVersionTable.PSEdition -ne 'Desktop' -or $PSVersionTable.PSVersion.Major -ne 5 -or $PSVersionTable.PSVersion.Minor -ne 1)) -or
        ($Interpreter -eq 'PowerShell7' -and
            ($PSVersionTable.PSEdition -ne 'Core' -or $PSVersionTable.PSVersion.Major -ne 7))) {
        throw 'Run the gate with its explicitly selected PowerShell interpreter.'
    }
}

function Read-TestGateReceipt {
    param([Parameter(Mandatory = $true)][string]$Path)
    $settings = New-Object System.Xml.XmlReaderSettings
    $settings.DtdProcessing = [Xml.DtdProcessing]::Prohibit
    $settings.XmlResolver = $null
    $document = New-Object System.Xml.XmlDocument
    $document.XmlResolver = $null
    $reader = [Xml.XmlReader]::Create($Path, $settings)
    try { $document.Load($reader) } finally { $reader.Dispose() }
    $manager = New-Object System.Xml.XmlNamespaceManager($document.NameTable)
    $manager.AddNamespace('t', 'http://microsoft.com/schemas/VisualStudio/TeamTest/2010')
    $rows = @($document.SelectNodes('/t:TestRun/t:Results/t:UnitTestResult', $manager))
    $definitions = @($document.SelectNodes('/t:TestRun/t:TestDefinitions/t:UnitTest', $manager))
    $entries = @($document.SelectNodes('/t:TestRun/t:TestEntries/t:TestEntry', $manager))
    $counters = $document.SelectSingleNode('/t:TestRun/t:ResultSummary/t:Counters', $manager)
    $summary = $document.SelectSingleNode('/t:TestRun/t:ResultSummary', $manager)
    if ($null -ne $summary -and $summary.HasAttribute('outcome') -and
        $summary.GetAttribute('outcome') -cnotin @('Passed', 'Failed', 'Completed')) {
        throw 'TRX contains an incomplete or erroneous terminal.'
    }
    foreach ($required in @('total', 'executed', 'passed', 'failed', 'notExecuted')) {
        if ($null -eq $counters -or !$counters.HasAttribute($required)) { throw 'TRX counters are absent.' }
    }
    if ($definitions.Count -gt $rows.Count -or $rows.Count -ne $entries.Count -or
        ($rows.Count -gt 0 -and $definitions.Count -eq 0)) {
        throw 'Incomplete TRX execution mappings.'
    }
    $definitionMap = [Collections.Generic.Dictionary[string,object]]::new([StringComparer]::Ordinal)
    $entryMap = [Collections.Generic.Dictionary[string,string]]::new([StringComparer]::Ordinal)
    foreach ($definition in $definitions) { $definitionMap.Add($definition.GetAttribute('id'), $definition) }
    foreach ($entry in $entries) { $entryMap.Add($entry.GetAttribute('executionId'), $entry.GetAttribute('testId')) }
    $names = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $ids = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $executions = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $failures = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $skips = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $methods = [Collections.Generic.Dictionary[string,string]]::new([StringComparer]::Ordinal)
    $caseKeys = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $usedDefinitions = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $passed = 0; $failedCount = 0; $skippedCount = 0
    foreach ($row in $rows) {
        $name = $row.GetAttribute('testName'); $id = $row.GetAttribute('testId'); $execution = $row.GetAttribute('executionId')
        if ([string]::IsNullOrWhiteSpace($name) -or [string]::IsNullOrWhiteSpace($id) -or
            [string]::IsNullOrWhiteSpace($execution) -or !$caseKeys.Add($id + [char]31 + $name) -or !$executions.Add($execution)) {
            throw 'Empty or duplicate test identity.'
        }
        $null = $names.Add($name)
        $newIdentity = $ids.Add($id)
        if (!$definitionMap.ContainsKey($id) -or !$entryMap.ContainsKey($execution)) {
            throw 'A result lost its definition or execution entry.'
        }
        $definition = $definitionMap[$id]
        $definedName = $definition.GetAttribute('name')
        $definedExecution = $definition.SelectSingleNode('t:Execution', $manager)
        $method = $definition.SelectSingleNode('t:TestMethod', $manager)
        if ($null -eq $definedExecution -or $null -eq $method -or [string]::IsNullOrWhiteSpace($definedName) -or
            [string]::IsNullOrWhiteSpace($method.GetAttribute('className')) -or [string]::IsNullOrWhiteSpace($method.GetAttribute('name')) -or
            !$entryMap.ContainsKey($definedExecution.GetAttribute('id')) -or
            $entryMap[$definedExecution.GetAttribute('id')] -cne $id -or $entryMap[$execution] -cne $id -or
            !($name -ceq $definedName -or $name.StartsWith($definedName + '(', [StringComparison]::Ordinal))) {
            throw 'Result, method, definition and execution mapping disagree.'
        }
        $methodName = $method.GetAttribute('className') + '.' + $method.GetAttribute('name')
        if (!$newIdentity -and !$name.StartsWith($methodName + '(', [StringComparison]::Ordinal)) {
            throw 'Only distinct theory rows may share a method definition identity.'
        }
        if (!($name -ceq $methodName -or $name.StartsWith($methodName + '(', [StringComparison]::Ordinal))) {
            throw 'The result does not identify its declared method.'
        }
        $methods.Add($id + [char]31 + $name, $methodName)
        $null = $usedDefinitions.Add($id)
        switch -CaseSensitive ($row.GetAttribute('outcome')) {
            'Passed' { $passed++ }
            'Failed' { $failedCount++; $null = $failures.Add($name) }
            'NotExecuted' { $skippedCount++; $null = $skips.Add($name) }
            default { throw 'Unsupported or incomplete execution outcome.' }
        }
    }
    if ($usedDefinitions.Count -ne $definitionMap.Count) { throw 'An orphaned test definition is present.' }
    if ([int]$counters.GetAttribute('total') -ne $rows.Count -or
        [int]$counters.GetAttribute('executed') -ne ($passed + $failedCount) -or
        [int]$counters.GetAttribute('passed') -ne $passed -or [int]$counters.GetAttribute('failed') -ne $failedCount -or
        [int]$counters.GetAttribute('notExecuted') -notin @(0, $skippedCount)) {
        throw 'TRX counters disagree with the actual result rows.'
    }
    foreach ($terminalError in @('error', 'timeout', 'aborted', 'inconclusive', 'disconnected', 'inProgress', 'pending')) {
        if ($counters.HasAttribute($terminalError) -and [int]$counters.GetAttribute($terminalError) -ne 0) {
            throw 'TRX contains an incomplete or erroneous terminal.'
        }
    }
    [pscustomobject]@{
        Names = $names; CaseKeys = $caseKeys; Ids = $ids; Executions = $executions; Methods = $methods
        Passed = $passed; FailedCount = $failedCount; SkippedCount = $skippedCount
        Failures = $failures; Skips = $skips; Empty = ($rows.Count -eq 0)
        Sha256 = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    }
}

function Test-TestGateResults {
    param(
        [Parameter(Mandatory = $true)][string[]]$ReceiptPaths,
        [Parameter(Mandatory = $true)][string[]]$ReferencePaths,
        [Parameter(Mandatory = $true)][ValidateNotNull()][Nullable[int]]$NativeExitCode,
        [string[]]$AllowedSkippedCases = @(),
        [string[]]$AllowedFailedCases = @()
    )
    if ($NativeExitCode -notin @(0, 1)) { throw 'The actual native test exit is missing or interrupted.' }
    if (!$ReceiptPaths.Count -or !$ReferencePaths.Count) { throw 'Current receipts and a predeclared reference matrix are required.' }
    $required = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $referenceMethods = [Collections.Generic.Dictionary[string,string]]::new([StringComparer]::Ordinal)
    foreach ($path in $ReferencePaths) {
        $reference = Read-TestGateReceipt $path
        foreach ($key in $reference.CaseKeys) {
            $null = $required.Add($key)
            if ($referenceMethods.ContainsKey($key) -and $referenceMethods[$key] -cne $reference.Methods[$key]) {
                throw 'Reference method bindings disagree.'
            }
            $referenceMethods[$key] = $reference.Methods[$key]
        }
    }
    if (!$required.Count) { throw 'An empty reference matrix cannot qualify a run.' }
    $names = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $ids = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $executions = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $failures = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $skips = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $allowedSkips = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $allowedFailures = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($name in $AllowedSkippedCases) { $null = $allowedSkips.Add($name) }
    foreach ($name in $AllowedFailedCases) { $null = $allowedFailures.Add($name) }
    $requiredDisplayNames = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($key in $required) { $null = $requiredDisplayNames.Add(($key -split [char]31, 2)[1]) }
    if (!$requiredDisplayNames.IsSupersetOf($allowedSkips) -or !$requiredDisplayNames.IsSupersetOf($allowedFailures)) {
        throw 'An outcome exception does not belong to the predeclared matrix.'
    }
    $hashes = @(); $emptyReceipts = 0; $passed = 0; $failedCount = 0; $skippedCount = 0
    foreach ($path in $ReceiptPaths) {
        $current = Read-TestGateReceipt $path
        if ($current.Empty) { $emptyReceipts++ }
        foreach ($key in $current.CaseKeys) {
            if (!$names.Add($key)) { throw 'A case was executed more than once across receipts.' }
            if (!$referenceMethods.ContainsKey($key) -or $referenceMethods[$key] -cne $current.Methods[$key]) {
                throw 'The predeclared full/focused case union or method binding differs from actual executions.'
            }
        }
        foreach ($id in $current.Ids) { if (!$ids.Add($id)) { throw 'A test identity is duplicated across receipts.' } }
        foreach ($execution in $current.Executions) { if (!$executions.Add($execution)) { throw 'An execution identity is duplicated across receipts.' } }
        foreach ($name in $current.Failures) { $null = $failures.Add($name) }
        foreach ($name in $current.Skips) { $null = $skips.Add($name) }
        $passed += $current.Passed; $hashes += $current.Sha256
        $failedCount += $current.FailedCount; $skippedCount += $current.SkippedCount
    }
    if (!$required.SetEquals($names)) { throw 'The predeclared full/focused case union differs from actual executions.' }
    if (!$allowedSkips.SetEquals($skips) -or !$allowedFailures.IsSupersetOf($failures)) {
        throw 'Current production qualification requires every unclassified execution to pass.'
    }
    if (($NativeExitCode -eq 0 -and $failures.Count) -or ($NativeExitCode -eq 1 -and !$failures.Count)) {
        throw 'The actual native test exit disagrees with its mapped outcomes.'
    }
    [pscustomobject]@{
        NativeExitCode = $NativeExitCode; Passed = $passed; Failed = $failedCount; Skipped = $skippedCount
        Required = $required.Count; ExactCaseMapping = $true; MatrixQualified = $true
        FullAccepted = ($NativeExitCode -eq 0 -and !$failures.Count)
        EmptyReceipts = $emptyReceipts; ReceiptSha256 = $hashes
    }
}

function Get-TestGateInputs {
    param([string]$WorkspaceRoot, [string[]]$Repositories, [string]$Configuration, [string[]]$ExtraPaths,
        [string]$BinaryRepository, [string]$Solution)
    $paths = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($repo in $Repositories) {
        $root = Join-Path $WorkspaceRoot $repo
        $inventory = @(& git -C $root ls-files -co --exclude-standard)
        if ($LASTEXITCODE -ne 0) { throw 'Cannot inventory gate inputs.' }
        foreach ($relative in $inventory) {
            if ($relative -notmatch '(^|/)(bin|obj|artifacts)/' -and
                ($relative -match '^(src|tests|eng|native|scripts)/' -or $relative -match '^[^/]+\.(slnx|props|targets|json|config)$' -or $relative -ceq 'AGENTS.md')) {
                $path = Join-Path $root $relative.Replace('/', '\')
                if (Test-Path -LiteralPath $path -PathType Leaf) { $null = $paths.Add($path) }
            }
        }
        if ($repo -eq $BinaryRepository) {
            [xml]$graph = Get-Content -LiteralPath (Join-Path $root $Solution) -Raw -Encoding UTF8
            foreach ($project in $graph.SelectNodes('//Project')) {
                $relativeProject = $project.GetAttribute('Path').Replace('/', '\')
                if ($relativeProject -notmatch 'Tests[^\\]*\.csproj$') { continue }
                $projectDirectory = Split-Path -Parent (Join-Path $root $relativeProject)
                $output = Join-Path $projectDirectory ('bin\' + $Configuration + '\net10.0')
                if (Test-Path -LiteralPath $output) {
                    foreach ($file in Get-ChildItem -LiteralPath $output -Recurse -File) {
                        $relativeOutput = $file.FullName.Substring($output.Length)
                        if ($relativeOutput -match '[\\/]artifacts[\\/]') { continue }
                        if ($file.Extension -in @('.dll', '.exe', '.json', '.so', '.dylib', '.sql', '.config')) { $null = $paths.Add($file.FullName) }
                    }
                }
            }
        }
    }
    foreach ($relative in @('docs\architecture', 'docs\survival-program\decisions', 'docs\survival-program\releases\v3.0.0\specs', 'scripts')) {
        $root = Join-Path $WorkspaceRoot $relative
        if (!(Test-Path -LiteralPath $root)) { throw 'A required normative/tooling directory is absent.' }
        foreach ($file in Get-ChildItem -LiteralPath $root -Recurse -File) { $null = $paths.Add($file.FullName) }
    }
    foreach ($relative in @('AGENTS.md', 'Directory.Build.props', 'Directory.Build.targets', 'global.json', 'NuGet.Config', 'nuget.config')) {
        $path = Join-Path $WorkspaceRoot $relative
        if (Test-Path -LiteralPath $path -PathType Leaf) { $null = $paths.Add($path) }
    }
    foreach ($path in $ExtraPaths) { $null = $paths.Add([IO.Path]::GetFullPath($path)) }
    $prefix = [IO.Path]::GetFullPath($WorkspaceRoot).TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
    $inputs = @($paths | Sort-Object -CaseSensitive | ForEach-Object {
        if (!$_.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) { throw 'A gate input escaped its workspace.' }
        [pscustomobject]@{ Path = $_.Substring($prefix.Length); Sha256 = (Get-FileHash -LiteralPath $_ -Algorithm SHA256).Hash }
    })
    return ,$inputs
}

function Invoke-TestGateNative {
    param([string]$Executable, [string[]]$Arguments, [string]$WorkingDirectory, [string]$LogPath, [int]$TimeoutSeconds = 0,
        [string]$WitnessPowerShellDirectory = '')
    $quoted = @($Arguments | ForEach-Object { '"' + $_.Replace('"', '\"') + '"' }) -join ' '
    $started = [DateTime]::UtcNow
    $gitAuthority = @('GIT_DIR', 'GIT_WORK_TREE', 'GIT_INDEX_FILE', 'GIT_OBJECT_DIRECTORY',
        'GIT_ALTERNATE_OBJECT_DIRECTORIES', 'GIT_COMMON_DIR', 'GIT_CONFIG', 'GIT_CONFIG_GLOBAL',
        'GIT_CONFIG_SYSTEM', 'GIT_CONFIG_NOSYSTEM', 'GIT_CONFIG_COUNT', 'GIT_CONFIG_PARAMETERS',
        'GIT_ATTR_NOSYSTEM', 'GIT_CEILING_DIRECTORIES', 'GIT_DISCOVERY_ACROSS_FILESYSTEM')
    $savedGit = @{}
    foreach ($entry in Get-ChildItem Env:) {
        if ($entry.Name -in $gitAuthority -or $entry.Name -match '^GIT_CONFIG_(KEY|VALUE)_\d+$') {
            $savedGit[$entry.Name] = $entry.Value
        }
    }
    $savedPath = $env:PATH
    $savedTemp = $env:TEMP; $savedTmp = $env:TMP
    $userTemp = Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'Temp'
    if (!(Test-Path -LiteralPath $userTemp -PathType Container)) { throw 'A supported user-local temporary directory is required.' }
    $nativeTemp = Join-Path $userTemp ('deep-test-gate-' + [Guid]::NewGuid().ToString('N'))
    $null = [IO.Directory]::CreateDirectory($nativeTemp)
    try {
        foreach ($name in $savedGit.Keys) { [Environment]::SetEnvironmentVariable($name, $null, 'Process') }
        $env:TEMP = $nativeTemp; $env:TMP = $nativeTemp
        if ($WitnessPowerShellDirectory) { $env:PATH = $WitnessPowerShellDirectory + [IO.Path]::PathSeparator + $env:PATH }
        $process = Start-Process -FilePath $Executable -ArgumentList $quoted -WorkingDirectory $WorkingDirectory `
            -NoNewWindow -PassThru -RedirectStandardOutput $LogPath -RedirectStandardError ($LogPath + '.stderr')
    } catch {
        if (@([IO.Directory]::EnumerateFileSystemEntries($nativeTemp)).Count -eq 0) {
            [IO.Directory]::Delete($nativeTemp, $false)
        }
        throw
    } finally {
        $env:PATH = $savedPath
        $env:TEMP = $savedTemp; $env:TMP = $savedTmp
        foreach ($name in $savedGit.Keys) { [Environment]::SetEnvironmentVariable($name, $savedGit[$name], 'Process') }
    }
    $null = $process.Handle
    try {
        if ($TimeoutSeconds -gt 0 -and !$process.WaitForExit($TimeoutSeconds * 1000)) {
            $owned = [Collections.Generic.HashSet[int]]::new()
            $null = $owned.Add($process.Id)
            $tree = @(Get-CimInstance Win32_Process)
            for ($pass = 0; $pass -lt $tree.Count; $pass++) {
                foreach ($child in $tree) {
                    if ($owned.Contains([int]$child.ParentProcessId)) { $null = $owned.Add([int]$child.ProcessId) }
                }
            }
            foreach ($id in $owned) {
                if ($id -ne $process.Id) { Stop-Process -Id $id -ErrorAction SilentlyContinue }
            }
            Stop-Process -Id $process.Id -ErrorAction SilentlyContinue
            $process.WaitForExit()
            throw 'The bounded fixture preflight timed out; full was not launched.'
        }
        $process.WaitForExit(); $process.Refresh()
        [pscustomobject]@{ ExitCode = $process.ExitCode; StartedAt = $started.ToString('o'); FinishedAt = [DateTime]::UtcNow.ToString('o') }
    } finally {
        $process.Dispose()
        if ([IO.Directory]::Exists($nativeTemp) -and
            @([IO.Directory]::EnumerateFileSystemEntries($nativeTemp)).Count -eq 0) {
            [IO.Directory]::Delete($nativeTemp, $false)
        }
    }
}

function Get-TestGateStatus {
    param([Parameter(Mandatory = $true)][string]$RunDirectory)
    $terminalPath = Join-Path $RunDirectory 'terminal.json'
    if (Test-Path -LiteralPath $terminalPath) {
        $terminal = Get-Content -LiteralPath $terminalPath -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($terminal.PreflightOnly -and $terminal.PreflightExitCode -eq 0 -and $terminal.QualificationExitCode -eq 0) {
            return [pscustomobject]@{ State = 'PreflightCompleted'; FullAccepted = $false }
        }
        if ($null -eq $terminal.TestExitCode -or $null -eq $terminal.QualificationExitCode) {
            return [pscustomobject]@{ State = 'InterruptedOrBlocked'; FullAccepted = $false }
        }
        return $terminal
    }
    $runningPath = Join-Path $RunDirectory 'running.json'
    if (!(Test-Path -LiteralPath $runningPath)) { throw 'The run has no start receipt.' }
    $running = Get-Content -LiteralPath $runningPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $process = Get-Process -Id $running.RunnerProcessId -ErrorAction SilentlyContinue
    $active = $null -ne $process -and $process.StartTime.ToUniversalTime().ToString('o') -ceq $running.RunnerProcessStartedAt
    [pscustomobject]@{ State = $(if ($active) { 'Running' } else { 'Interrupted' }); FullAccepted = $false }
}

function Invoke-RepositoryTestGate {
    param(
        [string]$WorkspaceRoot, [string]$Repository, [string]$Solution, [string[]]$BuildProperties,
        [string[]]$InputRepositories, [string]$RunDirectory, [string[]]$ReferencePaths,
        [string]$Configuration, [string]$Interpreter, [string[]]$AllowedSkippedCases,
        [string[]]$AllowedFailedCases, [switch]$PreflightOnly, [string]$WitnessPowerShellPath = ''
    )
    Assert-TestGateInterpreter $Interpreter
    $repoRoot = Join-Path $WorkspaceRoot $Repository
    $runRoot = [IO.Path]::GetFullPath($RunDirectory)
    $artifactRoot = [IO.Path]::GetFullPath((Join-Path $repoRoot 'artifacts')) + [IO.Path]::DirectorySeparatorChar
    if (!$runRoot.StartsWith($artifactRoot, [StringComparison]::OrdinalIgnoreCase) -or (Test-Path -LiteralPath $runRoot)) {
        throw 'Use a fresh run directory strictly inside the selected repository artifacts.'
    }
    if (!$PreflightOnly -and !$ReferencePaths.Count) { throw 'Full qualification requires a predeclared case matrix.' }
    $vectorPath = Join-Path $WorkspaceRoot 'docs\survival-program\releases\v3.0.0\specs\contact-codec-v1.vectors.json'
    if (!(Test-Path -LiteralPath $vectorPath -PathType Leaf)) { throw 'Required frozen ContactAccept vectors are absent; full was not launched.' }
    $dotnet = (Get-Command dotnet -ErrorAction Stop).Source
    $sdk = @(& $dotnet --version)
    if ($LASTEXITCODE -ne 0 -or $sdk.Count -ne 1 -or $sdk[0] -cne '10.0.301') { throw 'The gate requires SDK 10.0.301.' }
    $witnessDirectory = ''
    if ($Repository -eq 'deep-protocol') {
        if (!$WitnessPowerShellPath) {
            $command = Get-Command pwsh -ErrorAction SilentlyContinue
            if ($null -eq $command) { throw 'Protocol requires explicitly available PowerShell7.5.4 witnesses before full.' }
            $WitnessPowerShellPath = $command.Source
        }
        $witnessVersion = @(& $WitnessPowerShellPath -NoProfile -Command '$PSVersionTable.PSVersion.ToString()')
        if ($LASTEXITCODE -ne 0 -or $witnessVersion.Count -ne 1 -or $witnessVersion[0] -cne '7.5.4') {
            throw 'Protocol witness interpreter must be PowerShell7.5.4.'
        }
        $witnessDirectory = Split-Path -Parent ([IO.Path]::GetFullPath($WitnessPowerShellPath))
    }
    if ($Repository -eq 'deep-registry-api') {
        foreach ($name in @('DEEP_TEST_DID2_FLOOR_POSTGRES', 'DEEP_TEST_DID2_ROUTE_POSTGRES', 'DEEP_TEST_DID2_GRANT_POSTGRES')) {
            if ([string]::IsNullOrWhiteSpace([Environment]::GetEnvironmentVariable($name))) {
                throw 'The Registry gate requires its disposable local PostgreSQL provider.'
            }
        }
    }
    $lockDirectory = Join-Path $WorkspaceRoot '.tmp'
    $null = [IO.Directory]::CreateDirectory($lockDirectory)
    $lease = [IO.File]::Open((Join-Path $lockDirectory 'repository-test-gate.lock'), [IO.FileMode]::OpenOrCreate, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None)
    $started = [DateTime]::UtcNow
    $buildExit = $null; $preflightExit = $null; $testExit = $null; $qualificationExit = $null
    $failure = $null; $qualified = $null; $inputs = @(); $preflightTime = 0
    $null = [IO.Directory]::CreateDirectory($runRoot)
    try {
        [pscustomobject]@{
            RunnerProcessId = $PID; RunnerProcessStartedAt = (Get-Process -Id $PID).StartTime.ToUniversalTime().ToString('o')
            StartedAt = $started.ToString('o'); Interpreter = $Interpreter; PowerShellVersion = $PSVersionTable.PSVersion.ToString()
        } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $runRoot 'running.json') -Encoding UTF8
        $build = Invoke-TestGateNative $dotnet (@('build', $Solution, '-c', $Configuration, '--no-restore', '-m:1', '-warnaserror', '--verbosity', 'quiet') + $BuildProperties) $repoRoot (Join-Path $runRoot 'build.txt') 0 $witnessDirectory
        $buildExit = $build.ExitCode
        if ($buildExit -ne 0) { throw 'The current solution build failed; full was not launched.' }
        $extra = @($ReferencePaths) + @($vectorPath, (Join-Path $WorkspaceRoot 'scripts\Invoke-RepositoryTestGate.ps1'), $script:TestGateModulePath)
        $inputs = Get-TestGateInputs $WorkspaceRoot $InputRepositories $Configuration $extra $Repository $Solution
        [pscustomobject]@{ CapturedAt = [DateTime]::UtcNow.ToString('o'); Inputs = $inputs } |
            ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $runRoot 'inputs.json') -Encoding UTF8
        $preflightRoot = Join-Path $runRoot 'preflight'
        $null = [IO.Directory]::CreateDirectory($preflightRoot)
        $preflight = Invoke-TestGateNative $dotnet (@('test', $Solution, '-c', $Configuration, '--no-build', '--no-restore', '-m:1',
            '--filter', 'FixturePreflight=true', '--logger', 'trx', '--results-directory', $preflightRoot, '--verbosity', 'quiet') + $BuildProperties) $repoRoot (Join-Path $runRoot 'preflight.txt') 120 $witnessDirectory
        $preflightExit = $preflight.ExitCode
        $preflightTime = ([DateTime]::Parse($preflight.FinishedAt) - [DateTime]::Parse($preflight.StartedAt)).TotalSeconds
        $preflightMethods = [Collections.Generic.Dictionary[string,string]]::new([StringComparer]::Ordinal)
        $preflightExecutions = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
        $preflightCount = 0
        foreach ($file in Get-ChildItem -LiteralPath $preflightRoot -Filter '*.trx' -File) {
            $receipt = Read-TestGateReceipt $file.FullName
            if ($receipt.Failures.Count -or $receipt.Skips.Count) { throw 'A fixture preflight failed or skipped; full was not launched.' }
            foreach ($key in $receipt.CaseKeys) {
                if ($preflightMethods.ContainsKey($key)) { throw 'A fixture prerequisite was executed more than once.' }
                $preflightMethods.Add($key, $receipt.Methods[$key])
            }
            foreach ($execution in $receipt.Executions) {
                if (!$preflightExecutions.Add($execution)) { throw 'A fixture prerequisite execution identity is duplicated.' }
            }
            $preflightCount += $receipt.Passed
        }
        if ($preflightExit -ne 0 -or !$preflightCount) { throw 'The fixture preflight has no successful terminal and executions; full was not launched.' }
        if (!$PreflightOnly) {
            $expectedPreflight = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
            foreach ($path in $ReferencePaths) {
                $reference = Read-TestGateReceipt $path
                foreach ($key in $reference.CaseKeys) {
                    $name = ($key -split [char]31, 2)[1]
                    if ($name.Contains('.FixturePreflight_') -or $name.Contains('.CurrentDesktopCandidate_ExactAssetSignsVerifiesAndRejectsSubstitution')) {
                        $null = $expectedPreflight.Add($key)
                        if (!$preflightMethods.ContainsKey($key) -or $preflightMethods[$key] -cne $reference.Methods[$key]) {
                            throw 'Preflight executions differ from the predeclared current prerequisite matrix; full was not launched.'
                        }
                    }
                }
            }
            if (!$expectedPreflight.Count -or !$expectedPreflight.SetEquals($preflightMethods.Keys)) {
                throw 'Preflight executions differ from the predeclared current prerequisite matrix; full was not launched.'
            }
            $preflightInputs = Get-TestGateInputs $WorkspaceRoot $InputRepositories $Configuration $extra $Repository $Solution
            if ((ConvertTo-Json -InputObject $inputs -Compress) -cne (ConvertTo-Json -InputObject $preflightInputs -Compress)) {
                throw 'Captured inputs changed during fixture preflight; full was not launched.'
            }
            $fullRoot = Join-Path $runRoot 'full'
            $null = [IO.Directory]::CreateDirectory($fullRoot)
            $testArguments = @('test', $Solution, '-c', $Configuration, '--no-build', '--no-restore', '-m:1',
                '--logger', 'trx', '--results-directory', $fullRoot, '--verbosity', 'quiet') + $BuildProperties
            $test = Invoke-TestGateNative $dotnet $testArguments $repoRoot (Join-Path $runRoot 'test.txt') 0 $witnessDirectory
            $testExit = $test.ExitCode
            $receipts = @(Get-ChildItem -LiteralPath $fullRoot -Filter '*.trx' -File | ForEach-Object { $_.FullName })
            $qualified = Test-TestGateResults -ReceiptPaths $receipts -ReferencePaths $ReferencePaths -NativeExitCode $testExit `
                -AllowedSkippedCases $AllowedSkippedCases -AllowedFailedCases $AllowedFailedCases
            $qualified | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $runRoot 'qualification.json') -Encoding UTF8
        }
        $currentInputs = Get-TestGateInputs $WorkspaceRoot $InputRepositories $Configuration $extra $Repository $Solution
        if ((ConvertTo-Json -InputObject $inputs -Compress) -cne (ConvertTo-Json -InputObject $currentInputs -Compress)) {
            throw 'The captured input set or its bytes changed during the gate.'
        }
        $qualificationExit = 0
    } catch {
        $failure = $_.Exception.GetType().FullName
        Write-Error -Message $_.Exception.Message -ErrorAction Continue
        $qualificationExit = 1
    } finally {
        try {
            [pscustomobject]@{
            State = $(if ($qualificationExit -eq 0) { 'Completed' } else { 'FailedOrBlocked' })
            StartedAt = $started.ToString('o'); FinishedAt = [DateTime]::UtcNow.ToString('o')
            Interpreter = $Interpreter; PowerShellVersion = $PSVersionTable.PSVersion.ToString(); SdkVersion = $sdk[0]
            WitnessPowerShellVersion = $(if ($witnessDirectory) { '7.5.4' } else { $null })
            BuildExitCode = $buildExit; PreflightExitCode = $preflightExit; TestExitCode = $testExit
            QualificationExitCode = $qualificationExit; PreflightSeconds = $preflightTime
            CapturedInputs = $inputs.Count; FailureType = $failure; PreflightOnly = [bool]$PreflightOnly
            FullAccepted = (!$PreflightOnly -and $null -ne $qualified -and $qualified.FullAccepted -and $qualificationExit -eq 0)
            } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $runRoot 'terminal.json') -Encoding UTF8
        } finally { $lease.Dispose() }
    }
    if ($qualificationExit -eq 0 -and ($PreflightOnly -or $testExit -eq 0)) { return 0 }
    return 1
}

Export-ModuleMember -Function Assert-TestGateInterpreter, Read-TestGateReceipt, Test-TestGateResults, Get-TestGateInputs, Get-TestGateStatus, Invoke-RepositoryTestGate
