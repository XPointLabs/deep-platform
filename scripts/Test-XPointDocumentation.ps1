[CmdletBinding()]
param(
    [switch] $RenderedOutput
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$publishedRoot = [IO.Path]::GetFullPath((Join-Path $repositoryRoot 'xpoint-docs'))
$bookRoot = Join-Path $publishedRoot '_book'
$utf8 = [Text.UTF8Encoding]::new($false, $true)
$checks = 0

function Assert-Documentation([bool] $Condition, [string] $Message) {
    if (-not $Condition) {
        throw "XPoint documentation gate failed: $Message"
    }
    $script:checks++
}

function Read-StrictUtf8([string] $Path) {
    return $utf8.GetString([IO.File]::ReadAllBytes($Path))
}

function Get-PublicMarkdown {
    return @(Get-ChildItem -LiteralPath $publishedRoot -Recurse -File -Filter '*.md' |
        Where-Object {
            $_.Name -notin @('AGENTS.md', 'SUMMARY.md') -and
            $_.FullName -notmatch '[\\/](node_modules|_book)[\\/]'
        })
}

$summaryPath = Join-Path $publishedRoot 'SUMMARY.md'
Assert-Documentation (Test-Path -LiteralPath $summaryPath -PathType Leaf) 'SUMMARY.md is missing'
$summary = Read-StrictUtf8 $summaryPath
$publicPages = Get-PublicMarkdown
Assert-Documentation ($publicPages.Count -gt 0) 'no public pages were found'

$allMarkdown = @($publicPages) + @(Get-Item -LiteralPath $summaryPath)
foreach ($file in $allMarkdown) {
    $text = Read-StrictUtf8 $file.FullName
    Assert-Documentation (-not $text.Contains([char] 0xfffd)) "invalid UTF-8 in $($file.FullName)"
    Assert-Documentation (-not $text.Contains([char] 0x0000)) "NUL byte in $($file.FullName)"
    Assert-Documentation ($text -notmatch '(?i)C:\\Users\\[^\\\s]+|C:\\Work\\DeepSession\\secrets|-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----') "private path or key material marker in $($file.FullName)"
}

foreach ($page in $publicPages) {
    $relative = $page.FullName.Substring($publishedRoot.Length).TrimStart('\', '/').Replace('\', '/')
    Assert-Documentation ($summary.Contains("($relative)")) "SUMMARY.md does not reach $relative"
}

$linkPattern = [regex] '\[[^\]]*\]\((?<target>[^)]+)\)'
foreach ($file in $allMarkdown) {
    $text = Read-StrictUtf8 $file.FullName
    foreach ($match in $linkPattern.Matches($text)) {
        $target = $match.Groups['target'].Value.Trim().Trim('<', '>')
        if ($target.Length -eq 0 -or $target.StartsWith('#') -or
            $target -match '^[A-Za-z][A-Za-z0-9+.-]*:') {
            continue
        }
        $relativeTarget = ($target -split '[?#]', 2)[0]
        if ($relativeTarget.Length -eq 0) {
            continue
        }
        $resolved = [IO.Path]::GetFullPath((Join-Path $file.DirectoryName ([Uri]::UnescapeDataString($relativeTarget))))
        Assert-Documentation ($resolved.StartsWith($publishedRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) "link escapes xpoint-docs in $($file.FullName)"
        Assert-Documentation (Test-Path -LiteralPath $resolved) "broken relative link '$target' in $($file.FullName)"
    }
}

$packagePath = Join-Path $publishedRoot 'package.json'
$lockPath = Join-Path $publishedRoot 'package-lock.json'
$package = Get-Content -Raw -Encoding UTF8 $packagePath | ConvertFrom-Json
Assert-Documentation ($package.devDependencies.marked -eq '18.0.11') 'marked must be pinned exactly'
Assert-Documentation (-not ($package.devDependencies.PSObject.Properties.Name -contains 'honkit')) 'HonKit must not remain in package.json'
Assert-Documentation ($package.packageManager -eq 'npm@11.8.0') 'npm pin drifted'
Assert-Documentation ($package.engines.node -eq '24.13.0') 'Node.js pin drifted'
$lockValidation = @(& node -e "const fs=require('node:fs');const p=JSON.parse(fs.readFileSync(process.argv[1],'utf8'));const names=Object.keys(p.packages||{});process.exit(p.lockfileVersion===3&&p.packages?.['']?.devDependencies?.marked==='18.0.11'&&!names.includes('node_modules/honkit')&&!names.includes('node_modules/immutable')?0:1)" $lockPath 2>$null)
Assert-Documentation ($LASTEXITCODE -eq 0) 'lockfile generation/dependency closure drifted'

if ($RenderedOutput) {
    Assert-Documentation (Test-Path -LiteralPath $bookRoot -PathType Container) 'rendered _book is missing'
    $renderedPages = @(Get-ChildItem -LiteralPath $bookRoot -Recurse -File -Filter '*.html')
    Assert-Documentation ($renderedPages.Count -eq $publicPages.Count) 'rendered page count differs from public source count'
    foreach ($page in $renderedPages) {
        $text = Read-StrictUtf8 $page.FullName
        Assert-Documentation ($text.Contains('<html lang="ru">')) "Russian language marker missing in $($page.FullName)"
        Assert-Documentation ($text.Contains('Content-Security-Policy')) "CSP missing in $($page.FullName)"
        Assert-Documentation ($text -notmatch '(?i)<script\b|<iframe\b|on(?:load|error|click)\s*=') "active content in $($page.FullName)"
    }
    foreach ($privateAsset in @('AGENTS.md', 'SUMMARY.md', 'package.json', 'package-lock.json', '.nvmrc', '.bookignore', 'tools')) {
        Assert-Documentation (-not (Test-Path -LiteralPath (Join-Path $bookRoot $privateAsset))) "private tool asset published: $privateAsset"
    }
}

Write-Output "XPoint documentation gate passed: $checks checks."
