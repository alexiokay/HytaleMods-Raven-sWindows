Add-Type -AssemblyName System.Drawing

$glassPane = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane"
$glassColor = [System.Drawing.Color]::FromArgb(180, 200, 230, 255)

# Create truly solid textures for corners, t-shapes, cross
$shapes = @("corner_ne", "corner_nw", "corner_se", "corner_sw",
            "tshape_e", "tshape_n", "tshape_s", "tshape_w", "cross")

foreach ($shape in $shapes) {
    $bmp = New-Object System.Drawing.Bitmap(40, 40)

    # Fill EVERY pixel with the exact same color
    for ($x = 0; $x -lt 40; $x++) {
        for ($y = 0; $y -lt 40; $y++) {
            $bmp.SetPixel($x, $y, $glassColor)
        }
    }

    $outputPath = Join-Path $glassPane "glass_$shape.png"
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)

    # Verify it's actually solid
    $verify = New-Object System.Drawing.Bitmap($outputPath)
    $allSame = $true
    for ($x = 0; $x -lt 40 -and $allSame; $x++) {
        for ($y = 0; $y -lt 40 -and $allSame; $y++) {
            $p = $verify.GetPixel($x, $y)
            if ($p.R -ne 200 -or $p.G -ne 230 -or $p.B -ne 255 -or $p.A -ne 180) {
                $allSame = $false
                Write-Host "ERROR: Pixel at ($x,$y) is different! RGBA=($($p.R),$($p.G),$($p.B),$($p.A))"
            }
        }
    }
    $verify.Dispose()
    $bmp.Dispose()

    if ($allSame) {
        Write-Host "OK: glass_$shape.png is solid"
    } else {
        Write-Host "FAIL: glass_$shape.png has variations!"
    }
}

Write-Host "`nAll textures regenerated and verified as solid"
