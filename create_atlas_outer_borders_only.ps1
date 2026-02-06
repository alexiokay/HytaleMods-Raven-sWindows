Add-Type -AssemblyName System.Drawing

$basePath = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane"

# Colors
$glassColor = [System.Drawing.Color]::FromArgb(180, 200, 230, 255)
$borderColor = [System.Drawing.Color]::FromArgb(255, 100, 140, 180)

function Create-Texture {
    param(
        [string]$fileName,
        [bool]$leftBorder,
        [bool]$rightBorder,
        [bool]$topBorder,
        [bool]$bottomBorder
    )

    $outputPath = Join-Path $basePath $fileName
    $bmp = New-Object System.Drawing.Bitmap(64, 32)

    # Fill entire texture with glass color
    for ($x = 0; $x -lt 64; $x++) {
        for ($y = 0; $y -lt 32; $y++) {
            $bmp.SetPixel($x, $y, $glassColor)
        }
    }

    # REGION 1: Center post clean glass (x: 4-7)
    # Already filled with glass color, no borders

    # REGION 2: Arm FRONT faces with borders (x: 20-33, 14 pixels)
    if ($leftBorder) {
        for ($y = 4; $y -lt 28; $y++) {
            $bmp.SetPixel(20, $y, $borderColor)
            $bmp.SetPixel(21, $y, $borderColor)
        }
    }

    if ($rightBorder) {
        for ($y = 4; $y -lt 28; $y++) {
            $bmp.SetPixel(32, $y, $borderColor)
            $bmp.SetPixel(33, $y, $borderColor)
        }
    }

    if ($topBorder) {
        for ($x = 20; $x -lt 34; $x++) {
            $bmp.SetPixel($x, 4, $borderColor)
            $bmp.SetPixel($x, 5, $borderColor)
        }
    }

    if ($bottomBorder) {
        for ($x = 20; $x -lt 34; $x++) {
            $bmp.SetPixel($x, 26, $borderColor)
            $bmp.SetPixel($x, 27, $borderColor)
        }
    }

    # REGION 3: Arm BACK faces - CLEAN, NO BORDERS (x: 36-49, 14 pixels)
    # This region is for back faces that face toward center
    # Already filled with glass color, intentionally NO borders

    # REGION 4: Center back face - clean (x: 56-59)
    # Already filled with glass color

    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()

    Write-Host "Created $fileName" -ForegroundColor Green
}

Write-Host "`nGenerating texture atlas with borders only on OUTER faces..." -ForegroundColor Cyan
Write-Host "  x: 4-7    = Center post (clean)" -ForegroundColor Yellow
Write-Host "  x: 20-33  = Arm front/sides (WITH borders)" -ForegroundColor Yellow
Write-Host "  x: 36-49  = Arm back (CLEAN - faces center)" -ForegroundColor Yellow
Write-Host "  x: 56-59  = Center back (clean)`n" -ForegroundColor Yellow

# Cross
Create-Texture "glass_cross.png" $true $true $true $true

# Corners
Create-Texture "glass_corner_ne.png" $false $true $true $true
Create-Texture "glass_corner_nw.png" $true $false $true $true
Create-Texture "glass_corner_se.png" $false $true $true $true
Create-Texture "glass_corner_sw.png" $true $false $true $true

# T-shapes
Create-Texture "glass_tshape_n.png" $true $true $true $true
Create-Texture "glass_tshape_s.png" $true $true $true $true
Create-Texture "glass_tshape_e.png" $true $true $true $true
Create-Texture "glass_tshape_w.png" $true $true $true $true

Write-Host "`nTextures created! Now updating blockymodel back face offsets..." -ForegroundColor Green
