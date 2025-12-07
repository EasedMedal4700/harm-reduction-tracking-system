# Fix remaining edge case errors - missing properties and methods

Write-Host "Fixing final edge cases..." -ForegroundColor Cyan

$projectRoot = "c:\Users\user\Desktop\Power BI\mobile_drug_use_app"
Set-Location $projectRoot

# Fix files with missing AppColorScheme properties
$edgeCaseFixes = @{
    # Fix .Border references (doesn't exist in AppColorScheme)
    "\.Border" = ".textTertiary.withOpacity(0.2)"
    # Fix .AccentGreen references
    "\.AccentGreen" = ".success"
    # Fix .AccentPurple references  
    "\.AccentPurple" = ".accentSecondary"
    # Fix .AccentAmber, .AccentOrange references
    "\.AccentAmber" = ".warning"
    "\.AccentOrange" = ".warning"
    # Fix .AccentIndigo references
    "\.AccentIndigo" = ".accentSecondary"
    # Fix .NeonTeal, .NeonBlue, .NeonViolet references
    "\.NeonTeal" = ".accentPrimary"
    "\.NeonBlue" = ".accentPrimary"
    "\.NeonViolet" = ".accentSecondary"
    # Fix .createGlassmorphism() method calls
    "\.createGlassmorphism\(\)" = ".surfaceVariant"
    # Fix .createSoftShadow() method calls  
    "\.createSoftShadow\(\)" = ".textTertiary.withOpacity(0.1)"
    # Fix .cardPaddingMedium, .cardPaddingLarge
    "\.cardPaddingMedium" = "16.0"
    "\.cardPaddingLarge" = "20.0"
    # Fix DrugCategories references in widgets
    "DrugCategories\.categoryIconMap" = "Categories.categoryIconMap"
    "DrugCategories\.categoryPriority" = "Categories.categoryPriority"
}

$filesFixed = 0

Get-ChildItem -Path "lib" -Include "*.dart" -Recurse | ForEach-Object {
    $file = $_
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    
    foreach ($pattern in $edgeCaseFixes.Keys) {
        if ($content -match $pattern) {
            $content = $content -replace $pattern, $edgeCaseFixes[$pattern]
        }
    }
    
    # Fix specific files with unique issues
    if ($file.Name -eq "edit_log_entry_page.dart") {
        # Fix AppTheme reference that should be a literal or import
        $content = $content -replace "AppTheme\.space", "20.0"
    }
    
    if ($file.Name -eq "set_new_password_page.dart") {
        # Fix const evaluation errors by removing const keyword
        $content = $content -replace "const EdgeInsets\.symmetric", "EdgeInsets.symmetric"
        $content = $content -replace "const SizedBox", "SizedBox"
    }
    
    # Add missing imports if we're using withOpacity
    if (($content -match "withOpacity") -and ($content -notmatch "import 'package:flutter/material.dart'")) {
        $content = "import 'package:flutter/material.dart';`r`n" + $content
    }
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "Fixed: $($file.Name)" -ForegroundColor Green
        $filesFixed++
    }
}

Write-Host ""
Write-Host "=== Edge Case Fixes Complete ===" -ForegroundColor Cyan
Write-Host "Files fixed: $filesFixed" -ForegroundColor Yellow
