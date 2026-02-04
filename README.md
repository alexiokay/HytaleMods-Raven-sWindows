# Raven's Windows

A Hytale mod that adds glass windows that automatically connect to each other - just like fences!

## Features

- **Auto-Connecting** - Place windows next to each other and they seamlessly merge
- **Rotatable** - Place in any direction
- **Find in Creative Menu** - Blocks > Deco category

## Installation

1. Download the latest release from [Releases](https://github.com/alexiokay/HytaleMods-Raven-sWindows/releases)
2. Place the `.jar` file in your Hytale mods folder: `[Hytale]/UserData/Mods/`
3. Launch Hytale

## Building from Source

```bash
# Clone the repository
git clone https://github.com/alexiokay/HytaleMods-Raven-sWindows.git
cd HytaleMods-Raven-sWindows

# Build
./gradlew.bat :app:build

# The built JAR will be in app/build/libs/
```

## Usage

1. Open Creative Mode inventory
2. Navigate to **Blocks > Deco** category
3. Find "Glass Window" item
4. Place windows - they will automatically connect to neighbors!

## Technical Details

- Uses Hytale's `CustomConnectedBlockTemplates` system for auto-connection
- Custom `.blockymodel` files for each shape variant
- Pattern matching with `FaceTags` to detect neighboring windows

## License

All rights reserved.

## Author

**alexispace** (Raven)
