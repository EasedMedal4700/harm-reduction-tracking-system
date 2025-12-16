$projectRoot = "C:\Users\fquaa\dev\TrackYourDrugs\lib"

$forbiddenImports = @(
    "app_theme.dart",
    "app_color_palette.dart",
    "app_spacing.dart",
    "app_typography.dart",
    "app_shadows.dart",
    "app_accent_colors.dart"
)

$themeExtensionImport = "import 'constants/theme/app_theme_extension.dart';"

Get-ChildItem -Path $projectRoot -Recurse -Filter "*.dart" | ForEach-Object {

    # Skip theme internals
    if ($_.FullName -match "constants\\theme") {
        return
    }

    $content = Get-Content $_.FullName -Raw
    $original = $content
    $changed = $false

    foreach ($import in $forbiddenImports) {
        $pattern = "import\s+.*?$import';\r?\n"
        if ($content -match $pattern) {
            $content = $content -replace $pattern, ""
            $changed = $true
        }
    }

    # Ensure theme extension import exists if we removed anything
    if ($changed -and ($content -notmatch "app_theme_extension.dart")) {
        if ($content -match "(import .*?;\r?\n)+") {
            $content = $content -replace "(import .*?;\r?\n)+", "`$0$themeExtensionImport`r`n"
        } else {
            $content = "$themeExtensionImport`r`n`r`n$content"
        }
    }

    if ($changed -and $content -ne $original) {
        Set-Content -Path $_.FullName -Value $content -Encoding UTF8
        Write-Host "✔ Fixed imports in $($_.FullName)" -ForegroundColor Yellow
    }
}
