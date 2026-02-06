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

Write-Host "`nUpdating blockymodel files for doubleSided: false..." -ForegroundColor Cyan
Write-Host "  Front face: offset (20, 4) for arms, (4, 4) for center" -ForegroundColor Yellow
Write-Host "  Back face: offset (30, 4) for arms, (56, 4) for center (mirrored)`n" -ForegroundColor Yellow

foreach ($fileName in $files) {
    $filePath = Join-Path $glassPane $fileName

    if (-not (Test-Path $filePath)) {
        Write-Host "Skipping $fileName (not found)" -ForegroundColor Red
        continue
    }

    $content = Get-Content $filePath -Raw
    $json = $content | ConvertFrom-Json

    foreach ($node in $json.nodes) {
        # Set doubleSided to false for all nodes
        $node.shape.doubleSided = $false

        if ($node.name -match "arm_") {
            # Arms use bordered region
            # Front face: left half (normal)
            $node.shape.textureLayout.front.offset.x = 20
            # Back face: right half (mirrored) - arms span x=30-43 in mirrored region
            $node.shape.textureLayout.back.offset.x = 30

            # Left and right faces also need proper offsets
            $node.shape.textureLayout.left.offset.x = 20
            $node.shape.textureLayout.right.offset.x = 20

            # Top and bottom
            $node.shape.textureLayout.top.offset.x = 20
            $node.shape.textureLayout.bottom.offset.x = 20

        } elseif ($node.name -match "center") {
            # Center uses clean glass region
            # Front face: left half
            $node.shape.textureLayout.front.offset.x = 4
            # Back face: right half (mirrored) - center at x=56-59
            $node.shape.textureLayout.back.offset.x = 56

            # Other faces
            $node.shape.textureLayout.left.offset.x = 4
            $node.shape.textureLayout.right.offset.x = 4
            $node.shape.textureLayout.top.offset.x = 4
            $node.shape.textureLayout.bottom.offset.x = 4
        }
    }

    # Convert back to JSON
    $newContent = $json | ConvertTo-Json -Depth 10 -Compress

    # Format it
    $newContent = $newContent -replace '\{"id":', "`n    {`"id`":"
    $newContent = $newContent -replace '^\s*\{', "{"
    $newContent = $newContent -replace '\}\]', "}`n  ]"
    $newContent = $newContent -replace ',"format":', ",`n  `"format`":"

    Set-Content -Path $filePath -Value $newContent -NoNewline
    Write-Host "Updated: $fileName" -ForegroundColor Green
}

Write-Host "`nAll blockymodel files updated to doubleSided: false!" -ForegroundColor Green
