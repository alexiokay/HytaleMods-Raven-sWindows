# Fix GlassPane models: set doubleSided to true and fix y offsets

$glassPane = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane"

Get-ChildItem -Path $glassPane -Filter "*.blockymodel" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw

    # Change doubleSided from false to true
    $content = $content -replace '"doubleSided":\s*false', '"doubleSided": true'

    # Fix thin edge offsets: change y from 16 to 0 for right/left
    # This fixes out-of-bounds texture reads for 32-pixel tall textures
    $content = $content -replace '("right":\s*\{\s*"offset":\s*\{\s*"x":\s*32,\s*"y":\s*)16(\s*\})', '${1}0${2}'
    $content = $content -replace '("left":\s*\{\s*"offset":\s*\{\s*"x":\s*32,\s*"y":\s*)16(\s*\})', '${1}0${2}'

    Set-Content -Path $_.FullName -Value $content -NoNewline
    Write-Host "Fixed: $($_.Name)"
}

Write-Host "`nAll GlassPane models fixed:"
Write-Host "  - doubleSided: true (for atlas approach)"
Write-Host "  - Thin edges now use y: 0 (prevents out-of-bounds reads)"
