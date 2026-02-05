Add-Type -AssemblyName System.Drawing

$bmp = New-Object System.Drawing.Bitmap(32, 32)
$glass = [System.Drawing.Color]::FromArgb(60, 200, 230, 255)
$red = [System.Drawing.Color]::FromArgb(255, 255, 0, 0)
$blue = [System.Drawing.Color]::FromArgb(255, 0, 0, 255)
$green = [System.Drawing.Color]::FromArgb(255, 0, 255, 0)
$yellow = [System.Drawing.Color]::FromArgb(255, 255, 255, 0)
$white = [System.Drawing.Color]::FromArgb(255, 255, 255, 255)

# Fill with glass
for ($y = 0; $y -lt 32; $y++) {
    for ($x = 0; $x -lt 32; $x++) {
        $bmp.SetPixel($x, $y, $glass)
    }
}

# Top-left corner: RED
for ($y = 0; $y -lt 6; $y++) {
    for ($x = 0; $x -lt 6; $x++) {
        $bmp.SetPixel($x, $y, $red)
    }
}

# Top-right corner: BLUE
for ($y = 0; $y -lt 6; $y++) {
    for ($x = 26; $x -lt 32; $x++) {
        $bmp.SetPixel($x, $y, $blue)
    }
}

# Bottom-left corner: GREEN
for ($y = 26; $y -lt 32; $y++) {
    for ($x = 0; $x -lt 6; $x++) {
        $bmp.SetPixel($x, $y, $green)
    }
}

# Bottom-right corner: YELLOW
for ($y = 26; $y -lt 32; $y++) {
    for ($x = 26; $x -lt 32; $x++) {
        $bmp.SetPixel($x, $y, $yellow)
    }
}

# White T/B borders
for ($x = 6; $x -lt 26; $x++) {
    $bmp.SetPixel($x, 0, $white)
    $bmp.SetPixel($x, 1, $white)
    $bmp.SetPixel($x, 30, $white)
    $bmp.SetPixel($x, 31, $white)
}

$bmp.Save("C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane\glass_horizontal.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "Created debug texture with colored corners: RED=top-left, BLUE=top-right, GREEN=bottom-left, YELLOW=bottom-right"
