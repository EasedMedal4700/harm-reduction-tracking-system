Write-Host ""
Write-Host "🔍 Phase 1: Scanning for illegal theme imports..." -ForegroundColor Cyan
Write-Host ""

$checkScript = ".\scripts\powershell\01_check_theme_imports.ps1"
$fixScript   = ".\scripts\powershell\02_fix_theme_imports.ps1"

$violations = & $checkScript

if ($violations -eq 0) {
    Write-Host ""
    Write-Host "✅ No violations found. Nothing to migrate." -ForegroundColor Green
    return
}

Write-Host ""
Write-Host "⚠️  Found $violations files with illegal theme imports." -ForegroundColor Yellow
Write-Host ""

$answer = Read-Host "Do you want to AUTO-FIX these imports now? (y/N)"

if ($answer -ne "y" -and $answer -ne "Y") {
    Write-Host ""
    Write-Host "❌ Migration aborted by user." -ForegroundColor Red
    return
}

Write-Host ""
Write-Host "🛠 Phase 2: Fixing imports..." -ForegroundColor Cyan
Write-Host ""

& $fixScript

Write-Host ""
Write-Host "✅ Import migration complete." -ForegroundColor Green
Write-Host "👉 Next step: run 'flutter analyze'." -ForegroundColor Cyan
