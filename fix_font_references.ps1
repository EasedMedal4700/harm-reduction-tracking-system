Write-Host "Fixing all font constant references to use AppTheme instead of AppColors..."

$files = Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse

$count = 0
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    
    $originalContent = $content
    
    # Fix font size constants accessed from AppColors
    $content = $content -replace 'AppColors\.(font(XSmall|Small|Medium|Large|XLarge|2XLarge|3XLarge|4XLarge))\b', 'AppTheme.$1'
    
    # Fix font weight constants accessed from AppColors
    $content = $content -replace 'AppColors\.(font(Light|Regular|MediumWeight|SemiBold|Bold|ExtraBold))\b', 'AppTheme.$1'
    
    # Fix animation constants accessed from AppColors
    $content = $content -replace 'AppColors\.(animation(Fast|Normal|Slow))\b', 'AppTheme.$1'
    
    # Fix nested AppTheme references like AppColors.AppTheme
    $content = $content -replace 'AppColors\.AppTheme\b', 'AppTheme'
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "Fixed: $($file.Name)"
        $count++
    }
}

Write-Host "`n=== Font Reference Fixes Complete ==="
Write-Host "Files fixed: $count"
