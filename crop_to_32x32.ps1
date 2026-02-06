Add-Type -AssemblyName System.Drawing

$glassPane = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane"

Get-ChildItem -Path $glassPane -Filter "glass_*.png" | ForEach-Object {
    $oldBmp = New-Object System.Drawing.Bitmap($_.FullName)

    # Only process if texture is 64x32 (double-sided atlas)
    if ($oldBmp.Width -eq 64 -and $oldBmp.Height -eq 32) {
        # Create new 32x32 bitmap
        $newBmp = New-Object System.Drawing.Bitmap(32, 32)

        # Copy left half only (x: 0-31, y: 0-31)
        for ($x = 0; $x -lt 32; $x++) {
            for ($y = 0; $y -lt 32; $y++) {
                $pixel = $oldBmp.GetPixel($x, $y)
                $newBmp.SetPixel($x, $y, $pixel)
            }
        }

        $oldBmp.Dispose()
        $newBmp.Save($_.FullName, [System.Drawing.Imaging.ImageFormat]::Png)
        $newBmp.Dispose()
        Write-Host "Cropped: $($_.Name) (64x32 -> 32x32)"
    } else {
        $oldBmp.Dispose()
        Write-Host "Skipped: $($_.Name) (not 64x32)"
    }
}

Write-Host "`nCropped all 64x32 double-sided textures to 32x32 single-sided"
