Add-Type -AssemblyName System.Drawing

$glassPane = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane"
$glassColor = [System.Drawing.Color]::FromArgb(40, 200, 230, 255)  # Light blue glass

Get-ChildItem -Path $glassPane -Filter "glass_*.png" | ForEach-Object {
    $oldBmp = New-Object System.Drawing.Bitmap($_.FullName)

    # Only process 36x36 textures
    if ($oldBmp.Width -eq 36 -and $oldBmp.Height -eq 36) {
        # Create 40x40 bitmap
        $newBmp = New-Object System.Drawing.Bitmap(40, 40)

        # Fill entire texture with glass color first (for edge strips)
        for ($x = 0; $x -lt 40; $x++) {
            for ($y = 0; $y -lt 40; $y++) {
                $newBmp.SetPixel($x, $y, $glassColor)
            }
        }

        # Copy center 32x32 from old texture (2-33, 2-33) to new texture (4-35, 4-35)
        for ($x = 0; $x -lt 32; $x++) {
            for ($y = 0; $y -lt 32; $y++) {
                $pixel = $oldBmp.GetPixel($x + 2, $y + 2)
                $newBmp.SetPixel($x + 4, $y + 4, $pixel)
            }
        }

        # Edge strips (0-3 and 36-39) are already filled with glass color

        $oldBmp.Dispose()
        $newBmp.Save($_.FullName, [System.Drawing.Imaging.ImageFormat]::Png)
        $newBmp.Dispose()
        Write-Host "Expanded: $($_.Name) (36x36 -> 40x40 with 4px edge strips)"
    } else {
        $oldBmp.Dispose()
        Write-Host "Skipped: $($_.Name) (not 36x36)"
    }
}

Write-Host "`nExpanded all 36x36 textures to 40x40 with 4px solid edge strips:"
Write-Host "  - Center (4-35, 4-35): Original 32x32 glass texture"
Write-Host "  - Edges (0-3, 36-39): 4px solid glass color for thin faces"
