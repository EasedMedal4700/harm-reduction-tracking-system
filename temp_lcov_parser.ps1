 = @{}
 = ''
Get-Content coverage\lcov.info | ForEach-Object {
    if ( -match 'SF:(.+)') {
         = [1]
        [] = @{LF=0; LH=0}
    } elseif ( -match 'LF:(\d+)') {
        [].LF = [int][1]
    } elseif ( -match 'LH:(\d+)') {
        [].LH = [int][1]
    }
}
.GetEnumerator() | Where-Object { .Value.LF -gt 0 -and .Value.LH -eq 0 } | ForEach-Object {
    Write-Host ("{0} - {1}/{2} lines covered" -f .Key, .Value.LH, .Value.LF)
}
