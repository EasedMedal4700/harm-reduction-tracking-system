Write-Host "Fixing final error patterns..."

$files = Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse

$count = 0
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    
    $originalContent = $content
    
    # Fix SizedBox(height: EdgeInsets.all(X)) -> SizedBox(height: X)
    $content = $content -replace 'height:\s*EdgeInsets\.all\((\d+)\)', 'height: $1'
    $content = $content -replace 'width:\s*EdgeInsets\.all\((\d+)\)', 'width: $1'
    
    # Fix boxShadow: null -> remove the line entirely or use empty list
    $content = $content -replace 'boxShadow:\s*null,?\s*\n', ''
    
    # Fix remaining .createGlassmorphism() that wasn't caught
    $content = $content -replace 'colors\.createGlassmorphism\(\)', 'colors.surfaceVariant'
    $content = $content -replace 'AppColors\.\w+\.createGlassmorphism\(\)', 'colors.surfaceVariant'
    
    # Fix const expressions with color properties - remove const keyword
    $content = $content -replace 'const\s+Icon\(\s*Icons\.\w+,\s*color:\s*colors\.\w+', 'Icon(Icons.$0'
    $content = $content -replace 'const\s+(\w+)\s*\([^)]*colors\.\w+[^)]*\)', '$1('
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "Fixed: $($file.Name)"
        $count++
    }
}

Write-Host "`n=== Final Error Fixes Complete ==="
Write-Host "Files fixed: $count"
