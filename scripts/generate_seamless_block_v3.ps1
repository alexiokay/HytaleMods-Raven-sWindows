# generate_seamless_block_v3.ps1
# Generates all 64 states (16 horizontal × 4 vertical) for GlassBlockSeamless
# Outputs: 64 textures, template JSON, item JSON

Add-Type -AssemblyName System.Drawing

$projectRoot = "c:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources"
$textureDir = "$projectRoot\Common\Items\GlassBlockSeamless"
$templatePath = "$projectRoot\Server\Item\CustomConnectedBlockTemplates\GlassBlockSeamlessTemplate.json"
$itemPath = "$projectRoot\Server\Item\Items\GlassBlockSeamless_Item.json"

# --- Configuration ---
$enableCornerDecorations = $true  # Set to $false to disable corner decorations

# --- Colors ---
$glass  = [System.Drawing.Color]::FromArgb(0, 0, 0, 0)
$border = [System.Drawing.Color]::FromArgb(255, 228, 248, 255)  # Light blue border color
$corner = $border  # Corner decoration uses same color as border
$bw = 1           # Border width in pixels
$cornerSize = 3   # Corner diagonal line length (3 pixels)
$cornerOffset = 3 # Distance from borders (2 pixels)

# --- Face definitions for 96x64 atlas (6 faces of 32x32) ---
# Dir = which world direction this face points toward
# L/R/T/B = which world direction each edge of this face borders
$faces = @(
    @{ Name="Front";  OX=0;  OY=0;  Dir="S"; L="W"; R="E"; T="Up"; B="Down" }    # front faces South - L/R swapped back
    @{ Name="Right";  OX=32; OY=0;  Dir="E"; L="S"; R="N"; T="Up"; B="Down" }    # L/R swapped for N-S side fix
    @{ Name="Back";   OX=64; OY=0;  Dir="N"; L="E"; R="W"; T="Up"; B="Down" }    # back faces North - L/R swapped back
    @{ Name="Left";   OX=0;  OY=32; Dir="W"; L="N"; R="S"; T="Up"; B="Down" }    # L/R swapped for N-S side fix
    @{ Name="Top";    OX=32; OY=32; Dir="Up";   L="W"; R="E"; T="N"; B="S" }     # L/R swapped for E-W, T/B swapped for N-S
    @{ Name="Bottom"; OX=64; OY=32; Dir="Down"; L="W"; R="E"; T="S"; B="N" }     # L/R swapped for E-W, T/B swapped for N-S
)

# --- 16 base horizontal states ---
# HorizDirs = connected horizontal directions (for texture border logic)
# Rules = [E(X+1), W(X-1), S(Z+1), N(Z-1)] Include/Exclude
$baseStates = [ordered]@{
    "Single"     = @{ HorizDirs=@();                Rules=@("Exclude","Exclude","Exclude","Exclude") }
    "Horizontal" = @{ HorizDirs=@("E","W");         Rules=@("Include","Include","Exclude","Exclude") }
    "Vertical"   = @{ HorizDirs=@("N","S");         Rules=@("Exclude","Exclude","Include","Include") }
    "Corner_NE"  = @{ HorizDirs=@("E","S");         Rules=@("Include","Exclude","Include","Exclude") }
    "Corner_NW"  = @{ HorizDirs=@("W","S");         Rules=@("Exclude","Include","Include","Exclude") }
    "Corner_SE"  = @{ HorizDirs=@("E","N");         Rules=@("Include","Exclude","Exclude","Include") }
    "Corner_SW"  = @{ HorizDirs=@("W","N");         Rules=@("Exclude","Include","Exclude","Include") }
    "TShape_N"   = @{ HorizDirs=@("E","W","N");     Rules=@("Include","Include","Exclude","Include") }
    "TShape_S"   = @{ HorizDirs=@("E","W","S");     Rules=@("Include","Include","Include","Exclude") }
    "TShape_E"   = @{ HorizDirs=@("W","N","S");     Rules=@("Exclude","Include","Include","Include") }
    "TShape_W"   = @{ HorizDirs=@("E","N","S");     Rules=@("Include","Exclude","Include","Include") }
    "EndCap_E"   = @{ HorizDirs=@("E");             Rules=@("Include","Exclude","Exclude","Exclude") }
    "EndCap_W"   = @{ HorizDirs=@("W");             Rules=@("Exclude","Include","Exclude","Exclude") }
    "EndCap_N"   = @{ HorizDirs=@("N");             Rules=@("Exclude","Exclude","Exclude","Include") }
    "EndCap_S"   = @{ HorizDirs=@("S");             Rules=@("Exclude","Exclude","Include","Exclude") }
    "Cross"      = @{ HorizDirs=@("E","W","N","S"); Rules=@("Include","Include","Include","Include") }
}

