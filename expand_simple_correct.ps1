Add-Type -AssemblyName System.Drawing

$sourceDir = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPaneOneSided"
$glassColor = [System.Drawing.Color]::FromArgb(255, 240, 250, 245)  # Solid opaque glass

Get-ChildItem -Path $sourceDir -Filter "glass_*.png" | ForEach-Object {
    $oldBmp = New-Object System.Drawing.Bitmap($_.FullName)
    $newBmp = New-Object System.Drawing.Bitmap(64, 64)

    # LEFT HALF (x: 0-31): Glass texture region
    # Top portion (0-31, 0-31): Copy original 32x32 glass texture with borders
    for ($x = 0; $x -lt 32; $x++) {
        for ($y = 0; $y -lt 32; $y++) {
            if ($x -lt $oldBmp.Width -and $y -lt $oldBmp.Height) {
                $newBmp.SetPixel($x, $y, $oldBmp.GetPixel($x, $y))
            }
        }
    }

    # Bottom portion (0-31, 32-63): Fill with solid color (no borders, no tiling)
    for ($x = 0; $x -lt 32; $x++) {
        for ($y = 32; $y -lt 64; $y++) {
            $newBmp.SetPixel($x, $y, $glassColor)
        }
    }

    # RIGHT HALF (x: 32-63, full height 0-63): Solid color for thin edges
    for ($x = 32; $x -lt 64; $x++) {
        for ($y = 0; $y -lt 64; $y++) {
            $newBmp.SetPixel($x, $y, $glassColor)
        }
    }

    $oldBmp.Dispose()
    $newBmp.Save($_.FullName, [System.Drawing.Imaging.ImageFormat]::Png)
    $newBmp.Dispose()
    Write-Host "Processed: $($_.Name)"
}

Write-Host "`nExpanded all Simple textures to 64x64 with correct format:"
Write-Host "  Left half (0-31): Glass texture for front/back faces"
Write-Host "  Right half (32-63): Solid color for edge faces"
