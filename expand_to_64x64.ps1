Add-Type -AssemblyName System.Drawing

$sourceDir = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPaneOneSided"
$glassColor = [System.Drawing.Color]::FromArgb(255, 240, 250, 245)

Get-ChildItem -Path $sourceDir -Filter "glass_*.png" | ForEach-Object {
    $oldBmp = New-Object System.Drawing.Bitmap($_.FullName)
    $newBmp = New-Object System.Drawing.Bitmap(64, 64)

    # Copy original texture to top-left (0-31, 0-31)
    for ($x = 0; $x -lt [Math]::Min(64, $oldBmp.Width); $x++) {
        for ($y = 0; $y -lt [Math]::Min(32, $oldBmp.Height); $y++) {
            if ($x -lt $oldBmp.Width -and $y -lt $oldBmp.Height) {
                $newBmp.SetPixel($x, $y, $oldBmp.GetPixel($x, $y))
            }
        }
    }

    # Fill solid region (x: 32-63, y: 0-63) with solid glass
    for ($x = 32; $x -lt 64; $x++) {
        for ($y = 0; $y -lt 64; $y++) {
            $newBmp.SetPixel($x, $y, $glassColor)
        }
    }

    # Fill bottom region (y: 32-63) with solid glass for sides
    for ($x = 0; $x -lt 32; $x++) {
        for ($y = 32; $y -lt 64; $y++) {
            $newBmp.SetPixel($x, $y, $glassColor)
        }
    }

    $oldBmp.Dispose()
    $newBmp.Save($_.FullName, [System.Drawing.Imaging.ImageFormat]::Png)
    $newBmp.Dispose()
}

Write-Host "Expanded all textures to 64x64 with full solid regions"