# --- 4 vertical variants ---
# Suffix = appended to shape name
# YUp/YDown = Include/Exclude for Y+1/Y-1 rules
# VertDirs = added to connected directions for texture generation
$vertVariants = @(
    @{ Suffix="";       YUp="Exclude"; YDown="Exclude"; VertDirs=@() }
    @{ Suffix="_Above"; YUp="Include"; YDown="Exclude"; VertDirs=@("Up") }
    @{ Suffix="_Below"; YUp="Exclude"; YDown="Include"; VertDirs=@("Down") }
    @{ Suffix="_Both";  YUp="Include"; YDown="Include"; VertDirs=@("Up","Down") }
)

$tag = "GlassBlockSeamlessConnection"

# =============================================
# Part 1: Generate 64 textures
# =============================================

function Draw-DiagonalLine {
    param(
        [System.Drawing.Bitmap]$bmp,
        [int]$ox, [int]$oy,
        [string]$direction,  # "TL", "TR", "BL", "BR"
        [System.Drawing.Color]$color,
        [int]$length,
        [int]$offset
    )
    # Draw 3-pixel diagonal line, 2 pixels from borders
    for ($i = 0; $i -lt $length; $i++) {
        $px = 0
        $py = 0

        switch ($direction) {
            "TL" {  # Top-left: / diagonal (upper-right to lower-left)
                $px = $ox + $offset + ($length - 1 - $i)
                $py = $oy + $offset + $i
            }
            "TR" {  # Top-right: \ diagonal (upper-left to lower-right)
                $px = $ox + (31 - $offset) - ($length - 1 - $i)
                $py = $oy + $offset + $i
            }
            "BL" {  # Bottom-left: \ diagonal (upper-left to lower-right)
                $px = $ox + $offset + $i
                $py = $oy + (31 - $offset) - ($length - 1 - $i)
            }
            "BR" {  # Bottom-right: / diagonal (upper-right to lower-left)
                $px = $ox + (31 - $offset) - $i
                $py = $oy + (31 - $offset) - ($length - 1 - $i)
            }
        }

        if ($px -ge 0 -and $px -lt $bmp.Width -and $py -ge 0 -and $py -lt $bmp.Height) {
            $bmp.SetPixel($px, $py, $color)
        }
    }
}

function Draw-FaceRegion {
    param(
        [System.Drawing.Bitmap]$bmp,
        [int]$ox, [int]$oy,
        [bool]$borderL, [bool]$borderR, [bool]$borderT, [bool]$borderB
    )
    # Fill with glass
    for ($y = 0; $y -lt 32; $y++) {
        for ($x = 0; $x -lt 32; $x++) {
            $bmp.SetPixel($ox + $x, $oy + $y, $glass)
        }
    }

    # Draw borders
    if ($borderL) { for ($y = 0; $y -lt 32; $y++) { for ($i = 0; $i -lt $bw; $i++) { $bmp.SetPixel($ox + $i, $oy + $y, $border) } } }
    if ($borderR) { for ($y = 0; $y -lt 32; $y++) { for ($i = 0; $i -lt $bw; $i++) { $bmp.SetPixel($ox + 31 - $i, $oy + $y, $border) } } }
    if ($borderT) { for ($x = 0; $x -lt 32; $x++) { for ($i = 0; $i -lt $bw; $i++) { $bmp.SetPixel($ox + $x, $oy + $i, $border) } } }
    if ($borderB) { for ($x = 0; $x -lt 32; $x++) { for ($i = 0; $i -lt $bw; $i++) { $bmp.SetPixel($ox + $x, $oy + 31 - $i, $border) } } }

    # Draw corner decorations at exposed corners (diagonal lines)
    if ($enableCornerDecorations) {
        if ($borderT -and $borderL) {
            Draw-DiagonalLine $bmp $ox $oy "TL" $corner $cornerSize $cornerOffset
        }
        if ($borderT -and $borderR) {
            Draw-DiagonalLine $bmp $ox $oy "TR" $corner $cornerSize $cornerOffset
        }
        if ($borderB -and $borderL) {
            Draw-DiagonalLine $bmp $ox $oy "BL" $corner $cornerSize $cornerOffset
        }
        if ($borderB -and $borderR) {
            Draw-DiagonalLine $bmp $ox $oy "BR" $corner $cornerSize $cornerOffset
        }
    }
}

