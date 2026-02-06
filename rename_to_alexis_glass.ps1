Write-Host "`nRenaming mod to Alexi's Glass..." -ForegroundColor Cyan

$rootPath = "C:\Users\alexispace\Desktop\webdev\hytale\HytaleWindows"
$modName = "Alexi's Glass"

# Step 1: Update manifest.json
Write-Host "`n1. Updating manifest.json..." -ForegroundColor Yellow
$manifestPath = "$rootPath\app\src\main\resources\manifest.json"
$manifest = Get-Content $manifestPath -Raw
$manifest = $manifest -replace '"Name":\s*"[^"]*"', ('"Name": "' + $modName + '"')
$manifest = $manifest -replace '"Main":\s*"com\.alexispace\.hywindows\.HytaleWindowsPlugin"', '"Main": "com.alexispace.alexisglass.AlexisGlassPlugin"'
$manifest = $manifest -replace '"Description":\s*"[^"]*"', ('"Description": "' + $modName + ' - Connected glass panes and windows with decorative borders that auto-connect like fences."')
$manifest = $manifest -replace '"Repository":\s*"[^"]*"', '"Repository": "https://github.com/alexiokay/HytaleMods-AlexisGlass"'
$manifest = $manifest -replace '\["windows",\s*"glass"[^\]]*\]', '["glass", "windows", "decoration", "building", "connected-glass", "alexi"]'
Set-Content -Path $manifestPath -Value $manifest -NoNewline
Write-Host "  Done: manifest.json updated" -ForegroundColor Green

# Step 2: Update settings.gradle.kts
Write-Host "`n2. Updating settings.gradle.kts..." -ForegroundColor Yellow
$settingsPath = "$rootPath\settings.gradle.kts"
$settings = Get-Content $settingsPath -Raw
$settings = $settings -replace 'rootProject\.name\s*=\s*"HytaleWindows"', 'rootProject.name = "AlexisGlass"'
Set-Content -Path $settingsPath -Value $settings -NoNewline
Write-Host "  Done: settings.gradle.kts updated" -ForegroundColor Green

# Step 3: Update Java plugin file content
Write-Host "`n3. Updating Java plugin file..." -ForegroundColor Yellow
$javaPath = "$rootPath\app\src\main\java\com\alexispace\hywindows\HytaleWindowsPlugin.java"
$java = Get-Content $javaPath -Raw
$java = $java -replace 'package com\.alexispace\.hywindows;', 'package com.alexispace.alexisglass;'
$java = $java -replace 'class HytaleWindowsPlugin', 'class AlexisGlassPlugin'
$java = $java -replace 'HytaleWindowsPlugin instance', 'AlexisGlassPlugin instance'
$java = $java -replace 'public HytaleWindowsPlugin', 'public AlexisGlassPlugin'
$java = $java -replace 'public static HytaleWindowsPlugin', 'public static AlexisGlassPlugin'
$java = $java -replace '/\*\*\s*\*\s*HytaleWindows\s*-[^*]*\*/', ("/**`n * " + $modName + " - Connected glass panes and windows for Hytale`n *")
$java = $java -replace '"HytaleWindows', ('"' + $modName)
$java = $java -replace 'HytaleWindows loading', ($modName + ' loading')
$java = $java -replace 'HytaleWindows setup complete', ($modName + ' setup complete')
$java = $java -replace 'HytaleWindows started', ($modName + ' started')
$java = $java -replace 'HytaleWindows shutting down', ($modName + ' shutting down')
Set-Content -Path $javaPath -Value $java -NoNewline
Write-Host "  Done: Java plugin file content updated" -ForegroundColor Green

# Step 4: Rename Java file
Write-Host "`n4. Renaming Java files and directories..." -ForegroundColor Yellow
$newJavaPath = "$rootPath\app\src\main\java\com\alexispace\hywindows\AlexisGlassPlugin.java"
if (Test-Path $javaPath) {
    Move-Item -Path $javaPath -Destination $newJavaPath -Force
    Write-Host "  Done: HytaleWindowsPlugin.java renamed to AlexisGlassPlugin.java" -ForegroundColor Green
}

# Step 5: Rename package directory
$oldPackageDir = "$rootPath\app\src\main\java\com\alexispace\hywindows"
$newPackageDir = "$rootPath\app\src\main\java\com\alexispace\alexisglass"
if (Test-Path $oldPackageDir) {
    Move-Item -Path $oldPackageDir -Destination $newPackageDir -Force
    Write-Host "  Done: hywindows renamed to alexisglass package directory" -ForegroundColor Green
}

# Step 6: Update language file
Write-Host "`n5. Updating language files..." -ForegroundColor Yellow
$langPath = "$rootPath\app\src\main\resources\Server\Languages\en-US\ui.lang"
if (Test-Path $langPath) {
    $lang = Get-Content $langPath -Raw
    $lang = $lang -replace 'HytaleWindows|HyWindow|Raven''sWindows', $modName
    Set-Content -Path $langPath -Value $lang -NoNewline
    Write-Host "  Done: ui.lang updated" -ForegroundColor Green
}

# Step 7: Update item JSON files
Write-Host "`n6. Updating item JSON files..." -ForegroundColor Yellow
$itemFiles = Get-ChildItem "$rootPath\app\src\main\resources\Server\Item\Items" -Filter "*.json"
foreach ($file in $itemFiles) {
    $content = Get-Content $file.FullName -Raw
    $updated = $content -replace 'HytaleWindows|HyWindow|Raven''sWindows', $modName
    if ($content -ne $updated) {
        Set-Content -Path $file.FullName -Value $updated -NoNewline
        Write-Host "  Done: Updated $($file.Name)" -ForegroundColor Green
    }
}

Write-Host "`nMod successfully renamed to $modName!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "  1. Build: ./gradlew.bat :app:build" -ForegroundColor Yellow
Write-Host "  2. Deploy: ./gradlew.bat :app:deployToGame" -ForegroundColor Yellow
