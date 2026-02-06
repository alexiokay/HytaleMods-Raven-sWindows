$glassPane = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane"

Get-ChildItem -Path $glassPane -Filter "*.blockymodel" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw

    # Front face: (0, 0) -> (2, 2) - center glass texture
    $content = $content -replace '("front":\s*\{\s*"offset":\s*\{\s*"x":\s*)0(,\s*"y":\s*)0(\s*\})', '${1}2${2}2${3}'

    # Back face: (32, 0) -> (2, 2) - same as front (single-sided)
    # OR if it's still (0, 0), change to (2, 2)
    $content = $content -replace '("back":\s*\{\s*"offset":\s*\{\s*"x":\s*)32(,\s*"y":\s*)0(\s*\})', '${1}2${2}2${3}'
    $content = $content -replace '("back":\s*\{\s*"offset":\s*\{\s*"x":\s*)0(,\s*"y":\s*)0(\s*\})', '${1}2${2}2${3}'

    # Left edge: (32, 0) -> (0, 2) - left strip
    # OR if it's (0, 0), change to (0, 2)
    $content = $content -replace '("left":\s*\{\s*"offset":\s*\{\s*"x":\s*)32(,\s*"y":\s*)0(\s*\})', '${1}0${2}2${3}'
    $content = $content -replace '("left":\s*\{\s*"offset":\s*\{\s*"x":\s*)0(,\s*"y":\s*)0(\s*\})', '${1}0${2}2${3}'

    # Right edge: (32, 0) -> (34, 2) - right strip
    # OR if it's (0, 0), change to (34, 2)
    $content = $content -replace '("right":\s*\{\s*"offset":\s*\{\s*"x":\s*)32(,\s*"y":\s*)0(\s*\})', '${1}34${2}2${3}'
    $content = $content -replace '("right":\s*\{\s*"offset":\s*\{\s*"x":\s*)0(,\s*"y":\s*)0(\s*\})', '${1}34${2}2${3}'

    # Top edge: (0, 0) -> (2, 0) - top strip
    $content = $content -replace '("top":\s*\{\s*"offset":\s*\{\s*"x":\s*)0(,\s*"y":\s*)0(\s*\})', '${1}2${2}0${3}'

    # Bottom edge: (0, 0) -> (2, 34) - bottom strip
    $content = $content -replace '("bottom":\s*\{\s*"offset":\s*\{\s*"x":\s*)0(,\s*"y":\s*)0(\s*\})', '${1}2${2}34${3}'

    Set-Content -Path $_.FullName -Value $content -NoNewline
    Write-Host "Fixed: $($_.Name)"
}

Write-Host "`nAll GlassPane model offsets updated for 36x36 texture format:"
Write-Host "  - Front/Back: (2, 2) - center glass texture"
Write-Host "  - Left: (0, 2) - left edge strip"
Write-Host "  - Right: (34, 2) - right edge strip"
Write-Host "  - Top: (2, 0) - top edge strip"
Write-Host "  - Bottom: (2, 34) - bottom edge strip"
