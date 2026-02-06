Add-Type -AssemblyName System.Drawing

$glassPane = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane"
# Higher alpha for more visible/opaque glass (180 = semi-transparent but visible)
$glassColor = [System.Drawing.Color]::FromArgb(180, 200, 230, 255)  # Light blue glass

# Create textures for shapes with small arms: corners, t-shapes, cross
$shapes = @("corner_ne", "corner_nw", "corner_se", "corner_sw",
            "tshape_e", "tshape_n", "tshape_s", "tshape_w", "cross")

foreach ($shape in $shapes) {
    $bmp = New-Object System.Drawing.Bitmap(40, 40)

    # Fill entire texture with solid glass color (no borders)
    for ($x = 0; $x -lt 40; $x++) {
        for ($y = 0; $y -lt 40; $y++) {
            $bmp.SetPixel($x, $y, $glassColor)
        }
    }

    $outputPath = Join-Path $glassPane "glass_$shape.png"
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "Created: glass_$shape.png (alpha: 180)"
}

Write-Host "`nConnection textures created with consistent opacity:"
Write-Host "  - Alpha: 180/255 (semi-transparent but visible)"
Write-Host "  - Should look the same from all angles"
