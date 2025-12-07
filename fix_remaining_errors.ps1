# Fix remaining compilation errors after first migration pass

Write-Host "Fixing remaining compilation errors..." -ForegroundColor Cyan

$projectRoot = "c:\Users\user\Desktop\Power BI\mobile_drug_use_app"
Set-Location $projectRoot

$filesFixed = 0

# Fix specific files with remaining issues
$specificFixes = @{
    "lib\screens\analytics_page.dart" = @(
        @{ Old = 'DrugCategories\.categoryPriority'; New = 'Categories.categoryPriority' },
        @{ Old = 'DrugCategories\.categoryIconMap'; New = 'Categories.categoryIconMap' },
        @{ Old = 'DrugCategories\.'; New = 'Categories.' }
    )
    "lib\screens\edit\edit_craving_page.dart" = @(
        @{ Old = 'cravingCategories'; New = 'Categories.cravingCategories' }
    )
    "lib\screens\edit\edit_log_entry_page.dart" = @(
        @{ Old = 'ThemeConstants\.'; New = 'AppTheme.' }
    )
    "lib\screens\home_page.dart" = @(
        @{ Old = 'ThemeConstants\.'; New = 'AppTheme.' },
        @{ Old = 'const \[UIColors\.'; New = '[AppColors.light.' },
        @{ Old = ', UIColors\.'; New = ', AppColors.light.' }
    )
}

# Apply specific fixes
foreach ($filePath in $specificFixes.Keys) {
    $fullPath = Join-Path $projectRoot $filePath
    if (Test-Path $fullPath) {
        $content = Get-Content $fullPath -Raw
        $originalContent = $content
        
        foreach ($fix in $specificFixes[$filePath]) {
            $content = $content -replace $fix.Old, $fix.New
        }
        
        if ($content -ne $originalContent) {
            Set-Content -Path $fullPath -Value $content -NoNewline
            Write-Host "Fixed: $filePath" -ForegroundColor Green
            $filesFixed++
        }
    }
}

# Fix any remaining UIColors references in all files
Get-ChildItem -Path "lib" -Include "*.dart" -Recurse | ForEach-Object {
    $file = $_
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    
    # Catch any remaining UIColors that slipped through
    if ($content -match 'UIColors\.') {
        # Generic catch-all for any remaining UIColors
        $content = $content -replace 'UIColors\.light([A-Z][a-zA-Z]+)', 'AppColors.light.$1'
        $content = $content -replace 'UIColors\.dark([A-Z][a-zA-Z]+)', 'AppColors.dark.$1'
        
        # Specific remaining cases
        $content = $content -replace 'UIColors\.', 'AppColors.light.'
        
        if ($content -ne $originalContent) {
            Set-Content -Path $file.FullName -Value $content -NoNewline
            Write-Host "Fixed remaining UIColors in: $($file.Name)" -ForegroundColor Yellow
            $filesFixed++
        }
    }
    
    # Fix any remaining ThemeConstants
    if ($content -match 'ThemeConstants\.' -and $content -ne $originalContent) {
        $content = $content -replace 'ThemeConstants\.', 'AppTheme.'
        
        if ($content -ne $originalContent) {
            Set-Content -Path $file.FullName -Value $content -NoNewline
            Write-Host "Fixed remaining ThemeConstants in: $($file.Name)" -ForegroundColor Yellow
            $filesFixed++
        }
    }
}

Write-Host ""
Write-Host "=== Remaining Fixes Complete ===" -ForegroundColor Cyan
Write-Host "Files fixed: $filesFixed" -ForegroundColor Yellow
