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

    # Add borders where specified
    # Main face region (x=4-17, y=4-35)

    if ($leftBorder) {
        for ($y = 4; $y -lt 36; $y++) {
            $bmp.SetPixel(4, $y, $borderColor)
            $bmp.SetPixel(5, $y, $borderColor)
        }
    }

    if ($rightBorder) {
        for ($y = 4; $y -lt 36; $y++) {
            $bmp.SetPixel(16, $y, $borderColor)
            $bmp.SetPixel(17, $y, $borderColor)
        }
    }

    if ($topBorder) {
        for ($x = 4; $x -lt 18; $x++) {
            $bmp.SetPixel($x, 4, $borderColor)
            $bmp.SetPixel($x, 5, $borderColor)
        }
        # Top face region
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

Write-Host "`nGenerating glass pane connection textures with selective borders..." -ForegroundColor Cyan
Write-Host "Borders appear only where panes connect to other windows, and on top/bottom`n" -ForegroundColor Yellow

# Cross - all 4 sides connect
Create-Texture "glass_cross.png" $true $true $true $true
Write-Host "  Cross: borders on all sides (N+S+E+W connections) + top/bottom`n"

# Corners - 2 sides connect each
Create-Texture "glass_corner_ne.png" $false $true $true $true  # North + East
Write-Host "  Corner NE: borders on north and east edges + top/bottom"

Create-Texture "glass_corner_nw.png" $true $false $true $true  # North + West
Write-Host "  Corner NW: borders on north and west edges + top/bottom"

Create-Texture "glass_corner_se.png" $false $true $true $true  # South + East
Write-Host "  Corner SE: borders on south and east edges + top/bottom"

Create-Texture "glass_corner_sw.png" $true $false $true $true  # South + West
Write-Host "  Corner SW: borders on south and west edges + top/bottom`n"

# T-shapes - 3 sides connect each
Create-Texture "glass_tshape_n.png" $true $true $true $true  # T pointing north: W+N+E
Write-Host "  T-shape North: borders on west, north, and east edges + top/bottom"

Create-Texture "glass_tshape_s.png" $true $true $true $true  # T pointing south: W+S+E
Write-Host "  T-shape South: borders on west, south, and east edges + top/bottom"

Create-Texture "glass_tshape_e.png" $true $true $true $true  # T pointing east: N+E+S
Write-Host "  T-shape East: borders on north, east, and south edges + top/bottom"

Create-Texture "glass_tshape_w.png" $true $true $true $true  # T pointing west: N+W+S
Write-Host "  T-shape West: borders on north, west, and south edges + top/bottom"

Write-Host "`nAll textures created successfully!" -ForegroundColor Green
Write-Host "Location: $basePath" -ForegroundColor Cyan
