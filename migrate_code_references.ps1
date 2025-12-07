# PowerShell script to migrate code references from old constants to new API
# This handles the actual usage of constants in code, not just imports

Write-Host "Starting code reference migration..." -ForegroundColor Cyan
Write-Host "This will update UIColors.* and ThemeConstants.* references" -ForegroundColor Yellow
Write-Host ""

$projectRoot = "c:\Users\user\Desktop\Power BI\mobile_drug_use_app"
Set-Location $projectRoot

$filesUpdated = 0
$totalReplacements = 0

# Process all Dart files in lib/
Get-ChildItem -Path "lib" -Include "*.dart" -Recurse | ForEach-Object {
    $file = $_
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    $fileChanged = $false
    
    # Skip if file doesn't contain UIColors or ThemeConstants
    if (-not ($content -match 'UIColors\.' -or $content -match 'ThemeConstants\.')) {
        return
    }
    
    # ==========================================================================
    # COLORS - UIColors to AppColors
    # ==========================================================================
    
    # Light theme colors
    $content = $content -replace 'UIColors\.lightBackground', 'AppColors.light.background'
    $content = $content -replace 'UIColors\.lightSurface', 'AppColors.light.surface'
    $content = $content -replace 'UIColors\.lightText\b', 'AppColors.light.textPrimary'
    $content = $content -replace 'UIColors\.lightTextSecondary', 'AppColors.light.textSecondary'
    $content = $content -replace 'UIColors\.lightTextTertiary', 'AppColors.light.textTertiary'
    $content = $content -replace 'UIColors\.lightFab', 'AppColors.light.accentPrimary'
    $content = $content -replace 'UIColors\.lightAccentBlue', 'AppColors.light.accentPrimary'
    $content = $content -replace 'UIColors\.lightAccentTeal', 'AppColors.light.accentSecondary'
    $content = $content -replace 'UIColors\.lightAccentRed', 'AppColors.light.error'
    $content = $content -replace 'UIColors\.lightDivider', 'AppColors.light.textTertiary'
    $content = $content -replace 'UIColors\.lightShadowColor', 'Colors.black.withOpacity(0.1)'
    
    # Dark theme colors
    $content = $content -replace 'UIColors\.darkBackground', 'AppColors.dark.background'
    $content = $content -replace 'UIColors\.darkSurface', 'AppColors.dark.surface'
    $content = $content -replace 'UIColors\.darkText\b', 'AppColors.dark.textPrimary'
    $content = $content -replace 'UIColors\.darkTextSecondary', 'AppColors.dark.textSecondary'
    $content = $content -replace 'UIColors\.darkTextTertiary', 'AppColors.dark.textTertiary'
    $content = $content -replace 'UIColors\.darkNeonCyan', 'AppColors.dark.accentPrimary'
    $content = $content -replace 'UIColors\.darkNeonPurple', 'AppColors.dark.accentSecondary'
    $content = $content -replace 'UIColors\.darkNeonOrange', 'AppColors.dark.error'
    $content = $content -replace 'UIColors\.darkNeonPink', 'AppColors.dark.warning'
    $content = $content -replace 'UIColors\.darkNeonGreen', 'AppColors.dark.success'
    $content = $content -replace 'UIColors\.darkBorder', 'AppColors.dark.textTertiary'
    $content = $content -replace 'UIColors\.darkDivider', 'AppColors.dark.textTertiary'
    $content = $content -replace 'UIColors\.darkShadowColor', 'Colors.black.withOpacity(0.3)'
    
    # ==========================================================================
    # SPACING - ThemeConstants to AppSpacing
    # ==========================================================================
    
    $content = $content -replace 'ThemeConstants\.space4\b', 'AppSpacing.xs'
    $content = $content -replace 'ThemeConstants\.space8\b', 'AppSpacing.sm'
    $content = $content -replace 'ThemeConstants\.space12\b', 'AppSpacing.md'
    $content = $content -replace 'ThemeConstants\.space16\b', 'AppSpacing.lg'
    $content = $content -replace 'ThemeConstants\.space20\b', '20.0'
    $content = $content -replace 'ThemeConstants\.space24\b', 'AppSpacing.xl'
    $content = $content -replace 'ThemeConstants\.space32\b', 'AppSpacing.xxl'
    $content = $content -replace 'ThemeConstants\.space40\b', '40.0'
    $content = $content -replace 'ThemeConstants\.space48\b', 'AppSpacing.xxxl'
    $content = $content -replace 'ThemeConstants\.homePagePadding', '20.0'
    $content = $content -replace 'ThemeConstants\.cardSpacing', 'AppSpacing.xl'
    $content = $content -replace 'ThemeConstants\.quickActionSpacing', 'AppSpacing.md'
    
    # ==========================================================================
    # BORDER RADIUS - ThemeConstants to AppRadii
    # ==========================================================================
    
    $content = $content -replace 'ThemeConstants\.radiusSmall', 'AppRadii.sm'
    $content = $content -replace 'ThemeConstants\.radiusMedium', 'AppRadii.lg'
    $content = $content -replace 'ThemeConstants\.radiusLarge', 'AppRadii.xl'
    $content = $content -replace 'ThemeConstants\.radiusExtraLarge', '28.0'
    $content = $content -replace 'ThemeConstants\.cardRadius', 'AppRadii.md'
    $content = $content -replace 'ThemeConstants\.darkCardRadius', 'AppRadii.md'
    $content = $content -replace 'ThemeConstants\.quickActionRadius', 'AppRadii.md'
    $content = $content -replace 'ThemeConstants\.buttonRadius', 'AppRadii.md'
    
    # ==========================================================================
    # FONT SIZES - ThemeConstants to AppTheme
    # ==========================================================================
    
    $content = $content -replace 'ThemeConstants\.fontXSmall', 'AppTheme.fontXSmall'
    $content = $content -replace 'ThemeConstants\.fontSmall', 'AppTheme.fontSmall'
    $content = $content -replace 'ThemeConstants\.fontMedium', 'AppTheme.fontMedium'
    $content = $content -replace 'ThemeConstants\.fontLarge', 'AppTheme.fontLarge'
    $content = $content -replace 'ThemeConstants\.fontXLarge', 'AppTheme.fontXLarge'
    $content = $content -replace 'ThemeConstants\.font2XLarge', 'AppTheme.font2XLarge'
    $content = $content -replace 'ThemeConstants\.font3XLarge', 'AppTheme.font3XLarge'
    $content = $content -replace 'ThemeConstants\.font4XLarge', 'AppTheme.font4XLarge'
    
    # ==========================================================================
    # FONT WEIGHTS - ThemeConstants to AppTheme
    # ==========================================================================
    
    $content = $content -replace 'ThemeConstants\.fontLight', 'AppTheme.fontLight'
    $content = $content -replace 'ThemeConstants\.fontRegular', 'AppTheme.fontRegular'
    $content = $content -replace 'ThemeConstants\.fontMediumWeight', 'AppTheme.fontMediumWeight'
    $content = $content -replace 'ThemeConstants\.fontSemiBold', 'AppTheme.fontSemiBold'
    $content = $content -replace 'ThemeConstants\.fontBold', 'AppTheme.fontBold'
    $content = $content -replace 'ThemeConstants\.fontExtraBold', 'AppTheme.fontExtraBold'
    
    # ==========================================================================
    # ICON SIZES - ThemeConstants (keep as literals or constants)
    # ==========================================================================
    
    $content = $content -replace 'ThemeConstants\.iconSmall', '20.0'
    $content = $content -replace 'ThemeConstants\.iconMedium', '24.0'
    $content = $content -replace 'ThemeConstants\.iconLarge', '32.0'
    $content = $content -replace 'ThemeConstants\.iconExtraLarge', '40.0'
    $content = $content -replace 'ThemeConstants\.quickActionIconSize', '28.0'
    
    # ==========================================================================
    # ELEVATION - ThemeConstants (keep as literals)
    # ==========================================================================
    
    $content = $content -replace 'ThemeConstants\.elevationLow', '2.0'
    $content = $content -replace 'ThemeConstants\.elevationMedium', '4.0'
    $content = $content -replace 'ThemeConstants\.elevationHigh', '8.0'
    
    # ==========================================================================
    # BORDERS - ThemeConstants (keep as literals)
    # ==========================================================================
    
    $content = $content -replace 'ThemeConstants\.borderThin', '1.0'
    $content = $content -replace 'ThemeConstants\.borderMedium', '2.0'
    $content = $content -replace 'ThemeConstants\.borderThick', '3.0'
    
    # ==========================================================================
    # Add missing imports if needed
    # ==========================================================================
    
    # If we replaced UIColors but don't have AppColors import
    if (($originalContent -match 'UIColors\.') -and ($content -match 'AppColors\.') -and ($content -notmatch "import '.*constants/theme/app_colors\.dart'")) {
        # Determine the correct relative path based on file location
        $relativePath = $file.DirectoryName.Replace($projectRoot + "\lib\", "").Replace("\", "/")
        $depth = ($relativePath.Split("/").Count)
        $importPath = "../" * $depth + "constants/theme/app_colors.dart"
        
        # Add import after last existing import
        $content = $content -replace "(import '[^']+';[\r\n]+)", "`$1import '$importPath';`r`n"
    }
    
    # If we replaced ThemeConstants spacing but don't have AppSpacing import
    if (($originalContent -match 'ThemeConstants\.(space|cardSpacing|quickActionSpacing)') -and ($content -match 'AppSpacing\.') -and ($content -notmatch "import '.*constants/theme/app_spacing\.dart'")) {
        $relativePath = $file.DirectoryName.Replace($projectRoot + "\lib\", "").Replace("\", "/")
        $depth = ($relativePath.Split("/").Count)
        $importPath = "../" * $depth + "constants/theme/app_spacing.dart"
        
        $content = $content -replace "(import '[^']+';[\r\n]+)", "`$1import '$importPath';`r`n"
    }
    
    # If we replaced ThemeConstants radius but don't have AppRadii import
    if (($originalContent -match 'ThemeConstants\.(radius|cardRadius|buttonRadius)') -and ($content -match 'AppRadii\.') -and ($content -notmatch "import '.*constants/theme/app_radii\.dart'")) {
        $relativePath = $file.DirectoryName.Replace($projectRoot + "\lib\", "").Replace("\", "/")
        $depth = ($relativePath.Split("/").Count)
        $importPath = "../" * $depth + "constants/theme/app_radii.dart"
        
        $content = $content -replace "(import '[^']+';[\r\n]+)", "`$1import '$importPath';`r`n"
    }
    
    # If we replaced ThemeConstants fonts but don't have AppTheme import
    if (($originalContent -match 'ThemeConstants\.(font|Font)') -and ($content -match 'AppTheme\.(font|Font)') -and ($content -notmatch "import '.*theme/app_theme\.dart'")) {
        $relativePath = $file.DirectoryName.Replace($projectRoot + "\lib\", "").Replace("\", "/")
        $depth = ($relativePath.Split("/").Count)
        $importPath = "../" * $depth + "theme/app_theme.dart"
        
        $content = $content -replace "(import '[^']+';[\r\n]+)", "`$1import '$importPath';`r`n"
    }
    
    # Check if anything changed
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "Updated: $($file.Name)" -ForegroundColor Green
        $filesUpdated++
        
        # Count replacements (approximate)
        $changes = Compare-Object ($originalContent -split "`n") ($content -split "`n")
        $totalReplacements += $changes.Count
    }
}

Write-Host ""
Write-Host "=== Code Reference Migration Complete ===" -ForegroundColor Cyan
Write-Host "Files updated: $filesUpdated" -ForegroundColor Yellow
Write-Host "Approximate changes: $totalReplacements" -ForegroundColor Yellow
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Run: flutter analyze" -ForegroundColor White
Write-Host "2. Check for any remaining compilation errors" -ForegroundColor White
Write-Host "3. Test the app thoroughly" -ForegroundColor White
Write-Host "4. Delete old constant files if everything works" -ForegroundColor White
