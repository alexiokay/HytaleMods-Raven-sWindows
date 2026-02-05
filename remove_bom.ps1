$dir = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPaneOneSided"
Get-ChildItem -Path $dir -Filter "*.blockymodel" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $content = $content.TrimStart([char]0xFEFF)
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($_.FullName, $content, $utf8NoBom)
}
Write-Host "Removed BOM from $((Get-ChildItem -Path $dir -Filter '*.blockymodel').Count) files"
