# Raven's Windows

A Hytale mod that adds connected glass windows that auto-connect like fences, creating seamless window walls.

## Features

- **Smart Auto-Connection** - Windows automatically connect to adjacent windows, just like fences
- **12 Shape Variants** - Automatically switches between shapes based on neighbors:
  - Single (standalone)
  - Horizontal (east-west connection)
  - Vertical (north-south connection)
  - 4 Corner pieces (NE, NW, SE, SW)
  - 4 T-shape pieces (N, S, E, W)
  - Cross (4-way intersection)
- **4-Way Rotation** - Place windows in any cardinal direction (N, E, S, W)
- **Transparent Glass** - Full transparency with proper glass material properties
- **Creative Menu Integration** - Find windows in the Blocks > Deco category

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
