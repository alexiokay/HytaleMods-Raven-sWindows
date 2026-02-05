Add-Type -AssemblyName System.Drawing

$sourceDir = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPaneOneSided"
$glassColor = [System.Drawing.Color]::FromArgb(255, 240, 250, 245)  # Solid opaque glass

Get-ChildItem -Path $sourceDir -Filter "glass_*.png" | ForEach-Object {
    $oldBmp = New-Object System.Drawing.Bitmap($_.FullName)
    $newBmp = New-Object System.Drawing.Bitmap(64, 32)

    # Copy left half (original 32x32 texture)
    for ($x = 0; $x -lt 32; $x++) {
        for ($y = 0; $y -lt 32; $y++) {
            $newBmp.SetPixel($x, $y, $oldBmp.GetPixel($x, $y))
        }
    }

    # Fill right half (32-63) with solid glass color for side faces
    for ($x = 32; $x -lt 64; $x++) {
        for ($y = 0; $y -lt 32; $y++) {
            $newBmp.SetPixel($x, $y, $glassColor)
        }
    }

    $oldBmp.Dispose()
    $newBmp.Save($_.FullName, [System.Drawing.Imaging.ImageFormat]::Png)
    $newBmp.Dispose()
}

Write-Host "Expanded all Simple textures from 32x32 to 64x32 with solid region"
