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
    $original = $content

    # Parse JSON to identify arm nodes vs center_post
    $json = $content | ConvertFrom-Json

    foreach ($node in $json.nodes) {
        # Only update arm nodes, not center_post
        if ($node.name -match "arm_") {
            # Replace offset (4, 4) with (20, 4) for main faces in this arm's textureLayout
            # We need to do string replacement on the JSON for this specific node

            # Build the node pattern to find this specific arm
            $nodeId = $node.id
            $nodeName = $node.name

            # Find and replace offsets for this arm node
            # Main faces: change "offset": {"x": 4, "y": 4} to "offset": {"x": 20, "y": 4}
            # Top face: change "offset": {"x": 4, "y": 0} to "offset": {"x": 20, "y": 0}
            # Bottom face: change "offset": {"x": 4, "y": 36} to "offset": {"x": 20, "y": 36}
        }
    }

    # Do regex replacements for arms only
    # This is tricky because we need to distinguish arms from center_post

    # Strategy: Replace all (4,*) offsets with (20,*), then fix center_post back to (4,*)

    # First pass: change all offsets to (20,*)
    $content = $content -replace '("arm_[^"]*"[^}]*"textureLayout":\s*\{[^}]*"back":\s*\{)"offset":\s*\{"x":\s*4,\s*"y":\s*4\}', '${1}"offset": {"x": 20, "y": 4}'
    $content = $content -replace '("arm_[^"]*"[^}]*"textureLayout":\s*\{[^}]*"front":\s*\{)"offset":\s*\{"x":\s*4,\s*"y":\s*4\}', '${1}"offset": {"x": 20, "y": 4}'
    $content = $content -replace '("arm_[^"]*"[^}]*"textureLayout":\s*\{[^}]*"right":\s*\{)"offset":\s*\{"x":\s*4,\s*"y":\s*4\}', '${1}"offset": {"x": 20, "y": 4}'
    $content = $content -replace '("arm_[^"]*"[^}]*"textureLayout":\s*\{[^}]*"left":\s*\{)"offset":\s*\{"x":\s*4,\s*"y":\s*4\}', '${1}"offset": {"x": 20, "y": 4}'
    $content = $content -replace '("arm_[^"]*"[^}]*"textureLayout":\s*\{[^}]*"top":\s*\{)"offset":\s*\{"x":\s*4,\s*"y":\s*0\}', '${1}"offset": {"x": 20, "y": 0}'
    $content = $content -replace '("arm_[^"]*"[^}]*"textureLayout":\s*\{[^}]*"bottom":\s*\{)"offset":\s*\{"x":\s*4,\s*"y":\s*36\}', '${1}"offset": {"x": 20, "y": 36}'

    if ($content -ne $original) {
        Set-Content -Path $filePath -Value $content -NoNewline
        Write-Host "Updated: $fileName" -ForegroundColor Green
    } else {
        Write-Host "No changes: $fileName" -ForegroundColor Yellow
    }
}

Write-Host "`nAll blockymodel files updated!" -ForegroundColor Green
Write-Host "Arms now use offset (20,*) for bordered texture region" -ForegroundColor Cyan
