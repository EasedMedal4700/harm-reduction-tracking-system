Write-Host ""
Write-Host "App Theme Migration Pipeline" -ForegroundColor Cyan
Write-Host "============================"
Write-Host ""

$ErrorActionPreference = "Stop"

Write-Host "Step 1: Checking theme imports..."
& ".\scripts\powershell\01_check_theme_imports.ps1"

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    $Answer = Read-Host "Illegal imports found. Auto-fix now? (y/n)"
    if ($Answer -ne "y") {
        Write-Host "Aborted." -ForegroundColor Red
        exit 1
    }

    Write-Host ""
    & ".\scripts\powershell\02_fix_theme_imports.ps1"

    Write-Host ""
    Write-Host "Re-running checks..." -ForegroundColor Cyan
    & ".\scripts\powershell\01_check_theme_imports.ps1"

    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Issues remain after auto-fix." -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "Theme migration checks passed." -ForegroundColor Green
Write-Host "Next steps:"
Write-Host "- flutter analyze"
Write-Host "- flutter test"
Write-Host ""
