Add-Type -AssemblyName System.Drawing

$glassPane = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane"
$glassColor = [System.Drawing.Color]::FromArgb(40, 200, 230, 255)  # Light blue glass

Get-ChildItem -Path $glassPane -Filter "glass_*.png" | ForEach-Object {
    $oldBmp = New-Object System.Drawing.Bitmap($_.FullName)

    # Only process 40x40 textures
    if ($oldBmp.Width -eq 40 -and $oldBmp.Height -eq 40) {
        # Create 36x36 bitmap
        $newBmp = New-Object System.Drawing.Bitmap(36, 36)

        # Fill with glass color first (for 2px edge strips)
        for ($x = 0; $x -lt 36; $x++) {
            for ($y = 0; $y -lt 36; $y++) {
                $newBmp.SetPixel($x, $y, $glassColor)
            }
        }

        # Copy center 32x32 from old texture (4-35, 4-35) to new texture (2-33, 2-33)
        for ($x = 0; $x -lt 32; $x++) {
            for ($y = 0; $y -lt 32; $y++) {
                $pixel = $oldBmp.GetPixel($x + 4, $y + 4)
                $newBmp.SetPixel($x + 2, $y + 2, $pixel)
            }
        }

        $oldBmp.Dispose()
        $newBmp.Save($_.FullName, [System.Drawing.Imaging.ImageFormat]::Png)
        $newBmp.Dispose()
        Write-Host "Cropped: $($_.Name) (40x40 -> 36x36)"
    } else {
        $oldBmp.Dispose()
        Write-Host "Skipped: $($_.Name) (not 40x40)"
    }
}

Write-Host "`nCropped all 40x40 textures back to 36x36 with 2px edge strips"
