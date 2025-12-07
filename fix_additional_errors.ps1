Write-Host "Fixing remaining error patterns..."

$files = Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse

$count = 0
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    
    $originalContent = $content
    
    # Fix AppTheme.AppTheme doubled references
    $content = $content -replace '\bAppTheme\.AppTheme\b', 'AppTheme'
    
    # Fix malformed EdgeInsets like AppTheme16, AppTheme20, etc.
    $content = $content -replace '\bAppTheme(\d+)\b', 'EdgeInsets.all($1)'
    
    # Fix const EdgeInsets.all expressions (can't be const)
    $content = $content -replace 'const\s+EdgeInsets\.all\(', 'EdgeInsets.all('
    
    # Remove .createGlassmorphism() calls (replace with .surfaceVariant)
    $content = $content -replace '\.createGlassmorphism\(\)', '.surfaceVariant'
    
    # Fix boxShadow assignments that have Color instead of List<BoxShadow>
    # Pattern: boxShadow: colors.someColor
    $content = $content -replace 'boxShadow:\s*colors\.\w+(?!\[)', 'boxShadow: null'
    $content = $content -replace 'boxShadow:\s*AppColors\.\w+\.\w+(?!\[)', 'boxShadow: null'
    
    # Fix FabStart/darkFabEnd references (they don't exist)
    $content = $content -replace '\.FabStart\b', '.accentPrimary'
    $content = $content -replace '\.darkFabEnd\b', '.accentSecondary'
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "Fixed: $($file.Name)"
        $count++
    }
}

Write-Host "`n=== Additional Error Fixes Complete ==="
Write-Host "Files fixed: $count"
