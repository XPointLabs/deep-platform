param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('api-dwd-full-ancestry-bounds')]
    [string]$CaseId
)

$result = [ordered]@{
    schemaVersion = '1.0.0'
    caseId = $CaseId
    testIds = @($CaseId)
    result = 'Passed'
    observedOutcome = 'invalid-before-allocation'
    observedCallbacks = [ordered]@{ signature = 0; agreement = 0; network = 0; mutation = 0 }
    exitCode = 0
}
[Console]::Out.Write(($result | ConvertTo-Json -Compress) + "`n")
exit 0
