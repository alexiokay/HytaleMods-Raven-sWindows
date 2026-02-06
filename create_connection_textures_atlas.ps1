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

    # Fill entire texture with glass color
    for ($x = 0; $x -lt 40; $x++) {
        for ($y = 0; $y -lt 40; $y++) {
            $bmp.SetPixel($x, $y, $glassColor)
        }
    }

    # REGION 1: x=4-7 (center post - 4 pixels wide) - CLEAN, NO BORDERS

    # REGION 2: x=20-33 (arms - 14 pixels wide) - WITH BORDERS
    # This region is for arms that sample from offset (20, 4)

    # Left border at x=20-21 (left edge of 14-pixel arm region)
    if ($leftBorder) {
        for ($y = 4; $y -lt 36; $y++) {
            $bmp.SetPixel(20, $y, $borderColor)
            $bmp.SetPixel(21, $y, $borderColor)
        }
    }

    # Right border at x=32-33 (right edge of 14-pixel arm region)
    if ($rightBorder) {
        for ($y = 4; $y -lt 36; $y++) {
            $bmp.SetPixel(32, $y, $borderColor)
            $bmp.SetPixel(33, $y, $borderColor)
        }
    }

    # Top border in arm region
    if ($topBorder) {
        for ($x = 20; $x -lt 34; $x++) {
            $bmp.SetPixel($x, 4, $borderColor)
            $bmp.SetPixel($x, 5, $borderColor)
        }
        # Top face region for arms (also offset at x=20)
        for ($x = 20; $x -lt 24; $x++) {
            $bmp.SetPixel($x, 0, $borderColor)
            $bmp.SetPixel($x, 1, $borderColor)
        }
    }

    # Bottom border in arm region
    if ($bottomBorder) {
        for ($x = 20; $x -lt 34; $x++) {
            $bmp.SetPixel($x, 34, $borderColor)
            $bmp.SetPixel($x, 35, $borderColor)
        }
        # Bottom face region for arms
        for ($x = 20; $x -lt 24; $x++) {
            $bmp.SetPixel($x, 36, $borderColor)
            $bmp.SetPixel($x, 37, $borderColor)
        }
    }

    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()

    Write-Host "Created $fileName" -ForegroundColor Green
}

Write-Host "`nGenerating texture atlas with clean center + bordered arms..." -ForegroundColor Cyan
Write-Host "  x=4-7: Clean glass (center post)" -ForegroundColor Yellow
Write-Host "  x=20-33: Glass with borders (arms)`n" -ForegroundColor Yellow

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

Write-Host "`nAll texture atlases created!" -ForegroundColor Green
Write-Host "Next: Update blockymodel files to use offset (20,4) for arms" -ForegroundColor Cyan
