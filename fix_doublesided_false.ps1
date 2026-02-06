$glassPane = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane"

Get-ChildItem -Path $glassPane -Filter "*.blockymodel" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw

    # Change doubleSided from true to false
    $content = $content -replace '"doubleSided":\s*true', '"doubleSided": false'

    Set-Content -Path $_.FullName -Value $content -NoNewline
    Write-Host "Fixed: $($_.Name)"
}

Write-Host "`nAll GlassPane models updated:"
Write-Host "  - doubleSided: false (single-sided rendering)"
