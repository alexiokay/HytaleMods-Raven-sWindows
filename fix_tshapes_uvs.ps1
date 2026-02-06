$glassPane = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane"

$tshapes = @("tshape_n", "tshape_s", "tshape_e", "tshape_w")

foreach ($shape in $tshapes) {
    $file = Join-Path $glassPane "$shape.blockymodel"
    $content = Get-Content $file -Raw

    # Replace all bad UV offsets with (4, 4)
    $content = $content -replace '"right": \{"offset": \{"x": 36, "y": 4\}\}', '"right": {"offset": {"x": 4, "y": 4}}'
    $content = $content -replace '"left": \{"offset": \{"x": 0, "y": 4\}\}', '"left": {"offset": {"x": 4, "y": 4}}'

    Set-Content -Path $file -Value $content -NoNewline
    Write-Host "Fixed: $shape.blockymodel"
}

Write-Host "`nAll T-shapes fixed - all faces now use (4, 4) offset"
