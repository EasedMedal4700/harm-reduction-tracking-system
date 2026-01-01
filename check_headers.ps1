param(
    [string]$RootDir = "lib",
    [string]$OutputJson = "migration_headers.json"
)

$allowedState = @(
    "LEGACY",
    "PARTIAL",
    "MODERN",
    "MODERN (UI-only)"
)

$allowedNavigation = @(
    "LEGACY",
    "CENTRALIZED",
    "GOROUTER"
)

$allowedModels = @(
    "LEGACY",
    "FREEZED"
)

$allowedTheme = @(
    "LEGACY",
    "COMPLETE"
)

$allowedCommon = @(
    "LEGACY",
    "COMPLETE"
)

$requiredFields = @(
    "// MIGRATION:",
    "// State:",
    "// Navigation:",
    "// Models:",
    "// Theme:",
    "// Common:",
    "// Notes:"
)

$errors = @()
$allHeaders = @{}
$fileSamples = @{}

$workspaceRoot = Split-Path (Resolve-Path $RootDir) -Parent
$libPath = Join-Path $workspaceRoot "lib"

Get-ChildItem -Path $RootDir -Recurse -Filter "*.dart" | Where-Object {
    $_.Name -notlike "*.g.dart" -and $_.Name -notlike "*.freezed.dart"
} | ForEach-Object {
    $filePath = $_.FullName -replace "C:\\Users\\USER\\dev\\code\\mobile_drug_use_app\\", ""
    try {
        $content = Get-Content -Path $_.FullName -Encoding UTF8 -TotalCount 20
        $header = $content -join "`n"
        $allHeaders[$filePath] = $header

        # Read a bigger sample for heuristic scanning (imports + some code)
        $sampleLines = Get-Content -Path $_.FullName -Encoding UTF8 -TotalCount 400
        $fileSamples[$filePath] = ($sampleLines -join "`n")

        $missing = @()
        foreach ($field in $requiredFields) {
            if ($header -notmatch [regex]::Escape($field)) {
                $missing += $field
            }
        }
        if ($missing) {
            $errors += "$filePath : Missing $($missing -join ', ')"
        }

        # Enforce exact first line (no BOM/no deviations)
        $firstLine = ($content | Select-Object -First 1)
        if ($firstLine -ne "// MIGRATION:") {
            $errors += "$filePath : Header must start with exact '// MIGRATION:'"
        }

        # Disallowed legacy tracking field
        if ($header -match "^//\s*Riverpod:\s*" ) {
            $errors += "$filePath : Disallowed header field '// Riverpod:' (remove; use State + Notes)"
        }

        # Disallowed TODO markers for Theme/Common
        if ($header -match "^//\s*Theme:\s*TODO\b" ) {
            $errors += "$filePath : Disallowed value 'Theme: TODO' (must be LEGACY or COMPLETE)"
        }
        if ($header -match "^//\s*Common:\s*TODO\b" ) {
            $errors += "$filePath : Disallowed value 'Common: TODO' (must be LEGACY or COMPLETE)"
        }

        # Validate allowed enums when present
        if ($header -match "^//\s*State:\s*(.+)$" ) {
            $v = $Matches[1].Trim()
            if (-not ($allowedState -contains $v)) {
                $errors += "$filePath : Invalid State '$v'"
            }
        }
        if ($header -match "^//\s*Navigation:\s*(.+)$" ) {
            $v = $Matches[1].Trim()
            if (-not ($allowedNavigation -contains $v)) {
                $errors += "$filePath : Invalid Navigation '$v'"
            }
        }
        if ($header -match "^//\s*Models:\s*(.+)$" ) {
            $v = $Matches[1].Trim()
            if (-not ($allowedModels -contains $v)) {
                $errors += "$filePath : Invalid Models '$v'"
            }
        }
        if ($header -match "^//\s*Theme:\s*(.+)$" ) {
            $v = $Matches[1].Trim()
            if (-not ($allowedTheme -contains $v)) {
                $errors += "$filePath : Invalid Theme '$v'"
            }
        }
        if ($header -match "^//\s*Common:\s*(.+)$" ) {
            $v = $Matches[1].Trim()
            if (-not ($allowedCommon -contains $v)) {
                $errors += "$filePath : Invalid Common '$v'"
            }
        }
    } catch {
        $errors += "$filePath : Error reading file - $($_.Exception.Message)"
    }
}

# Create separate JSON files for different migration aspects
$commonTodo = @{}
$themeTodo = @{}
$gorouterReady = @{}
$navigationLegacy = @{}
$freezedModels = @{}
$providerUsage = @{}
$navigatorUsage = @{}

foreach ($file in $allHeaders.Keys) {
    $header = $allHeaders[$file]
    $sample = $fileSamples[$file]
    
    # With the new header spec, TODO is invalid. Treat LEGACY as the actionable state.
    if ($header -match "// Common: LEGACY") {
        $commonTodo[$file] = $header
    }
    if ($header -match "// Theme: LEGACY") {
        $themeTodo[$file] = $header
    }
    if ($header -match "// Navigation: GOROUTER" -or $header -match "// Navigation: GOROUTER-READY") {
        $gorouterReady[$file] = $header
    }
    if ($header -match "// Navigation: LEGACY") {
        $navigationLegacy[$file] = $header
    }
    if ($header -match "// Models: FREEZED") {
        $freezedModels[$file] = $header
    }

    # Heuristics to find Riverpod migration work:
    # - using provider package suggests legacy state management
    if ($sample -match "package:provider/provider\.dart") {
        $providerUsage[$file] = $header
    }

    # Heuristics to find widget-level navigation calls (should be centralized)
    if ($sample -match "Navigator\.of\(" -or $sample -match "context\.go\(" -or $sample -match "GoRouter\.of\(" -or $sample -match "context\.push\(" -or $sample -match "context\.pop\(") {
        $navigatorUsage[$file] = $header
    }
}

# Output separate text files for different migration aspects
$commonTodo.Keys | Sort-Object | Out-File -FilePath "migration/common_todo.txt" -Encoding UTF8
$themeTodo.Keys | Sort-Object | Out-File -FilePath "migration/theme_todo.txt" -Encoding UTF8
$gorouterReady.Keys | Sort-Object | Out-File -FilePath "migration/gorouter_ready.txt" -Encoding UTF8
$navigationLegacy.Keys | Sort-Object | Out-File -FilePath "migration/navigation_legacy.txt" -Encoding UTF8
$freezedModels.Keys | Sort-Object | Out-File -FilePath "migration/freezed_models.txt" -Encoding UTF8
$providerUsage.Keys | Sort-Object | Out-File -FilePath "migration/provider_usage.txt" -Encoding UTF8
$navigatorUsage.Keys | Sort-Object | Out-File -FilePath "migration/navigator_usage.txt" -Encoding UTF8
$errors | Sort-Object | Out-File -FilePath "migration/migration_errors.txt" -Encoding UTF8

Write-Host "Generated separate text files in migration/ folder:"
Write-Host "common_todo.txt: $($commonTodo.Count) files"
Write-Host "theme_todo.txt: $($themeTodo.Count) files"
Write-Host "gorouter_ready.txt: $($gorouterReady.Count) files"
Write-Host "navigation_legacy.txt: $($navigationLegacy.Count) files"
Write-Host "freezed_models.txt: $($freezedModels.Count) files"
Write-Host "provider_usage.txt: $($providerUsage.Count) files"
Write-Host "navigator_usage.txt: $($navigatorUsage.Count) files"
Write-Host "migration_errors.txt: $($errors.Count) files"