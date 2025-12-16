Write-Host ""
Write-Host "Phase 1: Scanning for illegal theme imports..." -ForegroundColor Cyan
Write-Host ""

$ProjectRoot = (Get-Location).Path
$ThemeRoot = Join-Path $ProjectRoot "lib\constants"

$Files = Get-ChildItem -Path $ProjectRoot -Recurse -Filter *.dart | Where-Object {
    $_.FullName -notlike "$ThemeRoot*"
}

$ForbiddenImports = @(
    "app_theme.dart",
    "app_theme_constants.dart",
    "app_color_palette.dart",
    "app_accent_colors.dart",
    "app_spacing.dart",
    "app_radius.dart",
    "app_typography.dart",
    "app_shapes.dart",
    "app_shadows.dart",
    "app_colors"
)

$Violations = @()

foreach ($File in $Files) {
    $Content = Get-Content $File.FullName -Raw

    foreach ($Forbidden in $ForbiddenImports) {
        if ($Content -match [Regex]::Escape($Forbidden)) {
            $Violations += [PSCustomObject]@{
                File   = $File.FullName.Replace($ProjectRoot, "")
                Import = $Forbidden
            }
        }
    }
}

if ($Violations.Count -eq 0) {
    Write-Host "OK: No illegal theme imports found." -ForegroundColor Green
    exit 0
}

Write-Host "ERROR: Illegal theme imports detected." -ForegroundColor Red
Write-Host ""

$Violations | Sort-Object File | Format-Table -AutoSize

Write-Host ""
Write-Host "Rule:"
Write-Host "Outside lib/constants/theme/, ONLY import app_theme_extension.dart"
Write-Host ""

exit 1
