Add-Type -AssemblyName System.Drawing

$base = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common"

# Glass colors - transparent with light neutral border
$glass = [System.Drawing.Color]::FromArgb(0, 0, 0, 0)
$border = [System.Drawing.Color]::FromArgb(255, 240, 240, 240)

# --- Bordered Glass Block Texture (32x32, simple non-connecting block) ---
$borderedPath = "$base\Items\GlassBlock\glass_block_texture.png"
New-Item -ItemType Directory -Force -Path (Split-Path $borderedPath) | Out-Null

$bmp = New-Object System.Drawing.Bitmap(32, 32)
for ($y = 0; $y -lt 32; $y++) {
    for ($x = 0; $x -lt 32; $x++) {
        $bmp.SetPixel($x, $y, $glass)
    }
}
for ($i = 0; $i -lt 32; $i++) {
    $bmp.SetPixel($i, 0, $border); $bmp.SetPixel($i, 1, $border)
    $bmp.SetPixel($i, 30, $border); $bmp.SetPixel($i, 31, $border)
    $bmp.SetPixel(0, $i, $border); $bmp.SetPixel(1, $i, $border)
    $bmp.SetPixel(30, $i, $border); $bmp.SetPixel(31, $i, $border)
}
$bmp.Save($borderedPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "Created: $borderedPath"

# --- Seamless Glass Block: per-state 96x64 textures ---
# Layout: 3 columns x 2 rows of 32x32 face regions
#   Row 0: [front/North @ 0,0] [right/East @ 32,0] [back/South @ 64,0]
#   Row 1: [left/West @ 0,32]  [top @ 32,32]       [bottom @ 64,32]

$seamlessDir = "$base\Items\GlassBlockSeamless"
New-Item -ItemType Directory -Force -Path $seamlessDir | Out-Null

function Draw-FaceRegion {
    param(
        [System.Drawing.Bitmap]$bmp,
        [int]$offsetX,
        [int]$offsetY,
        [bool]$bordered
    )
    for ($y = 0; $y -lt 32; $y++) {
        for ($x = 0; $x -lt 32; $x++) {
            $bmp.SetPixel($offsetX + $x, $offsetY + $y, $glass)
        }
    }
    if ($bordered) {
        for ($i = 0; $i -lt 32; $i++) {
            $bmp.SetPixel($offsetX + $i, $offsetY + 0, $border)
            $bmp.SetPixel($offsetX + $i, $offsetY + 1, $border)
            $bmp.SetPixel($offsetX + $i, $offsetY + 30, $border)
            $bmp.SetPixel($offsetX + $i, $offsetY + 31, $border)
            $bmp.SetPixel($offsetX + 0, $offsetY + $i, $border)
            $bmp.SetPixel($offsetX + 1, $offsetY + $i, $border)
            $bmp.SetPixel($offsetX + 30, $offsetY + $i, $border)
            $bmp.SetPixel($offsetX + 31, $offsetY + $i, $border)
        }
    }
}

function Create-StateTexture {
    param(
        [string]$name,
        [bool]$northBordered,
        [bool]$eastBordered,
        [bool]$southBordered,
        [bool]$westBordered,
        [bool]$topBordered,
        [bool]$bottomBordered
    )
    $bmp = New-Object System.Drawing.Bitmap(96, 64)
    Draw-FaceRegion $bmp 0  0  $northBordered
    Draw-FaceRegion $bmp 32 0  $eastBordered
    Draw-FaceRegion $bmp 64 0  $southBordered
    Draw-FaceRegion $bmp 0  32 $westBordered
    Draw-FaceRegion $bmp 32 32 $topBordered
    Draw-FaceRegion $bmp 64 32 $bottomBordered

    $path = "$seamlessDir\glass_$name.png"
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "Created: $path"
}

# State textures - borders on exposed faces, no borders on connected faces
# Top/bottom always bordered (no vertical connections yet)

#                         Name          N      E      S      W      Top    Bot
Create-StateTexture "single"            $true  $true  $true  $true  $true  $true
Create-StateTexture "horizontal"        $true  $false $true  $false $true  $true
Create-StateTexture "vertical"          $false $true  $false $true  $true  $true
Create-StateTexture "corner_ne"         $false $false $true  $true  $true  $true
Create-StateTexture "corner_nw"         $false $true  $true  $false $true  $true
Create-StateTexture "corner_se"         $true  $false $false $true  $true  $true
Create-StateTexture "corner_sw"         $true  $true  $false $false $true  $true
Create-StateTexture "tshape_n"          $true  $false $false $false $true  $true
Create-StateTexture "tshape_s"          $false $false $true  $false $true  $true
Create-StateTexture "tshape_e"          $false $true  $false $false $true  $true
Create-StateTexture "tshape_w"          $false $false $false $true  $true  $true
Create-StateTexture "cross"             $false $false $false $false $true  $true

# --- Icons (32x32) ---
$iconGlass = [System.Drawing.Color]::FromArgb(30, 240, 240, 240)
$iconBorder = [System.Drawing.Color]::FromArgb(200, 240, 240, 240)

foreach ($iconName in @("glass_block", "glass_block_seamless")) {
    $iconPath = "$base\Icons\ItemsGenerated\$iconName.png"
    $bmp = New-Object System.Drawing.Bitmap(32, 32)
    for ($y = 0; $y -lt 32; $y++) {
        for ($x = 0; $x -lt 32; $x++) {
            $bmp.SetPixel($x, $y, $iconGlass)
        }
    }
    for ($i = 0; $i -lt 32; $i++) {
        $bmp.SetPixel($i, 0, $iconBorder); $bmp.SetPixel($i, 1, $iconBorder)
        $bmp.SetPixel($i, 30, $iconBorder); $bmp.SetPixel($i, 31, $iconBorder)
        $bmp.SetPixel(0, $i, $iconBorder); $bmp.SetPixel(1, $i, $iconBorder)
        $bmp.SetPixel(30, $i, $iconBorder); $bmp.SetPixel(31, $i, $iconBorder)
    }
    $bmp.Save($iconPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "Created: $iconPath"
}

Write-Host "All glass block textures and icons created!"
