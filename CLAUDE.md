# HytaleWindows - Claude Project Memory

This file helps Claude understand the project context without re-exploring each session.

## Quick Commands

```bash
# Build
./gradlew.bat :app:build

# Deploy to game
./gradlew.bat :app:deployToGame

# Clean build
./gradlew.bat clean :app:build
```

## Project Overview

HytaleWindows adds connected glass window blocks to Hytale. Windows automatically connect to adjacent windows, similar to fences or iron bars in Minecraft.

## How Connected Blocks Work

Hytale's **ConnectedBlockRuleSet** system handles auto-connecting blocks:

1. **Template** (`Server/Block/ConnectedBlockTemplate/GlassWindowTemplate.json`)
   - Defines all possible shapes (Single, Horizontal, Vertical, Corners, T-shapes, Cross)
   - Uses `FaceTags` to mark connection points
   - Uses `PatternsToMatchAnyOf` with rules to detect neighbors

2. **Block Definition** (`Server/Block/Blocks/GlassWindow.json`)
   - References the template via `ConnectedBlockRuleSet`
   - Maps shape names to state definitions
   - Each state has its own custom model

3. **Models** (`Common/Items/GlassWindow/*.blockymodel`)
   - 12 different models for each connection configuration
   - Hytale auto-selects the correct model based on neighbors

## File Structure

```
app/src/main/
├── java/com/alexispace/hywindows/
│   └── HytaleWindowsPlugin.java     # Main plugin (minimal - asset-based)
└── resources/
    ├── manifest.json
    ├── Server/
    │   ├── Block/
    │   │   ├── Blocks/
    │   │   │   └── GlassWindow.json           # Block definition
    │   │   └── ConnectedBlockTemplate/
    │   │       └── GlassWindowTemplate.json   # Connection rules
    │   ├── Item/
    │   │   ├── Items/
    │   │   │   └── GlassWindow_Item.json      # Placeable item
    │   │   └── Category/CreativeLibrary/
    │   │       └── WindowsCategory.json       # Creative menu tab
    │   └── Languages/en-US/
    │       └── ui.lang                        # Translations
    └── Common/
        └── Items/GlassWindow/
            ├── single.blockymodel             # No connections
            ├── horizontal.blockymodel         # E-W connections
            ├── vertical.blockymodel           # N-S connections
            ├── corner_*.blockymodel           # Corner variants (4)
            ├── tshape_*.blockymodel           # T-shape variants (4)
            ├── cross.blockymodel              # All 4 connections
            └── glass_texture.png              # Texture (TODO)
```

## Shape Variants

| Shape | Connections | Model File |
|-------|-------------|------------|
| Single | None | single.blockymodel |
| Horizontal | East + West | horizontal.blockymodel |
| Vertical | North + South | vertical.blockymodel |
| Corner_NE | North + East | corner_ne.blockymodel |
| Corner_NW | North + West | corner_nw.blockymodel |
| Corner_SE | South + East | corner_se.blockymodel |
| Corner_SW | South + West | corner_sw.blockymodel |
| TShape_N | E + W + S | tshape_n.blockymodel |
| TShape_S | E + W + N | tshape_s.blockymodel |
| TShape_E | N + S + W | tshape_e.blockymodel |
| TShape_W | N + S + E | tshape_w.blockymodel |
| Cross | All 4 | cross.blockymodel |

## Connected Block Template Explained

The template uses `FaceTags` and pattern matching:

```json
{
  "MaterialName": "GlassWindow",
  "Shapes": {
    "Corner_NE": {
      "FaceTags": {
        "North": ["GlassWindowConnection"],
        "East": ["GlassWindowConnection"]
      },
      "PatternsToMatchAnyOf": [{
        "Type": "Custom",
        "RulesToMatch": [
          {"Position": {"X": 0, "Y": 0, "Z": 1}, "IncludeOrExclude": "Include", "FaceTags": {"North": ["GlassWindowConnection"]}},
          {"Position": {"X": 1, "Y": 0, "Z": 0}, "IncludeOrExclude": "Include", "FaceTags": {"West": ["GlassWindowConnection"]}}
        ]
      }]
    }
  }
}
```

- **FaceTags**: Which faces of THIS block can connect
- **RulesToMatch**: Check neighbors at relative positions
- **Include**: Neighbor MUST have matching face tag
- **Exclude**: Neighbor must NOT have matching face tag

## TODO

- [ ] Create actual glass texture (glass_texture.png)
- [ ] Test models in-game
- [ ] Add more window variants (framed, colored, etc.)
- [ ] Add vertical connections (up/down) for multi-story windows

## Hytale Installation
- Path: `F:\games\hytale`
- Mods folder: `F:\games\hytale\UserData\Mods`

## Resources

- [Pixelcomet ConveyorBelt Analysis](../HytaleVehicles/moding_info/pixelcomet_ConveyorBelt_Analysis.md) - Connected block template examples
- [HytaleDocs](https://hytale-docs.com/docs/modding/plugins/overview) - Plugin overview