$decorationStatus = if ($enableCornerDecorations) { "with corner decorations" } else { "without corner decorations" }
Write-Host "=== Generating 64 Textures $decorationStatus ==="
$textureCount = 0

foreach ($baseName in $baseStates.Keys) {
    $baseHoriz = $baseStates[$baseName].HorizDirs

    foreach ($variant in $vertVariants) {
        $stateName = "$baseName$($variant.Suffix)"
        $connected = @() + $baseHoriz + $variant.VertDirs

        $bmp = New-Object System.Drawing.Bitmap(96, 64)

        foreach ($face in $faces) {
            $ox = $face.OX; $oy = $face.OY

            if ($connected -contains $face.Dir) {
                # This face points toward a connected block -> fully borderless
                Draw-FaceRegion $bmp $ox $oy $false $false $false $false
            } else {
                # Exposed face: border on edges where neighbor direction is NOT connected
                $bL = -not ($connected -contains $face.L)
                $bR = -not ($connected -contains $face.R)
                $bT = -not ($connected -contains $face.T)
                $bB = -not ($connected -contains $face.B)
                Draw-FaceRegion $bmp $ox $oy $bL $bR $bT $bB
            }
        }

        $texName = "glass_$($stateName.ToLower()).png"
        $bmp.Save("$textureDir\$texName", [System.Drawing.Imaging.ImageFormat]::Png)
        $bmp.Dispose()
        $textureCount++
        Write-Host "  $texName  (connected: $($connected -join ', '))"
    }
}

Write-Host "Generated $textureCount textures.`n"

# =============================================
# Part 2: Generate Template JSON
# =============================================

Write-Host "=== Generating Template JSON ==="

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('{')
[void]$sb.AppendLine('  "ConnectsToOtherMaterials": false,')
[void]$sb.AppendLine('  "DefaultShape": "Single",')
[void]$sb.AppendLine('  "Shapes": {')

# Collect all 64 shape entries
$allShapes = New-Object System.Collections.ArrayList
foreach ($baseName in $baseStates.Keys) {
    $rules = $baseStates[$baseName].Rules  # [E, W, S, N]
    foreach ($variant in $vertVariants) {
        $shapeName = "$baseName$($variant.Suffix)"
        [void]$allShapes.Add(@{
            Name  = $shapeName
            RuleE = $rules[0]
            RuleW = $rules[1]
            RuleS = $rules[2]
            RuleN = $rules[3]
            YUp   = $variant.YUp
            YDown = $variant.YDown
        })
    }
}

