$files = Get-ChildItem "lib" -Recurse -Include *.dart

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw

    $original = $content

    $content = $content `
        -replace "import .*ui_colors.dart.*;", "" `
        -replace "import .*theme_constants.dart.*;", ""

    if ($content -ne $original) {
        Set-Content $file.FullName $content -Encoding UTF8
    }
}

Write-Host "Imports updated." -ForegroundColor Green
