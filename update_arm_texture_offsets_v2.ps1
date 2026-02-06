$glassPane = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane"

# List of files to update
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

Write-Host "`nUpdating arm texture offsets to use bordered region..." -ForegroundColor Cyan
Write-Host "  Center post: offset (4, 4) - clean glass" -ForegroundColor Yellow
Write-Host "  Arms: offset (20, 4) - bordered glass`n" -ForegroundColor Yellow

foreach ($fileName in $files) {
    $filePath = Join-Path $glassPane $fileName

    if (-not (Test-Path $filePath)) {
        Write-Host "Skipping $fileName (not found)" -ForegroundColor Red
        continue
    }

    $content = Get-Content $filePath -Raw
    $json = $content | ConvertFrom-Json

    $modified = $false

    foreach ($node in $json.nodes) {
        # Only update arm nodes, not center_post
        if ($node.name -match "arm_") {
            # Update main face offsets
            if ($node.shape.textureLayout.back.offset.x -eq 4) {
                $node.shape.textureLayout.back.offset.x = 20
                $modified = $true
            }
            if ($node.shape.textureLayout.front.offset.x -eq 4) {
                $node.shape.textureLayout.front.offset.x = 20
                $modified = $true
            }
            if ($node.shape.textureLayout.right.offset.x -eq 4) {
                $node.shape.textureLayout.right.offset.x = 20
                $modified = $true
            }
            if ($node.shape.textureLayout.left.offset.x -eq 4) {
                $node.shape.textureLayout.left.offset.x = 20
                $modified = $true
            }
            if ($node.shape.textureLayout.top.offset.x -eq 4) {
                $node.shape.textureLayout.top.offset.x = 20
                $modified = $true
            }
            if ($node.shape.textureLayout.bottom.offset.x -eq 4) {
                $node.shape.textureLayout.bottom.offset.x = 20
                $modified = $true
            }
        }
    }

    if ($modified) {
        # Convert back to JSON with proper formatting
        $newContent = $json | ConvertTo-Json -Depth 10 -Compress

        # Format it nicely (one line per node for readability)
        $newContent = $newContent -replace '\{"id":', "`n    {`"id`":"
        $newContent = $newContent -replace '^\s*\{', "{"
        $newContent = $newContent -replace '\}\]', "}`n  ]"
        $newContent = $newContent -replace ',"format":', ",`n  `"format`":"

        Set-Content -Path $filePath -Value $newContent -NoNewline
        Write-Host "Updated: $fileName" -ForegroundColor Green
    } else {
        Write-Host "No changes needed: $fileName" -ForegroundColor Yellow
    }
}

Write-Host "`nAll blockymodel files updated!" -ForegroundColor Green
Write-Host "Arms now use offset (20,*) for bordered texture region" -ForegroundColor Cyan