for ($i = 0; $i -lt $allShapes.Count; $i++) {
    $s = $allShapes[$i]
    $comma = if ($i -lt $allShapes.Count - 1) { "," } else { "" }

    [void]$sb.AppendLine("    `"$($s.Name)`": {")
    [void]$sb.AppendLine("      `"FaceTags`": {")
    [void]$sb.AppendLine("        `"North`": [`"$tag`"],")
    [void]$sb.AppendLine("        `"South`": [`"$tag`"],")
    [void]$sb.AppendLine("        `"East`": [`"$tag`"],")
    [void]$sb.AppendLine("        `"West`": [`"$tag`"],")
    [void]$sb.AppendLine("        `"Up`": [`"$tag`"],")
    [void]$sb.AppendLine("        `"Down`": [`"$tag`"]")
    [void]$sb.AppendLine("      },")
    [void]$sb.AppendLine("      `"PatternsToMatchAnyOf`": [")
    [void]$sb.AppendLine("        {")
    [void]$sb.AppendLine("          `"Type`": `"Custom`",")
    [void]$sb.AppendLine("          `"TransformRulesToOrientation`": true,")
    [void]$sb.AppendLine("          `"RulesToMatch`": [")
    [void]$sb.AppendLine("            {`"Position`": {`"X`": 1, `"Y`": 0, `"Z`": 0}, `"IncludeOrExclude`": `"$($s.RuleE)`", `"FaceTags`": {`"West`": [`"$tag`"]}},")
    [void]$sb.AppendLine("            {`"Position`": {`"X`": -1, `"Y`": 0, `"Z`": 0}, `"IncludeOrExclude`": `"$($s.RuleW)`", `"FaceTags`": {`"East`": [`"$tag`"]}},")
    [void]$sb.AppendLine("            {`"Position`": {`"X`": 0, `"Y`": 0, `"Z`": 1}, `"IncludeOrExclude`": `"$($s.RuleS)`", `"FaceTags`": {`"North`": [`"$tag`"]}},")
    [void]$sb.AppendLine("            {`"Position`": {`"X`": 0, `"Y`": 0, `"Z`": -1}, `"IncludeOrExclude`": `"$($s.RuleN)`", `"FaceTags`": {`"South`": [`"$tag`"]}},")
    [void]$sb.AppendLine("            {`"Position`": {`"X`": 0, `"Y`": 1, `"Z`": 0}, `"IncludeOrExclude`": `"$($s.YUp)`", `"FaceTags`": {`"Down`": [`"$tag`"]}},")
    [void]$sb.AppendLine("            {`"Position`": {`"X`": 0, `"Y`": -1, `"Z`": 0}, `"IncludeOrExclude`": `"$($s.YDown)`", `"FaceTags`": {`"Up`": [`"$tag`"]}}")
    [void]$sb.AppendLine("          ]")
    [void]$sb.AppendLine("        }")
    [void]$sb.AppendLine("      ]")
    [void]$sb.AppendLine("    }$comma")
}

[void]$sb.AppendLine("  }")
[void]$sb.Append("}")

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($templatePath, $sb.ToString(), $utf8NoBom)
Write-Host "Template written: $templatePath ($($allShapes.Count) shapes)`n"

# =============================================
# Part 3: Generate Item JSON
# =============================================

Write-Host "=== Generating Item JSON ==="

$sb2 = New-Object System.Text.StringBuilder

[void]$sb2.AppendLine('{')
[void]$sb2.AppendLine('  "TranslationProperties": {')
[void]$sb2.AppendLine('    "Name": "Glass Block Seamless"')
[void]$sb2.AppendLine('  },')
[void]$sb2.AppendLine('  "ItemLevel": 15,')
[void]$sb2.AppendLine('  "MaxStack": 100,')
[void]$sb2.AppendLine('  "Icon": "Icons/ItemsGenerated/glass_block_seamless.png",')
[void]$sb2.AppendLine('  "Categories": [')
[void]$sb2.AppendLine('    "Blocks.Deco"')
[void]$sb2.AppendLine('  ],')
[void]$sb2.AppendLine('  "PlayerAnimationsId": "Block",')
[void]$sb2.AppendLine('  "Set": "Glass",')
[void]$sb2.AppendLine('  "BlockType": {')
[void]$sb2.AppendLine('    "CustomModel": "Items/GlassBlockSeamless/block.blockymodel",')
[void]$sb2.AppendLine('    "CustomModelTexture": [')
[void]$sb2.AppendLine('      {')
[void]$sb2.AppendLine('        "Texture": "Items/GlassBlockSeamless/glass_single.png",')
[void]$sb2.AppendLine('        "Weight": 1')
[void]$sb2.AppendLine('      }')
[void]$sb2.AppendLine('    ],')
[void]$sb2.AppendLine('    "Material": "Solid",')
[void]$sb2.AppendLine('    "DrawType": "Model",')
[void]$sb2.AppendLine('    "Group": "Glass",')
[void]$sb2.AppendLine('    "Flags": {},')
[void]$sb2.AppendLine('    "Gathering": {')
[void]$sb2.AppendLine('      "Breaking": {')
[void]$sb2.AppendLine('        "GatherType": "Rocks"')
[void]$sb2.AppendLine('      }')
[void]$sb2.AppendLine('    },')
[void]$sb2.AppendLine('    "BlockParticleSetId": "Glass",')
[void]$sb2.AppendLine('    "ParticleColor": "#f0f0f0",')
[void]$sb2.AppendLine('    "VariantRotation": "None",')
[void]$sb2.AppendLine('    "BlockSoundSetId": "Glass",')
[void]$sb2.AppendLine('    "Opacity": "Transparent",')
[void]$sb2.AppendLine('    "State": {')
[void]$sb2.AppendLine('      "Definitions": {')

# State definitions: all 64 except "Single" (which is the default)
$stateDefList = New-Object System.Collections.ArrayList
foreach ($baseName in $baseStates.Keys) {
    foreach ($variant in $vertVariants) {
        $stateName = "$baseName$($variant.Suffix)"
        if ($stateName -eq "Single") { continue }
        [void]$stateDefList.Add($stateName)
    }
}

for ($i = 0; $i -lt $stateDefList.Count; $i++) {
    $stateName = $stateDefList[$i]
    $texName = "glass_$($stateName.ToLower()).png"
    $comma = if ($i -lt $stateDefList.Count - 1) { "," } else { "" }
    [void]$sb2.AppendLine("        `"$stateName`": {")
    [void]$sb2.AppendLine("          `"CustomModel`": `"Items/GlassBlockSeamless/block.blockymodel`",")
    [void]$sb2.AppendLine("          `"CustomModelTexture`": [{`"Texture`": `"Items/GlassBlockSeamless/$texName`", `"Weight`": 1}]")
    [void]$sb2.AppendLine("        }$comma")
}

[void]$sb2.AppendLine('      }')
[void]$sb2.AppendLine('    },')
[void]$sb2.AppendLine('    "ConnectedBlockRuleSet": {')
[void]$sb2.AppendLine('      "Type": "CustomTemplate",')
[void]$sb2.AppendLine('      "TemplateShapeAssetId": "GlassBlockSeamlessTemplate",')
[void]$sb2.AppendLine('      "TemplateShapeBlockPatterns": {')

# Pattern mappings: all 64 shapes
$patternList = New-Object System.Collections.ArrayList
foreach ($baseName in $baseStates.Keys) {
    foreach ($variant in $vertVariants) {
        $shapeName = "$baseName$($variant.Suffix)"
        [void]$patternList.Add($shapeName)
    }
}

for ($i = 0; $i -lt $patternList.Count; $i++) {
    $shapeName = $patternList[$i]
    $comma = if ($i -lt $patternList.Count - 1) { "," } else { "" }
    if ($shapeName -eq "Single") {
        [void]$sb2.AppendLine("        `"Single`": `"GlassBlockSeamless_Item`"$comma")
    } else {
        [void]$sb2.AppendLine("        `"$shapeName`": `"*GlassBlockSeamless_Item_State_Definitions_$shapeName`"$comma")
    }
}

[void]$sb2.AppendLine('      }')
[void]$sb2.AppendLine('    }')
[void]$sb2.AppendLine('  },')
[void]$sb2.AppendLine('  "Recipe": {')
[void]$sb2.AppendLine('    "TimeSeconds": 1.0,')
[void]$sb2.AppendLine('    "Input": [')
[void]$sb2.AppendLine('      {"ItemId": "Soil_Sand", "Quantity": 2}')
[void]$sb2.AppendLine('    ],')
[void]$sb2.AppendLine('    "BenchRequirement": [{')
[void]$sb2.AppendLine('      "Id": "Builders",')
[void]$sb2.AppendLine('      "Type": "StructuralCrafting",')
[void]$sb2.AppendLine('      "Categories": ["Window"]')
[void]$sb2.AppendLine('    }]')
[void]$sb2.AppendLine('  },')
[void]$sb2.AppendLine('  "ItemSoundSetId": "ISS_Items_Potion",')
[void]$sb2.AppendLine('  "IconProperties": {')
[void]$sb2.AppendLine('    "Scale": 0.5,')
[void]$sb2.AppendLine('    "Rotation": [22.5, 45, 22.5],')
[void]$sb2.AppendLine('    "Translation": [0, -8]')
[void]$sb2.AppendLine('  }')
[void]$sb2.Append('}')

[System.IO.File]::WriteAllText($itemPath, $sb2.ToString(), $utf8NoBom)
Write-Host "Item JSON written: $itemPath ($($stateDefList.Count) state definitions, $($patternList.Count) patterns)`n"

Write-Host "=== All Done! ==="
Write-Host "  64 textures generated"
Write-Host "  64 template shapes (16 base x 4 vertical)"
Write-Host "  63 state definitions + 1 default (Single)"
Write-Host "  64 pattern mappings"
