$illegalPatterns = @(
    "ui_colors.dart",
    "deprecated",
    "theme_constants.dart"
)

$files = Get-ChildItem "lib" -Recurse -Include *.dart

$violations = @()

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw

    foreach ($pattern in $illegalPatterns) {
        if ($content -match $pattern) {
            $violations += $file.FullName
            break
        }
    }
}

# IMPORTANT: return only a number
return $violations.Count
