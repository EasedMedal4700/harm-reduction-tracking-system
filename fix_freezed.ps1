Get-ChildItem -Path "c:\Users\USER\dev\code\mobile_drug_use_app\lib" -Recurse -Filter *.dart | ForEach-Object {
  $content = Get-Content $_.FullName -Raw
  if ($content -match '(?<!abstract\s)class (\w+) with _\$\1') {
    $content = $content -replace '(?<!abstract\s)class (\w+) with _\$\1', 'abstract class $1 with _$$$1'
    Set-Content -Path $_.FullName -Value $content -NoNewline
    Write-Host "Updated $($_.Name)"
  }
}
