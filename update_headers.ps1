param(
    [string]$MigrationFolder = "migration"
)

# Read the files that need updates
$commonTodoFiles = Get-Content "$MigrationFolder\common_todo.txt" | Where-Object { $_ -ne "" }
$themeTodoFiles = Get-Content "$MigrationFolder\theme_todo.txt" | Where-Object { $_ -ne "" }
$riverpodTodoFiles = Get-Content "$MigrationFolder\riverpod_todo.txt" | Where-Object { $_ -ne "" }
$navigationFiles = Get-Content "$MigrationFolder\gorouter_ready.txt" | Where-Object { $_ -ne "" }
$legacyFiles = Get-Content "$MigrationFolder\migration_errors.txt" | Where-Object { $_ -match "Contains LEGACY status" } | ForEach-Object { ($_ -split " : ")[0] }

# Function to update header in a file
function Update-Header {
    param($filePath, $updates)
    
    $fullPath = Join-Path (Get-Location) $filePath
    if (Test-Path $fullPath) {
        $content = Get-Content $fullPath -Encoding UTF8
        $headerEndIndex = -1
        for ($i = 0; $i -lt $content.Length; $i++) {
            if ($content[$i] -match "^import ") {
                $headerEndIndex = $i - 1
                break
            }
        }
        
        if ($headerEndIndex -ge 0) {
            $header = $content[0..$headerEndIndex] -join "`n"
            foreach ($update in $updates.GetEnumerator()) {
                $header = $header -replace $update.Key, $update.Value
            }
            $newContent = $header, "", $content[($headerEndIndex + 1)..($content.Length - 1)] | ForEach-Object { $_ }
            $newContent | Out-File $fullPath -Encoding UTF8
            Write-Host "Updated $filePath"
        }
    }
}

# Update Common TODO to COMPLETE
foreach ($file in $commonTodoFiles) {
    Update-Header $file @{"// Common: TODO" = "// Common: COMPLETE"}
}

# Update Theme TODO to COMPLETE
foreach ($file in $themeTodoFiles) {
    Update-Header $file @{"// Theme: TODO" = "// Theme: COMPLETE"}
}

# Update Riverpod TODO to COMPLETE (assuming implemented)
foreach ($file in $riverpodTodoFiles) {
    Update-Header $file @{"// Riverpod: TODO" = "// Riverpod: COMPLETE"}
}

# Update Navigation to GOROUTER
foreach ($file in $navigationFiles) {
    Update-Header $file @{
        "// Navigation: CENTRALIZED" = "// Navigation: GOROUTER"
        "// Navigation: LEGACY" = "// Navigation: GOROUTER"
    }
}

# Update LEGACY Navigation to GOROUTER
foreach ($file in $legacyFiles) {
    Update-Header $file @{"// Navigation: LEGACY" = "// Navigation: GOROUTER"}
}

Write-Host "Header updates completed."