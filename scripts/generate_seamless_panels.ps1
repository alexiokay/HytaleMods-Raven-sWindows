# generate_seamless_panels.ps1
# Generates textures for GlassPanelSeamless (fence-style with vertical variants)
# 48 total states: 12 base horizontal × 4 vertical variants

Add-Type -AssemblyName System.Drawing

$projectRoot = "c:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources"
$textureDir = "$projectRoot\Common\Items\GlassPanelSeamless_Test"

# Create test directory if it doesn't exist
if (-not (Test-Path $textureDir)) {
    New-Item -ItemType Directory -Path $textureDir | Out-Null
    Write-Host "Created test directory: $textureDir"
}

# --- Configuration ---
$enableCornerDecorations = $true  # Set to $false to disable corner decorations

# --- Colors ---
$glass  = [System.Drawing.Color]::FromArgb(128, 228, 248, 255)  # Semi-transparent light blue
$border = [System.Drawing.Color]::FromArgb(255, 228, 248, 255)  # Solid light blue
$corner = $border
$bw = 2           # Border width (2px for panels)
$cornerSize = 3   # Corner diagonal line length
$cornerOffset = 3 # Distance from borders

# --- 12 base horizontal states (fence-style) ---
$baseStates = [ordered]@{
    "Single"     = @{ Connections=@() }
    "Horizontal" = @{ Connections=@("E","W") }
    "Vertical"   = @{ Connections=@("N","S") }
    "Corner_NE"  = @{ Connections=@("N","E") }
    "Corner_NW"  = @{ Connections=@("N","W") }
    "Corner_SE"  = @{ Connections=@("S","E") }
    "Corner_SW"  = @{ Connections=@("S","W") }
    "TShape_N"   = @{ Connections=@("E","W","S") }
    "TShape_S"   = @{ Connections=@("E","W","N") }
    "TShape_E"   = @{ Connections=@("N","S","W") }
    "TShape_W"   = @{ Connections=@("N","S","E") }
    "Cross"      = @{ Connections=@("N","S","E","W") }
}

# --- 4 vertical variants ---
$vertVariants = @(
    @{ Suffix="";       Connections=@() }
    @{ Suffix="_Above"; Connections=@("Up") }
    @{ Suffix="_Below"; Connections=@("Down") }
    @{ Suffix="_Both";  Connections=@("Up","Down") }
)

# --- EndCaps (special 1-direction states) ---
$endCapStates = [ordered]@{
    "EndCap_E" = @{ Connections=@("E") }
    "EndCap_W" = @{ Connections=@("W") }
    "EndCap_N" = @{ Connections=@("N") }
    "EndCap_S" = @{ Connections=@("S") }
}

# =============================================
# Drawing Functions
# =============================================

function Draw-DiagonalLine {
    param(
        [System.Drawing.Bitmap]$bmp,
        [int]$ox, [int]$oy,
        [string]$direction,
        [System.Drawing.Color]$color,
        [int]$length,
        [int]$offset
    )

    for ($i = 0; $i -lt $length; $i++) {
        switch ($direction) {
            "TL" {
                $px = $ox + $offset + ($length - 1 - $i)
                $py = $oy + $offset + $i
            }
            "TR" {
                $px = $ox + (63 - $offset) - ($length - 1 - $i)
                $py = $oy + $offset + $i
            }
            "BL" {
                $px = $ox + $offset + $i
                $py = $oy + (63 - $offset) - ($length - 1 - $i)
            }
            "BR" {
                $px = $ox + (63 - $offset) - $i
                $py = $oy + (63 - $offset) - ($length - 1 - $i)
            }
        }

        if ($px -ge 0 -and $px -lt $bmp.Width -and $py -ge 0 -and $py -lt $bmp.Height) {
            $bmp.SetPixel($px, $py, $color)
        }
    }
}

function Draw-PanelTexture {
    param(
        [string]$baseName,
        [array]$connections,
        [bool]$drawDecorations
    )

    $textureSize = 64
    $bmp = New-Object System.Drawing.Bitmap($textureSize, $textureSize)

    # Fill with transparent glass
    for ($y = 0; $y -lt $textureSize; $y++) {
        for ($x = 0; $x -lt $textureSize; $x++) {
            $bmp.SetPixel($x, $y, $glass)
        }
    }

    # Determine which edges have borders (exposed edges)
    $borderL = -not ($connections -contains "W")
    $borderR = -not ($connections -contains "E")
    $borderT = -not ($connections -contains "N")
    $borderB = -not ($connections -contains "S")

    # Draw borders
    if ($borderL) {
        for ($y = 0; $y -lt $textureSize; $y++) {
            for ($i = 0; $i -lt $bw; $i++) {
                $bmp.SetPixel($i, $y, $border)
            }
        }
    }
    if ($borderR) {
        for ($y = 0; $y -lt $textureSize; $y++) {
            for ($i = 0; $i -lt $bw; $i++) {
                $bmp.SetPixel($textureSize - 1 - $i, $y, $border)
            }
        }
    }
    if ($borderT) {
        for ($x = 0; $x -lt $textureSize; $x++) {
            for ($i = 0; $i -lt $bw; $i++) {
                $bmp.SetPixel($x, $i, $border)
            }
        }
    }
    if ($borderB) {
        for ($x = 0; $x -lt $textureSize; $x++) {
            for ($i = 0; $i -lt $bw; $i++) {
                $bmp.SetPixel($x, $textureSize - 1 - $i, $border)
            }
        }
    }

    # Draw corner decorations ONLY if this state should have them
    if ($drawDecorations) {
        if ($borderT -and $borderL) {
            Draw-DiagonalLine $bmp 0 0 "TL" $corner $cornerSize $cornerOffset
        }
        if ($borderT -and $borderR) {
            Draw-DiagonalLine $bmp 0 0 "TR" $corner $cornerSize $cornerOffset
        }
        if ($borderB -and $borderL) {
            Draw-DiagonalLine $bmp 0 0 "BL" $corner $cornerSize $cornerOffset
        }
        if ($borderB -and $borderR) {
            Draw-DiagonalLine $bmp 0 0 "BR" $corner $cornerSize $cornerOffset
        }
    }

    return $bmp
}

# =============================================
# Generate Textures
# =============================================

Write-Host "=== Generating Seamless Glass Panel Textures ==="
$textureCount = 0

# Generate base states + EndCaps
$allBaseStates = $baseStates + $endCapStates

foreach ($baseName in $allBaseStates.Keys) {
    $baseConnections = $allBaseStates[$baseName].Connections

    foreach ($variant in $vertVariants) {
        $stateName = "$baseName$($variant.Suffix)"
        $allConnections = @() + $baseConnections + $variant.Connections

        # Only show decorations on Corner, EndCap, and Single states
        $showDecorations = $baseName -match '^(Corner_|EndCap_|Single)' -and $enableCornerDecorations

        $bmp = Draw-PanelTexture $baseName $allConnections $showDecorations

        $texName = "glass_$($stateName.ToLower()).png"
        $bmp.Save("$textureDir\$texName", [System.Drawing.Imaging.ImageFormat]::Png)
        $bmp.Dispose()
        $textureCount++

        $decorStatus = if ($showDecorations) { "[with decorations]" } else { "" }
        Write-Host "  $texName  (connections: $($allConnections -join ', ')) $decorStatus"
    }
}

Write-Host "`nGenerated $textureCount textures."
Write-Host "=== Done! ==="
