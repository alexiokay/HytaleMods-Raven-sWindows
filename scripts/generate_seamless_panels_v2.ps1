# generate_seamless_panels_v2.ps1
# Generates 40x40 atlas textures for GlassPanelSeamless (fence-style with vertical variants)
# Atlas layout: 32x32 center (front/back) + 4px edge strips (left/right/top/bottom)

Add-Type -AssemblyName System.Drawing

$projectRoot = "c:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources"
$textureDir = "$projectRoot\Common\Items\GlassPanelSeamless_Test"

if (-not (Test-Path $textureDir)) {
    New-Item -ItemType Directory -Path $textureDir | Out-Null
    Write-Host "Created test directory: $textureDir"
}

# --- Configuration ---
$enableCornerDecorations = $true

# --- Colors ---
$glass  = [System.Drawing.Color]::FromArgb(128, 228, 248, 255)  # Semi-transparent
$border = [System.Drawing.Color]::FromArgb(255, 228, 248, 255)  # Solid light blue
$corner = $border
$bw = 2           # Border width
$cornerSize = 3
$cornerOffset = 3

# --- Connection states ---
$baseStates = [ordered]@{
    "Single"     = @{ H=@() }
    "Horizontal" = @{ H=@("E","W") }
    "Vertical"   = @{ H=@("N","S") }
    "Corner_NE"  = @{ H=@("N","E") }
    "Corner_NW"  = @{ H=@("N","W") }
    "Corner_SE"  = @{ H=@("S","E") }
    "Corner_SW"  = @{ H=@("S","W") }
    "TShape_N"   = @{ H=@("E","W","S") }
    "TShape_S"   = @{ H=@("E","W","N") }
    "TShape_E"   = @{ H=@("N","S","W") }
    "TShape_W"   = @{ H=@("N","S","E") }
    "Cross"      = @{ H=@("N","S","E","W") }
    "EndCap_E"   = @{ H=@("E") }
    "EndCap_W"   = @{ H=@("W") }
    "EndCap_N"   = @{ H=@("N") }
    "EndCap_S"   = @{ H=@("S") }
}

$vertVariants = @(
    @{ Suffix="";       V=@() }
    @{ Suffix="_Above"; V=@("Up") }
    @{ Suffix="_Below"; V=@("Down") }
    @{ Suffix="_Both";  V=@("Up","Down") }
)

# =============================================
# Drawing Functions
# =============================================

function Draw-DiagonalLine {
    param([System.Drawing.Bitmap]$bmp, [int]$ox, [int]$oy, [string]$dir,
          [System.Drawing.Color]$color, [int]$length, [int]$offset)

    for ($i = 0; $i -lt $length; $i++) {
        switch ($dir) {
            "TL" { $px = $ox + $offset + ($length - 1 - $i); $py = $oy + $offset + $i }
            "TR" { $px = $ox + (31 - $offset) - ($length - 1 - $i); $py = $oy + $offset + $i }
            "BL" { $px = $ox + $offset + $i; $py = $oy + (31 - $offset) - ($length - 1 - $i) }
            "BR" { $px = $ox + (31 - $offset) - $i; $py = $oy + (31 - $offset) - ($length - 1 - $i) }
        }
        if ($px -ge 0 -and $px -lt $bmp.Width -and $py -ge 0 -and $py -lt $bmp.Height) {
            $bmp.SetPixel($px, $py, $color)
        }
    }
}

function Draw-MainFace {
    param([System.Drawing.Bitmap]$bmp, [int]$ox, [int]$oy, [array]$connected, [bool]$decorations)

    # Fill 32x32 with glass
    for ($y = 0; $y -lt 32; $y++) {
        for ($x = 0; $x -lt 32; $x++) {
            $bmp.SetPixel($ox + $x, $oy + $y, $glass)
        }
    }

    # Determine borders based on connections
    $bL = -not ($connected -contains "W")
    $bR = -not ($connected -contains "E")
    $bT = -not ($connected -contains "N")
    $bB = -not ($connected -contains "S")

    # Draw borders
    if ($bL) { for ($y = 0; $y -lt 32; $y++) { for ($i = 0; $i -lt $bw; $i++) { $bmp.SetPixel($ox + $i, $oy + $y, $border) } } }
    if ($bR) { for ($y = 0; $y -lt 32; $y++) { for ($i = 0; $i -lt $bw; $i++) { $bmp.SetPixel($ox + 31 - $i, $oy + $y, $border) } } }
    if ($bT) { for ($x = 0; $x -lt 32; $x++) { for ($i = 0; $i -lt $bw; $i++) { $bmp.SetPixel($ox + $x, $oy + $i, $border) } } }
    if ($bB) { for ($x = 0; $x -lt 32; $x++) { for ($i = 0; $i -lt $bw; $i++) { $bmp.SetPixel($ox + $x, $oy + 31 - $i, $border) } } }

    # Draw corner decorations
    if ($decorations) {
        if ($bT -and $bL) { Draw-DiagonalLine $bmp $ox $oy "TL" $corner $cornerSize $cornerOffset }
        if ($bT -and $bR) { Draw-DiagonalLine $bmp $ox $oy "TR" $corner $cornerSize $cornerOffset }
        if ($bB -and $bL) { Draw-DiagonalLine $bmp $ox $oy "BL" $corner $cornerSize $cornerOffset }
        if ($bB -and $bR) { Draw-DiagonalLine $bmp $ox $oy "BR" $corner $cornerSize $cornerOffset }
    }
}

