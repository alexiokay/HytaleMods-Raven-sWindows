$glassPane = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main\resources\Common\Items\GlassPane"

Get-ChildItem -Path $glassPane -Filter "*.blockymodel" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw

    # Check if this is a corner model
    if ($_.Name -match "corner_") {
        # Corners: doubleSided = true
        $content = $content -replace '"doubleSided":\s*(true|false)', '"doubleSided": true'
        Write-Host "Corner (doubleSided: true): $($_.Name)"
    } else {
        # All other shapes: doubleSided = false
        $content = $content -replace '"doubleSided":\s*(true|false)', '"doubleSided": false'
        Write-Host "Other (doubleSided: false): $($_.Name)"
    }

    Set-Content -Path $_.FullName -Value $content -NoNewline
}

Write-Host "`nDone: Corners have doubleSided: true, all others have doubleSided: false"
