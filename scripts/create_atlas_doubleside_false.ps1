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

    # Create 64x32 texture (double width for front + mirrored back)
    $bmp = New-Object System.Drawing.Bitmap(64, 32)

    # Fill entire texture with glass color
    for ($x = 0; $x -lt 64; $x++) {
        for ($y = 0; $y -lt 32; $y++) {
            $bmp.SetPixel($x, $y, $glassColor)
        }
    }

    # LEFT HALF (x: 0-31) - Normal texture for front face
    # Region for center post (clean): x=4-7
    # Region for arms (bordered): x=20-33 (14 pixels)

    # Arm region borders (left half)
    if ($leftBorder) {
        for ($y = 4; $y -lt 28; $y++) {
            $bmp.SetPixel(20, $y, $borderColor)
            $bmp.SetPixel(21, $y, $borderColor)
        }
    }

    if ($rightBorder) {
        for ($y = 4; $y -lt 28; $y++) {
            $bmp.SetPixel(30, $y, $borderColor)
            $bmp.SetPixel(31, $y, $borderColor)
        }
    }

    if ($topBorder) {
        for ($x = 20; $x -lt 32; $x++) {
            $bmp.SetPixel($x, 4, $borderColor)
            $bmp.SetPixel($x, 5, $borderColor)
        }
        # Top face region
        for ($x = 20; $x -lt 24; $x++) {
            $bmp.SetPixel($x, 0, $borderColor)
            $bmp.SetPixel($x, 1, $borderColor)
        }
    }

    if ($bottomBorder) {
        for ($x = 20; $x -lt 32; $x++) {
            $bmp.SetPixel($x, 26, $borderColor)
            $bmp.SetPixel($x, 27, $borderColor)
        }
    }

    # RIGHT HALF (x: 32-63) - X-MIRRORED texture for back face
    # Mirror the left half to create the back face texture
    for ($x = 0; $x -lt 32; $x++) {
        for ($y = 0; $y -lt 32; $y++) {
            $sourcePixel = $bmp.GetPixel($x, $y)
            $mirrorX = 63 - $x  # Mirror around center
            $bmp.SetPixel($mirrorX, $y, $sourcePixel)
        }
    }

    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()

    Write-Host "Created $fileName (64x32 atlas)" -ForegroundColor Green
}

Write-Host "`nGenerating 64x32 texture atlases with mirrored back faces..." -ForegroundColor Cyan
Write-Host "  Left half (0-31): Normal texture (front faces)" -ForegroundColor Yellow
Write-Host "  Right half (32-63): X-mirrored (back faces)" -ForegroundColor Yellow
Write-Host "  doubleSided will be set to FALSE`n" -ForegroundColor Yellow

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

Write-Host "`nAll 64x32 texture atlases created!" -ForegroundColor Green
Write-Host "Next: Update blockymodel files for doubleSided: false" -ForegroundColor Cyan
