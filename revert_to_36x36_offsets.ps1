$glassPane = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane"

Get-ChildItem -Path $glassPane -Filter "*.blockymodel" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw

    # Revert offsets from 40x40 to 36x36 format
    $content = $content -replace '("front":\s*\{\s*"offset":\s*\{\s*"x":\s*)4(,\s*"y":\s*)4(\s*\})', '${1}2${2}2${3}'
    $content = $content -replace '("back":\s*\{\s*"offset":\s*\{\s*"x":\s*)4(,\s*"y":\s*)4(\s*\})', '${1}2${2}2${3}'
    $content = $content -replace '("left":\s*\{\s*"offset":\s*\{\s*"x":\s*)0(,\s*"y":\s*)4(\s*\})', '${1}0${2}2${3}'
    $content = $content -replace '("right":\s*\{\s*"offset":\s*\{\s*"x":\s*)36(,\s*"y":\s*)4(\s*\})', '${1}34${2}2${3}'
    $content = $content -replace '("top":\s*\{\s*"offset":\s*\{\s*"x":\s*)4(,\s*"y":\s*)0(\s*\})', '${1}2${2}0${3}'
    $content = $content -replace '("bottom":\s*\{\s*"offset":\s*\{\s*"x":\s*)4(,\s*"y":\s*)36(\s*\})', '${1}2${2}34${3}'

    Set-Content -Path $_.FullName -Value $content -NoNewline
    Write-Host "Reverted: $($_.Name)"
}

Write-Host "`nReverted all model offsets to 36x36 format"
