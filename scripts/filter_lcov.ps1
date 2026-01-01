# PowerShell fallback to filter coverage/lcov.info using coverage/filter.lcov
# Usage: powershell -NoProfile -ExecutionPolicy Bypass -File scripts\filter_lcov.ps1

$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$filterFile = Join-Path $root 'coverage\filter.lcov'
$input = Join-Path $root 'coverage\lcov.info'
$output = Join-Path $root 'coverage\lcov_filtered.info'

if (-not (Test-Path $input)) { Write-Error "Input lcov not found: $input"; exit 1 }
if (-not (Test-Path $filterFile)) { Write-Error "Filter file not found: $filterFile"; exit 1 }

# Read patterns, ignore comments/blank, strip quotes, normalize slashes
$patterns = Get-Content $filterFile |
	ForEach-Object { $_.Trim() } |
	Where-Object { $_ -and -not $_.StartsWith('#') } |
	ForEach-Object { $_.Trim('"').Trim("'").Replace('\','/') }

function Convert-GlobToRegex([string]$glob) {
	# Treat patterns as unix-style globs with optional globstar (**).
	# Paths are normalized to forward slashes before matching.
	$rx = '^'
	for ($i = 0; $i -lt $glob.Length; $i++) {
		$ch = $glob[$i]
		if ($ch -eq '*') {
			if (($i + 1) -lt $glob.Length -and $glob[$i + 1] -eq '*') {
				$rx += '.*'
				$i++
			} else {
				$rx += '[^/]*'
			}
		} elseif ($ch -eq '?') {
			$rx += '[^/]'
		} else {
			$rx += [regex]::Escape([string]$ch)
		}
	}
	return $rx + '$'
}

$patternRegexes = $patterns | ForEach-Object { Convert-GlobToRegex $_ }

if ($patterns.Count -eq 0) {
	Copy-Item $input $output -Force
	Write-Host "No patterns found; copied input to output: $output"
	exit 0
}

# Read entire lcov and split by end_of_record
$text = Get-Content $input -Raw -Encoding UTF8
$blocks = $text -split "end_of_record\r?\n"

$kept = @()
$removed = 0

foreach ($block in $blocks) {
	if (-not $block.Trim()) { continue }
	$sfLine = $block -split "\r?\n" | Where-Object { $_ -match '^SF:' } | Select-Object -First 1
	if (-not $sfLine) { continue }

	# Normalize path separators to forward-slashes so unix-style globs match
	$sf = $sfLine.Substring(3).Replace('\','/')

	$exclude = $false
	foreach ($rx in $patternRegexes) {
		if ($sf -match $rx) { $exclude = $true; break }
	}
	if ($exclude) { $removed++; continue }

	$kept += ($block + "end_of_record`n")
}

$dir = Split-Path $output -Parent
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
Set-Content -Path $output -Value ($kept -join "") -Encoding UTF8
Write-Host "Filtered lcov written to: $output (removed $removed records)"
exit 0
