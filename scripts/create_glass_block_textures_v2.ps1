Add-Type -AssemblyName System.Drawing

$outDir = "c:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassBlockSeamless"

$glass  = [System.Drawing.Color]::FromArgb(0, 0, 0, 0)
$border = [System.Drawing.Color]::FromArgb(255, 240, 240, 240)
$bw = 2  # border width in pixels

# For each face of the cube, define which world direction each texture edge maps to.
# When looking at a face from OUTSIDE the cube:
#   L = left edge pixels (x=0..1)
#   R = right edge pixels (x=30..31)
#   T = top edge pixels (y=0..1)
#   B = bottom edge pixels (y=30..31)
#   Dir = which world direction this face points toward

# Atlas offsets: 96x64 = 3 columns x 2 rows of 32x32 faces
#   Front(0,0) Right(32,0) Back(64,0)
#   Left(0,32) Top(32,32)  Bottom(64,32)

$faces = @(
    @{ Name="Front";  OX=0;  OY=0;  Dir="S"; L="W"; R="E"; T="Up"; B="Down" }   # front faces South - L/R swapped back
    @{ Name="Right";  OX=32; OY=0;  Dir="E"; L="S"; R="N"; T="Up"; B="Down" }   # L/R swapped for N-S side fix
    @{ Name="Back";   OX=64; OY=0;  Dir="N"; L="E"; R="W"; T="Up"; B="Down" }   # back faces North - L/R swapped back
    @{ Name="Left";   OX=0;  OY=32; Dir="W"; L="N"; R="S"; T="Up"; B="Down" }   # L/R swapped for N-S side fix
    @{ Name="Top";    OX=32; OY=32; Dir="Up";   L="W"; R="E"; T="N"; B="S" }    # L/R swapped for E-W, T/B swapped for N-S
    @{ Name="Bottom"; OX=64; OY=32; Dir="Down"; L="W"; R="E"; T="S"; B="N" }    # L/R swapped for E-W, T/B swapped for N-S
)

# States and their connected horizontal directions (no vertical connections for now)
$states = [ordered]@{
    "single"     = @()
    "horizontal" = @("E","W")
    "vertical"   = @("N","S")
    "corner_ne"  = @("E","S")      # Template: Include X+1(E), Include Z+1(S)
    "corner_nw"  = @("W","S")      # Template: Include X-1(W), Include Z+1(S)
    "corner_se"  = @("E","N")      # Template: Include X+1(E), Include Z-1(N)
    "corner_sw"  = @("W","N")      # Template: Include X-1(W), Include Z-1(N)
    "tshape_n"   = @("E","W","N")  # All except S (Z+1)
    "tshape_s"   = @("E","W","S")  # All except N (Z-1)
    "tshape_e"   = @("W","N","S")  # All except E (X+1)
    "tshape_w"   = @("E","N","S")  # All except W (X-1)
    "endcap_e"   = @("E")
    "endcap_w"   = @("W")
    "endcap_n"   = @("N")
    "endcap_s"   = @("S")
    "cross"      = @("E","W","N","S")
}

function Draw-FaceRegion {
    param(
        [System.Drawing.Bitmap]$bmp,
        [int]$ox,
        [int]$oy,
        [bool]$borderL,
        [bool]$borderR,
        [bool]$borderT,
        [bool]$borderB
    )

    # Fill entire 32x32 face with glass color
    for ($y = 0; $y -lt 32; $y++) {
        for ($x = 0; $x -lt 32; $x++) {
            $bmp.SetPixel($ox + $x, $oy + $y, $glass)
        }
    }

    # Draw left border (x = 0..bw-1)
    if ($borderL) {
        for ($y = 0; $y -lt 32; $y++) {
            for ($i = 0; $i -lt $bw; $i++) {
                $bmp.SetPixel($ox + $i, $oy + $y, $border)
            }
        }
    }

    # Draw right border (x = 32-bw..31)
    if ($borderR) {
        for ($y = 0; $y -lt 32; $y++) {
            for ($i = 0; $i -lt $bw; $i++) {
                $bmp.SetPixel($ox + 31 - $i, $oy + $y, $border)
            }
        }
    }

    # Draw top border (y = 0..bw-1)
    if ($borderT) {
        for ($x = 0; $x -lt 32; $x++) {
            for ($i = 0; $i -lt $bw; $i++) {
                $bmp.SetPixel($ox + $x, $oy + $i, $border)
            }
        }
    }

    # Draw bottom border (y = 32-bw..31)
    if ($borderB) {
        for ($x = 0; $x -lt 32; $x++) {
            for ($i = 0; $i -lt $bw; $i++) {
                $bmp.SetPixel($ox + $x, $oy + 31 - $i, $border)
            }
        }
    }
}

foreach ($stateName in $states.Keys) {
    $connected = $states[$stateName]
    $bmp = New-Object System.Drawing.Bitmap(96, 64)

    foreach ($face in $faces) {
        $ox = $face.OX
        $oy = $face.OY
        $faceDir = $face.Dir

        if ($connected -contains $faceDir) {
            # This face touches another glass block -> fully borderless
            Draw-FaceRegion $bmp $ox $oy $false $false $false $false
        }
        else {
            # Exposed face: draw border on edges where the neighbor direction is NOT connected
            $borderL = -not ($connected -contains $face.L)
            $borderR = -not ($connected -contains $face.R)
            $borderT = -not ($connected -contains $face.T)
            $borderB = -not ($connected -contains $face.B)
            Draw-FaceRegion $bmp $ox $oy $borderL $borderR $borderT $borderB
        }
    }

    $path = "$outDir\glass_$stateName.png"
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "Generated: glass_$stateName.png  (connected: $($connected -join ', '))"
}

Write-Host ""
Write-Host "All 12 state textures generated with per-edge borders!"
Write-Host "Each face has selective borders based on which directions are connected."
