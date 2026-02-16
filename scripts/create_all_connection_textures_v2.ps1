Add-Type -AssemblyName System.Drawing

$basePath = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane"

# Colors
$glassColor = [System.Drawing.Color]::FromArgb(180, 200, 230, 255)  # Semi-transparent light blue
$borderColor = [System.Drawing.Color]::FromArgb(255, 100, 140, 180)  # Solid darker blue border

function Create-Texture {
    param(
        [string]$fileName,
        [bool]$leftBorder,
        [bool]$rightBorder,
        [bool]$topBorder,
        [bool]$bottomBorder
    )

    $outputPath = Join-Path $basePath $fileName
    $bmp = New-Object System.Drawing.Bitmap(40, 40)

    # Fill with glass color
    for ($x = 0; $x -lt 40; $x++) {
        for ($y = 0; $y -lt 40; $y++) {
            $bmp.SetPixel($x, $y, $glassColor)
        }
    }

    # IMPORTANT: Center post and arm thin faces sample x=4-7 (4 pixels wide)
    # Arm wide faces sample x=4-17 (14 pixels wide)
    # We need to keep x=4-7 border-free for center post, add borders at x=8+ and x=16-17

    # Add borders only on the outer edges of the WIDE arm faces (14 pixels)
    # Left border at x=8-9 (visible on wide arms, not on center post)
    if ($leftBorder) {
        for ($y = 4; $y -lt 36; $y++) {
            $bmp.SetPixel(8, $y, $borderColor)
            $bmp.SetPixel(9, $y, $borderColor)
        }
    }

    # Right border at x=16-17 (edge of wide arm faces)
    if ($rightBorder) {
        for ($y = 4; $y -lt 36; $y++) {
            $bmp.SetPixel(16, $y, $borderColor)
            $bmp.SetPixel(17, $y, $borderColor)
        }
    }

    # Top/bottom borders span the full arm width
    if ($topBorder) {
        for ($x = 4; $x -lt 18; $x++) {
            $bmp.SetPixel($x, 4, $borderColor)
            $bmp.SetPixel($x, 5, $borderColor)
        }
        # Top face region (4 pixels wide)
        for ($x = 4; $x -lt 8; $x++) {
            $bmp.SetPixel($x, 0, $borderColor)
            $bmp.SetPixel($x, 1, $borderColor)
        }
    }

    if ($bottomBorder) {
        for ($x = 4; $x -lt 18; $x++) {
            $bmp.SetPixel($x, 34, $borderColor)
            $bmp.SetPixel($x, 35, $borderColor)
        }
        # Bottom face region
        for ($x = 4; $x -lt 8; $x++) {
            $bmp.SetPixel($x, 36, $borderColor)
            $bmp.SetPixel($x, 37, $borderColor)
        }
    }

    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()

    Write-Host "Created $fileName" -ForegroundColor Green
}

Write-Host "`nGenerating glass pane connection textures (v2 - no center stripes)..." -ForegroundColor Cyan
Write-Host "Fixed: Borders positioned to avoid center post stripe issue`n" -ForegroundColor Yellow

# Cross - all 4 sides connect
Create-Texture "glass_cross.png" $true $true $true $true

# Corners - 2 sides connect each
Create-Texture "glass_corner_ne.png" $false $true $true $true
Create-Texture "glass_corner_nw.png" $true $false $true $true
Create-Texture "glass_corner_se.png" $false $true $true $true
Create-Texture "glass_corner_sw.png" $true $false $true $true

# T-shapes - 3 sides connect each
Create-Texture "glass_tshape_n.png" $true $true $true $true
Create-Texture "glass_tshape_s.png" $true $true $true $true
Create-Texture "glass_tshape_e.png" $true $true $true $true
Create-Texture "glass_tshape_w.png" $true $true $true $true

Write-Host "`nAll textures updated!" -ForegroundColor Green
Write-Host "Borders now positioned at x=8-9 and x=16-17 to avoid center post stripes" -ForegroundColor Cyan
Write-Host "Location: $basePath" -ForegroundColor Cyan
