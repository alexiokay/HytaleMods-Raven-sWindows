Add-Type -AssemblyName System.Drawing

$glassPane = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane"
$glassColor = [System.Drawing.Color]::FromArgb(40, 200, 230, 255)  # Light blue glass

Get-ChildItem -Path $glassPane -Filter "glass_*.png" | ForEach-Object {
    $oldBmp = New-Object System.Drawing.Bitmap($_.FullName)

    # Only process 32x32 textures
    if ($oldBmp.Width -eq 32 -and $oldBmp.Height -eq 32) {
        # Create 36x36 bitmap
        $newBmp = New-Object System.Drawing.Bitmap(36, 36)

        # Fill entire texture with glass color first (for edge strips)
        for ($x = 0; $x -lt 36; $x++) {
            for ($y = 0; $y -lt 36; $y++) {
                $newBmp.SetPixel($x, $y, $glassColor)
            }
        }

        # Copy original 32x32 texture to center (2-33, 2-33)
        for ($x = 0; $x -lt 32; $x++) {
            for ($y = 0; $y -lt 32; $y++) {
                $pixel = $oldBmp.GetPixel($x, $y)
                $newBmp.SetPixel($x + 2, $y + 2, $pixel)
            }
        }

        # Edge strips (0-1 and 34-35) are already filled with glass color

        $oldBmp.Dispose()
        $newBmp.Save($_.FullName, [System.Drawing.Imaging.ImageFormat]::Png)
        $newBmp.Dispose()
        Write-Host "Expanded: $($_.Name) (32x32 -> 36x36 with edge strips)"
    } else {
        $oldBmp.Dispose()
        Write-Host "Skipped: $($_.Name) (not 32x32)"
    }
}

Write-Host "`nExpanded all 32x32 textures to 36x36 with 2px solid edge strips:"
Write-Host "  - Center (2-33, 2-33): Original 32x32 glass texture"
Write-Host "  - Edges (0-1, 34-35): Solid glass color for thin faces"
