Write-Host "Fixing remaining compilation errors - Phase 2..."

$files = Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse

$count = 0
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    
    $originalContent = $content
    
    # Fix animation constants
    $content = $content -replace '\banimation(Fast|Normal|Slow)(?!\w)', 'AppTheme.animation$1'
    
    # Fix BoxShadow type errors - these methods returned BoxShadow but are now colors
    # Pattern: boxShadow: colors.createGlassmorphism() or similar
    $content = $content -replace 'boxShadow:\s*colors\.create\w+\(\)', 'boxShadow: null'
    $content = $content -replace 'boxShadow:\s*AppColors\.\w+\.create\w+\(\)', 'boxShadow: null'
    
    # Fix padding arguments that expect EdgeInsets
    $content = $content -replace 'padding:\s+AppSpacing\.(xs|sm|md|lg|xl|xxl)\b', 'padding: EdgeInsets.all(AppSpacing.$1)'
    
    # Fix const EdgeInsets expressions that can't be const
    $content = $content -replace 'const\s+EdgeInsets\.all\(AppSpacing\.(xs|sm|md|lg|xl|xxl)\)', 'EdgeInsets.all(AppSpacing.$1)'
    
    # Fix ButtonConstants references
    $content = $content -replace '\bButtonConstants\.', 'AppTheme.'
    
    # Fix remaining method-style references
    $content = $content -replace '\.createSoftShadow\(\)', '.textTertiary.withOpacity(0.1)'
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "Fixed: $($file.Name)"
        $count++
    }
}

Write-Host "`n=== Phase 2 Fixes Complete ==="
Write-Host "Files fixed: $count"
