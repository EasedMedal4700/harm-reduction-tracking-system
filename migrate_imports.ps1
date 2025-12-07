# PowerShell script to migrate old constants imports to new structure

Write-Host "Starting constants migration..." -ForegroundColor Cyan

$projectRoot = "c:\Users\user\Desktop\Power BI\mobile_drug_use_app"
Set-Location $projectRoot

$filesUpdated = 0

# Process all Dart files in lib/
Get-ChildItem -Path "lib" -Include "*.dart" -Recurse | ForEach-Object {
    $file = $_
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    
    # Replace old imports
    $content = $content -replace "import '../../constants/ui_colors\.dart';", "import '../../constants/theme/app_colors.dart';"
    $content = $content -replace "import '\.\./constants/ui_colors\.dart';", "import '../constants/theme/app_colors.dart';"
    $content = $content -replace "import '../../constants/theme_constants\.dart';", "import '../../constants/theme/app_spacing.dart';"
    $content = $content -replace "import '\.\./constants/theme_constants\.dart';", "import '../constants/theme/app_spacing.dart';"
    $content = $content -replace "import '../../constants/app_theme_constants\.dart';", "import '../../constants/theme/app_spacing.dart';"
    $content = $content -replace "import '\.\./constants/app_theme_constants\.dart';", "import '../constants/theme/app_spacing.dart';"
    $content = $content -replace "import '../../constants/drug_categories\.dart';", "import '../../constants/domain/categories.dart';"
    $content = $content -replace "import '\.\./\.\./\.\./constants/drug_categories\.dart';", "import '../../../constants/domain/categories.dart';"
    $content = $content -replace "import '\.\./constants/drug_categories\.dart';", "import '../constants/domain/categories.dart';"
    $content = $content -replace "import '../../constants/drug_theme\.dart';", "import '../../constants/domain/drug_category_colors.dart';"
    $content = $content -replace "import '\.\./constants/drug_theme\.dart';", "import '../constants/domain/drug_category_colors.dart';"
    $content = $content -replace "import '../../constants/app_mood\.dart';", "import '../../constants/domain/mood_emojis.dart';"
    $content = $content -replace "import '\.\./constants/app_mood\.dart';", "import '../constants/domain/mood_emojis.dart';"
    $content = $content -replace "import '../../constants/craving_consatnts\.dart';", "import '../../constants/domain/categories.dart';"
    $content = $content -replace "import '\.\./constants/craving_consatnts\.dart';", "import '../constants/domain/categories.dart';"
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "Updated: $($file.Name)" -ForegroundColor Green
        $filesUpdated++
    }
}

Write-Host ""
Write-Host "Migration complete! Files updated: $filesUpdated" -ForegroundColor Yellow
