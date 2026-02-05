$modelJson = @'
{
  "nodes": [
    {"id": "1", "name": "pane", "position": {"x": 0, "y": 0, "z": 0}, "orientation": {"x": 0, "y": 0, "z": 0, "w": 1},
      "shape": {"type": "box", "offset": {"x": 0, "y": 16, "z": 0}, "stretch": {"x": 1, "y": 1, "z": 1},
        "settings": {"isPiece": false, "size": {"x": 32, "y": 32, "z": 4}},
        "textureLayout": {"back": {"offset": {"x": 0, "y": 0}}, "front": {"offset": {"x": 0, "y": 0}}, "right": {"offset": {"x": 0, "y": 0}}, "left": {"offset": {"x": 0, "y": 0}}, "top": {"offset": {"x": 0, "y": 0}}, "bottom": {"offset": {"x": 0, "y": 0}}},
        "unwrapMode": "custom", "visible": true, "doubleSided": true, "shadingMode": "flat"}}
  ],
  "format": "prop", "lod": "auto"
}
'@

$shapes = @(
    'single', 'horizontal', 'horizontal_above', 'horizontal_below', 'horizontal_both',
    'vertical', 'vertical_above', 'vertical_below', 'vertical_both',
    'single_above', 'single_below', 'single_both',
    'corner_ne', 'corner_nw', 'corner_se', 'corner_sw',
    'tshape_n', 'tshape_s', 'tshape_e', 'tshape_w', 'cross',
    'endcap_e', 'endcap_w', 'endcap_n', 'endcap_s',
    'endcap_e_above', 'endcap_e_below', 'endcap_e_both',
    'endcap_w_above', 'endcap_w_below', 'endcap_w_both',
    'endcap_n_above', 'endcap_n_below', 'endcap_n_both',
    'endcap_s_above', 'endcap_s_below', 'endcap_s_both'
)

$outputDir = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPaneOneSided"

foreach ($shape in $shapes) {
    $modelJson | Out-File -FilePath "$outputDir\$shape.blockymodel" -Encoding utf8
}

Write-Host "Created $($shapes.Count) simplified blockymodel files"
