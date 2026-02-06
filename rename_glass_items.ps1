Write-Host "`nRenaming glass items..." -ForegroundColor Cyan
Write-Host "  GlassWindow -> GlassPanel" -ForegroundColor Yellow
Write-Host "  GlassPane -> GlassPanelSeamless`n" -ForegroundColor Yellow

$rootPath = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows\app\src\main"

# Step 1: Update content in all files
Write-Host "1. Updating file contents..." -ForegroundColor Cyan

$filesToUpdate = @(
    "$rootPath\resources\Server\Item\Items\GlassPane_Item.json",
    "$rootPath\resources\Server\Item\Items\GlassWindow_Item.json",
    "$rootPath\resources\Server\Item\CustomConnectedBlockTemplates\GlassPaneTemplate.json",
    "$rootPath\resources\Server\Item\CustomConnectedBlockTemplates\GlassWindowTemplate.json",
    "$rootPath\java\com\alexispace\alexisglass\AlexisGlassPlugin.java"
)

foreach ($file in $filesToUpdate) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw

        # Replace GlassPane -> GlassPanelSeamless (do this first to avoid conflicts)
        $content = $content -replace 'GlassPane', 'GlassPanelSeamless'

        # Replace GlassWindow -> GlassPanel
        $content = $content -replace 'GlassWindow', 'GlassPanel'

        Set-Content -Path $file -Value $content -NoNewline
        Write-Host "  Updated: $($file | Split-Path -Leaf)" -ForegroundColor Green
    }
}

# Step 2: Rename files
Write-Host "`n2. Renaming files..." -ForegroundColor Cyan

# Rename GlassWindow_Item.json -> GlassPanel_Item.json
$oldWindowItem = "$rootPath\resources\Server\Item\Items\GlassWindow_Item.json"
$newPanelItem = "$rootPath\resources\Server\Item\Items\GlassPanel_Item.json"
if (Test-Path $oldWindowItem) {
    Move-Item -Path $oldWindowItem -Destination $newPanelItem -Force
    Write-Host "  Renamed: GlassWindow_Item.json -> GlassPanel_Item.json" -ForegroundColor Green
}

# Rename GlassPane_Item.json -> GlassPanelSeamless_Item.json
$oldPaneItem = "$rootPath\resources\Server\Item\Items\GlassPane_Item.json"
$newSeamlessItem = "$rootPath\resources\Server\Item\Items\GlassPanelSeamless_Item.json"
if (Test-Path $oldPaneItem) {
    Move-Item -Path $oldPaneItem -Destination $newSeamlessItem -Force
    Write-Host "  Renamed: GlassPane_Item.json -> GlassPanelSeamless_Item.json" -ForegroundColor Green
}

# Rename GlassWindowTemplate.json -> GlassPanelTemplate.json
$oldWindowTemplate = "$rootPath\resources\Server\Item\CustomConnectedBlockTemplates\GlassWindowTemplate.json"
$newPanelTemplate = "$rootPath\resources\Server\Item\CustomConnectedBlockTemplates\GlassPanelTemplate.json"
if (Test-Path $oldWindowTemplate) {
    Move-Item -Path $oldWindowTemplate -Destination $newPanelTemplate -Force
    Write-Host "  Renamed: GlassWindowTemplate.json -> GlassPanelTemplate.json" -ForegroundColor Green
}

# Rename GlassPaneTemplate.json -> GlassPanelSeamlessTemplate.json
$oldPaneTemplate = "$rootPath\resources\Server\Item\CustomConnectedBlockTemplates\GlassPaneTemplate.json"
$newSeamlessTemplate = "$rootPath\resources\Server\Item\CustomConnectedBlockTemplates\GlassPanelSeamlessTemplate.json"
if (Test-Path $oldPaneTemplate) {
    Move-Item -Path $oldPaneTemplate -Destination $newSeamlessTemplate -Force
    Write-Host "  Renamed: GlassPaneTemplate.json -> GlassPanelSeamlessTemplate.json" -ForegroundColor Green
}

Write-Host "`nRenaming complete!" -ForegroundColor Green
Write-Host "`nNext: Build and deploy" -ForegroundColor Cyan
