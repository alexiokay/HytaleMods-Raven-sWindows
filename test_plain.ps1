Add-Type -AssemblyName System.Drawing

$bmp = New-Object System.Drawing.Bitmap(32, 32)
$glass = [System.Drawing.Color]::FromArgb(60, 200, 230, 255)

# Fill entirely with glass - NO borders at all
for ($y = 0; $y -lt 32; $y++) {
    for ($x = 0; $x -lt 32; $x++) {
        $bmp.SetPixel($x, $y, $glass)
    }
}

$bmp.Save("C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane\glass_horizontal.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "Created plain glass texture (no borders)"
