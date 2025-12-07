Write-Host "Fixing ALL remaining typography and constant errors..."

$files = Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse

$count = 0
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    
    $originalContent = $content
    
    # Fix typography constants - need to access from AppTheme, not AppColors
    $content = $content -replace '(?<!\.)font(XSmall|Small|Medium|Large|XLarge|2XLarge|3XLarge|4XLarge)(?!\w)', 'AppTheme.font$1'
    $content = $content -replace '(?<!\.)font(Light|Regular|MediumWeight|SemiBold|Bold|ExtraBold)(?!\w)', 'AppTheme.font$1'
    
    # Fix animation constants - need to access from AppTheme
    $content = $content -replace '(?<!\.

)animation(Fast|Normal|Slow)(?!\w)', 'AppTheme.animation$1'
    
    # Fix spacing constants that are incorrectly referenced
    $content = $content -replace 'cardPaddingSmall', 'AppSpacing.sm'
    $content = $content -replace 'cardPaddingMedium', 'AppSpacing.md'
    $content = $content -replace 'cardPaddingLarge', 'AppSpacing.lg'
    
    # Fix remaining color method calls
    $content = $content -replace '\.getDarkAccent\(\)', '.accentSecondary'
    $content = $content -replace '\.getLightAccent\(\)', '.accentPrimary'
    $content = $content -replace '\.createNeonGlow\([^)]*\)', '.accentPrimary'
    
    # Fix NeonEmerald
    $content = $content -replace '\.NeonEmerald(?!\w)', '.success'
    $content = $content -replace '\.NeonLavender(?!\w)', '.accentSecondary'
    
    # Fix surfaceLight reference
    $content = $content -replace '\.surfaceLight(?!\w)', '.surface'
    
    # Fix AppSpacing references that need dots
    $content = $content -replace '\bAppSpacing\s+(xs|sm|md|lg|xl|xxl)\b', 'AppSpacing.$1'
    
    # Fix theme constants lookups that should use AppTheme
    $content = $content -replace '\bThemeConstants\.', 'AppTheme.'
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "Fixed: $($file.Name)"
        $count++
    }
}

Write-Host "`n=== Typography and Constant Fixes Complete ==="
Write-Host "Files fixed: $count"
