Add-Type -AssemblyName System.Drawing

$outputPath = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane\glass_cross.png"

# Colors
$glassColor = [System.Drawing.Color]::FromArgb(180, 200, 230, 255)  # Semi-transparent light blue
$borderColor = [System.Drawing.Color]::FromArgb(255, 100, 140, 180)  # Solid darker blue border

# Create 40x40 texture
$bmp = New-Object System.Drawing.Bitmap(40, 40)

# Fill entire texture with glass color first
for ($x = 0; $x -lt 40; $x++) {
    for ($y = 0; $y -lt 40; $y++) {
        $bmp.SetPixel($x, $y, $glassColor)
    }
}

# The cross arms sample from the region starting at offset (4, 4)
# For a 14-pixel wide face (left/right faces of arms), it samples x=4-17
# For a 32-pixel tall face, it samples y=4-35
# Top faces sample from y=0, bottom faces from y=36

# Add LEFT border (x=4-5) - where cross connects to west window
for ($y = 4; $y -lt 36; $y++) {
    $bmp.SetPixel(4, $y, $borderColor)
    $bmp.SetPixel(5, $y, $borderColor)
}

# Add RIGHT border (x=16-17) - where cross connects to east window
for ($y = 4; $y -lt 36; $y++) {
    $bmp.SetPixel(16, $y, $borderColor)
    $bmp.SetPixel(17, $y, $borderColor)
}

# Add TOP border (y=4-5) - top edge
for ($x = 4; $x -lt 18; $x++) {
    $bmp.SetPixel($x, 4, $borderColor)
    $bmp.SetPixel($x, 5, $borderColor)
}

# Add BOTTOM border (y=34-35) - bottom edge
for ($x = 4; $x -lt 18; $x++) {
    $bmp.SetPixel($x, 34, $borderColor)
    $bmp.SetPixel($x, 35, $borderColor)
}

# Also add borders to top face region (y=0-13, x=4-7 for 4-pixel wide faces)
# Top border for top face
for ($x = 4; $x -lt 8; $x++) {
    $bmp.SetPixel($x, 0, $borderColor)
    $bmp.SetPixel($x, 1, $borderColor)
}

# Bottom face samples from y=36, needs borders too
for ($x = 4; $x -lt 8; $x++) {
    $bmp.SetPixel($x, 36, $borderColor)
    $bmp.SetPixel($x, 37, $borderColor)
}

$bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()

Write-Host "Created glass_cross.png with selective borders" -ForegroundColor Green
Write-Host "  - Borders on left/right edges (where cross connects to windows)" -ForegroundColor Cyan
Write-Host "  - Borders on top/bottom edges" -ForegroundColor Cyan
Write-Host "  - Glass color in center" -ForegroundColor Cyan
