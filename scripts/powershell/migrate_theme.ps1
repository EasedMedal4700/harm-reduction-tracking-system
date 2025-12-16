Write-Host ""
Write-Host "Phase 1: Scanning for illegal theme imports..." -ForegroundColor Cyan
Write-Host ""

$checkScript = ".\scripts\powershell\01_check_theme_imports.ps1"
$fixScript   = ".\scripts\powershell\02_fix_theme_imports.ps1"

[int]$violationCount = & $checkScript

if ($violationCount -eq 0) {
    Write-Host "No illegal theme imports found." -ForegroundColor Green
    return
}

Write-Host "Illegal theme imports detected." -ForegroundColor Yellow
Write-Host "Affected files: $violationCount" -ForegroundColor Yellow
Write-Host ""

$answer = Read-Host "Proceed with automatic migration? (y/N)"

if ($answer -notin @("y", "Y")) {
    Write-Host "Migration cancelled." -ForegroundColor Red
    return
}

Write-Host ""
Write-Host "Phase 2: Updating imports..." -ForegroundColor Cyan
Write-Host ""

& $fixScript

Write-Host ""
Write-Host "Theme migration complete." -ForegroundColor Green
Write-Host "Next step: flutter analyze" -ForegroundColor Cyan
