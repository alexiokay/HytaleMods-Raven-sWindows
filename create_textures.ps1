Add-Type -AssemblyName System.Drawing

function Create-GlassTexture {
    param(
        [string]$path,
        [bool]$leftBorder,
        [bool]$rightBorder,
        [bool]$topBorder,
        [bool]$bottomBorder
    )

    # Create 64x32 texture atlas: left half = front, right half = mirrored for back
    $bmp = New-Object System.Drawing.Bitmap(64, 32)
    $glass = [System.Drawing.Color]::FromArgb(40, 200, 230, 255)
    $border = [System.Drawing.Color]::FromArgb(255, 220, 235, 245)

    # Fill entire texture with glass
    for ($y = 0; $y -lt 32; $y++) {
        for ($x = 0; $x -lt 64; $x++) {
            $bmp.SetPixel($x, $y, $glass)
        }
    }

    # LEFT HALF (0-31): Normal texture for front face
    if ($topBorder) {
        for ($x = 0; $x -lt 32; $x++) {
            $bmp.SetPixel($x, 0, $border)
            $bmp.SetPixel($x, 1, $border)
        }
    }
    if ($bottomBorder) {
        for ($x = 0; $x -lt 32; $x++) {
            $bmp.SetPixel($x, 30, $border)
            $bmp.SetPixel($x, 31, $border)
        }
    }
    if ($leftBorder) {
        for ($y = 0; $y -lt 32; $y++) {
            $bmp.SetPixel(0, $y, $border)
            $bmp.SetPixel(1, $y, $border)
        }
    }
    if ($rightBorder) {
        for ($y = 0; $y -lt 32; $y++) {
            $bmp.SetPixel(30, $y, $border)
            $bmp.SetPixel(31, $y, $border)
        }
    }

    # RIGHT HALF (32-63): X-Mirrored texture for back face
    # When back face is viewed, it will be naturally flipped, so pre-flip here
    if ($topBorder) {
        for ($x = 32; $x -lt 64; $x++) {
            $bmp.SetPixel($x, 0, $border)
            $bmp.SetPixel($x, 1, $border)
        }
    }
    if ($bottomBorder) {
        for ($x = 32; $x -lt 64; $x++) {
            $bmp.SetPixel($x, 30, $border)
            $bmp.SetPixel($x, 31, $border)
        }
    }
    # Mirrored: leftBorder on RIGHT side of the right half
    if ($leftBorder) {
        for ($y = 0; $y -lt 32; $y++) {
            $bmp.SetPixel(62, $y, $border)
            $bmp.SetPixel(63, $y, $border)
        }
    }
    # Mirrored: rightBorder on LEFT side of the right half
    if ($rightBorder) {
        for ($y = 0; $y -lt 32; $y++) {
            $bmp.SetPixel(32, $y, $border)
            $bmp.SetPixel(33, $y, $border)
        }
    }

    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "Created: $path"
}

$base = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane\"

# Single: all 4 borders
Create-GlassTexture "$base\glass_single.png" $true $true $true $true

# Horizontal (E-W connection): no L/R, has T/B
Create-GlassTexture "$base\glass_horizontal.png" $false $false $true $true

# Vertical (N-S connection): same as horizontal - T/B borders, no L/R (seamless on connecting ends)
Create-GlassTexture "$base\glass_vertical.png" $false $false $true $true

# Cross (all 4 connections): NO borders
Create-GlassTexture "$base\glass_cross.png" $false $false $false $false

# EndCap_E (connects East only): has L (west border), no R, has T/B
Create-GlassTexture "$base\glass_endcap_e.png" $true $false $true $true

# EndCap_W (connects West only): no L, has R (east border), has T/B
Create-GlassTexture "$base\glass_endcap_w.png" $false $true $true $true

# EndCap_N (connects North only): border on South end (L), no border on North end (R)
Create-GlassTexture "$base\glass_endcap_n.png" $true $false $true $true

# EndCap_S (connects South only): no border on South end (L), border on North end (R)
Create-GlassTexture "$base\glass_endcap_s.png" $false $true $true $true

# Corners - border on the two open sides
Create-GlassTexture "$base\glass_corner_ne.png" $true $false $false $true
Create-GlassTexture "$base\glass_corner_nw.png" $false $true $false $true
Create-GlassTexture "$base\glass_corner_se.png" $true $false $true $false
Create-GlassTexture "$base\glass_corner_sw.png" $false $true $true $false

# T-shapes - border on the one open side only
Create-GlassTexture "$base\glass_tshape_n.png" $false $false $false $true
Create-GlassTexture "$base\glass_tshape_s.png" $false $false $true $false
Create-GlassTexture "$base\glass_tshape_e.png" $true $false $false $false
Create-GlassTexture "$base\glass_tshape_w.png" $false $true $false $false

Write-Host "All textures created!"
