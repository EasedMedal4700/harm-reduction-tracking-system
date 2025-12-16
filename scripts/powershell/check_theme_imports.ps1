$projectRoot = "C:\Users\fquaa\dev\TrackYourDrugs\lib"

# Theme internals that UI files must NOT import
$forbiddenImports = @(
    "app_theme.dart",
    "app_color_palette.dart",
    "app_spacing.dart",
    "app_typography.dart",
    "app_shadows.dart",
    "app_accent_colors.dart"
)

$violations = @()

Get-ChildItem -Path $projectRoot -Recurse -Filter "*.dart" | ForEach-Object {

    # Skip theme internals themselves
    if ($_.FullName -match "constants\\theme") {
        return
    }

    $content = Get-Content $_.FullName -Raw

    foreach ($import in $forbiddenImports) {
        if ($content -match $import) {
            $violations += [PSCustomObject]@{
                File  = $_.FullName
                Issue = "Imports forbidden theme internal: $import"
            }
        }
    }
}

if ($violations.Count -eq 0) {
    Write-Host "✅ No illegal theme imports found." -ForegroundColor Green
} else {
    Write-Host "❌ Illegal theme imports detected:" -ForegroundColor Red
    $violations | Format-Table -AutoSize
}
