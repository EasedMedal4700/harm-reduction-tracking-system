param(
    [string]$RootDir = "lib",
    [string]$OutputJson = "migration_headers.json"
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

$workspaceRoot = Split-Path (Resolve-Path $RootDir) -Parent
$libPath = Join-Path $workspaceRoot "lib"

Get-ChildItem -Path $RootDir -Recurse -Filter "*.dart" | Where-Object {
    $_.Name -notlike "*.g.dart" -and $_.Name -notlike "*.freezed.dart"
} | ForEach-Object {
    $filePath = $_.FullName -replace "C:\\Users\\USER\\dev\\code\\mobile_drug_use_app\\", ""
    try {
        $content = Get-Content -Path $_.FullName -Encoding UTF8 -TotalCount 10
        $header = $content -join "`n"
        $allHeaders[$filePath] = $header

        $missing = @()
        foreach ($field in $requiredFields) {
            if ($header -notmatch [regex]::Escape($field)) {
                $missing += $field
            }
        }
        if ($missing) {
            $errors += "$filePath : Missing $($missing -join ', ')"
        }
        
        # Check for LEGACY status
        if ($header -match "LEGACY") {
            $errors += "$filePath : Contains LEGACY status - needs migration"
        }
    } catch {
        $errors += "$filePath : Error reading file - $($_.Exception.Message)"
    }
}

# Create separate JSON files for different migration aspects
$commonTodo = @{}
$themeTodo = @{}
$gorouterReady = @{}
$riverpodTodo = @{}
$freezedModels = @{}

foreach ($file in $allHeaders.Keys) {
    $header = $allHeaders[$file]
    
    if ($header -match "// Common: TODO") {
        $commonTodo[$file] = $header
    }
    if ($header -match "// Theme: TODO") {
        $themeTodo[$file] = $header
    }
    if ($header -match "// Navigation: GOROUTER" -or $header -match "// Navigation: GOROUTER-READY") {
        $gorouterReady[$file] = $header
    }
    if ($header -match "// Riverpod: TODO") {
        $riverpodTodo[$file] = $header
    }
    if ($header -match "// Models: FREEZED") {
        $freezedModels[$file] = $header
    }
}

# Output separate text files for different migration aspects
$commonTodo.Keys | Sort-Object | Out-File -FilePath "migration/common_todo.txt" -Encoding UTF8
$themeTodo.Keys | Sort-Object | Out-File -FilePath "migration/theme_todo.txt" -Encoding UTF8
$gorouterReady.Keys | Sort-Object | Out-File -FilePath "migration/gorouter_ready.txt" -Encoding UTF8
$riverpodTodo.Keys | Sort-Object | Out-File -FilePath "migration/riverpod_todo.txt" -Encoding UTF8
$freezedModels.Keys | Sort-Object | Out-File -FilePath "migration/freezed_models.txt" -Encoding UTF8
$errors | Sort-Object | Out-File -FilePath "migration/migration_errors.txt" -Encoding UTF8

Write-Host "Generated separate text files in migration/ folder:"
Write-Host "common_todo.txt: $($commonTodo.Count) files"
Write-Host "theme_todo.txt: $($themeTodo.Count) files"
Write-Host "gorouter_ready.txt: $($gorouterReady.Count) files"
Write-Host "riverpod_todo.txt: $($riverpodTodo.Count) files"
Write-Host "freezed_models.txt: $($freezedModels.Count) files"
Write-Host "migration_errors.txt: $($errors.Count) files"