function Draw-EdgeStrip {
    param([System.Drawing.Bitmap]$bmp, [int]$ox, [int]$oy, [int]$w, [int]$h, [array]$connected, [string]$edge)

    # Determine if this edge should have vertical borders
    $hasUpBorder = -not ($connected -contains "Up")
    $hasDownBorder = -not ($connected -contains "Down")

    for ($y = 0; $y -lt $h; $y++) {
        for ($x = 0; $x -lt $w; $x++) {
            $isBorder = $false

            # Top/bottom strips: check Up/Down connections
            if ($edge -eq "Top" -or $edge -eq "Bottom") {
                if ($hasUpBorder -and $y -lt $bw) { $isBorder = $true }
                if ($hasDownBorder -and $y -ge ($h - $bw)) { $isBorder = $true }
            }
            # Left/right strips: check Up/Down connections
            elseif ($edge -eq "Left" -or $edge -eq "Right") {
                if ($hasUpBorder -and $y -lt $bw) { $isBorder = $true }
                if ($hasDownBorder -and $y -ge ($h - $bw)) { $isBorder = $true }
            }

            $color = if ($isBorder) { $border } else { $glass }
            $bmp.SetPixel($ox + $x, $oy + $y, $color)
        }
    }
}

# =============================================
# Generate Textures
# =============================================

Write-Host "=== Generating 40x40 Atlas Textures for Seamless Glass Panels ==="
$textureCount = 0

foreach ($baseName in $baseStates.Keys) {
    $baseH = $baseStates[$baseName].H

    foreach ($variant in $vertVariants) {
        $stateName = "$baseName$($variant.Suffix)"
        $allConnections = @() + $baseH + $variant.V

        # Only decorations on Corner, EndCap, Single states
        $showDecorations = $baseName -match '^(Corner_|EndCap_|Single)' -and $enableCornerDecorations

        # Create 40x40 atlas
        $bmp = New-Object System.Drawing.Bitmap(40, 40)

        # Layout: [4px left][32px center][4px right] = 40px width
        #         [4px top]
        #         [32px center]
        #         [4px bottom] = 40px height

        # Draw main face (center 32x32 at offset 4,4)
        Draw-MainFace $bmp 4 4 $allConnections $showDecorations

        # Draw edge strips
        Draw-EdgeStrip $bmp 0 4 4 32 $allConnections "Left"     # Left edge (4x32)
        Draw-EdgeStrip $bmp 36 4 4 32 $allConnections "Right"   # Right edge (4x32)
        Draw-EdgeStrip $bmp 4 0 32 4 $allConnections "Top"      # Top edge (32x4)
        Draw-EdgeStrip $bmp 4 36 32 4 $allConnections "Bottom"  # Bottom edge (32x4)

        # Fill corners (4x4 each) with glass
        for ($cy = 0; $cy -lt 4; $cy++) {
            for ($cx = 0; $cx -lt 4; $cx++) {
                $bmp.SetPixel($cx, $cy, $glass)           # Top-left
                $bmp.SetPixel(36 + $cx, $cy, $glass)      # Top-right
                $bmp.SetPixel($cx, 36 + $cy, $glass)      # Bottom-left
                $bmp.SetPixel(36 + $cx, 36 + $cy, $glass) # Bottom-right
            }
        }

        $texName = "glass_$($stateName.ToLower()).png"
        $bmp.Save("$textureDir\$texName", [System.Drawing.Imaging.ImageFormat]::Png)
        $bmp.Dispose()
        $textureCount++

        $decorStatus = if ($showDecorations) { "[with decorations]" } else { "" }
        Write-Host "  $texName  (connections: $($allConnections -join ', ')) $decorStatus"
    }
}

Write-Host "`nGenerated $textureCount textures (40x40 atlases)."
Write-Host "=== Done! ==="
