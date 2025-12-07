Write-Host "Fixing all remaining compilation errors..."

$files = Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse

$count = 0
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    
    $originalContent = $content
    
    # Fix remaining color references
    $content = $content -replace '\.Border(?!\w)', '.textTertiary.withOpacity(0.2)'
    $content = $content -replace '\.AccentGreen(?!\w)', '.success'
    $content = $content -replace '\.AccentPurple(?!\w)', '.accentSecondary'
    $content = $content -replace '\.AccentAmber(?!\w)', '.warning'
    $content = $content -replace '\.AccentOrange(?!\w)', '.warning'
    $content = $content -replace '\.AccentIndigo(?!\w)', '.accentSecondary'
    $content = $content -replace '\.NeonTeal(?!\w)', '.accentPrimary'
    $content = $content -replace '\.NeonBlue(?!\w)', '.accentPrimary'
    $content = $content -replace '\.NeonViolet(?!\w)', '.accentSecondary'
    
    # Fix method calls
    $content = $content -replace '\.createGlassmorphism\(\)', '.surfaceVariant'
    $content = $content -replace '\.createSoftShadow\(\)', '.textTertiary.withOpacity(0.1)'
    
    # Fix spacing references
    $content = $content -replace 'cardPaddingMedium', 'md'
    
    # Fix DrugCategories references
    $content = $content -replace '\bDrugCategories\.', 'Categories.'
    
    # Fix AppTheme references in edit_log_entry_page
    $content = $content -replace '\bAppTheme\.', 'AppColors.'
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "Fixed: $($file.Name)"
        $count++
    }
}

Write-Host "`n=== Final Error Fixes Complete ==="
Write-Host "Files fixed: $count"
