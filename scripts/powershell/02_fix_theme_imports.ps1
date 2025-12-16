Write-Host ""
Write-Host "Phase 2: Auto-fixing illegal theme imports..." -ForegroundColor Yellow
Write-Host ""

$ProjectRoot = (Get-Location).Path
$ThemeRoot = Join-Path $ProjectRoot "lib\constants\theme"

$Files = Get-ChildItem -Path $ProjectRoot -Recurse -Filter *.dart | Where-Object {
    $_.FullName -notlike "$ThemeRoot*"
}

$IllegalPatterns = @(
    "app_theme.dart",
    "app_theme_constants.dart",
    "app_color_palette.dart",
    "app_accent_colors.dart",
    "app_spacing.dart",
    "app_radius.dart",
    "app_typography.dart",
    "app_shapes.dart",
    "app_shadows.dart"
)

$FixedCount = 0

foreach ($File in $Files) {
    $Content = Get-Content $File.FullName -Raw
    $Original = $Content

    foreach ($Pattern in $IllegalPatterns) {
        $Content = $Content -replace "import\s+['""][^'""]*$Pattern['""]\s*;", ""
    }

    if ($Content -ne $Original) {
        if ($Content -notmatch "app_theme_extension.dart") {
            $Content = "import 'package:your_app/constants/theme/app_theme_extension.dart';`n$Content"
        }

        Set-Content -Path $File.FullName -Value $Content
        $FixedCount++
        Write-Host "Fixed: $($File.FullName.Replace($ProjectRoot, ""))"
    }
}

Write-Host ""
Write-Host "Done. Fixed $FixedCount files." -ForegroundColor Green
Write-Host "Next: run flutter analyze."
Write-Host ""
