$glassPane = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane"

$files = @(
    "cross.blockymodel",
    "corner_ne.blockymodel",
    "corner_nw.blockymodel",
    "corner_se.blockymodel",
    "corner_sw.blockymodel",
    "tshape_n.blockymodel",
    "tshape_s.blockymodel",
    "tshape_e.blockymodel",
    "tshape_w.blockymodel"
)

Write-Host "`nUpdating back face offsets to use clean region..." -ForegroundColor Cyan

foreach ($fileName in $files) {
    $filePath = Join-Path $glassPane $fileName

    if (-not (Test-Path $filePath)) {
        Write-Host "Skipping $fileName (not found)" -ForegroundColor Red
        continue
    }

    $content = Get-Content $filePath -Raw
    $json = $content | ConvertFrom-Json

    foreach ($node in $json.nodes) {
        if ($node.name -match "arm_") {
            # Arms: back face uses clean region (x: 36)
            $node.shape.textureLayout.back.offset.x = 36
        }
        # Center already uses correct offsets
    }

    $newContent = $json | ConvertTo-Json -Depth 10 -Compress
    $newContent = $newContent -replace '\{"id":', "`n    {`"id`":"
    $newContent = $newContent -replace '^\s*\{', "{"
    $newContent = $newContent -replace '\}\]', "}`n  ]"
    $newContent = $newContent -replace ',"format":', ",`n  `"format`":"

    Set-Content -Path $filePath -Value $newContent -NoNewline
    Write-Host "Updated: $fileName" -ForegroundColor Green
}

Write-Host "`nAll back faces now use clean texture region!" -ForegroundColor Green
