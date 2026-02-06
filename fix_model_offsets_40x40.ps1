$glassPane = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane"

Get-ChildItem -Path $glassPane -Filter "*.blockymodel" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw

    # Front face: (2, 2) -> (4, 4)
    $content = $content -replace '("front":\s*\{\s*"offset":\s*\{\s*"x":\s*)2(,\s*"y":\s*)2(\s*\})', '${1}4${2}4${3}'

    # Back face: (2, 2) -> (4, 4)
    $content = $content -replace '("back":\s*\{\s*"offset":\s*\{\s*"x":\s*)2(,\s*"y":\s*)2(\s*\})', '${1}4${2}4${3}'

    # Left edge: (0, 2) -> (0, 4)
    $content = $content -replace '("left":\s*\{\s*"offset":\s*\{\s*"x":\s*)0(,\s*"y":\s*)2(\s*\})', '${1}0${2}4${3}'

    # Right edge: (34, 2) -> (36, 4)
    $content = $content -replace '("right":\s*\{\s*"offset":\s*\{\s*"x":\s*)34(,\s*"y":\s*)2(\s*\})', '${1}36${2}4${3}'

    # Top edge: (2, 0) -> (4, 0)
    $content = $content -replace '("top":\s*\{\s*"offset":\s*\{\s*"x":\s*)2(,\s*"y":\s*)0(\s*\})', '${1}4${2}0${3}'

    # Bottom edge: (2, 34) -> (4, 36)
    $content = $content -replace '("bottom":\s*\{\s*"offset":\s*\{\s*"x":\s*)2(,\s*"y":\s*)34(\s*\})', '${1}4${2}36${3}'

    Set-Content -Path $_.FullName -Value $content -NoNewline
    Write-Host "Fixed: $($_.Name)"
}

Write-Host "`nAll GlassPane model offsets updated for 40x40 texture format:"
Write-Host "  - Front/Back: (4, 4) - center glass texture"
Write-Host "  - Left: (0, 4) - left edge strip (4px solid)"
Write-Host "  - Right: (36, 4) - right edge strip (4px solid)"
Write-Host "  - Top: (4, 0) - top edge strip (4px solid)"
Write-Host "  - Bottom: (4, 36) - bottom edge strip (4px solid)"
